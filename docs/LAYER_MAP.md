# Layer Map

Every provider dependency in the v8 app (`mobile-app-new/lib/`): which controllers reach which services, which services own which repositories, and where each repository gets its data. Views are not drawn.

## Legend

`view → controller / view-model → service → repository → data source`

| Shape | Meaning |
|---|---|
| Gold border | **Controller**: state shared by 2+ screens, in `controllers/` |
| Dashed gold | **View-model**: state used by one screen, beside its view |
| Grey | **Service**: between controllers and repositories, owns business rules |
| Dark | **Repository**: raw data source only |
| Violet | **App-level service** in `lib/services/` |
| Dashed pill | **Data source** outside the app |
| Grey pill | `main.dart` |

Solid arrows go one step down the chain. Dashed arrows leave it, to an app-level service, a data source or `main.dart`. An arrow labelled `read` is a one-shot `ref.read`; every other arrow is reactive.

## Podcasts

### Catalogue, library and downloads

```mermaid
flowchart LR
  PLVM["podcast_list_viewmodel"]:::vm
  ELVM["episode_list_viewmodel"]:::vm
  LIB["library_controller"]:::ctrl
  DLC["downloads_controller"]:::ctrl
  ROOT(["main.dart"]):::root

  APIS["api_service"]:::svc
  LIBS["library_service"]:::svc

  APIR["api_repository"]:::repo
  STOR["storage_repository"]:::repo
  DLR["download_repository"]:::repo

  NOTIF["notification_service"]:::plat
  DIO["dioProvider"]:::plat

  SRC1(["freeCodeCamp mobile API"]):::ext
  SRC2(["podcast-downloads.json"]):::ext
  SRC3(["episodes/ + images/ on disk"]):::ext

  PLVM --> APIS
  ELVM --> APIS
  ELVM --> LIB
  DLC -->|read| LIB
  DLC -->|read| LIBS
  LIB --> LIBS

  APIS --> APIR
  LIBS --> STOR
  LIBS --> DLR

  APIR -.-> SRC1
  STOR -.-> SRC2
  DLR -.-> SRC3

  LIBS -.-> NOTIF
  ROOT -.->|read| LIBS
  ROOT -.->|read| NOTIF
  APIR -.-> DIO
  DLR -.-> DIO

  classDef ctrl fill:#2A2A40,stroke:#FFC300,stroke-width:1.5px,color:#F5F6F7
  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
  classDef root fill:#15152a,stroke:#8E8EA8,stroke-width:1.5px,color:#DFDFE2
```

### Playback and resume

```mermaid
flowchart LR
  PLY["player_controller"]:::ctrl
  LIB2["library_controller"]:::ctrl
  PBS["playback_service"]:::svc

  STOR2["storage_repository"]:::repo
  DLR2["download_repository"]:::repo
  PRGR["progress_repository"]:::repo

  AUDIO["audio_service<br/>AudioPlayerHandler"]:::plat
  SRC4(["SharedPreferences"]):::ext

  PLY --> PBS
  PBS --> STOR2
  PBS --> DLR2
  PBS --> PRGR
  PRGR -.-> SRC4

  PLY -.-> AUDIO
  PBS -.-> AUDIO
  LIB2 -.->|read| AUDIO

  classDef ctrl fill:#2A2A40,stroke:#FFC300,stroke-width:1.5px,color:#F5F6F7
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
```

There are two graphs because the code is split the same way: audio on one side, podcast data on the other. `storage_repository` and `download_repository` appear in both because both services own them. `library_controller` appears in the second only because it stops playback before an episode is deleted.

**Screens:** `podcast_list_view`, `episode_list_view`, `episode_view`, `downloads_view`, plus the `episode_tile`, `download_button` and `podcast_grid_tile` widgets.

