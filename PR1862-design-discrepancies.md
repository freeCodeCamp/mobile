# PR #1862 — Mobile redesign: open design discrepancies

Source: "PR 1862 Design Re-review" report.
App state reviewed: commit `735cbb0`, re-checked against fixes up to `53cc360`.
Device: Pixel 6 Pro emulator (Android 13), **dark mode only**. Light mode was not audited.
Design: dark `D-*` boards + the Design system page of the freeCodeCamp Mobile App canvas, version `1793369462-ecdf`, rendered at 390px wide.

Totals: **73 open discrepancies** (3 high, 21 medium, 49 low). 100 of 133 previous findings are fixed (listed in Appendix B as a regression guard).

Paths are relative to the Flutter app root (the folder that contains `pubspec.yaml` and `lib/`). Line numbers are from `735cbb0`/`53cc360` and may have drifted.

Severity: **High** = visible design-system rule break, missing screen/state/flow, or broken behaviour. **Medium** = clearly visible mismatch on one screen. **Low** = small size, weight, radius, spacing or copy detail.

Notation: `16/700` = font size 16, weight 700. `15/1.45` = size 15, line height 1.45. Colours are dark-mode hex values.

---

## Index of open items

| # | ID | Sev | Screen |
|---|----|-----|--------|
| 1 | EF1 | High | Edit profile |
| 2 | PP1 | High | Edit project |
| 3 | SAVE-N1 | High | Saved articles / Article search |
| 4 | G15 | Medium | App-wide |
| 5 | GLOB-N2 | Medium | App-wide |
| 6 | GLOB-N3 | Medium | App-wide |
| 7 | GLOB-N4 | Medium | App-wide |
| 8 | GLOB-N5 | Medium | App-wide |
| 9 | HN1 | Medium | Courses home |
| 10 | CHAP-N1 | Medium | Course chapters |
| 11 | E3 | Medium | Challenge editor |
| 12 | HELP-N1 | Medium | Get help / Create a post |
| 13 | DAIL-N1 | Medium | Daily challenge archive (+ Home) |
| 14 | DE3 | Medium | Daily challenge editor |
| 15 | DEN1 | Medium | Daily challenge editor |
| 16 | S3 | Medium | Article search (shared error state) |
| 17 | L1 | Medium | Listen: Podcasts |
| 18 | P1 | Medium | Podcast episodes |
| 19 | EPIS-N1 | Medium | Episode player |
| 20 | AIP1 | Medium | Account (signed in) |
| 21 | PV2 | Medium | Profile visibility |
| 22 | PRIV-N1 | Medium | Profile visibility |
| 23 | ST3 | Medium | Settings |
| 24 | SETT-N2 | Medium | Settings |
| 25 | G20 | Low | App-wide |
| 26 | HOME-N1 | Low | Courses home |
| 27 | HOME-N2 | Low | Courses home |
| 28 | HOME-N3 | Low | Courses home |
| 29 | HOME-N4 | Low | Courses home |
| 30 | C2 | Low | Course chapters |
| 31 | C5 | Low | Course chapters |
| 32 | C6 | Low | Course chapters |
| 33 | CHAP-N2 | Low | Course chapters |
| 34 | CHAP-N3 | Low | Course chapters |
| 35 | CHAP-N4 | Low | Course chapters |
| 36 | M2 | Low | Module |
| 37 | MODU-N1 | Low | Module |
| 38 | MODU-N2 | Low | Module |
| 39 | MODU-N3 | Low | Module |
| 40 | MODU-N4 | Low | Module (+ Chapters) |
| 41 | EDIT-N1 | Low | Challenge editor |
| 42 | EDIT-N2 | Low | Challenge editor |
| 43 | HPN3 | Low | Get help / Create a post |
| 44 | DAN2 | Low | Daily challenge archive |
| 45 | DE2 | Low | Daily challenge editor |
| 46 | DED-N1 | Low | Daily challenge editor |
| 47 | A2 | Low | Articles feed |
| 48 | AN1 | Low | Articles feed |
| 49 | FEED-N1 | Low | Articles feed |
| 50 | ARTI-N1 | Low | Article |
| 51 | ARTI-N3 | Low | Article |
| 52 | SV1 | Low | Saved articles |
| 53 | SAVE-N2 | Low | Saved articles (+ Daily archive) |
| 54 | LIST-N1 | Low | Listen |
| 55 | LIST-N2 | Low | Listen: Podcasts |
| 56 | P2 | Low | Podcast episodes |
| 57 | PODC-N1 | Low | Podcast episodes |
| 58 | PODC-N2 | Low | Podcast episodes |
| 59 | EP2 | Low | Episode player |
| 60 | EP3 | Low | Episode player |
| 61 | EPN1 | Low | Episode player |
| 62 | EPIS-N2 | Low | Episode player |
| 63 | RN1 | Low | Code Radio |
| 64 | RADI-N1 | Low | Code Radio |
| 65 | AGN1 | Low | Account (signed out) |
| 66 | SIGN-N1 | Low | Sign in |
| 67 | SIGN-N2 | Low | Sign in |
| 68 | PF3 | Low | Public profile (your view) — design gap |
| 69 | PO-N1 | Low | Public profile (as others see it) |
| 70 | EFN1 | Low | Edit profile |
| 71 | EPRF-N1 | Low | Edit profile |
| 72 | PV3 | Low | Profile visibility |
| 73 | SETT-N1 | Low | Settings |
| — | X8 | (design) | Design contradicts itself — relates to ARTI-N3 |

---

## 1. App-wide: theme, buttons, tab bar, type (6 open)

The three cross-cutting items (letter-spacing, Roboto labels, lost card borders) are listed once here and referenced from screens.

### G15 — Medium — Partly fixed
Selected chips now match the design. Unselected chips are still filled `#2b2140`, where the design wants them **transparent**: the theme asks for transparent, but `RawChip` draws on a canvas-type `Material` that falls back to `canvasColor` `#2b2140`. The Articles filter chips are also about **40.5dp** tall, where the design's minimum is **44**.
Files: `lib/fcc_theme.dart:309,442-449`; `lib/news/ui/feed/feed_view.dart:97-102`

