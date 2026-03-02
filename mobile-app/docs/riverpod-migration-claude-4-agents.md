# Stacked -> Riverpod Migration Plan (Claude, 4 Agents)

## Baseline (current repo snapshot)
- `83` files import `package:stacked/stacked.dart`.
- `40` classes extend `BaseViewModel`.
- `36` files use `ViewModelBuilder`.
- `23` files import `stacked_services`.
- `103` `locator<T>()` usages.
- Heaviest area is `lib/ui/views/learn` (`48` stacked imports, `24` `BaseViewModel` classes).

## Migration Goal
- Replace Stacked state management with Riverpod across the app.
- Remove `stacked`, `stacked_services`, and `stacked_generator` from `pubspec.yaml`.
- Keep user behavior unchanged while improving testability and typed state boundaries.

## Architecture Decisions (to keep migration safe)
- Use `flutter_riverpod` for UI state (`Notifier`, `AsyncNotifier`, and `Provider`).
- Keep DI simple during migration: bridge current services into Riverpod providers first, then reduce direct `locator<T>()` usage.
- Replace Stacked routing/services with a local compatibility layer before deleting Stacked packages:
  - `Routes` constants + argument classes.
  - App router `onGenerateRoute`.
  - Navigation/Snackbar/Dialog wrappers not tied to Stacked.

## Agent Setup
Use exactly these four agents and keep ownership boundaries strict.

### Agent 1: Foundation + Compatibility Layer
- Owns:
  - `pubspec.yaml`
  - `lib/main.dart`
  - `lib/app/**` (except feature-specific route targets)
  - new `lib/core/providers/**` and `lib/core/navigation/**`
- Tasks:
  - Add `flutter_riverpod`; remove Stacked-only dependencies when safe.
  - Wrap app with `ProviderScope`.
  - Introduce provider bridge for existing singleton services.
  - Replace `@StackedApp`/generated locator-router path with local router + navigation wrappers.
  - Keep route names and argument models compatible with existing call sites.
- Deliverables:
  - App boots with no Stacked runtime dependency.
  - Existing screens still reachable.
  - No feature behavior changes.

### Agent 2: Learn Domain Migration
- Owns:
  - `lib/ui/views/learn/**`
- Tasks:
  - Convert `BaseViewModel` classes to Riverpod notifiers/state objects.
  - Replace `ViewModelBuilder` with `ConsumerWidget`/`ConsumerStatefulWidget`.
  - Migrate busy/loading/error state to explicit async state.
  - Prioritize complex files first:
    - `challenge/challenge_viewmodel.dart`
    - `widgets/scene/scene_viewmodel.dart`
    - `landing/landing_viewmodel.dart`
    - `daily_challenge/daily_challenge_viewmodel.dart`
- Deliverables:
  - Learn feature no longer imports Stacked.
  - No regression in challenge execution, progress display, and daily challenge navigation.

### Agent 3: News + Podcast + Auth/Profile/Settings Migration
- Owns:
  - `lib/ui/views/news/**`
  - `lib/ui/views/podcast/**`
  - `lib/ui/views/login/**`
  - `lib/ui/views/profile/**`
  - `lib/ui/views/settings/**`
  - `lib/ui/widgets/drawer_widget/**`
  - `lib/ui/widgets/setup_dialog_ui.dart`
- Tasks:
  - Migrate remaining `BaseViewModel` and `ViewModelBuilder` usage to Riverpod.
  - Replace `stacked_services` references with new navigation/dialog/snackbar abstractions.
  - Update feature tests to use provider overrides instead of Stacked mock registration.
- Deliverables:
  - Non-learn views no longer import Stacked.
  - Navigation and dialogs still behave the same.

### Agent 4: Quality Gate Agent (Required)
- Owns:
  - CI checks, lint/test config, migration checklist doc updates.
  - Test refactors in `test/**` and `integration_test/**` needed for Riverpod overrides.
- Tasks:
  - Add/maintain migration checks:
    - forbid Stacked imports in `lib/**` and `test/**`.
    - enforce analyzer + tests per PR.
  - Validate parity for core flows:
    - login
    - news feed pagination/open article
    - podcast list/episode open
    - learn challenge open/run/complete path
  - Run final cleanup:
    - remove Stacked generated files and stale comments (`@stacked-*` markers).
