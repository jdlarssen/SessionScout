# Release validation in the actual game

Status: **initial live observations recorded; functional validation incomplete**.
Automated tests are not a substitute for these checks.
Primary target: Forever beta 1.60.1.70338 (interface 16001). Record actual client version/build, date and outcomes here before uploading a
public release. Never mark a platform supported only by changing its TOC number.

## Required checks

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

Local, private evidence: `.tools/evidence/client/01-empty.png` and
`02-first-task.png`. These full-window captures contain unrelated game UI/chat
and must not be uploaded as project media as-is.

The same client process remained running while SessionScout became visible.
Process start time alone cannot establish whether the addon is loaded; use the
actual visible UI and test results instead. The user continued interacting with
the auction house, so an uninterrupted test interval was requested.

Confirmed first-client defect: the task list displayed the task name but omitted
its second-line minutes/priority/recurrence/scope details. Fixed using separate
bounded title and metadata FontStrings. All 22 updated Lua integration checks
passed. Revised package installed at 13:28 with SHA256
`1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
The fix still requires `/reload` and live visual verification; the earlier
screenshots show the pre-fix build.
