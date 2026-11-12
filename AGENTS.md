# AGENTS.md

freeCodeCamp's mobile app monorepo.

| Folder | What it is |
|---|---|
| `mobile-app/` | Flutter app (Riverpod 3 + GoRouter + Freezed), package `freecodecamp`. |
| `mobile-api/` | Node backend for podcasts (`/podcasts`, `/podcasts/{id}/episodes`). |

Everything below describes `mobile-app/`. The provider dependency graph is in [docs/LAYER_MAP.md](docs/LAYER_MAP.md).

## Commands

Run from `mobile-app/`:

```sh
dart run build_runner build        # after touching any @riverpod, @freezed, @JsonSerializable or @TypedGoRoute
dart analyze
flutter analyze
flutter test                       # unit tests in test/, also run by CI
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/<feature>/<name>_test.dart
dart integration_test_runner.dart [--curriculum] [--ios]
```

- Run both analyzers from the project root.
- A clean analyze is not verification. Run the change on a device.
- `.env` is bundled as an asset and must exist. Keys: `ALGOLIAAPPID`, `ALGOLIAKEY`, `HASHNODE_PUBLICATION_ID`, `AUTH0_DOMAIN`, `AUTH0_CLIENT_ID`, `DEVELOPMENT_MODE` (switches .org/.dev), `SHOW_ALL_SB` (show all superblocks).

## Architecture

```
lib/
  main.dart                 init: Firebase, Remote Config, audio, then runApp
  routing/router.dart       GoRouter; one routing/<feature>.dart per feature
  services/                 app-wide keepAlive state: auth, remote config, analytics, audio handler, dio, notifications
  <feature>/                news, podcasts, code_radio, learn, auth, settings
    constants/
    controllers/            state shared by 2+ screens
    models/                 Freezed
    repositories/           raw data sources only
    services/               everything between controllers and repositories
    ui/
      <feature>_shell.dart
      <screen>/<screen>_view.dart + <screen>_viewmodel.dart   viewmodel = state used by that screen only
      widgets/              shared widgets, flat
  widgets/                  cross-feature UI (ErrorRetry, drawer, html_handler)
  utils/                    provider-less helpers
```

### Layers
- **Repository** is the raw data source: API client, file or SharedPreferences. It deals in raw shapes and never imports UI.
- **Service** wraps repositories. It handles mapping to models, business rules, coordination and lifecycle.
- **Controller / viewmodel** is the single source of truth for a screen or shared widget.
- **View** renders state from its controller/viewmodel and forwards user actions to it. No business logic, no repository or service calls where avoidable.

Rules:
- A controller or viewmodel never watches a `…RepositoryProvider` directly.
- A view never imports another screen's viewmodel. If two screens need the same state, move it to `controllers/`.
- Don't collapse a layer just because it is thin. Judge a layer by the responsibility it owns.
- `lib/services/` holds app-wide, keepAlive providers that several features share: shared state (`AuthNotifier` → `authProvider`, Remote Config) and platform clients (audio handler, Dio, analytics, notifications). Shared state lives in a `…Notifier` whose methods are thin delegations to the feature's service; the repository, service, models and screens stay in `lib/<feature>/` (auth's are in `lib/auth/`).
- Naming: the folder carries the feature, the filename doesn't repeat it, the class does (`lib/news/repositories/api_repository.dart` → `NewsApiRepository`). Every routed screen gets its own folder under `ui/`. Don't create single-file folders.

### Riverpod 3 (codegen)
- Repositories and services are `@riverpod` function providers. State is `@riverpod class XNotifier`, and the generated provider drops the `Notifier` suffix (`NewsFeedNotifier` → `newsFeedProvider`). Check the `.g.dart` file.
- Providers are auto-dispose by default. Guard `state =` after an `await` with `if (ref.mounted)`.
- Never read `state` inside `build()`: it throws on the first build. Pass carried-over values as parameters instead.
- A keepAlive provider must not depend on an auto-dispose one (`only_use_keep_alive_inside_keep_alive`).
- Riverpod retries a failing provider up to 10 times (~38s of backoff, staying in `AsyncLoading`). Any provider with its own Retry button uses `@Riverpod(retry: noRetry)` from `lib/utils/riverpod.dart`.
- Links from `ref.keepAlive()` are dropped on every rebuild, not only on dispose.
- A family caches on its arguments. Don't pass closures, and give the arguments stable `==` (Freezed). Model a mode as a sealed Freezed union, not sentinel parameters.

### Models
- Freezed 3: `sealed class` for unions, `abstract class` for data.
- For snake_case wire keys, use `@JsonKey(name:)` on parameters.
- Split list and detail models when the detail payload is heavy (`PostSummary` vs `Post`).

### Routing
- Typed routes via `go_router_builder`, with path strings as top-level consts in `lib/routing/<feature>.dart`.
- **Concrete paths must be declared above parameterised ones**, because `$appRoutes` follows source order (`/news/image` above `/news/:slug`, `/podcasts/downloads` above `/podcasts/:podcastId`).
- Objects travel via `$extra`. That is only safe because nothing deep-links to those routes and state restoration is off.

## Persisted data