- Deliverables:
  - Green `flutter analyze`, unit/widget tests, and selected integration tests.
  - Final report: regressions found, fixed, and residual risk list.

## Execution Order
1. Agent 1 lands the foundation PR first (ProviderScope + compatibility router/services).
2. Agent 2 and Agent 3 run in parallel on separate feature folders.
3. Agent 4 runs continuously on each branch and blocks merges on parity/lint/test failures.
4. Final sweep PR removes remaining Stacked deps and generated artifacts.

## Agent Orchestration Rules
- You can launch multiple agents concurrently in one coordinator response, but apply dependency gating:
  - Start Agent 1 first and wait for completion.
  - After Agent 1 lands, start Agent 2 and Agent 3 in parallel.
  - Keep Agent 4 active for quality checks throughout all phases.
- Do not allow Agent 2 or Agent 3 to modify foundation-owned files (`pubspec.yaml`, `lib/main.dart`, `lib/app/**`, `lib/core/**`) while Agent 1 work is pending.
- If Agent 4 reports failing quality gates, block merge and send fixes back to the owning agent.

## Launch Runbook (for Claude Coordinator)
1. Launch Agent 1 only.
2. Wait for Agent 1 completion and ensure foundation checks pass:
   - app boots
   - routing works
   - DI bridge compiles
3. Launch Agent 2 + Agent 3 concurrently.
4. Run Agent 4 continuously against each branch/PR.
5. Merge only when Agent 4 confirms all gates.

## Small Branch Strategy (Per Feature)
Use a dedicated short-lived branch for each product feature area.

### Branch Naming
- `feat/riverpod-feature-<feature-name>`
- Examples:
  - `feat/riverpod-feature-learn`
  - `feat/riverpod-feature-podcast`
  - `feat/riverpod-feature-code-radio`

### Feature Branch Backlog
1. `feat/riverpod-feature-learn`: `lib/ui/views/learn/**`
2. `feat/riverpod-feature-podcast`: `lib/ui/views/podcast/**`
3. `feat/riverpod-feature-news`: `lib/ui/views/news/**`
4. `feat/riverpod-feature-code-radio`: `lib/ui/views/code_radio/**`
5. `feat/riverpod-feature-login`: `lib/ui/views/login/**`
6. `feat/riverpod-feature-profile`: `lib/ui/views/profile/**`
7. `feat/riverpod-feature-settings`: `lib/ui/views/settings/**`
8. `feat/riverpod-feature-shared-ui`: `lib/ui/widgets/drawer_widget/**`, `lib/ui/widgets/setup_dialog_ui.dart`

### Per-Feature Scope Rules
- Each feature branch may touch:
  - feature views/viewmodels/widgets within its owned folders
  - feature tests (`test/widget/**`, `integration_test/**`) tied to that feature
  - minimal shared plumbing required to compile (with note in PR description)
- Each feature branch must not:
  - refactor other feature folders
  - include unrelated formatting churn
  - change app foundation files owned by Agent 1 unless explicitly coordinated

### Recommended Parallel Layout
- Run `learn` on its own branch (largest scope).
- Run `podcast`, `news`, and `code-radio` in parallel.
- Run `login`, `profile`, and `settings` in parallel once navigation compatibility is stable.
- Keep `shared-ui` as a separate branch to minimize merge conflicts.

## Small Branch Strategy (Per Service)
Use short-lived branches with one service or one tightly-related service group per branch.

### Branch Naming
- `feat/riverpod-svc-<service-name>`
- Examples:
  - `feat/riverpod-svc-authentication`
  - `feat/riverpod-svc-news-api`
  - `feat/riverpod-svc-learn-offline`

