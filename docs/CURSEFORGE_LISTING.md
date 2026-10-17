# CurseForge listing — approved public alphas

Name: **SessionScout**. Slug: **sessionscout**. Project ID: **1738896**.
Author: **jdlarssen**. Created 11 October 2026; public visibility confirmed
12 October 2026.
Public project: https://www.curseforge.com/wow/addons/sessionscout
Manage: https://authors.curseforge.com/#/projects/1738896/files
Author preview: https://www.curseforge.com/wow/addons/sessionscout/preview

Summary: Pick a time budget and get up to three personal tasks that fit your next WoW session.

Saved categories: Quests & Leveling; Miscellaneous. Comments enabled.

Newest CurseForge release: **SessionScout 0.1.0-alpha.2 — Forever**, file ID **9132600**.
At approximately 19:57 Europe/Oslo on 12 October 2026, the author portal showed
**Approved**, with one download. The public project and both alpha files were
visible; the project displayed two total downloads. These are observed counters,
not evidence of use or adoption.
Primary download route: https://www.curseforge.com/wow/addons/sessionscout/files/9132600
On the website's **Files** tab, set **Show alpha files** to **Show**; the default
Hide setting showed no results. Availability through the CurseForge client app
has not been tested.
Release channel: **Alpha**; only **WoW Forever 1.60.1** selected; no dependencies.
The existing alpha.1 file was not replaced, and neither package changed.
Submission history: alpha.2 showed **Under Review**, with zero downloads, at
approximately 22:02 Europe/Oslo on 11 October 2026. It previously showed
**Processing** at approximately 20:29 that day.
ZIP: `dist/SessionScout-0.1.0-alpha.2-forever.zip`.
SHA256: `823f66642b936b23aa2750ab52bc81d4d92cad68bf0c7ed9c678add0148359ba`.