- **Two controllers, deliberately separate.** `library_controller` answers "is this on disk?". `downloads_controller` tracks transfers in progress. The library holds data that changes rarely and many widgets watch; downloads writes progress several times a second.
- **`downloads_controller` only reads.** It calls `library_controller.refresh()` after a download, because only the notifier can push new state to what the grid and tiles watch. `refresh()` assigns `AsyncData` directly, where `ref.invalidate` would flash a spinner.
- **"Is this downloaded?" is answered by `playback_service.playbackUris()`** from the store row, not from the controller's cached state or the filesystem.
- **`playback_service` runs off-screen and owns resume progress.** It holds raw stream subscriptions, so positions keep saving when no podcast screen is mounted.
- **Only `storage_repository` is `keepAlive`**, so every write to `podcast-downloads.json` goes through one serialised queue, even after the rest of the chain has been disposed and rebuilt. `player_controller` holds a `KeepAliveLink` while the handler holds an episode, which also covers a pause (exactly as long as the media notification exists). `downloads_controller` holds one while a transfer is running. Everything below them stays alive through them. A failed download is not kept, so leaving the screen resets its retry icon.
- **Both API repositories share one `Dio`** through `dioProvider`.

## News

```mermaid
flowchart TD
  PVM["post_viewmodel"]:::vm
  AVM["author_feed_viewmodel"]:::vm
  SVM["search_viewmodel"]:::vm
  FEED["feed_controller"]:::ctrl
  BOOK["bookmarks_controller"]:::ctrl

  APIS["api_service"]:::svc
  BMS["bookmark_service"]:::svc
  SRS["search_service"]:::svc

  APIR["api_repository"]:::repo
  BMR["bookmark_repository"]:::repo
  SRR["search_repository"]:::repo

  SRC1(["Hashnode GraphQL"]):::ext
  SRC2(["bookmarked-articles.json"]):::ext
  SRC3(["Algolia index"]):::ext

  PVM --> APIS
  AVM --> APIS
  FEED --> APIS
  SVM --> SRS
  BOOK --> BMS

  APIS --> APIR
  BMS --> BMR
  SRS --> SRR

  APIR -.-> SRC1
  BMR -.-> SRC2
  SRR -.-> SRC3

  classDef ctrl fill:#2A2A40,stroke:#FFC300,stroke-width:1.5px,color:#F5F6F7
  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
```

**Screens:** `feed_view`, `tag_feed_view`, `author_feed_view`, `post_view`, `search_view`, `bookmark_feed_view`, `bookmark_post_view`, `image_view`, plus the `post_feed_list` and `bookmark_button` widgets.

- **The reference implementation.** It has three independent stacks; each service owns exactly one repository and nothing crosses between them.
- **`feed_controller` is a family** keyed by the sealed `NewsFeedSource` (all / tag / author), so the main, tag and author feeds share one implementation.
- **No app-level services.** The API repository builds its own `GraphQLClient` rather than using `dioProvider`.

## Code Radio

```mermaid
flowchart TD
  PVM["player_viewmodel"]:::vm
  CRS["code_radio_service"]:::svc
  WSR["websocket_repository"]:::repo
  AUDIO["audio_service<br/>AudioPlayerHandler"]:::plat
  SRC(["AzuraCast live websocket"]):::ext

  PVM --> CRS
  CRS --> WSR
  PVM -.->|read| AUDIO
  CRS -.-> AUDIO
  WSR -.-> SRC

  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
```

**Screen:** `player_view`.

- **The service drives the notification.** It holds a raw websocket subscription inside a keepAlive provider and pushes song changes to the audio handler, so the notification keeps updating off-screen.
- **No `controllers/` folder.** There is one screen, so the state is a view-model beside it.

## Learn

### Curriculum, challenges and the editor

