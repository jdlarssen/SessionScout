# Release validation in the actual game

Status: **scoped alpha smoke checks and final restoration passed; extended validation incomplete**.
Automated tests are not a substitute for these checks.
Primary target: Forever beta 1.60.1.70338 (interface 16001). Record actual client version/build, date and outcomes here before uploading a
public release. Never mark a platform supported only by changing its TOC number.

## Full client validation checklist

- Fresh install: addon appears, login has no Lua errors, `/scout` opens the empty
  state, the panel fits the screen at low and high UI scales, Escape closes it.
- Create high/medium/low priority tasks with 5/15/30/60-minute estimates; verify
  15/30/60/custom budgets never overrun and at most three tasks appear.
- Verify keyboard text entry, long labels, Unicode, literal `|` characters and
  invalid duration input. Check that text does not overlap controls.
- Complete, undo, edit and delete; cancel editing; change pages after deletion.
- `/reload`, logout/login and restart preserve tasks, note and budget.
- Two characters: definitions are shared, character completion is separate,
  shared completion is shared, notes remain separate.
- Daily/weekly tasks clear at the real server reset without requiring a reload.
  Unavailable reset APIs show an understandable message and preserve tasks.
- Open/close repeatedly: no duplicate timers, memory growth or repeated messages.
- Enter/leave combat while the panel is visible; no blocked actions or secret-value
  errors. General free-slot totals exclude specialty/reagent bags.
- Test equipment with and without durability, empty slots and broken items.
- Capture real screenshots of empty state, three suggested tasks and editing.

## Result log

| Date | Client/build | Tester | Result / evidence |
| --- | --- | --- | --- |
| 2026-10-11 13:23–13:26 Europe/Oslo | Installed Forever 1.60.1.70338 / 16001 | Codex observation of user's client | SessionScout loaded and empty panel rendered fully on a 3440x1440 display. Later the user-created task `Sell items på AH` appeared with `10 min` in the plan and `1 next actions / 10 of 15 min`. Bag/durability context displayed. Functional test sequence and Lua-error reporting are not yet verified. |
| 2026-10-11 13:37 Europe/Oslo | Forever 1.60.1.70338 / 16001 | Codex live visual check | After `/reload`, the original user-created task persisted. The revised task list visibly displayed its separate metadata line, and the plan used singular `1 next action`. Private evidence: `03-metadata-fixed.png`. |
| 2026-10-11 13:40:33 Europe/Oslo | Forever 1.60.1.70338 / 16001 | Temporary local QA companion in the real client | Runtime widget-callback checks passed for six task definitions and stored selector values; invalid minutes; 15/30/60/custom 45-minute budgets with at most three tasks within budget; Done/Undo; edit cancel/save; pagination; and two-click deletion. Daily and weekly completion both succeeded with stored server-reset timestamps. The subsequent synchronous Unicode-note assertion failed; the run did not reach fixture persistence verification. |
| 2026-10-11 after 13:41 reload, Europe/Oslo | Forever 1.60.1.70338 / 16001 | Codex restoration check | The QA companion automatically restored the original data after the assertion failure. After `/reload`, SHA256 hashes of both the account and character SavedVariables files matched the independent pre-QA file backups exactly. Private evidence: `04-runtime-note-check.png`, `qa-first-run-saved.lua` and `before-runtime-qa/`. |
| 2026-10-11 13:45:15 Europe/Oslo | Forever 1.60.1.70338 / 16001 | Instrumented local QA rerun and live visual check | The corrected full fixture run passed. The Unicode input accepted all 625 requested bytes; the addon's existing close/reopen path saved them exactly. A 265-byte Unicode fixture was then prepared for reload verification. Visually, the panel displayed three recommended tasks totaling 40 of 45 minutes, five of six tasks on page one of two, readable metadata on each displayed task, and subdued completed rows with Undo buttons. Reload persistence was still pending at this observation. Private evidence: `05-runtime-fixture.png`. |
| 2026-10-11 13:48:42 Europe/Oslo | Forever 1.60.1.70338 / 16001 | QA verification after actual `/reload` | The entire account and character fixture data matched the pre-reload expected tables, including task definitions, completion, budget and the 265-byte Unicode note. The native UI verification also passed. Private evidence: `06-reload-verified.png`. |
| 2026-10-11 after 13:48:42, before 13:50:08 Europe/Oslo | Forever 1.60.1.70338 / 16001 | Physical mouse/keyboard follow-up and visual check | Clicking Edit opened the first task. A Unicode label containing a literal pipe appeared intact while typing. Clicking Cancel edit cleared the form and left the pre-edit definition unchanged. Keyboard Escape closed the panel. Private evidence: `07-physical-unicode-edit.png`. |
| 2026-10-11 13:50:08 Europe/Oslo | Forever 1.60.1.70338 / 16001 | QA restoration and local cleanup | The companion reported restoration of the original tasks, completion, budget and note. The temporary QA addon was moved out of the client's AddOns directory. Final reload and independent hash verification were still pending at this observation. |
| 2026-10-11 13:51 Europe/Oslo | Forever 1.60.1.70338 / 16001 | Final independent restoration check | WoW reloaded normally after removal of the temporary QA addon. Both account and character `SessionScout.lua` SavedVariables files had SHA256 hashes identical to the independent pre-QA backups. The final QA record was `stage = restored` and retained the successful reload-verification result; the first attempt's assertion failure remained only in archived history. |