Installed apps already hold this data in the documents directory and SharedPreferences, so **paths and keys never change**. Downgrades never happen, so a format may change as long as the previous one is still read.

| Data | Location |
|---|---|
| Bookmarks | `storage/bookmarked-articles.json`, keys `articleId`/`articleTitle`/`authorName`/`articleText` (mapped only in `bookmark_service.dart`) |
| Podcast downloads | `storage/podcast-downloads.json` (version 2, API key names; version 1 is normalised in memory on read), `episodes/`, `images/` |
| Podcast resume | prefs `{episodeId}_progress`, LRU index `podcast_recent_episodes` (cap 10) |
| Learn saved code | prefs `<challengeId>.<name>.<ext>` |
| Last reported notification permission | prefs `analytics_notification_permission` (bool) |

- JSON files live inside the feature's own repository: an atomic write (`.tmp` then `rename`, no delete first), a serialised `Future` queue, and tolerant reads. Don't build a generic store.
- Podcast completion is signalled by the store row, never by file existence: dio writes the `.mp3` in place while downloading. The orphan sweep reads raw store entries, not parsed models.

## Audio

`AudioPlayerHandler` (`lib/services/audio_service.dart`) is shared by Code Radio, podcasts and Learn, and is injected in `main()` via `audioHandlerProvider.overrideWithValue`.
- Code Radio is one continuous live stream. Never reload on a song change; push `mediaItem` only. Resuming after a pause reconnects to rejoin the live edge.
- Never call `load()` after `setAudioSource`: it is already preloading, and a second call opens a second connection.
- Only advertise media controls that have a real override behind them. The control set depends on `_audioConfig`.
- Code Radio is never shipped on iOS (the drawer tile is hidden there). Keep `UIBackgroundModes: audio` anyway, because podcasts and Learn need it.

## Startup

- `main()` awaits Remote Config (10s fetch timeout) and audio init before `runApp`. Nothing else goes there: a hang before `runApp` means a black screen.
- Session restore runs under a deferred first frame (10s timeout). Post-frame work (notification permission, daily reminders, podcast orphan sweep) is registered after `allowFirstFrame`.
- Crashlytics and Analytics only collect in release builds.
- Analytics: every event and user property goes through `AnalyticsService` (`lib/services/analytics_service.dart`). The naming and parameter rules, the event catalog and how to add an event are in [docs/ANALYTICS.md](docs/ANALYTICS.md); the unit tests fail when an event breaks the rules or is missing from that file. Automatic screen reporting stays off on both platforms, because its nameless screen view wipes the current screen on every resume.

## Experiments (Firebase A/B Testing)

`lib/services/experiment_service.dart` holds every experiment as an `Experiment` enum value backed by a string Remote Config key. A key that Remote Config doesn't return reads as `control`.
- `experimentsProvider` reads every arm once, the first time it is used, and never rebuilds. A Remote Config update mid-session can't switch a user's arm; new values apply on the next launch.
- Read the arm with `ref.read(experimentsProvider.notifier).variant(Experiment.x)`.
- Call `logExposure(Experiment.x)` where the user first sees the difference. It logs `<key>_exposure` once per app session with a `variant` param; use that event as the experiment's activation event in the console so only exposed users are counted.
- Keys are at most 31 characters (the exposure event name is capped at 40). The console experiment's parameter name and variant values must match the enum key and the strings the code checks.
- `exp_aa_test` is an AA test: exposure is logged after the first frame and no arm changes behaviour.
- Every build prints `Firebase installation ID: …` at startup (`adb logcat | grep "installation ID"`); add it as a test device in the console to force an arm. Analytics only collects in release builds, so verify events with a release build and `adb shell setprop debug.firebase.analytics.app org.freecodecamp` (DebugView).

## Conventions

- No `///` doc comments. Use plain one-line `//` only where a reader would otherwise change the code and break it.
- Strings are hardcoded English. There is no localisation.
- Unit tests live in `test/`, mirroring `lib/` (`test/services/analytics_service_test.dart` for `lib/services/analytics_service.dart`), and run in CI. Fake providers with `overrideWithValue`/`overrideWith`; `test/helpers/fake_analytics.dart` records analytics. Add tests when you add an analytics event.
- The curriculum e2e (`integration_test/test_runner/curriculum_test.dart`, run via `dart integration_test_runner.dart --curriculum`) is the required e2e test. Other e2e tests live in `integration_test/<feature>/`:
  - Use type-based finders (`find.byType`, `tester.widget<T>().field`). Widgets used as finders (e.g. `NewsPostHeader`) stay public.
  - Device stdout is lossy on long runs. Return results through `binding.reportData`.
- Use `ErrorRetry` (`lib/widgets/error_retry.dart`) for async error states.
- Always give `CachedNetworkImage` explicit bounds. Unsized, it fills its constraints or jumps while loading.
- Cover art (podcasts, Code Radio) is always square: use `AspectRatio(1)` and never crop.
- Pin every dependency to the exact version it was tested with (no `^`). New dependencies start at the latest version.
- Hashnode's GraphQL API is slow upstream, and `graphql` 5.2.4 applies a 5s default request timeout.