```mermaid
flowchart LR
  CVM["challenge_viewmodel"]:::vm
  EVM["editor_challenge_viewmodel"]:::vm
  CC["curriculum_controller"]:::ctrl
  SC["scene_controller"]:::ctrl

  CS["curriculum_service"]:::svc
  CODE["code_service"]:::svc
  TRS["test_runner_service"]:::svc
  QS["quote_service"]:::svc

  CR["curriculum_repository"]:::repo
  PR["prefs_repository"]:::repo
  SESS["auth/session_repository"]:::repo

  RC["remote_config_service"]:::plat
  AUTH["auth_service<br/>AuthNotifier"]:::plat
  AUDIO["audio_service<br/>AudioPlayerHandler"]:::plat
  DIO["dioProvider"]:::plat

  SRC1(["curriculum data JSON"]):::ext
  SRC2(["SharedPreferences"]):::ext
  SRC3(["localhost:8080 · assets/test_runner"]):::ext

  CVM --> CC
  CVM --> CS
  CVM -->|read| CODE
  CVM -.->|read| AUTH
  EVM -->|read| TRS
  EVM -->|read| CODE
  EVM --> QS
  CC --> CS
  SC --> CS

  CS --> CR
  CODE --> PR

  CR -.-> SRC1
  PR -.-> SRC2
  TRS -.-> SRC3

  CC -.-> RC
  SC -.->|read| AUDIO
  CR -.-> SESS
  CR -.-> DIO

  classDef ctrl fill:#2A2A40,stroke:#FFC300,stroke-width:1.5px,color:#F5F6F7
  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
```

### Daily challenge, reminders and the landing page

```mermaid
flowchart LR
  LVM["landing_viewmodel"]:::vm
  DVM["daily_challenge_viewmodel"]:::vm
  AVM["daily_challenge_archive_viewmodel"]:::vm
  CVM2["challenge_viewmodel"]:::vm
  ROOT(["main.dart"]):::root

  DCS["daily_challenge_service"]:::svc
  REM["daily_challenge_reminder_service"]:::svc
  QS2["quote_service"]:::svc

  DCR["daily_challenge_repository"]:::repo
  PR2["prefs_repository"]:::repo
  QR["quote_repository"]:::repo
  SESS2["auth/session_repository"]:::repo

  NOTIF["notification_service"]:::plat
  DIO2["dioProvider"]:::plat

  SRC4(["freeCodeCamp API<br/>/daily-coding-challenge"]):::ext
  SRC5(["SharedPreferences"]):::ext
  SRC6(["motivational-quotes.json asset"]):::ext

  LVM --> DCS
  LVM --> QS2
  DVM --> DCS
  AVM --> DCS
  CVM2 -->|read| DCS
  CVM2 -->|read| REM
  REM --> DCS

  DCS --> DCR
  DCS --> PR2
  QS2 --> QR

  DCR -.-> SRC4
  PR2 -.-> SRC5
  QR -.-> SRC6

  REM -.-> NOTIF
  ROOT -.->|read| REM
  DCR -.-> SESS2
  DCR -.-> DIO2

  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
  classDef root fill:#15152a,stroke:#8E8EA8,stroke-width:1.5px,color:#DFDFE2
```

The curriculum side and the daily-challenge side share no service. `challenge_viewmodel` appears in both because a daily challenge is solved on the ordinary challenge screen, which then records it through the daily services.

**Screens:** `landing_view`, `superblock_view`, `module_view`, `challenge_view` (with its `english_view`, `lesson_view`, `quiz_view` and `python_project_view` bodies), `editor_challenge_view`, `daily_challenge_view`, `daily_challenge_archive_view`, `scene_fullscreen_view`, plus the `block_card`, `daily_challenge_card`, `complete_button`, `quiz_audio_player` and `scene/` widgets.

