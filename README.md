# SessionScout

<img src="assets/icon.png" alt="SessionScout compass icon" width="96" height="96">

Choose how much time you have. See up to three personal tasks that fit.

SessionScout is an early WoW Classic/Forever addon prototype for people who want a small,
deliberate plan for their next session. Its name and positioning are provisional.
**Scoped in-client checks passed on Forever 1.60.1.70338.
The alpha was submitted to CurseForge and is under review, pending moderation.
Public download availability is not yet confirmed.**

[Source](https://github.com/jdlarssen/SessionScout) ·
[Report a reproducible issue](https://github.com/jdlarssen/SessionScout/issues)

## Use

1. Copy the `SessionScout` directory into your Forever `Interface/AddOns` folder
   (the current beta uses `_classic_beta_/Interface/AddOns`).
2. Start the game and enable SessionScout in the AddOns menu.
3. Enter `/scout` (or `/sessionscout`).
4. Add a task, its estimated minutes, priority and recurrence. Choose whether
   completion is shared across the account or tracked separately per character.
5. Choose 15, 30 or 60 minutes. `/scout 45` accepts a custom budget up to 240 minutes.
6. Complete tasks manually. Daily and weekly completion expires at the reset
   time supplied by the game. Undo reverses a completion for the applicable scope.

Task definitions are shared across characters; “Per character” refers to their
completion. Editing or deleting a definition affects every character. The
“Next time” note belongs only to the current character. Delete needs a second click.

## What it does

- Recommends at most three unfinished tasks within the chosen time budget.
- Prefers more high-priority tasks, then medium, then low; ties favor used time.
- Saves tasks, completion and a personal reminder using WoW SavedVariables.
- Shows general bag space and lowest equipped-item durability outside combat.
- Uses no external service, telemetry, advertising, chat broadcasts or dependencies.

It does not automatically detect quest completion, recommend game content, time
your activities, or synchronize between separate WoW accounts. Time estimates are
your own. If the weekly-reset API is unavailable, weekly tasks cannot be marked
complete until it is available; the addon does not guess a reset date.

## Feedback

Use the [issue tracker](https://github.com/jdlarssen/SessionScout/issues) to report
a reproducible bug or describe a real play session. The templates distinguish
technical errors from whether the addon helped after setup effort, and whether
you chose to use it again. Reports that it did not help are useful too.

Use fictional task names and remove chat or personal information from optional
screenshots. Please do not attach complete SavedVariables files.

## Compatibility and validation

The alpha targets **Forever 1.60.1, interface 16001**. Actual client checks on
**1.60.1.70338** passed for task creation/editing/deletion, completion/undo,
priorities and budgets, pagination, and reload persistence of tasks, completion,
budget and a Unicode note. Daily and weekly completion stored server-reset
timestamps. Physical Unicode/pipe text entry, cancelling an edit and Escape were
also checked. A task-metadata display defect found in the client was fixed and
visually verified.

This is a scoped alpha, not full compatibility certification. Actual daily/weekly
reset crossings, second-character behavior, combat transitions, extreme UI scales
and long-session behavior remain unverified. Retail, Classic Era and other
Classic flavors have not been validated or packaged as supported releases.
See the [client test record](docs/CLIENT_TESTING.md) for methodology and the
remaining checks. The temporary QA addon was removed and the user's original
account and character data were restored and independently hash-verified.

The 56 automated Lua model, mocked integration and Python tooling checks support
logic and packaging validation. They do not replace actual client checks.

The submitted CurseForge release is **Alpha**. The author portal states that Alpha
files are not visible in the CurseForge client; after approval, downloads use the
project's website file page.

## Development

```sh
lua5.1 tests/model_spec.lua
lua5.1 tests/integration_spec.lua
python -m unittest discover -s tests -p '*_spec.py'
python tools/build.py
```

The build creates a deterministic ZIP in `dist/`. Only addon source, its TOC and
license are packaged. See [build and installation tools](tools/README.md) for the
guarded local Forever installer. `tools/observe_rank.py --help` describes the optional
single-page ranking observer; unavailable observations are recorded as unknown.

See [research](docs/RESEARCH.md), [project status](STATUS.md) and the
[provisional listing draft](docs/CURSEFORGE_LISTING.md). No ranking or download
claims should be made without fresh evidence from the actual published project.

## Local product experiment

[`experiments/GearEvidencePilot`](experiments/GearEvidencePilot/README.txt) is a
separate RFK gear-evidence experiment for a level 30 Enhancement Shaman on
Forever. It reads equipped items and two candidate items from the client,
explains stat tradeoffs under two dated fixed-weight models, and exposes source
limitations. It is not included in the SessionScout package or published on
CurseForge. See its [validation record](experiments/GearEvidencePilot/TESTING.md).