All listed evidence is local under `.tools/evidence/client/`. The screenshots
contain unrelated game UI/chat, and the saved-data evidence contains character
information. Neither should be uploaded as project media as-is.

The same client process remained running while SessionScout became visible.
Process start time alone cannot establish whether the addon is loaded; use the
actual visible UI and test results instead. The user continued interacting with
the auction house during the initial observations; those observations are not
an uninterrupted functional test sequence.

Confirmed first-client defect: the task list displayed the task name but omitted
its second-line minutes/priority/recurrence/scope details. Fixed using separate
bounded title and metadata FontStrings. All 22 updated Lua integration checks
passed. Revised package installed at 13:28 with SHA256
`1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
The 13:37 observation verifies the fix visually after `/reload`; the first two
screenshots show the pre-fix build.

## Runtime-check method and limits

The temporary, local-only `SessionScoutQA` companion ran in the actual Forever
client. It backed up the original account and character tables, invoked the
addon's native button callbacks and text controls, checked resulting saved data,
and restored the original tables in place on failure. An independent file backup
provided the separate post-reload restoration check recorded above.

Programmatic `Button:Click()` and `EditBox:SetText()` exercise real client widgets
and addon callbacks, but do not establish physical mouse targeting, keyboard
entry, focus behavior or rendered text visibility. Assertions on `GetText()` are
not visual evidence; the metadata fix has a separate actual screenshot check.
The later physical mouse/keyboard follow-up separately establishes the Edit,
Cancel and Escape interactions recorded in the result log. Its typed label was
`[QA] Lång oppgave | øvelse med æ, ø og å`; it was cancelled, so this follow-up
does not claim that the edited label was saved and reloaded.
Lua-error reporting was enabled for the runtime checks and no Lua-error popup
was observed. The QA assertion failure was caught and reported by the companion.

The first note assertion incorrectly required a synchronous save immediately
after programmatic text assignment. The instrumented rerun requested a prefix
followed by 300 `å` characters: 625 bytes requested and 625 bytes accepted by the
native control, while the saved note still contained zero bytes at that immediate
check. The native control reported `maxBytes = 0` and `maxLetters = 500`.

Invoking the addon's existing hide/show path through `/scout 45` saved all 625
accepted bytes exactly. No product change was needed; the QA assumption was
corrected to exercise the actual close/save lifecycle. A shorter 265-byte Unicode
note was then saved through the same path and subsequently passed the actual
reload verification at 13:48:42. This resolves the synchronous assertion failure
and establishes reload persistence for that fixture. It does not establish every
physical keyboard-entry or native-event timing case.

## Remaining checks and alpha scope

### Overlapping-window correction — scoped client checks passed, remaining checks open

On 11 October at approximately 19:00 Europe/Oslo, opening SessionScout while
GearEvidencePilot was visible showed interleaved text and buttons in their
overlapping area. Closing the pilot left the planner readable. Both root frames
then used DIALOG strata without top-level window ordering. This supports a frame-level
collision; the exact rendering cause has not been confirmed with runtime level
inspection. The 0.98 backdrop opacity alone does not explain foreground controls.

The candidate on `codex/dialog-stacking` marks both roots top-level and raises
each on opening, preserving SessionScout's existing OnShow ticker and the pilot's
refresh behavior. It does not raise windows during periodic/background updates.
The APIs are present in the pinned
[Blizzard frame API declarations](https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_APIDocumentationGenerated/SimpleFrameAPIDocumentation.lua).
Automated stubs cannot verify native drawing order or click-to-front behavior.

The agreed client session ran on **11 October 2026, 19:18:39–19:27:25
Europe/Oslo**, in Forever 1.60.1.70338 / interface 16001. Commit `d6c8251`
was installed with exactly three changed files: SessionScout `UI.lua` and the
pilot's `Core.lua` and `UI.lua`. Prior files and installed hashes are recorded in
`backups/dialog-stacking-20261011T171931Z/manifest.json`. Exactly one `/reload`
was performed. This local candidate is not included in the published alpha ZIP.

Observed passes:

- Opening `/gearevidence` and then `/scout` left the planner cleanly in front,
  with only faint normal backdrop transparency and no interleaved controls.
- A mouse-down/drag attempt on the exposed pilot header brought the whole pilot
  in front without interleaved controls. This establishes foreground ordering,
  not successful dragging.
- The Batwing Mantle candidate button rendered the corresponding data, and the
  pilot's Close button worked.
- `/gearevidence` reopened the closed pilot above the still-visible planner.
  The pilot remained in front for more than 60 seconds while the planner was
  shown; the planner's periodic refresh did not steal the foreground.
- The planner's 30-minute budget button worked, and the original 15-minute budget
  was restored. The final Close action worked. Both windows and chat were closed
  at the end of the session.

No error popup was observed; this was not a full Lua-error or taint audit. Two
pilot drag attempts and one planner drag attempt did not move either window.
Source review found the expected movable/mouse/drag handlers and no later
re-anchoring, so these automation attempts do not establish a drag defect.
**Dragging remains unverified; no speculative drag fix is proposed.**

Not tested: reopening an already-visible pilot from behind the planner, or
clicking an exposed planner behind the pilot (the pilot completely covered it).
These remain explicit validation limits. Source and release-readiness reviews
support merging the small correction into the development branch: the original
defect was exercised, both opening orders passed, and the unchanged drag handlers
show no concrete regression. At a new explicitly agreed screen window, check the
remaining cases and manual dragging, then capture the prepared privacy-safe
product examples. Do not mark the full client checklist passed or replace the
alpha ZIP from these partial results.

Private evidence is `.tools/pilot/evidence/dialog-stacking-pilot-front-20261011.png`.
It contains chat and **must never be published**. Product screenshots were not
captured. Neither `SCShot` nor example/fixture commands were executed: the one
original completed task and blank note were untouched, and the budget was
restored to 15. A fresh SavedVariables backup is recorded in
`backups/sessionscout-media-20261011T172000Z/manifest.json`.

The native node_repl and CUA sessions were reset successfully at 19:27 to release
control. The screen is free; no further PC use is authorized without a new agreed
window. Do not reopen control tools merely to inspect the border.

### Other remaining checks

- Exercise long-label clipping/tooltips and saved Unicode/pipe task-label edits;
  the physical-entry check covered editing and cancellation, not saving that label.
- Complete the intended duration cases: runtime fixtures used 5/10/12/15/20-minute
  tasks; 30/60-minute task definitions from the checklist remain untested in-client.
- Check repeated open/close behavior and a safe combat transition when available.
  There is no measured long-duration memory or timer-growth result.

The observed startup, rendering, task operations, budget selection, recurrence
completion and reload-persistence checks support a scoped Forever alpha with
the limitations below disclosed. They do not establish full compatibility.

Still unverified: real daily/weekly reset crossing, alternate-character sharing
and isolation, full logout/login and restart persistence, low/high UI scales, and
the complete bag-family/durability matrix. If any are deferred for an alpha, name
them explicitly in release notes; do not mark this checklist wholly passed or
claim full Forever compatibility from the partial checks above.
