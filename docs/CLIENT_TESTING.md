# Release validation in the actual game

Status: **scoped alpha smoke checks and final restoration passed; extended validation incomplete**.
Automated tests are not a substitute for these checks.
Primary target: Forever beta 1.60.1.70338 (interface 16001). Record actual client version/build, date and outcomes here before uploading a
public release. Never mark a platform supported only by changing its TOC number.

## Custom budget correction — 15 October, local alpha.3 pending client check

An owner-supplied screenshot showed ten saved tasks, a selected 60-minute budget,
several unfinished 120-minute tasks and no recommendation. The preset-only UI
provided no visible custom budget control even though the slash command already
accepted up to 240 minutes. This is actual usability evidence from the existing
version, not a runtime observation of the correction.

Alpha.3 adds a visible Custom minutes field and Apply button, explicit no-fit
guidance, and a distinct all-complete message. Fifteen model, 28 mocked integration
and 19 Python checks passed; six integration cases cover the new input behavior.
These verify real addon callbacks with mocked widgets, not fonts/layout in WoW.
Lua 5.1 syntax validation passed. No task model or SavedVariables schema changed.

The guarded installer identified the current client as Forever 1.60.1.70374 and
installed alpha.3 without starting, reloading or controlling the game. It preserved
the prior addon directory and verified installed hashes. SavedVariables and other
addons were not install targets. The installation record is
`backups/20261015T1715589539098Z-09001f5c273b42d4809a5868511de48b/installation.json`.

Pending in the player's next convenient reload: open `/scout`, set Custom minutes
to 120 and Apply, confirm an unfinished 120-minute task appears; set 90 and confirm
that it is excluded with the shortest-task explanation. Check that the new controls
and two-line summary are readable. No alpha.3 public upload or successful in-client
check is claimed yet. The broader checklist below remains incomplete.

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
was performed. This correction is absent from the preserved alpha.1 ZIP. Its
SessionScout portion is included in the published GitHub alpha.2 ZIP and
CurseForge file 9132600, verified Approved on 12 October. The
GearEvidencePilot portion remains local and unpublished.

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

The already-visible pilot and exposed-planner click cases were not tested in
that 11 October session; the follow-up below resolves those two limits. Source
and release-readiness reviews supported merging the small correction into the
development branch: the original defect was exercised, both opening orders
passed, and the unchanged drag handlers showed no concrete regression.

Private evidence is `.tools/pilot/evidence/dialog-stacking-pilot-front-20261011.png`.
It contains chat and **must never be published**. Product screenshots were not
captured. Neither `SCShot` nor example/fixture commands were executed: the one
original completed task and blank note were untouched, and the budget was
restored to 15. A fresh SavedVariables backup is recorded in
`backups/sessionscout-media-20261011T172000Z/manifest.json`.

The native node_repl and CUA sessions were reset successfully at 19:27 to release
control. The screen is free; no further PC use is authorized without a new agreed
window. Do not reopen control tools merely to inspect the border.

### Follow-up on 12 October — two remaining foreground cases passed

The user's fresh "Bare overta pcn" instruction authorized one additional batch
at approximately 20:53–20:59 Europe/Oslo. A fresh backup of the two known
SavedVariables files was verified against source hashes before and after copying:
`backups/sessionscout-screen-20261012T185533Z/manifest.json`. The companion
`installed-file-comparison.json` verifies the installed SessionScout `UI.lua`
and pilot `Core.lua` / `UI.lua` against the repository. Installed SessionScout
`Core.lua` differs only in its alpha.1 version string; its repository value is
alpha.2. No installation, reload or build-number query occurred during this
batch. The same Forever client was used; a fresh exact build number was not
independently collected.

Observed through physical input and tool screenshots:

- `/gearevidence` opened the pilot, then `/scout` opened the planner cleanly
  in front. Original completed task, 15-minute budget and blank note were visible.
- Invoking `/gearevidence` again while the pilot remained visible behind the
  planner raised the entire pilot, including its controls, above the overlap.
- Clicking the exposed blank background of the planner behind the pilot raised
  the entire planner. No interleaved controls were visible in either case.
- Both Close buttons worked at the end. Chat was closed. No error popup was
  observed; this was not a Lua-error or taint audit.