- **`curriculum_controller` is the shared one.** The landing, superblock and module screens all watch it, and `challenge_viewmodel` watches its `superBlockProvider`.
- **Both API repositories use auth's `session_repository`**, which supplies `apiUrl` and wraps signed-in requests. Any 401 signs the user out everywhere.
- **The only service-to-service edge in any feature:** `daily_challenge_reminder_service` asks `daily_challenge_service` for today's challenge, then checks the user's completed list before rescheduling. `main.dart` calls it at startup.
- **`test_runner_service` is the only `keepAlive` in Learn.** It owns an `InAppLocalhostServer` on port 8080 plus headless web views (Babel and the test evaluator), so the next challenge never fights the previous one for the port.
- **Some views skip their view-model:** `editor_challenge_view` reads `code_service` and the test-runner server, `daily_challenge_view` watches `daily_challenge_service`, and `quiz_audio_player` and `scene_controls` use the audio handler.

## Auth & Settings

```mermaid
flowchart TD
  LGVM["login_viewmodel"]:::vm
  PFVM["profile_viewmodel"]:::vm
  DAVM["delete_account_viewmodel"]:::vm
  ROOT2(["main.dart"]):::root

  AUTH2["auth_service<br/>AuthNotifier"]:::plat
  SSVC["session_service"]:::svc
  SREP["session_repository"]:::repo
  DIO3["dioProvider"]:::plat

  SRC7(["Auth0"]):::ext
  SRC8(["freeCodeCamp API"]):::ext
  SRC9(["secure storage"]):::ext

  LGVM -.->|read| AUTH2
  LGVM -->|read| SSVC
  PFVM -.->|read| AUTH2
  DAVM -.->|read| AUTH2
  ROOT2 -.->|read| AUTH2
  AUTH2 -.-> SSVC

  SSVC --> SREP
  SSVC -.-> SRC7
  SREP -.-> SRC8
  SREP -.-> SRC9
  SREP -.-> DIO3

  classDef vm fill:#23233a,stroke:#B98F1F,stroke-width:1.5px,stroke-dasharray:4 3,color:#DFDFE2
  classDef svc fill:#22223a,stroke:#6B6B85,stroke-width:1.5px,color:#DFDFE2
  classDef repo fill:#1B1B32,stroke:#4A4A63,stroke-width:1.5px,color:#DFDFE2
  classDef plat fill:#241736,stroke:#DBB8FF,stroke-width:1.5px,color:#EBD9FF
  classDef ext fill:transparent,stroke:#585870,stroke-width:1px,stroke-dasharray:3 3,color:#9A9AA8
  classDef root fill:#15152a,stroke:#8E8EA8,stroke-width:1.5px,color:#DFDFE2
```

**Screens:** `login_view`, `profile_view`, `settings_view`, `delete_account_view` and the app drawer. All of them also watch `authProvider` directly for the current user.

- **`AuthNotifier` is the only place auth state changes.** View-models read the notifier and call its methods; only login goes below it, to start a sign-in flow.
- **The session layer is `keepAlive`** and lives for the app's lifetime. Learn's two API repositories depend on it too.

## Regenerating

The edges come from resolving every `ref.watch` / `ref.read` / `ref.listen` in `lib/` back to the file that declares the provider (map each `final xProvider` in `*.g.dart` to its source file). From `mobile-app-new/`:

```sh
for f in $(find lib -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' | sort); do
  tr '\n' ' ' < "$f" | grep -oE 'ref *\. *(watch|read|listen) *\( *[A-Za-z_][A-Za-z0-9_]*' \
    | sed -E 's/ref *\. *//; s/ *\( */ /' | sort -u | while read m p; do echo "${f#lib/}|$p|$m"; done
done
```

Seven edges are invisible to this method because the provider sits behind a local name, so they are added by hand:
- `_provider` getters in `post_feed_list`, `episode_list_view` and `editor_challenge_view`
- `_runner` in `editor_challenge_viewmodel`
- a local `provider` variable in `challenge_view`, `complete_button` and `module_view`

A pair that appears as both `read` and `watch` counts as a watch. Diff the output against the nodes already drawn: a wrong edge survives regeneration if nobody checks it.
