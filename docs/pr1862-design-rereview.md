# PR #1862 design re-review report

69 of 73 audit items are resolved (including upstream fixes re-verified on this branch), 3 need a product/backend decision, and PF3 is unchanged because its empty state has no design. X8 is resolved. All 155 widget tests pass; both analyzers are clean; the Android debug build succeeds. The required curriculum E2E did not pass; details below.

The complete 73-ID checklist plus X8 is in [pr1862-design-checklist.md](pr1862-design-checklist.md). Reviewed twice against every requested sub-point and Appendix B, with three independent review agents for learning/editor, media, and account/settings. The original specification is retained at the repository root.

## Needs decision

1. **EF1 — camera/library upload.** Checked the profile repository, freeCodeCamp `/update-my-about` and `/update-my-portfolio` schemas, the web profile editor and mobile API routes. They accept hosted image URLs, but provide no binary upload/hosting endpoint. Hosted URL changes and profile-photo removal now work through the existing draft/Save flow; project Add/Change/Remove image works too (PP1). The photo sheet has the requested title, subtitle, dividers, danger removal and full-width outline Cancel. Camera/library rows are visibly disabled with the reason shown. **Decision: which authenticated image-hosting endpoint should receive camera/library files?** No upload package or platform permission was added.
2. **ST3 — Campfire behavior.** Socrates is backed by `user.socrates` and `/update-socrates`, with optimistic update, duplicate suppression, session checks and rollback that preserves unrelated updates. Extra in-app hints remain disabled as previously requested. Web Campfire uses browser-local `fcc-sound` and Tone effects; mobile has no corresponding sound engine or settings contract. Its row remains disabled with a reason. **Decision: should mobile reproduce web learning sounds, and which events should play alongside podcasts/radio?**
3. **EP3 — size before download.** Checked the Dart/API Episode models and RSS update job: only `enclosure.url` is retained; `enclosure.length` is dropped. Completed downloads now display their actual file length only after the persisted completion row exists. Missing files omit size. **Decision: should the API persist and expose RSS enclosure length for episodes that have not been downloaded?** No size is fabricated or estimated.

## Assumptions and explicit precedence