An incoming group invitation prompted immediate wind-down so the user could
respond. The invitation was left untouched. Native control was reset and the
screen released at approximately 20:59. No task edits, budget changes or fixture
commands were executed. These observations are recorded in
`data/client-window-observation-20261012.json`; the live screenshots remain in
the tool transcript and were not exported as product media.

Actual dragging and privacy-safe product photos remain outstanding. Schedule
those together at a future explicitly agreed screen window. Do not mark the
full client checklist passed or replace the alpha ZIP from these scoped results.

### Short media fixture session on 12 October — restoration verified

A fresh short screen window was authorized at approximately 21:23–21:29
Europe/Oslo. The backup manifest is
`backups/sessionscout-screen-20261012T192338Z/manifest.json`; both copied files
matched source hashes before and after copying and the previous baseline.
The original completed task, 15-minute budget and blank note were observed
before the temporary fixture. One physical title drag did not move the planner.
This remains inconclusive rather than evidence of a code defect.

Prepared media commands 1–4 displayed four fictional tasks and an explicit
"Example tasks only" note in the actual planner. The 15-, 10- and 5-minute tasks
filled the 30-minute plan; the 60-minute dungeon did not fit. This verifies that
this example rendered and excluded the over-budget task. It does not establish
normal UI creation, completion or persistence of a 60-minute task.

No clean product image was captured. At the final observation the planner was
already closed; it was not reopened for a further capture attempt. Commands 5
and 6 restored both SavedVariables roots in place, checked their keys and values
in both directions against the retained originals (including nested reference
identity), and printed "SessionScout restored". Original nested tables had not
been edited by the fixture sequence. This is an in-memory restoration check,
not a new persistence test. No reload/logout occurred. The temporary `SCShot`
backup was cleared only after successful verification. The addon and chat were
closed and native control was reset at approximately 21:29, releasing the PC.

See `data/client-media-observation-20261012.json`. No full client compatibility,
Lua-error audit, clean product photo or successful dragging claim follows from
this limited batch.

### Product capture on 12 October — image saved and original data restored

A new explicitly authorized batch ran at approximately 21:55–22:04 Europe/Oslo.
The fresh backup is recorded in
`backups/sessionscout-screen-20261012T195604Z/manifest.json`; both copied files
matched source hashes before and after copying and the previous baseline.
The original UI was observed before prepared media steps 1–4 were executed.

The same clearly labelled four-task example rendered in the real client.
An unmodified full-client image was saved as
`docs/media/sessionscout-30-minute-plan-forever-20261012.jpg`. Its 30-minute plan
contains the 15-, 5- and 10-minute tasks; the 60-minute task remains outside the
plan. ChatFrame1 and PlayerFrame visibility was saved, temporarily hidden for
the image, then restored using the retained flags and equality assertions.
The client printed "Capture UI restored" at 22:03:05. An independent review of
the deliverable found no private chat, player names or obscuring tooltips.

The attempted native region capture did not produce a clip and changed the
camera angle; it was abandoned. The saved full-client image was not cropped,
retouched or generated. A separate background-area drag did not move the addon;
that remains an inconclusive automation result, not a confirmed code defect.

Media steps 5–6 restored the original SavedVariables roots in place and asserted
bidirectional root key/value equality, including nested reference identity.
"SessionScout restored" appeared at 22:03:49. `SCShot` was cleared only after
verification. No reload/logout/install occurred. The addon and chat were closed;
native control was reset and the screen released. See
`data/client-product-capture-20261012.json` for the scoped record.

This image establishes rendered product behavior with a fixture, not player
demand, normal task-entry/persistence of these exact examples, full compatibility,
or a new Lua-error/taint audit. Actual dragging remains unverified.

### Other remaining checks

- Exercise long-label clipping/tooltips and saved Unicode/pipe task-label edits;
  the physical-entry check covered editing and cancellation, not saving that label.
- Complete the intended duration cases: runtime fixtures used 5/10/12/15/20-minute
  tasks; a 60-minute task was rendered and excluded from a 30-minute plan in the
  media fixture above. Normal creation/completion/persistence for the checklist's
  30/60-minute cases remain untested in-client.
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
