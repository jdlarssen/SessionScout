# Draft listing — not submitted

Name: **SessionScout** (availability unconfirmed)

Summary: Pick a time budget and get up to three personal tasks that fit your next WoW session.

Suggested categories: Quests & Leveling; Miscellaneous.

Release channel: Alpha. Primary flavor: Forever. Target version: 1.60.1.
Supported versions must be selected only after client tests; do not select all Classic versions.
License: MIT. No CurseForge project ID has been assigned yet.
Source: https://github.com/jdlarssen/SessionScout
Issues: https://github.com/jdlarssen/SessionScout/issues

## Description draft

**Have 30 minutes? Decide what to do before the time disappears.**

SessionScout turns your own WoW to-do list into a small plan. Add tasks with time
estimates and priorities, choose your available time, and see up to three tasks
that fit. Use it for a weekly goal, an alt's next step, or a quick reminder before
your next login.

- One-click 15, 30 and 60-minute budgets, plus custom minutes with `/scout 45`.
- Manual tasks with one-time, daily or weekly completion.
- Shared task definitions with account-wide or per-character completion.
- A personal “next time” note for each character.
- General bag-space and equipment-durability context outside combat.
- No dependencies or external account needed. No telemetry.

Open with `/scout` or `/sessionscout`. Add your first task, set its minutes and
priority, then choose a budget. Daily and weekly completion resets according to
the game server. Tasks are completed manually; SessionScout does not automatically
track quests or supply a maintained list of current-season activities.

Recurring completion needs the corresponding server-reset API. If that API is
unavailable, the task stays unfinished and SessionScout explains the problem;
it does not invent a reset schedule. One-time tasks remain available.

## Alpha release notes

Initial implementation of task planning, manual completion, server reset timing,
task editing, character notes and readiness information. This draft must be updated
with actual client-test results and known issues before submission.

## Submission preparation

Original project icon: `assets/icon.png` (512 x 512), editable source `assets/icon.svg`.

Required remaining items: verified client compatibility, real screenshots, unique
project name/slug and author account access. Do not
present this draft as a released product or use unverified adoption claims.
