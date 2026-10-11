# Registered listing — submitted alpha under review

Name: **SessionScout**. Slug: **sessionscout**. Project ID: **1738896**.
Author: **jdlarssen**. Created 11 October 2026; not yet publicly visible.
Manage: https://authors.curseforge.com/#/projects/1738896/files
Author preview: https://www.curseforge.com/wow/addons/sessionscout/preview

Summary: Pick a time budget and get up to three personal tasks that fit your next WoW session.

Saved categories: Quests & Leveling; Miscellaneous. Comments enabled.

Submitted file: **SessionScout 0.1.0-alpha.1 — Forever**, file ID **9128965**.
Release channel: Alpha.
Only **WoW Forever 1.60.1** is selected, with automatic publication after approval.
Server status at approximately 14:45 Europe/Oslo on 11 October 2026: **Under Review**, with zero
downloads shown in the author portal. The project-moderation banner is still
present; public approval and download availability are not yet confirmed.
ZIP: `dist/SessionScout-0.1.0-alpha.1-forever.zip`.
SHA256: `1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
The portal explicitly states that Alpha files are not visible in the CurseForge
client; after approval, downloads use the direct project website file page.
License: MIT. Third-party distribution allowed; no automatic packaging.
Source: https://github.com/jdlarssen/SessionScout
Issues: https://github.com/jdlarssen/SessionScout/issues

## Saved project description

**Have 30 minutes? Decide what to do before the time disappears.**

SessionScout turns your own WoW to-do list into a small plan. Add tasks with time
estimates and priorities, choose your available time, and see up to three tasks
that fit. Use it for a weekly goal, an alt's next step, or a quick reminder before
your next login.

**Early alpha for WoW Forever 1.60.1.** Core workflows and saving through `/reload`
have been tested in Forever beta 1.60.1.70338. Real reset crossings, use across
multiple characters, combat behavior, other UI scales and long sessions still
need testing. Retail and other Classic versions are not supported by the initial
file.

## Features

- One-click 15, 30 and 60-minute budgets, plus custom minutes with `/scout 45`.
- Manual tasks with one-time, daily or weekly completion.
- Shared task definitions with account-wide or per-character completion.
- A personal “next time” note for each character.
- General bag-space and equipment-durability context outside combat.
- No dependencies or external account needed. No telemetry.

## Getting started

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

## Alpha release notes

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

The description update and server receipt of the file are confirmed. Remaining
publication steps: moderation approval and actual public
download availability. Private evidence: `.tools/evidence/curseforge-alpha-processing.png`
and `.tools/evidence/curseforge-description-tested.png`. Do not present the
pending alpha as publicly released or use unverified adoption claims.