### GLOB-N2 — Medium — New
Most text carries Material's default letter-spacing, but the design-system rule (DS-Type-Sentence-case-no-caps) says "No all-caps labels or letter-spacing" — **letterSpacing 0 everywhere**.
Why: the theme overrides body, title and label styles with new `TextStyle`s that leave `letterSpacing` null. `Theme.of()` then merges the M3 `englishLike2021` geometry back in (`ThemeData.localize`, theme.dart:139), so the defaults return: bodyLarge 0.5, bodyMedium 0.25, bodySmall 0.4, titleMedium 0.15, labelLarge 0.1, labelSmall 0.5.
Where it shows:
- Every plain `Text` inherits Material's `DefaultTextStyle` (bodyMedium) → 0.25 unless it sets letterSpacing. Covers almost all screens: hero copy, card titles, daily challenge text, module and chapter names.
- `ListTile` titles use bodyLarge (0.5): Account links (Settings, Downloads, Report an issue), Settings rows, chapter names inside `ExpansionTile`.
- Text fields use bodyLarge (0.5).
- Chips merge labelLarge (0.1).
Only `LearnEyebrow`, code blocks, the news bookmark and tag buttons, and the English word style set `letterSpacing: 0`. Buttons are not affected (their Material textStyle replaces DefaultTextStyle).
Files: `lib/fcc_theme.dart:313-363` — fix is `letterSpacing: 0` on each style, or a `DefaultTextStyle` at the app root.

### GLOB-N3 — Medium — New
Some buttons render their labels in **Roboto instead of Lato**. They override `textStyle` without a `fontFamily`. `ThemeData.fontFamily` only reaches the textTheme, and `ButtonStyleButton` puts the resolved textStyle straight onto its Material without merging, so the label falls back to the platform font. Affected:
- Listen "Podcasts" / "Code Radio" tabs (`listen_tabs.dart:38`, 15/700-900). Roboto visible in screenshots.
- Podcast "Play latest" `FilledButton` (`episode_list_view.dart:362`, 16/900).
- Episode play/download pill buttons (`episode_play_button.dart:116`, 13/700).
The design is Lato only (DS-Type-One-family-three-weights).
Files: `lib/widgets/listen_tabs.dart:38`; `lib/podcasts/ui/episode_list/episode_list_view.dart:362`; `lib/podcasts/ui/widgets/episode_play_button.dart:116`

### GLOB-N4 — Medium — New
Several cards lost the theme's **1px `#4c4066` border**. Each passes `shape: RoundedRectangleBorder(borderRadius: ...)` without a `side`, which replaces the cardTheme shape and its border. The fix commits introduced this when they changed radii; at `9143cbe` these were plain `Card()` with the theme border. Affected:
- Account profile card (`account_view.dart:177`)
- Account card (`account_view.dart:216`)
- Account links card: Settings, Downloads, Report an issue (`account_view.dart:279`)
- Every profile section card (`_Section`, `profile_view.dart:491`)
The design draws all of them with `border 1px solid #4c4066` (D-Account-In, D-Profile-Me). On the account screen the cards show no edge, while the home cards do.
Files: `lib/auth/ui/account/account_view.dart:177,216,279`; `lib/auth/ui/profile/profile_view.dart:491`

### GLOB-N5 — Medium — New
Secondary buttons in dialogs don't follow the updated design, where **every dialog button pair is 50px with a 17px label (primary 900, secondary 700)**:
- Settings "Reset app data" dialog: "Cancel" is a plain text button (no outline), 48px, 16/700. Design: 50px outline button, 17/700.
- Edit profile "Discard": danger outline, 48px, 16/700. Design: 50px, 17/700.
- "Leave quiz": 50px but 16/700. Design: 17/700.
- Delete account "Keep my account": theme outline, 48px, 16/700. Design: 50px, 17/700.
Files: `lib/widgets/dialog/confirm_dialog.dart:27`; `lib/auth/ui/widgets/profile_form.dart:38-41`; `lib/learn/ui/challenge/widgets/quiz_leave_dialog.dart:80-90`; `lib/settings/ui/settings/delete_account/delete_account_view.dart:230-233`

### G20 — Low — Partly fixed
The theme still has no **attention, info or danger callout tokens**; only the success set exists. Design (DS-Comp-Callouts, dark): attention `#3e2d02` fill / `#5b4403` line; info `#042f62` / `#07458d`; danger `#5f0705` / `#880b09`. The code surface and danger button tokens now exist.
Files: `lib/fcc_theme.dart:4-51,566-594`

---

## 2. Courses home — board D-Home (5 open)

### HN1 — Medium — Partly fixed
The guest first-visit hero exists, but four details differ:
- Main button reads "Start learning"; design says **"Start step 1"**.
- "Sign in" is a full-width 48px outline button (radius 12, 16/700) stacked under the sentence, behind an edge-to-edge divider. Design: a **compact** button (min-height 44, padding `0 16`, radius 10, 14/700, 1.5px `#ffffff` edge) **on the same row as the sentence, to its right**, with the divider **inside** the hero padding.
- "New here? Start here" is 14/400; design **13/700**.
- The intro line is 14px; design **15px at 1.45**.
Files: `lib/learn/ui/landing/landing_view.dart:333-404`

### HOME-N1 — Low — New
Returning-learner hero progress bar is 6px tall; design hero bar is **8px**.
Files: `lib/learn/ui/landing/landing_view.dart:209-218`

### HOME-N2 — Low — New
Gap between hero and daily challenge card is 12px; design main column gap is **16px**.
Files: `lib/learn/ui/landing/daily_challenge_card.dart:106`

### HOME-N3 — Low — New
Daily challenge card:
- "Past challenges" is 16/700; design **15/700**.
- Gap between date row and buttons is 8px; design **12**.
- Gap from "Daily challenge" label to title is 4px; design **2**.
Files: `lib/learn/ui/landing/daily_challenge_card.dart:167,193,264-269`