Preserved release: **SessionScout 0.1.0-alpha.1 — Forever**, file ID **9128965**.
Release channel: Alpha.
Only **WoW Forever 1.60.1** is selected. At approximately 19:57 Europe/Oslo on
12 October 2026, the author portal showed **Approved**, with one download.
Submission history: at approximately 22:02 Europe/Oslo on 11 October 2026 it
showed **Under Review**, with zero downloads and the project-moderation banner.
ZIP: `dist/SessionScout-0.1.0-alpha.1-forever.zip`.
SHA256: `1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
The portal stated during submission that Alpha files are not visible in the
CurseForge client. The verified public route is the website file page; current
client-app availability remains untested.
License: MIT. Third-party distribution allowed; no automatic packaging.
Source: https://github.com/jdlarssen/SessionScout
Issues: https://github.com/jdlarssen/SessionScout/issues

## GitHub mirror (prereleases)

### Alpha.3 — experimental GitHub prerelease, 17 October

The existing draft was published at **06:58:09 UTC** as
[an experimental GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever).
Release ID `415634645` and the uploaded assets are unchanged. API readback confirms
`draft: false`, `prerelease: true`, the publication timestamp and exact notes.
The tag `v0.1.0-alpha.3-forever` resolves to the tested source commit
`888a47b7ced501687dda3c7563550800cdf1d7fe`; the rendered page shows Pre-release.

Its two uploaded assets are the existing 38,070-byte alpha.3 ZIP and checksum;
GitHub's ZIP digest matches
`33834eed7b609be233f11dd84d318fb6c91b920d1a5f2db5c5f4b2c900256e74`.
The checksum asset digest also matches locally. No ZIP was rebuilt, no earlier
release changed, and no alpha.3 CurseForge file was submitted. The notes explain
Custom minutes and the unresolved rendering/input checks, including the newly
installed 1.60.1.70450 client build. The release decision and remaining limits are
recorded in `docs/CLIENT_TESTING.md`; no pending check was marked passed.
Evidence: `.tools/observations/20261017-alpha3-publication.json` and
`.tools/alpha3-public-20261017.png`. The earlier draft record is preserved.

### Public alpha.2 and alpha.1

The previous GitHub mirror is
[SessionScout 0.1.0-alpha.2 — Forever](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.2-forever),
published at approximately 20:21 on 11 October. It adds the tested planner
window-ordering correction and targets `098d7ea2c43fbcbfe289965096592b793016d6bf`.
CI passed on that commit; the uploaded ZIP digest is
`823f66642b936b23aa2750ab52bc81d4d92cad68bf0c7ed9c678add0148359ba`.
The same alpha.2 ZIP was submitted separately to CurseForge as file **9132600**;
its moderation status is recorded above. Its package excludes the
local GearEvidencePilot and does not change the alpha.1 submission above.
Both GitHub release tags and assets remain unchanged.

On 15 October, the alpha.2 GitHub release notes were corrected after a focused
distribution audit found they still described CurseForge as hidden and under
review. They now link the public file and README installation steps, explain the
Alpha filter and record the approval already verified on 12 October. The existing
12 October foreground follow-up is linked as well. Exact body readback and rendered
page verification passed; asset IDs, sizes, hashes, tag and prerelease flag were
unchanged. This was a release-description correction, not a new release.

The original alpha.1 ZIP and its checksum were published on 11 October 2026 at
[SessionScout 0.1.0-alpha.1 — Forever](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.1-forever).
The tag targets verified source commit `0fffb795b25d98032d2bbd0280017315eeec4946`;
the release is public and marked prerelease. Its uploaded ZIP digest matches the
CurseForge submission hash above. This provided a manual download while
CurseForge moderation was pending; it does not establish user adoption.
On 17 October the existing CurseForge description was updated to link the public
experimental GitHub alpha.3, while preserving the direct CurseForge alpha.2 route.
It also makes the existing `/scout 120` command visible to players who keep alpha.2,
labels the image as alpha.2, and assigns earlier client checks to earlier releases.
The public page rendered the new text and exact GitHub release link after saving.
This was a description update: no ZIP was selected or uploaded, and the separate
CurseForge file-upload confirmation remains pending. Evidence:
`.tools/curseforge-alpha3-link-20261017.png`.

## Saved project description

The download paragraph under Getting started was saved in the author portal
and verified on the public description on 12 October 2026, approximately
20:01 Europe/Oslo. This was a listing-only change; the Alpha files were unchanged.
The same evening, the manual installation paragraph was added and publicly
verified after a focused review found that the listing skipped from download
to `/scout`. The repository homepage now points to the public CurseForge project.

Later that evening, the authentic client image below and its example-data
caption were added to the description. Save completed in the author portal;
the public page was reloaded and the rendered image and caption were visually
verified. The image is served from the public GitHub commit `8eb0bcb` and links
to its full-resolution copy. This was a description-only edit; no gallery
upload, release replacement or new download was performed. Native screen
control remained released during browser work.

**Have 30 minutes? Decide what to do before the time disappears.**

SessionScout turns your own WoW to-do list into a small plan. Add tasks with time
estimates and priorities, choose your available time, and see up to three tasks
that fit. Use it for a weekly goal, an alt's next step, or a quick reminder before
your next login.

**Early alpha for WoW Forever 1.60.1.** Core workflows in the earlier alpha releases,
including saving through `/reload`, were tested in Forever beta 1.60.1.70338. Real reset crossings, use across
multiple characters, combat behavior, other UI scales and long sessions still
need testing. Retail and other Classic versions are not supported by the initial
file.

[![SessionScout in the Forever client with fictional example tasks](https://raw.githubusercontent.com/jdlarssen/SessionScout/8eb0bcb/docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)](https://github.com/jdlarssen/SessionScout/blob/8eb0bcb/docs/media/sessionscout-30-minute-plan-forever-20261012.jpg)

*Alpha.2 in the actual Forever client, fictional example tasks; this image predates the Custom minutes control. Open the image at full size to read the planner. Manually entered estimates produce three suggestions totaling 30 minutes; the 60-minute dungeon stays outside this plan.*

## Features

- One-click 15, 30 and 60-minute budgets, plus custom minutes with `/scout 45`.
- Manual tasks with one-time, daily or weekly completion.
- Shared task definitions with account-wide or per-character completion.
- A personal “next time” note for each character.
- General bag-space and equipment-durability context outside combat.
- No dependencies or external account needed. No telemetry.

## Getting started

Download the Forever alpha from the
[alpha.2 file page](https://www.curseforge.com/wow/addons/sessionscout/files/9132600).
If you browse Files, set **Show alpha files** to **Show**; the default view hides
these early builds.

**More than 60 minutes?** Alpha.2 already accepts `/scout 120` for a two-hour budget
(1–240 whole minutes). The
[experimental alpha.3 on GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever)
adds a visible **Custom minutes** field and **Apply**. Its automated checks passed;
the new controls and current beta build 1.60.1.70450 still need in-client verification.

With WoW closed, extract the ZIP's `SessionScout` folder into your Forever
`Interface/AddOns` folder (the current beta uses `_classic_beta_/Interface/AddOns`).
The resulting path must contain `SessionScout/SessionScout.toc` directly.
Start Forever and enable SessionScout in the AddOns menu.

Open with `/scout` or `/sessionscout`. Add your first task, set its minutes and
priority, then choose a budget. Daily and weekly completion resets according to
the game server. Tasks are completed manually; SessionScout does not automatically
track quests or supply a maintained list of current-season activities.

Task definitions are shared: editing or deleting a task changes it for every
character. The completion setting controls whether finishing it applies to one
character or the account.

Recurring completion needs the corresponding server-reset API. If that API is
unavailable, the task stays unfinished and SessionScout explains the problem;
it does not invent a reset schedule. One-time tasks remain available.

## Feedback and source

Report bugs or suggest improvements in the project comments or on the
[issue tracker](https://github.com/jdlarssen/SessionScout/issues). Please include
your game version and steps to reproduce a problem.

[Source code](https://github.com/jdlarssen/SessionScout) is available under the MIT license.

## Historical alpha.1 release notes

Initial implementation of task planning, manual completion, server reset timing,
task editing, character notes and readiness information. Fixed missing task-list
metadata discovered in the actual client and corrected singular plan wording.
In-client task operations, selection controls, budget limits, pagination,
daily/weekly completion and Unicode-note reload persistence passed. Physical
Unicode/pipe entry, edit cancellation and Escape were also checked.

Known validation limits: reset crossings, alternate characters, combat,
extreme UI scales, long sessions, full restart/logout permutations and the full
bag/durability matrix. See `docs/CLIENT_TESTING.md` for the detailed evidence.

## Submission preparation

Uploaded project icon: `assets/icon-400.png` (400 x 400), rendered from the original
editable `assets/icon.svg`. The original 512px `assets/icon.png` is retained.
The 400px export follows the current [moderation policy](https://support.curseforge.com/support/solutions/articles/9000197279-moderation-policies).

Scoped client checks are complete for this alpha. The original account and
character data were restored and independently hash-verified; the temporary QA
addon was removed. Public screenshots have not been uploaded: full-window client
evidence contains unrelated game UI/chat and is private.

Both alpha files were confirmed **Approved** on 12 October 2026, with the public
project and website file entries visible as recorded above. The packages remain
unchanged. Private evidence for the
original submission: `.tools/evidence/curseforge-alpha-processing.png`
and `.tools/evidence/curseforge-description-tested.png`. Approval does not make
these Alpha releases stable or establish user adoption.
