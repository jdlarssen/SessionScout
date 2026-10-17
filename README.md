# SessionScout

<img src="assets/icon.png" alt="SessionScout compass icon" width="96" height="96">

Choose how much time you have. See up to three personal tasks that fit.

SessionScout turns your WoW to-do list into a plan for your next session. Enter
tasks with time estimates and priorities, choose your available minutes, and see
up to three unfinished tasks that fit. **Version 0.1.0 supports WoW Forever
1.60.1.** Estimates and completion are manual.

[Download on CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9222143) ·
[Alternate download on GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-forever) ·
[Report an issue](https://github.com/jdlarssen/SessionScout/issues)

[![SessionScout in Forever with three suggested tasks totaling 30 minutes](docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)](docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)

*Alpha.2 in the Forever client with fictional example tasks. This image predates
the Custom minutes control and the separate This session / My tasks views in
0.1.0. Estimates and priorities are entered manually; the 60-minute dungeon stays
outside this 30-minute plan.*

## Install

1. Download `SessionScout-0.1.0-forever.zip` from
   [CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9222143)
   or [GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-forever).
2. With WoW closed, extract its `SessionScout` directory into your Forever
   `Interface/AddOns` folder. The current beta uses `_classic_beta_/Interface/AddOns`.
   The resulting path must contain `SessionScout/SessionScout.toc` directly.
   Keep your SavedVariables when updating.
3. Start the game and enable SessionScout in the AddOns menu.
4. Enter `/scout` or `/sessionscout`.

Installation and updating through the CurseForge app have not been verified;
use the manual installation steps above.

## Use

1. Open **My tasks** → **+ New task**. Enter a name and estimated minutes,
   then choose priority, recurrence and completion scope. Press **Add task**.
2. Return to **This session**. Choose 15, 30 or 60 minutes, or enter 1–240 whole
   minutes in **Custom minutes** and press **Apply** or Enter. `/scout 45` also
   accepts a custom budget.
3. Mark a task **Done** when you finish. In **My tasks** → **Completed**, **Undo**
   makes it unfinished again.
4. Leave a **Next time, remember...** note for your next session.

**Nothing fits?** A task estimated at 120 minutes will not appear in a 90-minute
plan. Check the shortest unfinished estimate shown by the planner, then adjust
your available time or correct an inaccurate task estimate.

Task definitions are shared across characters. Editing or deleting a definition
affects every character; deleting requires a second click. Completion can be
shared across the account or tracked per character. The next-session note
belongs only to the current character.

## Features

- Up to three unfinished tasks within the chosen time budget.
- More high-priority tasks are preferred, then medium, then low; ties favor used time.
- One-time, daily and weekly tasks with manual completion and Undo.
- Tasks, completion, selected budget and reminders saved through WoW SavedVariables.
- General bag space and lowest equipped-item durability shown outside combat.
- No dependencies, external service, telemetry, advertising or chat broadcasts.

Daily and weekly completion uses reset times supplied by the game. If the
required reset API is unavailable, completion cannot be saved and the addon
explains why; it does not guess a reset schedule. One-time tasks remain available.

SessionScout does not discover game activities, detect quest completion, calculate
gear upgrades, time your activities or synchronize separate WoW accounts.

## Compatibility and validation

The release targets **Forever 1.60.1, interface 16001**. The UI and logic used in
0.1.0 passed 71 automated Lua model, mocked integration and Python tooling checks.
In-client checks on **1.60.1.70450** covered creating and editing tasks, cancelling
edits, Done/Undo, confirmed deletion, 120/90-minute budgets and invalid input.
Existing tasks, completion and character settings were preserved after `/reload`.
The release differs from the tested alpha.4 package only in its version strings.

Earlier checks on **1.60.1.70338** covered task operations, priority and recurrence
controls, completion scope, pagination, Unicode/pipe text entry, Escape, server-reset
timestamps and reload persistence. Scoped window-overlap checks also passed.
These checks do not replace testing across all supported workflows.

Actual daily/weekly reset crossings, second-character behavior, combat transitions,
manual window dragging, extreme UI scales, long sessions, full logout/restart
permutations and the complete bag/durability matrix remain unverified. Retail,
Classic Era and other Classic flavors are not supported by this package.
See the [client test record](docs/CLIENT_TESTING.md) and
[0.1.0 release record](docs/RELEASE_READINESS.md) for the test scope and package details.

Earlier [alpha.3](https://www.curseforge.com/wow/addons/sessionscout/files/9219847)
and [alpha.2](https://www.curseforge.com/wow/addons/sessionscout/files/9132600)
files remain available. Set **Show alpha files** to **Show** in CurseForge's
**Files** tab when looking for older versions.

## Feedback

Report reproducible bugs or describe a real play session in the
[issue tracker](https://github.com/jdlarssen/SessionScout/issues). Include the addon
and game versions, the steps taken and the result. Feedback about whether the
suggestions helped you choose a task is useful too.

Remove chat and personal information from screenshots. Please do not attach
complete SavedVariables files.

## Development

```sh
lua5.1 tests/model_spec.lua
lua5.1 tests/integration_spec.lua
python -m unittest discover -s tests -p '*_spec.py'
python tools/build.py
```

The build creates a deterministic ZIP in `dist/`. Only addon source, its TOC and
license are packaged. See [build and installation tools](tools/README.md) for the
local Forever installer and [the changelog](CHANGELOG.md) for version history.

SessionScout is released under the [MIT license](LICENSE).