### HOME-N4 — Low — New
Course list cards ("Recommended curriculum", "Learn English for Developers") use the Card theme's radius 18; design **16**.
Files: `lib/learn/ui/landing/landing_view.dart:93`; `lib/fcc_theme.dart:382`

---

## 3. Course chapters (Responsive Web Design) — board D-Chapters (7 open)

### CHAP-N1 — Medium — New
For a signed-in learner with no completed steps, the same resume action has **three labels**: "Continue step 1" on the home hero, "Start learning" on the chapters hero, "Start workshop" in the module footer. Each screen uses a different rule (`isReturning`, `done > 0`, `block done > 0`). The design wording is consistent across screens: **"Continue step 3" / "Continue" / "Continue step 3"** (home hero / chapters hero / module footer).
Files: `lib/learn/ui/landing/landing_view.dart:265-271`; `lib/learn/ui/superblock/superblock_view.dart:330`; `lib/learn/ui/widgets/block_card.dart:394-401`

### C2 — Low — Partly fixed
Chapters hero bar has equal-width segments (4 × ~82.6dp). Design sizes each segment **by the chapter's module count** (flex-grow 6:1:21:1, min 14px), so HTML, Computers, CSS and the exam render in proportion.
Files: `lib/learn/ui/superblock/superblock_view.dart:290-303`

### C5 — Low — Partly fixed
Collapsed chapters now show 8px module dots. With progress (from code), a finished chapter's tile stays `#29216c` with a `#8ddba3` check; design **fills the tile `#8ddba3` with a `#1a1530` check**. The meta line ("3 of 21 modules" / "Done") is drawn under the dots; design puts it **between the chapter name and the dots**.
Files: `lib/learn/ui/superblock/superblock_view.dart:415-423,447-485`

### C6 — Low — Partly fixed
Exam card's "Open" link sits on its own row under the sentence, left-aligned, icon before the word. Design: **on the sentence's row, right-aligned, 15/700, icon after the word**. Sentence is `#fff8ec` at default 14/1.45; design **`#cabeea` at 14/1.4**. Trophy tile radius 12; design **14**.
Files: `lib/learn/ui/superblock/superblock_view.dart:179-238`

### CHAP-N2 — Low — New
Open chapter's collapse chevron is `#9ea1fe` (ExpansionTile default, `colorScheme.primary`). Design draws it **`#cabeea`** like the other chevrons.
Files: `lib/learn/ui/superblock/superblock_view.dart:402-410`

### CHAP-N3 — Low — New
Module rows in an open chapter are ~54dp apart (12px padding around a 26px node, plus 4px gap). Design rows: **min-height 60, 10px padding, 2px gap**.
Files: `lib/learn/ui/superblock/superblock_view.dart:551-552,585-587`

### CHAP-N4 — Low — New
Gaps between cards are off. Chapter cards are 12px apart (padding bottom 12); exam card is 20px below the last chapter (12 + margin-top 8). Design column gap **16px throughout**.
Files: `lib/learn/ui/superblock/superblock_view.dart:171,394-395`

---

## 4. Module (Basic HTML) — board D-Course (5 open)

### M2 — Low — Partly fixed
Module action is now a fixed bar above the tab bar, but the bar background is `#2b2140` (`colors.surface`); design is the **page colour `#1a1530`**. The button has no trailing arrow; design puts an **18px arrow after the label**.
Files: `lib/learn/ui/module/module_view.dart:142-152`; `lib/learn/ui/widgets/block_card.dart:378-402`

### MODU-N1 — Low — New
Block status circles on the module screen are 26px (shared `LearnStatus` was resized for chapters); design block circles are **28px**. In-progress block: 2px ring + 8px dot; design **2.5px ring + 10px dot**. (Chapters module nodes must stay 26px with 3px ring + 8px dot — see fixed CR1.)
Files: `lib/learn/ui/widgets/learn_presentation.dart:91-113`; `lib/learn/ui/widgets/block_card.dart:148-151`

