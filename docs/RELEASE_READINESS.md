# SessionScout 0.1.0 release record

Released 17 October 2026 for **WoW Forever 1.60.1**, interface **16001**.

[CurseForge file 9222143](https://www.curseforge.com/wow/addons/sessionscout/files/9222143) ·
[GitHub release](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-forever) ·
[Release notes](RELEASE_0.1.0.txt)

## Package

| Field | Value |
| --- | --- |
| Filename | `SessionScout-0.1.0-forever.zip` |
| Release channel | Release |
| Size | 47,331 bytes |
| Source | `b4a0f86e10119ca38a6292d1dc8e5627e0b82479` |
| Tag | `v0.1.0-forever` |
| SHA256 | `ba7079a7f56275c434bf81abbe72f6c91860e92228a9d222506a09c16a30573c` |

The CI artifact, local ZIP and GitHub asset have the same checksum. The package
contains `Core.lua`, `Model.lua`, `UI.lua`, `SessionScout.toc` and `LICENSE` under
one `SessionScout` directory. No dependencies or separate experimental addons
are included.

The UI and logic match the validated alpha.4 source
`d94ca15034c3a65117692042dd3db0d365108c1e`; only version strings in `Core.lua` and
the TOC changed. Archive comparison confirmed all other members are byte-identical.
The SavedVariables schema, selection model and interface version are unchanged.
Existing alpha packages and tags are preserved.

## Validation

All **71 automated checks** passed: 15 model, 37 mocked integration and 19 Python
checks. CI also passed for the release source. Automated checks support logic and
packaging validation; they do not replace client testing.

Mouse/keyboard checks on **Forever 1.60.1.70450** covered:

- Creating a 10-minute task, cancelling an edit to 20 minutes, and saving an edit
  to 120 minutes.
- Done/Undo and the matching completed/unfinished filters.
- A 120-minute budget producing a fitting recommendation; invalid `0` preserving
  that budget; a 90-minute budget excluding the 120-minute task.
- Confirmed deletion of the temporary task, followed by `/reload`.
- Preservation of all 11 pre-existing tasks, all completion records and all
  character settings, verified by semantic SavedVariables comparison. Only the
  expected `nextId` increment from 13 to 14 remained after the temporary task
  was deleted. The previous 90-minute budget and empty reminder were preserved.

No visible Lua error was observed during these checks. This was not a full
error-log or taint audit. See [Client testing](CLIENT_TESTING.md) for detailed
coverage across the alpha builds and this release.

## Known validation limits

The following remain unverified:

- Actual daily and weekly reset crossings and alternate-character behavior.
- Combat transitions, manual dragging, extreme UI scales and long sessions.
- Full logout/restart permutations and the complete bag/durability matrix.
- Installation and updating through the CurseForge app.

Retail, Classic Era and other Classic flavors are not supported by this package.
Use the manual installation instructions in the [README](../README.md).