- **CHAP-N1:** no completed steps means “Start step 1” at home/module and “Start” on chapters. With progress, use “Continue step N” / “Continue”; a finished scope uses Review. A current challenge ID alone does not count as progress. Buttons, outlined current tiles, expanded blocks, chapter module markers and English dialogue tasks now use the same target.
- **Latest welcome request:** “Choose a certification or start with the essentials.” applies to guests and signed-in learners without progress. Removed the extra “Learn to code for free” sentence.
- **Latest news request:** divider spacing is now 14px above and below the 1px rule, superseding FEED-N1's bottom-only padding. Short tags are leading-aligned; the tag/title/meta gaps remain 4px and the tag retains a 48px target.
- **Latest celebrations request:** a modest burst stops within three seconds and respects reduced motion, superseding the older continuous confetti request.
- **EPIS-N1/EP2:** kept “Press play to use speed and skip controls.” Shared audio loads only after Play; preloading an episode to enable these controls would take over Radio/Learn audio. Disabled controls have no fill.
- **ST3:** neutral explanatory subtitles were chosen because exact board wording was not supplied. Socrates copy makes its current web effect clear.
- **EFN1:** kept the existing mobile About maximum of 500. The inspected backend schema/web textarea does not impose that maximum; it is a mobile UX assumption, not a claimed server restriction. Counter and placeholder match the requested pattern.
- **EF1/PP1:** “Use image URL” is a supported alternative to unavailable file upload. Images stage until the existing Save action; no success is simulated.
- **PV2:** the URL is an atomic span. An exceptionally long username scales down only when the complete URL cannot fit; normal and 1.3× fixtures stay unbroken. This is a known accessibility tradeoff against the no-wrap requirement.
- **G20:** retained existing light callout tokens: attention fill/line/text `#ffebc0/#fcd889/#5b4403`, info `#e2eefe/#c8defe/#185eb4`, danger `#fee7e3/#ffcfc8/#b02019`. Dark tokens exactly match Appendix A. No new widget hex values.
- **SAVE-N2:** retained the already-present global AppBar 16/700 style after checking plain titles across Articles, archive, podcasts, profile and settings routes; dedicated page headlines remain 30/900.
- **EP3:** MB uses 1,000,000 bytes, one decimal below 10MB and whole numbers thereafter, using locale-aware `NumberFormat`. `intl` is now direct and pinned at 0.20.3, the version already in the baseline lockfile ([package source](https://pub.dev/packages/intl)).
- **EDIT-N1:** Material exposes `Icons.checklist` without a distinct filled counterpart; the existing selected tool styling identifies selection.
- **HELP-N1:** retained the existing 50-character minimum and encoded URL length limit of 8,000; the sheet now explains the actual unmet requirement. These limits were absent from the design.
- **Specific type exceptions:** DAN2/AN1/EPN1/RN1 explicitly require regular 12px mono; DE3 explicitly requires 600 mono for the unselected language. These specific values take precedence over the general weight/12px rules.
- **Targets:** compact controls keep their painted 44px appearance with at least 48px targets. The explicit podcast share control is 48px square; the global icon appearance remains 44px with a padded target. Segments retain the reference 54px track, 44px pills and 4px gaps, with 52px semantic bounds.

## Regression review

Two item-by-item source/diff passes were supplemented by independent cross-area review. The review covered every Appendix B group, including disabled/pressed/focus styles, 12/10 button radii, primary labels, outline/danger rules, raised Donate baseline, chapter radius20, chapter node26/ring3/dot8, Home outline CTA, profile stats radius14, pristine Save remaining yellow, project draft/validation behavior, and immediate visibility saving with Saved feedback. The final checks caught and fixed lost segment focus/disabled styling, undersized semantic bounds, off-switch focus treatment, a resume-marker mismatch, the short-tag alignment, and the navigation line crossing Donate.

Measured checks use the real theme and bundled Lato, JetBrains Mono and Material icons at a 390×844 logical surface, including light/dark and 1.3× text scale. Account tests use fake APIs; no authenticated profile data was changed on the user's emulator. Screenshot evidence is fixture rendering, not a claim of live server verification. The running Pixel 9 debug app was also inspected; its navigation divider paints behind the raised Donate circle. The user's emulator remained available while the separate curriculum device ran.

## Other observations left unchanged

Paths here are relative to `mobile-app/`:

- `lib/news/ui/author_feed/author_feed_view.dart:108,149`, `lib/news/ui/bookmark_post/bookmark_post_view.dart:66`, and `lib/news/ui/widgets/article_reader.dart:96` retain inherited 800-weight headings outside the requested IDs.
- `lib/podcasts/ui/downloads/downloads_view.dart:52,91,286,295` retains an inherited radius18 offline notice and 600-weight labels. These were outside this audit's screen findings.
- Quiz/lesson components retain inherited 800 weights and some specialized 14px radii outside the supplied items; no broad redesign was added to Appendix C screens.
- `lib/auth/ui/profile/profile_view.dart:936` retains “This camper has not yet earned any certifications.” PF3 has no empty-state board; the requested private-profile sentence uses “learner.”
- `lib/news/ui/widgets/bottom_button.dart:28` has an inherited split-button shape override without the shared focus-ring shape. It was not changed by this work.
- Some older handwritten doc comments remain despite the current AGENTS convention. No new handwritten doc comments were introduced.
- The existing Firebase plugins emit Flutter's future Kotlin Gradle Plugin migration warning during the successful Android build. Dependency migration is outside this design change.

## Validation

Baseline at `cad5b53`: pub get and Flutter/Dart analysis passed. Format check found pre-existing formatting in `learn_presentation.dart`; baseline widget run had 42 passes and 14 failures, including stale expectations and a real module-footer overflow. The final layout and updated regression checks resolve those failures.

| Command | Result |
|---|---|
| `flutter pub get` | Passed; exact direct intl0.20.3, no version change from baseline lock. |
| `dart run build_runner build` | Passed; generated auth/profile/download provider files refreshed. |
| `dart format lib test` then `dart format --output=none --set-exit-if-changed lib test` | Passed; final check changes0 files. |
| `dart analyze` | Passed; no issues. |
| `flutter analyze` | Passed; no issues. |
| `flutter test --concurrency=2` | Passed; 155 tests, no skips or failures. |
| `flutter build apk --debug` | Passed; normal APK built after temporary curriculum asset was removed. |
| `dart integration_test_runner.dart --curriculum` on isolated Android5556 | **Failed.** Available local fixture ran 2,872 challenges, emitted one failure, then aborted because `dev-playground` is missing. No valid reportData, so no curriculum-pass claim. |
| `git diff --check` and static audit | Passed; each pattern hit categorized. |

The curriculum failure emitted is `javascript-v9 / workshop-envelope-budget-app / Step 46`, ID `69b2c970cb02ddaafff1c10b`. The missing fixture key caused `curriculum_test.dart:65` to throw before assigning reportData; the runner then failed on null response data. Individual assertion detail was lost in that abort. Test-execution services were not modified in this re-review. The older PR's 3,603-challenge pass describes a different fixture; it is not the result of this run. Both the temporary 118MB asset and isolated emulator were removed.

Evidence (logs, three agent reports, shared-control review, static-audit dispositions and screenshots) is saved locally under `outputs/design-rereview-1862` in the Codex task workspace. Current app code is on `feat/mobile-redesign-main`; the user's Pixel9 remains in debug mode.