### MODU-N2 — Low — New
Module back link "Responsive Web Design" is 18/700; design (and the app's chapters screen) uses **16/700**.
Files: `lib/learn/ui/module/module_view.dart:66-75`

### MODU-N3 — Low — New
Open workshop card shows no step count until the learner has progress (`expanded && done > 0`). Design **always** shows "2 of 11 steps" (13px `#cabeea`) to the right of the "Workshop" label, so a new learner should see **"0 of 11 steps"**.
Files: `lib/learn/ui/widgets/block_card.dart:157-181`

### MODU-N4 — Low — New
Completed status circle (module blocks and chapter module rows) draws its check in `#2b2140` (`colors.surface`); design **`#1a1530`** on the `#8ddba3` fill.
Files: `lib/learn/ui/widgets/learn_presentation.dart:107`

---

## 5. Challenge editor (step) — boards D-JS-Before, D-JS-Passed (3 open)

### E3 — Medium — Partly fixed
Colours now match (guest: transparent with `#bbbfff` edge and label; signed in: yellow). But "Next step" sits in a **fixed 128dp-wide box** with a 17px label, so the guest label wraps to two lines ("Next / step", ~60dp tall). Design **sizes the button to its content (padding `0 14 0 18`) with a one-line 16px label at 48px**. The signed-in variant uses the same 128 width and a 17/900 label, so it wraps too (from code; not captured).
Files: `lib/learn/ui/editor_challenge/editor_challenge_view.dart:1105-1125,977-989`

### EDIT-N1 — Low — New
Step editor header "Step N of M" is 16/800; D-JS-Before uses **15/900**. Tests tool icon is Material `fact_check` (box with tick); design uses a **checklist** (three ticks with lines) and, when selected, a **filled checklist**.
Files: `lib/learn/ui/editor_challenge/editor_challenge_view.dart:446,1052-1053`

### EDIT-N2 — Low — New
Instructions "Hide"/"Show" label is 14/800; design **14/700** (DS text buttons are weight 700).
Files: `lib/learn/ui/editor_challenge/editor_challenge_view.dart:616-622`

---

## 6. Get help sheet and Create a post — boards D-Help, D-Help-Post (2 open)

### HELP-N1 — Medium — New
Create a post: "Post to the forum" stays disabled until the description has **at least 50 characters**, and also when the forum URL would be too long, but **nothing on screen says so**. The footer always reads "Tick both boxes to post.", so someone who ticked both boxes and typed a short description sees a disabled button with a wrong hint. The design has no length rule.
Files: `lib/learn/ui/challenge/widgets/help_dialog.dart:12,246-253,380-399`

### HPN3 — Low — Partly fixed
Headings now match; checkboxes match except corner radius: 26px box at radius 7, D-Help-Post uses **8**. Other leftovers:
- "We'll attach automatically" card radius 12 (`help_dialog.dart:345`); design **16**.
- "Before you post, please confirm:" is 16px (bodyLarge); design **15**.
- "Tick both boxes to post." is 14px; design **13**.
- "Post to the forum" is 48px tall; design **50**.
Files: `lib/learn/ui/challenge/widgets/help_dialog.dart:280-283,381-386,495`

---

## 7. Daily challenge archive — board D-Daily-Archive (2 open)

### DAIL-N1 — Medium — New
The daily challenge card's "Start challenge" is an outline button at **44px with a 15/700 label** (`daily_challenge_card.dart:203-213`); the same widget is used on Home and the archive.
- D-Home: **48px, radius 12, 1.5px `#bbbfff`, 16/700** outline (DS-Button-Sizes: card buttons 48px/16px).
- D-Daily-Archive (today card): **filled yellow `#ffc83d`, 48px, radius 12, `#1a1530` 16/900**.
So the app is 4px short and 1px small on both screens, and on the archive it is also outline instead of filled.
Files: `lib/learn/ui/landing/daily_challenge_card.dart:200-222`

### DAN2 — Low — Partly fixed
Row eyebrow is now JetBrains Mono 12 `#cabeea` but **bold (700)**; design uses **regular**. Row title is 16/700 (titleMedium); design **15/700**.
Files: `lib/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart:240-254`

---

## 8. Daily challenge editor — board D-Daily-Editor (4 open)

### DE3 — Medium — Partly fixed
JavaScript | Python control is a Material `SegmentedButton`: one `#bbbfff` outline around both halves, a divider between them, transparent track, Lato 15 labels (900 selected, 700 unselected). Design:
- track `#2b2140` with 1px `#4c4066` edge, radius 12, 4px padding, 4px gap
- selected pill: radius 8, `#29216c`, inset 1.5px `#bbbfff`
- unselected segment: no border
- labels **JetBrains Mono 14** (700 selected, 600 unselected)
Files: `lib/learn/ui/daily_challenge/daily_challenge_view.dart:62-78`; `lib/fcc_theme.dart:484-519`

### DEN1 — Medium — Partly fixed
Editor is now an inset rounded card. The **Example** renders as stacked outlined code blocks: the call, then "should return" on its own line, then the result block, then a stray "." on its own line, ~140dp in all. Design: **one 13px `#cabeea` line with inline `#3f3557` chips (radius 4, no border) and the period inline**.
Files: `lib/learn/ui/editor_challenge/editor_panels.dart:81-106`

### DE2 — Low — Partly fixed
Inset card with 20/900 title and "Read more" is in place. Leftovers:
- Summary is cut to 2 lines with ellipsis; design shows **the whole first paragraph, 15/1.5**.
- "Read more" is a padded `TextButton`, sitting ~14dp right of the title; design **padding 0, flush left**.
- Card padding 12 all round; design **12 16 14** (top, horizontal, bottom).
Files: `lib/learn/ui/editor_challenge/editor_panels.dart:31-73`

### DED-N1 — Low — New
Daily editor back icon is a chevron (`Icons.chevron_left_rounded`); D-Daily-Editor uses a **left arrow** (as does the archive screen before it). Header title is 16/800; design **16/700**.
Files: `lib/learn/ui/editor_challenge/editor_challenge_view.dart:430-446`

---

## 9. Articles feed — board D-Tutorials (3 open)

### A2 — Low — Partly fixed
Search entry is now radius 12, 48dp, 16px hint. Its edge is 1px `#7d709d` (`colors.outline`); design **1.5px `#4c4066`**. Its fill is `#3f3557` (`colors.surfaceContainer`); D-Tutorials and DS-Role-Surface (inputs on surface/card) use **`#2b2140`**.
Files: `lib/news/ui/feed/feed_view.dart:39-46`

### AN1 — Low — Partly fixed
List eyebrow is now JetBrains Mono 12 `#bbbfff` but **bold (700)**; design **regular**.
Files: `lib/news/ui/widgets/tag_button.dart:33-41`

### FEED-N1 — Low — New
In feed list rows the tag eyebrow is a 44dp-tall `TextButton`, so the title starts ~20dp below the eyebrow text and the eyebrow sits well below the top of the thumbnail. Design stacks **eyebrow, title and meta with 4px gaps, top-aligned with the image**. Row padding is 18 top and bottom; design **14 below with no extra top**.
Files: `lib/news/ui/widgets/post_tile.dart:41,70-79`; `lib/news/ui/widgets/tag_button.dart:30-31`

---

## 10. Article search — board D-Search (1 open)

### S3 — Medium — Partly fixed
`ErrorRetry` is now a card with a 72px circle, a 20/900 title and a yellow "Try again", but:
- **No body line**: it only takes `message`, so the design's explanation ("Something went wrong ... Your progress is safe.") can't be shown.
- Card shrinks to its content with zero margin; design **spans the width with 16px side padding**.
- Radius 18, padding 16; design **radius 20, padding 28 vertical / 20 horizontal**.
- Icon is default 24px `#fff8ec`; design **34px `#cabeea`**.
- "Try again" is 48px 16/900; design **50px 17/900**.
Files: `lib/widgets/error_retry.dart:3-50`; `lib/fcc_theme.dart:377-384`

---

## 11. Article — board D-Article (2 open)

### ARTI-N1 — Low — New
Article header (tag, title, author, cover) and tags footer use 20dp side padding while body uses 16, so title and cover sit 4dp inside the body text's left edge. Header starts 24dp below the progress bar, and the tag is a full 44dp button with a 10dp gap, so the title sits much lower. Design: **16 side padding everywhere, 16 top padding, tag pulled in with -6/-14 margins**.
Files: `lib/news/ui/post/post_view.dart:22,31,129`; `lib/news/ui/widgets/article_reader.dart:170`

### ARTI-N3 — Low — New
Code-block "Copy" buttons are 44px with a 13/700 label; updated design (D-Code, and D-Article's JavaScript block) uses **14/700** (compact button size). See X8: the HTML block on D-Article still shows 13/700 — follow the design-system rule (14/700).
Files: `lib/widgets/html_handler/code_block.dart:154-169`

---

## 12. Saved articles — board D-Saved (3 open)

### SAVE-N1 — High — New
**Android system back on Saved articles and on article search closes the app.** `/news/bookmarks` and `/news/search` are sibling routes inside the news `ShellRoute`, opened with `context.go` ("View bookmarks", the "Search articles" entry, and the "Saved articles" link on the news load-error screen). `go` replaces the location, so nothing is left to pop, and there is no `PopScope`. Only the in-app back arrows (`context.go('/news')`) return to Articles. The design treats both as sub-screens with a back arrow to Articles.
Not affected: Podcasts "Downloaded" uses the same `context.go` pattern inside the podcasts shell, but it is a filter chip with no back arrow, so system back behaves like any tab root. Daily archive and daily challenge are pushed.
Pre-existing (already in `9143cbe`). Fix: **push these two routes, or add a `PopScope` that goes to `/news`**.
Files: `lib/news/ui/news_shell.dart:54,72`; `lib/news/ui/feed/feed_view.dart:49`; `lib/news/ui/search/search_view.dart:41`; `lib/news/ui/widgets/news_load_error.dart:46`; `lib/routing/news.dart:26-31`; (reference only) `lib/podcasts/ui/podcasts_shell.dart:42,52`; `lib/learn/ui/landing/daily_challenge_card.dart:216,272`

### SV1 — Low — Partly fixed
Empty state matches (dashed `#4c4066` card on `#2b2140`, 64px `#29216c` circle, "No saved articles" 20/900, new copy, yellow "Browse articles"). Leftovers: bookmark glyph is 40px (design **28**), body is 14 (design **15**), padding 24 all round (design **28 vertical / 20 horizontal**).
Files: `lib/news/ui/bookmark_feed/bookmark_feed_view.dart:165-215`

### SAVE-N2 — Low — New
Plain AppBar titles use the theme's 18/700: "Saved articles" and "Daily coding challenges". D-Saved and D-Daily-Archive use **16/700**.
Files: `lib/fcc_theme.dart:370-374`; `lib/news/ui/news_shell.dart:75-77`; `lib/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart:48`

---

## 13. Listen: Podcasts — board D-Listen (3 open)

### L1 — Medium — Partly fixed
Colours, edges, sizes and weights of the Podcasts/Code Radio tabs match; outer box is radius 12 like D-Listen. Remaining: tab labels render in **Roboto instead of Lato** (GLOB-N3), and the **inner tabs are radius 12 where D-Listen and DS-Comp-Segmented-tabs use 8**.
Files: `lib/widgets/listen_tabs.dart:23,38-43,54`

### LIST-N1 — Low — New
The Listen header jumps when switching between Podcasts and Code Radio. Podcasts insets title and tabs 18px from the sides with a 24px top pad; Code Radio uses a `SliverAppBar` title and 16px tab padding. Tab box moves from x81-1360/y375-543 to x74-1367/y403-571 (px). D-Listen uses **16px on both**; the header must not move between tabs.
Files: `lib/podcasts/ui/podcasts_shell.dart:26-33`; `lib/code_radio/ui/player/player_view.dart:24-34`

### LIST-N2 — Low — New
Episode counts have no thousands separator ("1051 episodes"); design writes **"1,042 episodes"**.
Files: `lib/podcasts/ui/widgets/podcast_grid_tile.dart:48`

---

## 14. Podcast episodes — board D-Podcast (4 open)

### P1 — Medium — Partly fixed
"Play latest" has the right shape and size (radius 12, 48px, 16/900), but its label renders in **Roboto Black instead of Lato** (GLOB-N3).
Files: `lib/podcasts/ui/episode_list/episode_list_view.dart:359-375`

### P2 — Low — Partly fixed
Episode play pills have the right shape and colours, but the duration label ("1 hr 18 min") is 13/700 where D-Podcast uses **14/700** (DS-Button-Sizes: pills use 14px Label S), and it renders in Roboto (GLOB-N3).
Files: `lib/podcasts/ui/widgets/episode_play_button.dart:116-118`

### PODC-N1 — Low — New
Share button next to "Play latest" is a 44×44 rounded square (radius 10) filled `#2b2140` (`IconButton.filled` with `surfaceButtonStyle`). D-Podcast draws it **48×48, radius 10, transparent, no edge** (DS-Button-Icon). Drop the fill and make it 48px.
Files: `lib/podcasts/ui/episode_list/episode_list_view.dart:377-389`; `lib/fcc_theme.dart:215,249`

### PODC-N2 — Low — New
"Episodes" heading is 18/700; design **20/900**. "Newest first" sort label is 13px; design **14/700**.
Files: `lib/podcasts/ui/episode_list/episode_list_view.dart:223-240`

---

## 15. Episode player — board D-Episode (5 open)

### EPIS-N1 — Medium — New
Before playback starts, the -10 and +30 skip buttons render as `#3f3557` rounded tiles (radius 10) with `#7d709d` glyphs, because the `TextButton` picks up the theme's disabled fill. DS-Button-States: **disabled icon buttons have no fill (only the glyph dims) and the reason should be shown nearby**; nothing on screen says why.
Files: `lib/podcasts/ui/episode/episode_view.dart:493-504`; `lib/fcc_theme.dart:225-230`

### EP2 — Low — Partly fixed
Speed and download are now transparent with a 1.5px `#bbbfff` edge, but still **52×48 rounded rectangles at radius 12**; D-Episode draws **52×44 pills (radius 999)**. Before playback the speed button is disabled with a `#3f3557` fill and `#7d709d` "1×", and nothing says why (same rule as EPIS-N1).
Files: `lib/podcasts/ui/episode/episode_view.dart:313-333`; `lib/podcasts/ui/widgets/download_button.dart:65-73`

### EP3 — Low — Partly fixed
Meta line is 13px `#cabeea` and adds "Downloaded" once saved. It still has **no file size**: app shows "May 19, 2026 · 1 hr 18 min"; design "May 19, 2026 · 1 hr 19 min · [Size]".
Files: `lib/podcasts/ui/episode/episode_view.dart:443-470`

### EPN1 — Low — Partly fixed
Title (20/900), JetBrains Mono timestamps and "10"/"30" labels are fixed. Remaining: skip glyph is 30px (design **24**), timestamps are weight 700 (design **regular**).
Files: `lib/podcasts/ui/episode/episode_view.dart:286-291,505-506`

### EPIS-N2 — Low — New
Episode player sizes:
- Artwork 290px radius 24; design **250px, radius 20, 1px `#3e329c` edge**.
- Main play button 80px; design **72**.
- Show notes card: heading 18/700 (design **15/900**), body 16/1.5 (design **14/1.5**), "Read all" uses theme text-button style (design **14/700 `#bbbfff` underlined**), card radius 18 with 18 padding (design **radius 16, padding 14 vertical / 16 horizontal**).
Files: `lib/podcasts/ui/episode/episode_view.dart:40-43,84-97,121-190`; `lib/podcasts/ui/widgets/episode_play_button.dart:138`

---

## 16. Code Radio — board D-Listen-Radio (2 open)

### RN1 — Low — Partly fixed
Timestamps are JetBrains Mono 12px `#cabeea` but **weight 700**; design **regular**.
Files: `lib/code_radio/ui/player/player_view.dart:199-216`

### RADI-N1 — Low — New
- Album art 240px radius 22; design **220px, radius 20, 1px `#3e329c` edge**.
- Song title 20/800; design **20/900**. Artist/listeners line 14px; design **13px**.
- Play button 76px with 38px glyph; design **72px, 30px glyph**.
- Up next card radius 18, padding 16, heading 16/700; design **radius 16, padding 14 vertical / 16 horizontal, heading 15/900**. Its art 48px; design **44px**.
Files: `lib/code_radio/ui/player/player_view.dart:95-118,128-160,228-262,330-336`

---

## 17. Account (signed out) — board D-Profile / D-Account-In (1 open)

### AGN1 — Low — Partly fixed
Copy, Sign in label (17/700) and 13px footer are fixed. Guest card is still radius 18 with 16px padding; D-Account-In uses **radius 16 with 18 vertical / 16 horizontal padding**, and its edge is gone (GLOB-N4). The 56px avatar has **no 1px `#4c4066` edge** and is **top-aligned**; design **centres it against the text**.
Files: `lib/auth/ui/account/account_view.dart:215-233`

## 18. Account (signed in) — board D-Account-In (1 open)

### AIP1 — Medium — Partly fixed
Handle, avatar and 18/16 padding of the header card are fixed. D-Account-In draws **both the header card and the links card (Settings, Downloads, Report an issue) at radius 16**; the app has the header card at radius 12 (`account_view.dart:177`) and the links card at 18 (`account_view.dart:279`). Both have lost their 1px `#4c4066` edge (GLOB-N4).
Files: `lib/auth/ui/account/account_view.dart:176-177,278-279`

---

## 19. Sign in — board D-Signin (2 open)

### SIGN-N1 — Low — New
"or use your email" divider is off-centre. The label sits in a loose `Flexible(flex: 4)` between two `Expanded(flex: 1)` rules, so each rule gets a sixth of the width and the unused space ends up after the right rule (left rule x23-92, right rule x240-310 of 461). D-Signin **centres the label between rules that reach both edges**. Label is 14px; design **13px**.
Files: `lib/auth/ui/login/login_view.dart:210-233`

### SIGN-N2 — Low — New
"Email" field label is 16/700 (titleMedium); design **14/700**. Provider buttons are 12px apart; design **10px**.
Files: `lib/auth/ui/login/login_view.dart:208,235`

---

## 20. Public profile (your view) — board D-Profile-Me (1 open)

### PF3 — Low — Still open (DESIGN GAP — no code change expected)
No board draws an empty Certifications state; the app shows "You have not yet earned any certifications." in a plain card. Needs a design decision.
Files: `lib/auth/ui/profile/profile_view.dart:903-910`

## 21. Public profile (as others see it) — boards D-Profile-Me-Private, D-Profile-Private-Others (1 open)

### PO-N1 — Low — New
Private-profile message reads "This camper has chosen to keep their profile private."; both boards say **"This learner has chosen to keep their profile private."**
Files: `lib/auth/ui/profile/profile_view.dart:163`

---

## 22. Edit profile — boards D-Profile-Edit, D-Profile-Edit-Photo, D-Profile-Edit-Unsaved (3 open)

### EF1 — High — Partly fixed
"Change photo" opens a sheet, but **nothing in it works**. Take photo, Choose from library and Remove photo are all disabled under "Photo changes are not available in the app yet.", yet they render at **near-full contrast, so they look tappable**. The sheet also differs from D-Profile-Edit-Photo, which has:
- title **"Profile photo"** with subtitle **"Square images work best."**
- **dividers** between rows
- a **`#ffaea2` "Remove photo"** with a red icon
- a **full-width `#bbbfff` outline Cancel** button
Files: `lib/auth/ui/widgets/profile_photo_options.dart:1-38`; `lib/auth/ui/profile_edit/profile_edit_view.dart:153-162`

### EFN1 — Low — Partly fixed
Field edges are now `#7d709d`. The About counter reads "33 characters" with **no maximum**, while Portfolio's description shows "21 / 288 characters" and the design shows **"[N] / [max] characters"**. About field has **no placeholder**; design: **"A sentence or two about you and what you're learning"**.
Files: `lib/auth/ui/profile_edit/profile_edit_view.dart:167-183`

### EPRF-N1 — Low — New
- Header Save is radius 10, 16/900, min 64×44; D-Profile-Edit draws a **radius-999 pill at 15/900, min 72×44**.
- "Change photo" is radius 10; design **radius-999 pill**.
- Username helper text "Your profile link: …" is inset ~12dp by Material's helper padding; design **aligns it with the field edge**.
- "Discard changes?" dialog: title 20/700 and body 14px; D-Profile-Edit-Unsaved **20/900 and 15px**.
Files: `lib/auth/ui/widgets/profile_form.dart:12-16,126-136,239`; `lib/auth/ui/profile_edit/profile_edit_view.dart:153-162`

---

## 23. Edit project — board D-Profile-Portfolio (1 open)

### PP1 — High — Partly fixed
The 180px dashed drop zone matches. Its "Add image" button is **hard-disabled** (`#3f3557` pill, dimmed label) with the extra line "Project image changes are not available in the app yet." below it, so a project image **still cannot be added or changed**. Design shows an **enabled `#bbbfff` outline "Add image" pill**.
Files: `lib/auth/ui/profile_project/profile_project_view.dart:132-170`

---

## 24. Profile visibility — board D-Privacy (3 open)

### PV2 — Medium — Partly fixed
There is a Public | Private control with globe and lock icons and the design's notes, but it is a Material `SegmentedButton`: two joined outlined segments sitting straight on the page. D-Privacy:
- wraps it in a **card** (`#2b2140`, 1px `#4c4066`, radius 16, padding 14), with the **note inside that card**
- **track** `#2b2140` with 1px `#4c4066` edge, radius 12, 4px padding and 4px gap
- **separate radius-8 segments**, 15px labels
- "Who can see your profile" and "Show on your public profile" are 16/700 `#fff8ec`; design **14/700 `#cabeea`**
- the note **wraps in the middle of the URL** ("freecodecamp.org/" then "myusername.") — must not break inside the URL
Files: `lib/auth/ui/profile_visibility/profile_visibility_view.dart:90-138`

### PRIV-N1 — Medium — New
Profile visibility **shows the bottom tab bar**, while Settings (which leads to it) does not. D-Privacy, like D-Settings, has **no tab bar**.
Files: `lib/auth/ui/profile_visibility/profile_visibility_view.dart:50`

### PV3 — Low — Partly fixed
Groups, labels, weights and Supporter subtitle match. The About you group is ordered Name, About, Location; D-Privacy orders it **Name, Location, About**.
Files: `lib/auth/ui/profile_visibility/profile_visibility_view.dart:220-236`

---

## 25. Settings — board D-Settings (3 open)

### ST3 — Medium — Partly fixed
Socrates, Campfire and Profile visibility rows exist. Socrates and Campfire are **permanently disabled** switches labelled "Socrates mode" and "Campfire mode" with "Not available in the app yet", placed **below** the Daily challenge reminder. Design:
- labels **"Socrates"** and **"Campfire mode"**
- **working switches with descriptive subtitles**
- listed **above** the reminder
- Profile visibility row has subtitle **"Choose who sees your profile and what it shows"** and a **"Public"** value before the chevron (app has neither)
Files: `lib/settings/ui/settings/settings_view.dart:216-260,556-576`

### SETT-N2 — Medium — New
Off-state switches use the Material default: track `#4c4066` with a 2px `#7d709d` edge and a small 16dp `#7d709d` thumb, ~52×32. D-Settings draws **off switches 48×28 with a `#3f3557` track, a 1px `#7d709d` edge and a 22px `#cabeea` knob**. On switches match. Affects Daily challenge reminder, Socrates and Campfire switches, and any off switch on Profile visibility.
Files: `lib/fcc_theme.dart` (no `switchTheme`); `lib/settings/ui/settings/settings_view.dart:216,563`

### SETT-N1 — Low — New
Settings group cards use the theme card radius 18; D-Settings draws them at **16** (also what DS-Button-Shape says for cards).
Files: `lib/fcc_theme.dart:376-384`; `lib/settings/ui/settings/settings_view.dart:487`

---

## 26. Where the design contradicts itself (1)

### X8 — Partly resolved (design-side)
DS-Button-Sizes: compact 44px buttons, pills and chips use a 14px label; text buttons 700. The editor "Hide" button (14/700) and all D-Code "Copy" buttons (14/700) comply. Holdout: the HTML code-block "Copy" in D-Article is still 44px 13/700, while the JavaScript block's "Copy" on the same board is 14/700. → App should follow the design-system rule: **14/700 for all Copy buttons** (ARTI-N3).

---

## Appendix A — Design-system reference (dark) distilled from the report

Use these when a finding refers to a rule rather than an exact number.

**Colour tokens (dark)**
| Role | Hex |
|---|---|
| Page background | `#1a1530` |
| Surface / card / input on card | `#2b2140` |
| Sunken / disabled fill / chip fill in code | `#3f3557` |
| Card border / divider | `#4c4066` |
| Control edge (fields), disabled label | `#7d709d` |
| Muted text | `#cabeea` |
| Text | `#fff8ec` |
| Link / outline-button label & edge | `#bbbfff` |
| Primary violet (focus, progress, current) | `#9ea1fe` |
| Tint (selected/pressed bg) | `#29216c` |
| Deep violet (timeline, art edge, heatmap L1) | `#3e329c` |
| Primary yellow / pressed | `#ffc83d` / `#d7a401` |
| Label on yellow | `#1a1530` |
| Success text / dark / banner fill | `#8ddba3` / `#03572b` / `#013b1b` |
| Error text / danger-outline edge | `#ffaea2` |
| Danger fill / pressed | `#b02019` / `#880b09` |
| Danger-outline pressed | `#5f0705` |
| Donate pink on | `#ffaabc` on `#5b0928` |
| Callout attention fill/line | `#3e2d02` / `#5b4403` |
| Callout info fill/line | `#042f62` / `#07458d` |
| Callout danger fill/line | `#5f0705` / `#880b09` |
| Heatmap levels | `#4c4066` (empty), `#3e329c`, `#8381ff`, `#bbbfff` |

**Type**
- Lato only for UI text, weights **400 / 700 / 900** only (DS-Type-One-family-three-weights). JetBrains Mono for code, step numbers, date eyebrows, timestamps, usernames.
- **letterSpacing 0 everywhere**, no all-caps.
- **Nothing under 12px**; 12px only in bold for badges and tab labels. Subtitles/meta are 13px; values 14px.
- Display (page titles) 30/36 w900.

**Buttons**
- Radius **12** for buttons ≥48px; **10** for compact 44px buttons; pills (999) only for chips, avatars, Donate, and where a board explicitly draws a pill (episode player speed/download, Edit profile Save and Change photo, Add image).
- Filled labels weight **900**: **17px** on hero, footer and dialog buttons; **16px** elsewhere. Outline and text buttons **700**.
- Card buttons **48px / 16px label**. Compact buttons, pills and chips **44px / 14px label**. Dialog button pairs **50px / 17px** (primary 900, secondary 700).
- Outline: transparent, 1.5px `#bbbfff` edge, `#bbbfff` label — never a grey edge.
- Danger-outline: transparent, 1.5px `#ffaea2` edge, `#ffaea2` label, radius 12, pressed `#5f0705`.
- Danger solid: `#b02019` fill, `#ffffff` 900 label.
- Disabled (filled/outline/text): `#3f3557` fill, `#7d709d` label, no border/underline. **Disabled icon buttons: no fill, only the glyph dims, and the reason is shown nearby** (DS-Button-States).
- Icon button (DS-Button-Icon per latest D-Podcast): 48×48, radius 10, transparent, no edge, `#fff8ec` glyph.
- Focus ring: 2px in text colour with 2px gap.

**Layout**
- Cards: radius **16** (exceptions explicitly drawn: chapters hero and chapter cards 20, error card 20, stats cells 14), **1px `#4c4066` border**.
- Main column gap **16px**; side padding **16px**.
- Segmented controls (DS-Comp-Segmented-tabs): track `#2b2140` + 1px `#4c4066`, radius 12, 4px padding and gap; selected segment radius 8, `#29216c`, 1.5px `#bbbfff` inset; unselected no border.
- Switch (off): 48×28, track `#3f3557`, 1px `#7d709d` edge, 22px `#cabeea` knob.
- Inputs: on surface/card fill `#2b2140`; focused edge 2px `#9ea1fe`.

## Appendix B — Fixed since the last review (DO NOT REGRESS)

App-wide: G1 (no tab pill indicator), G2 (selected tab filled icon + `#fff8ec` label), G4 (tab labels 12/700), G5 (raised Donate heart), G6 (pressed colours), G7 (disabled look), G8 (focus ring), G9 (button radii 12/10, pills only where specified), G10 (filled labels 900, 17/16), G11 (primary label `#1a1530`), G12 (outline buttons transparent, 1.5px `#bbbfff`), G13 (danger-outline style), G14 (danger solid style), G16 (progress bars 6px), G17 (page titles 30/36 w900), G18 (icon buttons `#fff8ec` glyph, radius 10), G19 (skeleton loading + status line), GLOB-N1 (Donate label baseline, c3e341e).
Home: H1 (daily "Start challenge" outline on Home), H2 (calendar date tile), H3 (hero bar white on 30% white), H4 (neutral 44px icon tiles), H5 ("Start here"/"In progress" status), HN2 (daily card text), HN3 (hero title 20/900 + shadow), HN4 (section headings 20/900), HN5 (rows ≥72px).
Chapters: C1, C4, CN1, CN2, CN3, CN4, CN5, CN6 (hero + chapter cards radius 20), CR1 (chapter nodes 26px, 3px ring, 8px dot).
Module: M3, M4, MN1, MN2, MN3, MN4, MR1.
Editor: E1, E2, E4, EN1.
Help: HP1, HP2, HP3, HP4, HP5, HPN1, HPN2.
Daily archive: DA1, DA3, DAN1. Daily editor: DE1, DE4.
Articles: A1, AN2. Search: S1, S2, SN1. Article: ARN1, ARN2, ARN3, ARN4.
Saved: SVN1, SVN2. Listen: LN1. Podcast: P3, PN1. Episode: EP1.
Account: AI1, AI2, AI3. Sign in: SI1, SIN1.
Profile: PR1, PF1, PF2, PF4, PF5, PF6, PF7, PF8, PF9, PF10, PO1.
Edit profile: EF2, EF3, EFR1. Edit project: PP2, PP3, PP4.
Profile visibility: PV1 (back arrow, saves immediately with "Saved" toast).
Settings: ST1 (Theme segmented control — this is the reference implementation of the design's segmented control), ST2, STN1, STR1.

## Appendix C — Not covered by the review (check you don't break these)

Signed-in challenge completion (judged from code); profile "as others see it", earned certifications, experience rows, Supporter badge (judged from code); email sign-in code screen; Delete account; quizzes; lectures; English and review challenges; Python challenges; offline and error states; **light mode**.
Out of scope (content/data, not design): daily archive ending in August, "Challenge 80" numbering, 2020-dated search results.