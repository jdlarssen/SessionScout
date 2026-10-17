# SessionScout

<img src="assets/icon.png" alt="SessionScout compass icon" width="96" height="96">

Choose how much time you have. See up to three personal tasks that fit.

SessionScout is an early WoW Classic/Forever addon prototype for people who want a small,
deliberate plan for their next session. Its name and positioning are provisional.
**Experimental alpha.3 is available on CurseForge and GitHub for Forever 1.60.1.** It adds a
visible Custom minutes control. Its automated checks passed; actual-client
rendering and input checks for that control are still pending. The earlier
alpha.2 remains publicly available on CurseForge, with scoped client checks on
Forever 1.60.1.70338.

The development checkout contains an **unreleased alpha.4 GUI revision**.
Download links below still point to alpha.3/alpha.2. The new session and task-list
views have been observed in the actual game, but physical input testing is
unresolved. Alpha.4 has not been published as a release.

[Download experimental alpha.3 on CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9219847) ·
[GitHub mirror](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever) ·
[Source](https://github.com/jdlarssen/SessionScout) ·
[Report a reproducible issue](https://github.com/jdlarssen/SessionScout/issues)

[![SessionScout in the Forever client: three suggested tasks totaling 30 minutes, from four fictional example tasks](docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)](docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)

Alpha.2 in the Forever client, with fictional example tasks; this image predates
the Custom minutes control. Open it at full size to read the planner. Estimates
and priorities are entered manually; the 60-minute dungeon stays outside this
30-minute plan.

## Use

1. Download `SessionScout-0.1.0-alpha.3-forever.zip` from the
   [CurseForge file page](https://www.curseforge.com/wow/addons/sessionscout/files/9219847)
   or the [GitHub mirror](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever).
   With WoW closed, extract its `SessionScout` directory into your Forever
   `Interface/AddOns` folder (the current beta uses `_classic_beta_/Interface/AddOns`).
   The resulting path must contain `SessionScout/SessionScout.toc` directly.
2. Start the game and enable SessionScout in the AddOns menu.
3. Enter `/scout` (or `/sessionscout`).
4. Add a task, its estimated minutes, priority and recurrence. Choose whether
   completion is shared across the account or tracked separately per character.
5. Choose 15, 30 or 60 minutes, or enter 1–240 whole minutes in **Custom minutes**
   and press **Apply** or Enter. `/scout 45` also accepts a custom budget.
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

Alpha.3 adds the custom-budget field and clearer no-fit messages. Its new-control
rendering, keyboard entry and focus behavior remain unverified in the actual
client. Alpha.3 installation was recorded on **1.60.1.70374**. The development
alpha.4 was subsequently installed and observed on **1.60.1.70450**: the session
and task-list views rendered, and direct invocation of Edit opened the editor.
Physical budget/Edit/Cancel input remains unresolved. Automated regressions,
callback diagnostics and earlier 70338 checks do not establish these pending
interaction results.

Alpha.2 adds a window-ordering correction: the planner raises as one window when
opened, and periodic refreshes do not change foreground order. Scoped overlap
checks with the separately corrected local GearEvidencePilot passed on the same
client. The already-visible pilot and exposed-planner click cases also passed
in a follow-up on 12 October. Manual dragging remains unverified; see the client
test record for the exact checks. The pilot is not
included in this release, and the alpha.1 tag and ZIP remain unchanged.

This is a scoped alpha, not full compatibility certification. Actual daily/weekly
reset crossings, second-character behavior, combat transitions, extreme UI scales
and long-session behavior remain unverified. Retail, Classic Era and other
Classic flavors have not been validated or packaged as supported releases.
See the [client test record](docs/CLIENT_TESTING.md) for methodology and the
remaining checks. The temporary QA addon was removed and the user's original
account and character data were restored and independently hash-verified.

The published alpha.3 passed 62 automated Lua model, mocked integration and
Python tooling checks. The unreleased alpha.4 checkout passes 71. These support
logic and packaging validation and do not replace actual client checks.

The CurseForge releases use the **Alpha** channel. On the project's website,
open **Files** and set **Show alpha files** to **Show** if the list appears empty.
The link above opens experimental alpha.3. The
[previous alpha.2](https://www.curseforge.com/wow/addons/sessionscout/files/9132600)
remains available.
Availability through the CurseForge client app has not been tested.

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

Read the [Ferine Leggings comparison](docs/GEAR_COMPARISON_EXAMPLE.md) for one
verified stat tradeoff, the two fixed-model calculations and what remains unknown.
No installation is needed to read the example.
