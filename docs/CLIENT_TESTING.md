# Release validation in the actual game

Status: **not run**. Automated tests are not a substitute for these checks.
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
| Pending | Forever 1.60.1.70338 / 16001 | Pending | No in-client execution yet |
