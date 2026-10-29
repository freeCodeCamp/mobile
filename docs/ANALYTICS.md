# Analytics

Firebase Analytics (GA4 property for project `mobile-4ee8a`). Only release builds collect: debug and profile builds are deactivated natively (`firebase_analytics_collection_deactivated`, `FIREBASE_ANALYTICS_COLLECTION_DEACTIVATED`).

## Rules

1. **Every event goes through `AnalyticsService`** (`mobile-app/lib/services/analytics_service.dart`). Nothing else imports `firebase_analytics`. Each event is a typed method, so names and parameters live in one place.
2. **Log from the layer that knows the outcome**: a controller, view-model or app-level notifier, after the action succeeded. Views only log where no notifier owns the action (the help dialog).
3. **Names** (events, parameters, user properties) are lowercase `snake_case`, start with a letter, and never start with `firebase_`, `google_` or `ga_`. Events and parameters are at most 40 characters, user properties at most 24. Use Google's recommended names where one fits (`login`).
4. **Parameters**: at most 25 per event. Values are `String`, `int`/`double` or `bool`. Booleans are sent as `'true'`/`'false'`, `null` is dropped, and strings are cut to 100 characters. User property values are at most 36 characters.
5. **No personal data**: no emails, names, free text or user IDs in events or user properties.
6. **Screen context comes for free**: every event carries the current screen, so don't add the route as a parameter.
7. **Adding an event**: add the method and its name to `AnalyticsService.eventNames`, add a row below, add a test in `mobile-app/test/services/analytics_service_test.dart`, and register any parameter you want in GA reports as a custom dimension. The tests fail if a name breaks the rules or is missing from this file.
8. **Never rename** an event, parameter or value that has shipped; GA treats the new name as a different event.

## Screen views

Logged by the router listener in `main.dart` on every navigation. Automatic screen reporting is off on both platforms.

| Field | Value |
|---|---|
| `screen_name` | The location, e.g. `/news/how-to-learn-react` |
| `screen_class` | The route template, e.g. `/news/:slug`; `not_found` for an unmatched location |

## Events

| Event | When | Parameters | Logged in |
|---|---|---|---|
| `challenge_tests_run` | Tests finish running in the editor | `superblock`, `block`, `challenge_type`, `passed`, `failed_tests` | `editor_challenge_viewmodel.dart` |
| `challenge_completed` | A curriculum challenge is completed (signed in: after it is saved) | `superblock`, `block`, `challenge_type` | `challenge_viewmodel.dart` |
| `daily_challenge_completed` | A daily coding challenge is completed | `language` (`javascript`, `python`) | `challenge_viewmodel.dart` |
| `code_reset` | The camper resets their code | `superblock`, `block`, `challenge_type` | `editor_challenge_viewmodel.dart` |
| `help_requested` | The forum post for "Ask for Help" is opened | `superblock`, `block`, `challenge_type` | `help_dialog.dart` |
| `login` | Sign-in succeeds | `method` (`google`, `github`, `apple`, `email`) | `auth_service.dart` |
| `logout` | The user signs out | – | `auth_service.dart` |
| `account_deleted` | The account is deleted | – | `auth_service.dart` |
| `notification_permission` | The notification permission differs from the last one reported (first launch, grant, revoke) | `granted` | `main.dart` |
| `notification_opened` | The user taps a notification, whether it launches the app or not | `type` (`daily_challenge`, `podcast_download`, `unknown`) | `main.dart` |
| `<experiment key>_exposure` | The user first sees an experiment in a session | `variant` | `experiment_service.dart` |

## User properties

| Property | Values | Set |
|---|---|---|
| `signed_in` | `true`, `false` | Whenever auth state settles (session restore, sign-in, sign-out, a 401) |
| `notifications_enabled` | `true`, `false` | Every launch, after the permission request |

Firebase also sets `firebase_exp_<n>` for users in an A/B test.

## Verifying on a device

Use a release build (`flutter run --release`), then:

```sh
adb shell setprop debug.firebase.analytics.app org.freecodecamp   # DebugView in the Firebase console
adb shell setprop log.tag.FA VERBOSE && adb shell setprop log.tag.FA-SVC VERBOSE
adb logcat | grep "Logging event"
```
