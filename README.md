# SessionScout

<img src="assets/icon.png" alt="SessionScout compass icon" width="96" height="96">

Choose how much time you have. See up to three personal tasks that fit.

SessionScout is an early WoW Classic/Forever addon prototype for people who want a small,
deliberate plan for their next session. Its name and positioning are provisional.
**It has not yet been tested in the WoW client or published on CurseForge.**

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

## Compatibility and validation

The initial TOC targets **Forever 1.60.1, interface 16001**, as requested by the
project owner. This is a development target, not a compatibility certification.
The local client is Classic beta 1.60.1.70338. Retail, Classic Era and other
Classic flavors have not been validated or packaged as supported releases.

Lua model tests, mocked integration tests and tooling tests validate logic and
packaging only (56 automated tests currently pass). Before publication,
run the [client checklist](docs/CLIENT_TESTING.md) on the intended Forever version.

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
