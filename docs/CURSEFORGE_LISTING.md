# Registered listing — no release file submitted

Name: **SessionScout**. Slug: **sessionscout**. Project ID: **1738896**.
Author: **jdlarssen**. Created 11 October 2026; not yet publicly visible.
Manage: https://authors.curseforge.com/#/projects/1738896/files
Author preview: https://www.curseforge.com/wow/addons/sessionscout/preview

Summary: Pick a time budget and get up to three personal tasks that fit your next WoW session.

Saved categories: Quests & Leveling; Miscellaneous. Comments enabled.

Release channel: Alpha. Primary flavor: Forever. Target version: 1.60.1.
Supported versions must be selected only after client tests; do not select all Classic versions.
License: MIT. Third-party distribution allowed; no automatic packaging.
Source: https://github.com/jdlarssen/SessionScout
Issues: https://github.com/jdlarssen/SessionScout/issues

## Saved project description

**Have 30 minutes? Decide what to do before the time disappears.**

SessionScout turns your own WoW to-do list into a small plan. Add tasks with time
estimates and priorities, choose your available time, and see up to three tasks
that fit. Use it for a weekly goal, an alt's next step, or a quick reminder before
your next login.

**Development status:** Early alpha targeting WoW Forever 1.60.1. In-game
compatibility testing is still pending; no download is available yet.

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
task editing, character notes and readiness information. This draft must be updated
with actual client-test results and known issues before submission.

## Submission preparation

Uploaded project icon: `assets/icon-400.png` (400 x 400), rendered from the original
editable `assets/icon.svg`. The original 512px `assets/icon.png` is retained.
The 400px export follows the current [moderation policy](https://support.curseforge.com/support/solutions/articles/9000197279-moderation-policies).

Required remaining items: verified client compatibility, real screenshots,
updated release notes, file upload and moderation approval. Do not present the
registered project as a released product or use unverified adoption claims.