### Service Branch Backlog
1. `feat/riverpod-svc-dio`: `lib/service/dio_service.dart`
2. `feat/riverpod-svc-locale`: `lib/service/locale_service.dart`
3. `feat/riverpod-svc-developer`: `lib/service/developer_service.dart`
4. `feat/riverpod-svc-authentication`: `lib/service/authentication/authentication_service.dart`
5. `feat/riverpod-svc-analytics`: `lib/service/firebase/analytics_service.dart`
6. `feat/riverpod-svc-remote-config`: `lib/service/firebase/remote_config_service.dart`
7. `feat/riverpod-svc-news-api`: `lib/service/news/api_service.dart`
8. `feat/riverpod-svc-news-bookmark`: `lib/service/news/bookmark_service.dart`
9. `feat/riverpod-svc-podcast-notification`: `lib/service/podcast/notification_service.dart`
10. `feat/riverpod-svc-podcast-database`: `lib/service/podcast/podcasts_service.dart`
11. `feat/riverpod-svc-podcast-download`: `lib/service/podcast/download_service.dart`
12. `feat/riverpod-svc-quick-actions`: `lib/service/navigation/quick_actions_service.dart`
13. `feat/riverpod-svc-audio`: `lib/service/audio/audio_service.dart`
14. `feat/riverpod-svc-learn-file`: `lib/service/learn/learn_file_service.dart`
15. `feat/riverpod-svc-learn-offline`: `lib/service/learn/learn_offline_service.dart`
16. `feat/riverpod-svc-learn-main`: `lib/service/learn/learn_service.dart`
17. `feat/riverpod-svc-daily-challenge`: `lib/service/learn/daily_challenge_service.dart`
18. `feat/riverpod-svc-daily-challenge-notification`: `lib/service/learn/daily_challenge_notification_service.dart`
19. `feat/riverpod-svc-scene-assets`: `lib/service/learn/scene_assets_service.dart`

### Per-Branch Scope Rules
- Each service branch may touch:
  - the service file itself
  - provider wiring (`lib/core/providers/**`)
  - the minimal consumer call sites needed to compile
  - tests directly related to that service
- Each service branch must not:
  - refactor unrelated UI state
  - include broad formatting-only churn
  - modify route tables unless required by that service

### Per-Branch Done Criteria
- `flutter analyze` passes.
- relevant unit/widget tests pass.
- no new `stacked` imports are introduced.
- provider override path exists for tests using that service.

## Merge Gates (must pass before merge)
- `flutter pub get` succeeds without dependency conflicts.
- `flutter analyze` passes.
- `flutter test` passes.
- No Stacked usage in app/test code:
  - `rg -n "package:stacked|stacked_services|ViewModelBuilder|BaseViewModel|@StackedApp|StackedService" lib test` returns no hits.
- Manual smoke checks for login, news, podcast, and learn flows.

## Claude Coordinator Prompt (copy/paste)
```text
You are coordinating a 4-agent migration in this Flutter repo from Stacked to Riverpod.

Create and manage exactly 4 agents with these roles:
1) Foundation + compatibility layer (app bootstrap, routing, DI bridge)
2) Learn feature migration
3) News/Podcast/Auth/Profile/Settings migration
4) Quality gate agent (tests, lint, parity checks, final validation)

Rules:
- Keep behavior unchanged.
- Keep agents inside their owned folders to avoid merge conflicts.
- Agent 1 merges first; Agent 2/3 then work in parallel; Agent 4 validates all branches.
- Prefer incremental PRs with runnable app after each PR.
- Do not leave any `stacked`/`stacked_services` imports in `lib` or `test`.

Completion criteria:
- Riverpod is used for state in migrated features.
- `stacked`, `stacked_services`, and `stacked_generator` removed from dependencies.
- All checks pass: analyze, tests, smoke flows.
- Provide a final migration report with changed files, risk notes, and rollback points.
```

## Optional Parallel Kickoff Prompt (after Agent 1 lands)
```text
Agent 1 is complete and merged. Start the remaining migration phase now:

- Run Agent 2 (Learn domain migration) and Agent 3 (News/Podcast/Auth/Profile/Settings migration) in parallel.
- Run Agent 4 (Quality gate) continuously while Agent 2/3 are active.
- Block merges on failing analyze/test/parity checks.
- Keep folder ownership strict to avoid conflicts.
```
