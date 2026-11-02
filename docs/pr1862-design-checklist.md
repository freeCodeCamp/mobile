# PR #1862 design re-review checklist

Reviewed from `cad5b53` against [the supplied specification](../PR1862-design-discrepancies.md). Source paths below are relative to `mobile-app/`. FIXED includes upstream fixes verified without unnecessary rewrites.

69 of 73 audit items are resolved (including upstream fixes re-verified on this branch), 3 need a product/backend decision, and PF3 is unchanged because its empty state has no design. X8 is resolved. All 155 widget tests pass; both analyzers are clean; the Android debug build succeeds. The required curriculum E2E did not pass; details below.

| ID | Sev | Status | Files changed / checked | How verified |
|---|---|---|---|---|
| EF1 | High | NEEDS-DECISION | `lib/auth/ui/profile_edit/profile_edit_view.dart`; `lib/auth/ui/widgets/profile_photo_options.dart`; `lib/auth/ui/widgets/image_url_dialog.dart`; `lib/auth/controllers/profile_editor_controller.dart`; `lib/auth/services/profile_service.dart` | photo sheet identifies unavailable uploads and keeps URL/remove actions working; profile photo URL and removal are persisted through update-my-about |
| PP1 | High | FIXED | `lib/auth/ui/profile_project/profile_project_view.dart`; `lib/auth/ui/profile_project/profile_project_viewmodel.dart`; `lib/auth/ui/widgets/image_url_dialog.dart`; `lib/auth/services/profile_service.dart` | project image changes preserve remote text and support image-only additions; account-project-dark.png/light.png |
| SAVE-N1 | High | FIXED | `lib/news/ui/news_shell.dart`; `lib/news/ui/feed/feed_view.dart`; `lib/news/ui/search/search_view.dart`; `lib/news/ui/widgets/news_load_error.dart` | 7 SAVE-N1 realroute navigation tests |
| G15 | Medium | FIXED | `lib/widgets/chip_surface.dart`; `lib/news/ui/feed/feed_view.dart`; `lib/podcasts/ui/podcasts_shell.dart` | rereview_theme_test measures actual RawChip PhysicalShape and Ink paint transparent; media tests verify real Articles filter height>=44. |
| GLOB-N2 | Medium | FIXED | `lib/fcc_theme.dart` | rereview_theme_test: all 15 localized textTheme and primaryTextTheme slots, TextField, ListTile and Chip have Lato and letterSpacing 0 in both themes. |
| GLOB-N3 | Medium | FIXED | `lib/fcc_theme.dart`; `lib/widgets/segmented_tabs.dart` | rereview_theme_test: all themed button types; rereview_media_test: real Listen tabs, Play latest and episode pills render Lato; local style static audit. |
| GLOB-N4 | Medium | FIXED | `lib/fcc_theme.dart`; `lib/auth/ui/profile/profile_view.dart`; `lib/auth/ui/profile_visibility/profile_visibility_view.dart` | audit_account_behavior_test: account and profile cards retain token border1 and exact radii; static audit of every Card override. |
| GLOB-N5 | Medium | FIXED | `lib/fcc_theme.dart`; `lib/widgets/dialog/confirm_dialog.dart`; `lib/auth/ui/widgets/profile_form.dart`; `lib/learn/ui/challenge/widgets/quiz_leave_dialog.dart`; `lib/settings/ui/settings/delete_account/delete_account_view.dart` | Theme/account/editor tests measure Reset, Discard, Leave quiz and Delete account pairs at50px, labels17/w900 or700; Cancel outlined. |
| HN1 | Medium | FIXED | `lib/learn/ui/landing/landing_view.dart` | rereview_learn_test: compact inline Sign in 44px visual/48px hit, padding16/radius10/14w700/white1.5 edge; internal divider; eyebrow13w700; intro15/1.45; Start step1. Dark real-font fixture inspected. |
| CHAP-N1 | Medium | FIXED | `lib/learn/utils/learning_action.dart`; `lib/learn/ui/landing/learning_resume.dart`; `lib/learn/ui/landing/landing_view.dart`; `lib/learn/ui/superblock/superblock_view.dart`; `lib/learn/ui/module/module_view.dart`; `lib/learn/ui/widgets/block_card.dart`; `lib/learn/ui/widgets/challenge_grid.dart`; `lib/learn/ui/widgets/dialogue_block_card.dart` | rereview_learn_test: unit cases for guest/no progress/some progress/current challenge/finished block; actual home, chapters and module agree on current step5 target and Continue labels. Current outlined grid tile, list row, default-open block, and current chapter/module now share target; later-block and English-dialogue regression tests pass. |
| E3 | Medium | FIXED | `lib/learn/ui/editor_challenge/editor_challenge_view.dart` | rereview_editor_test: all6 cases (guest/member × Next step/Finish/Finish challenge) height48, labels16w700 or16w900, TextPainter one line, content-sized padding18left14right. |
| HELP-N1 | Medium | FIXED | `lib/learn/ui/challenge/widgets/help_dialog.dart` | rereview_editor_test: unticked->Tick both boxes; ticked49chars->Add1morecharacter;50chars enables; encoded URL too long disables with correct reason. No forum post sent. |
| DAIL-N1 | Medium | FIXED | `lib/learn/ui/landing/daily_challenge_card.dart`; `lib/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart` | rereview_learn_test: home outline48/r12/1.5link/16w700; archive filledyellow48/r12/page16w900. Both screenshots inspected. |
| DE3 | Medium | FIXED | `lib/learn/ui/daily_challenge/daily_challenge_view.dart`; `lib/widgets/segmented_tabs.dart` | rereview_editor_test: shared track surface/border1/r12/padding4/gap4; selected r8/tint/1.5link edge; labels JBM14w700selected/w600unselected; tap still changes language. |
| DEN1 | Medium | FIXED | `lib/learn/ui/editor_challenge/editor_panels.dart` | rereview_editor_test: inline13px muted Example with borderless code-fill chips r4 and inline period; baseline alignment checked; long example wraps without overflow in existing editor regression. |
| S3 | Medium | FIXED | `lib/news/ui/search/search_view.dart`; `lib/widgets/error_retry.dart` | S3 actual search failure has body and width at1.3scale; media-search-error-dark.png; parent shared ErrorRetry tests |
| L1 | Medium | FIXED | `lib/widgets/listen_tabs.dart`; `lib/widgets/segmented_tabs.dart` | LIST-N1 actual Listen route labelstyles; parent segmentedtests; media-listen-dark.png |
| P1 | Medium | FIXED | `lib/podcasts/ui/episode_list/episode_list_view.dart` | P1 P2 PODC-N1 PODC-N2 real podcast labels and share sizing |
| EPIS-N1 | Medium | FIXED | `lib/podcasts/ui/episode/episode_view.dart` | 4 player metric/scaling tests; media-episode-dark.png |
| AIP1 | Medium | FIXED | `lib/auth/ui/account/account_view.dart`; `lib/fcc_theme.dart` | account and profile cards keep one-pixel borders and design radii; account-account-dark.png/light.png |
| PV2 | Medium | FIXED | `lib/auth/ui/profile_visibility/profile_visibility_view.dart`; `lib/widgets/segmented_tabs.dart` | privacy note URL stays one line at 390dp and 1.3 scale and real routes return to Settings; account-privacy-dark.png/light.png |
| PRIV-N1 | Medium | FIXED | `lib/auth/ui/profile_visibility/profile_visibility_view.dart`; `lib/routing/auth.dart`; `lib/routing/router.dart` | privacy note URL stays one line at 390dp and 1.3 scale and real routes return to Settings; should save visibility immediately and announce Saved |
| ST3 | Medium | NEEDS-DECISION | `lib/settings/ui/settings/settings_view.dart`; `lib/auth/models/user_model.dart`; `lib/auth/services/profile_service.dart`; `lib/services/auth_service.dart` | Socrates writes its supported endpoint for the captured user; Socrates updates optimistically, suppresses duplicates and rolls back failure; account-settings-dark.png/light.png |
| SETT-N2 | Medium | FIXED | `lib/settings/ui/settings/settings_view.dart`; `lib/auth/ui/profile_visibility/profile_visibility_view.dart`; `lib/widgets/fcc_switch.dart` | should save visibility immediately and announce Saved; dark/light1.3 smoke; root shared switch geometry/semantics tests |
| G20 | Low | FIXED | `lib/fcc_theme.dart` | Verified existing dark attention3e2d02/5b4403, info042f62/07458d and danger5f0705/880b09 tokens and light counterparts; no widget hex added. |
| HOME-N1 | Low | FIXED | `lib/learn/ui/landing/landing_view.dart` | rereview_learn_test: returning LinearProgressIndicator height8; screenshot returning hero. |
| HOME-N2 | Low | FIXED | `lib/learn/ui/landing/daily_challenge_card.dart` | rereview_learn_test: hero-to-daily card vertical gap16. |
| HOME-N3 | Low | FIXED | `lib/learn/ui/landing/daily_challenge_card.dart` | rereview_learn_test: Past challenges15w700, date-row/button gap12, Daily challenge/title gap2. |
| HOME-N4 | Low | FIXED | `lib/fcc_theme.dart`; `lib/learn/ui/landing/landing_view.dart` | Root card-theme test verifies radius16 and retained 1px border; course Card inherits it; dark home screenshot inspected. |
| C2 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: module counts6:1:21:1 produce proportional segments with min14; comingSoon modules retained in count. |
| C5 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: completed chapter tile success fill, page-color check; meta line between name and8px dots. |
| C6 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: Open link right-aligned on same description row,15w700 with trailing icon; sentence14/1.4 muted; trophy radius14. |
| CHAP-N2 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: expanded collapse chevron resolves onSurfaceVariant (#cabeea dark); screenshot inspected. |
| CHAP-N3 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: rows min60, padding10, gap2; chapter nodes remain26/ring3/dot8. |
| CHAP-N4 | Low | FIXED | `lib/learn/ui/superblock/superblock_view.dart` | rereview_learn_test: chapter-to-chapter and last-chapter-to-exam gaps16. |
| M2 | Low | FIXED | `lib/learn/ui/module/module_view.dart`; `lib/learn/ui/widgets/block_card.dart` | rereview_learn_test: fixed footer uses scaffold background;52px button and trailing18px arrow;360dp and390dp1.3 smoke pass. |
| MODU-N1 | Low | FIXED | `lib/learn/ui/widgets/block_card.dart`; `lib/learn/ui/widgets/learn_presentation.dart` | rereview_learn_test: block status diameter28/ring2.5/dot10, while chapter node26/ring3/dot8 remains intact. |
| MODU-N2 | Low | FIXED | `lib/learn/ui/module/module_view.dart` | rereview_learn_test: Responsive Web Design backlink16w700. |
| MODU-N3 | Low | FIXED | `lib/learn/ui/widgets/block_card.dart` | rereview_learn_test: expanded untouched workshop shows0of11steps at13 muted; screenshot inspected. |
| MODU-N4 | Low | FIXED | `lib/learn/ui/widgets/learn_presentation.dart` | rereview_learn_test: completed module/block check glyph uses page color on success fill. |
| EDIT-N1 | Low | FIXED | `lib/learn/ui/editor_challenge/editor_challenge_view.dart` | rereview_editor_test: StepNofM15w900 and Icons.checklist rendered; screenshot inspected. |
| EDIT-N2 | Low | FIXED | `lib/learn/ui/editor_challenge/editor_challenge_view.dart` | rereview_editor_test: both Hide and Show labels14w700. |
| HPN3 | Low | FIXED | `lib/learn/ui/challenge/widgets/help_dialog.dart` | rereview_editor_test/source: checkbox26/radius8 and48hit; attachment card16; intro15; footer13; submit50;1.3 dark/light dialog smoke. |
| DAN2 | Low | FIXED | `lib/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart` | rereview_learn_test: archive eyebrow JetBrainsMono12w400 muted and row title15w700. |
| DE2 | Low | FIXED | `lib/learn/ui/editor_challenge/editor_panels.dart` | rereview_editor_test: whole first paragraph15/1.5 with no maxLines; Read more padding0 flushleft and48hit; card padding16,12,16,14. |
| DED-N1 | Low | FIXED | `lib/learn/ui/editor_challenge/editor_challenge_view.dart` | rereview_editor_test: Icons.arrow_back_rounded in daily mode and title16w700; step header separately15w900. |
| A2 | Low | FIXED | `lib/news/ui/feed/feed_view.dart` | rereview_media_test: A2 G15 rendered search edge and filter chip height |
| AN1 | Low | FIXED | `lib/news/ui/widgets/tag_button.dart` | FEED-N1 AN1 tag/title gaps; media-feed-dark.png |
| FEED-N1 | Low | FIXED | `lib/news/ui/widgets/tag_button.dart`; `lib/news/ui/widgets/post_tile.dart`; `lib/news/ui/widgets/post_feed_list.dart` | FEED-N1 AN1 tag/title gaps; FEED-N1 eyebrow accepts tap48target outside painted text; USER-news-divider measured separators |
| ARTI-N1 | Low | FIXED | `lib/news/ui/post/post_view.dart`; `lib/news/ui/widgets/tag_button.dart` | ARTI-N1 header aligns at16 and eyebrow/title has4gap; media-article-dark.png |
| ARTI-N3 | Low | FIXED | `lib/widgets/html_handler/code_block.dart` | rereview_theme_test: rendered HTML Copy button44px visual,48px target, Lato14/w700/spacing0 in both themes; existing upstream implementation retained. |
| SV1 | Low | FIXED | `lib/news/ui/bookmark_feed/bookmark_feed_view.dart` | SV1 SAVE-N2 empty glyph padding body and saved title match; media-bookmarks-dark.png |
| SAVE-N2 | Low | FIXED | `lib/fcc_theme.dart` | Media and learn tests inspect Saved articles and Daily coding challenges titles16/w700; existing global16 scope retained after AppBar inventory. |
| LIST-N1 | Low | FIXED | `lib/widgets/listen_header.dart`; `lib/podcasts/ui/podcasts_shell.dart`; `lib/code_radio/ui/player/player_view.dart` | LIST-N1 same rendered header bounds on both actual Listen routes |
| LIST-N2 | Low | FIXED | `lib/podcasts/ui/widgets/podcast_grid_tile.dart`; `pubspec.yaml` | LIST-N1 rendered 1,051 episodes |
| P2 | Low | FIXED | `lib/podcasts/ui/widgets/episode_play_button.dart` | P1 P2 PODC-N1 PODC-N2; audit_news_listen_test actioncheck |
| PODC-N1 | Low | FIXED | `lib/podcasts/ui/episode_list/episode_list_view.dart` | P1 P2 PODC-N1 PODC-N2 measured48square materialtransparent |
| PODC-N2 | Low | FIXED | `lib/podcasts/ui/episode_list/episode_list_view.dart` | P1 P2 PODC-N1 PODC-N2 renderedtext |
| EP2 | Low | FIXED | `lib/podcasts/ui/episode/episode_view.dart`; `lib/podcasts/ui/widgets/download_button.dart` | 4 player metric/scaling tests measurebothmaterial52x44/radius999 |
| EP3 | Low | NEEDS-DECISION | `lib/podcasts/controllers/library_controller.dart`; `lib/podcasts/repositories/download_repository.dart`; `lib/podcasts/services/library_service.dart`; `lib/podcasts/ui/episode/episode_view.dart`; `lib/podcasts/ui/widgets/podcast_format.dart` | EP3 local size real/missingfile test; EP3 downloadedmetadata test; EP3 localeformat test |
| EPN1 | Low | FIXED | `lib/podcasts/ui/episode/episode_view.dart` | 4 player metrics/scaling tests; media-episode-dark.png |
| EPIS-N2 | Low | FIXED | `lib/podcasts/ui/episode/episode_view.dart`; `lib/podcasts/ui/widgets/podcast_artwork.dart` | 4 player metrics/scaling tests; media-episode-dark/light.png |
| RN1 | Low | FIXED | `lib/code_radio/ui/player/player_view.dart` | LIST-N1 actualradiotimestamps; audit_news_listen_test |
| RADI-N1 | Low | FIXED | `lib/code_radio/ui/player/player_view.dart` | LIST-N1 actualradioart220/radius20/edge; media-radio-dark/light.png |
| AGN1 | Low | FIXED | `lib/auth/ui/account/account_view.dart`; `lib/fcc_theme.dart` | account and profile cards keep one-pixel borders and design radii; account-guest-dark.png/light.png |
| SIGN-N1 | Low | FIXED | `lib/auth/ui/login/login_view.dart` | sign-in divider is centered and provider gaps and Email label match; account-login-dark.png/light.png |
| SIGN-N2 | Low | FIXED | `lib/auth/ui/login/login_view.dart` | sign-in divider is centered and provider gaps and Email label match |
| PF3 | Low | NO-CHANGE | `lib/auth/ui/profile/profile_view.dart` | Source re-read of empty Certifications state and Appendix B |
| PO-N1 | Low | FIXED | `lib/auth/ui/profile/profile_view.dart` | private profile preview uses learner wording |
| EFN1 | Low | FIXED | `lib/auth/ui/profile_edit/profile_edit_view.dart`; `lib/auth/ui/widgets/profile_form.dart` | profile Save and Change photo are pills and About counter and helper align |
| EPRF-N1 | Low | FIXED | `lib/auth/ui/profile_edit/profile_edit_view.dart`; `lib/auth/ui/widgets/profile_form.dart` | profile Save and Change photo are pills and About counter and helper align; discard and delete account action pairs measure 50px with 17px Lato labels |
| PV3 | Low | FIXED | `lib/auth/ui/profile_visibility/profile_visibility_view.dart` | should list About you as Name, Location, About |
| SETT-N1 | Low | FIXED | `lib/settings/ui/settings/settings_view.dart`; `lib/fcc_theme.dart` | account-settings-dark.png/light.png; shared card shape tests |
| X8 | Design | FIXED | `lib/widgets/html_handler/code_block.dart` | Same shared Copy control test; applies14/w700 consistently, following explicit design-system resolution. |

## Latest user follow-ups

| Request | Status | Verification |
|---|---|---|
| default-dark | FIXED | first install defaults dark and saved System, Light and Dark remain explicit |
| player | FIXED | USER-player dismiss stops and clears persistent player across tabs; explicit playback can reopen; media-mini-player-dark/light.png |
| news-divider | FIXED | USER-news-divider leaves14dp above and below every feed separator; media-feed-dark/light.png |
| news-tags | FIXED | USER-news-tags short and long eyebrows start at the title edge; rendered RichText measurement for #js, #mcp, and #JavaScript |
| welcome | FIXED | rereview_learn_test: no-progress member sees essentials welcome; guest sees compact sign-in; completed progress is required for returning hero. |
| labs | FIXED | rereview_learn_test: real challengeLink lab header with showActions:false navigates to its challenge route; disabled guard preserved. |
| confetti | FIXED | rereview_editor_test: ticker ends by3seconds, does not restart after another3seconds, and reduced-motion produces no animation. |
| nav-border | FIXED | 1px token top border behind transparent NavigationBar; raised opaque Donate circle paints over it. Root widget layering test and live Pixel9 screenshot confirm no line through circle. |

Decisions, assumptions and final command results: [re-review report](pr1862-design-rereview.md).
