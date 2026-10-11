# Changelog

## 0.1.0-alpha.2 — 2026-10-11

Available as a
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.2-forever)
for Forever 1.60.1 (interface 16001). The alpha.1 tag and ZIP remain unchanged.
Alpha.2 was submitted separately to CurseForge as file **9132600**, showing
**Processing** at approximately 20:29 Europe/Oslo on 11 October 2026. Processing
and moderation remain pending; public CurseForge availability is unconfirmed.
Alpha.1 file **9128965** is preserved and remains **Under Review**.

- Mark the planner as a top-level window and raise it when opened, addressing
  interleaved text and buttons observed when overlapping the local
  GearEvidencePilot. Periodic refreshes do not change foreground order.
- Package only this two-line SessionScout UI correction plus the version update;
  the local GearEvidencePilot remains excluded and unpublished.

Scoped checks on Forever **1.60.1.70338**, with both local windows corrected,
passed for both opening orders, pilot click-to-front and no foreground stealing
over more than 60 seconds. Lua 5.1 syntax and the existing integration/runtime
boundary checks passed for the correction. See
[the client test record](docs/CLIENT_TESTING.md) for exact scope.

Manual dragging, reopening an already-visible pilot behind the planner and
clicking an exposed planner behind the pilot remain unverified. This was not a
full error/taint audit. The alpha.1 limits below still apply, including actual
reset crossings, multiple characters, combat, extreme UI scales and long sessions.

## 0.1.0-alpha.1 — 2026-10-11

Scoped alpha tested in Forever 1.60.1.70338. Submitted as CurseForge file
**9128965**; last confirmed **Under Review** at 18:53 Europe/Oslo.
The same tested ZIP is available as a
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.1-forever).
CurseForge public download availability has not yet been confirmed.

- Prioritize Forever beta 1.60.1 (interface 16001) at the user's request.
- Separate task names and metadata into bounded lines after the first client
  observation showed missing minutes, priority, recurrence and completion scope.
- Use singular wording when the plan contains one next action.

- Plan up to three manual tasks within a 15, 30, 60 or custom minute budget.
- Add, edit, delete, complete and undo tasks with explicit priorities.
- Share definitions and optionally completion across characters.
- Reset daily and weekly completion using game-provided timestamps.
- Save a per-character next-session note and show noncombat readiness context.
- Add Lua 5.1 model/integration tests, reproducible packaging, and an honest
  single-page rank observer that records unsupported observations as unknown.

In-client checks passed for task operations, priority/recurrence/scope selectors,
15/30/60/custom 45-minute budgets, at most three fitting recommendations,
pagination, invalid duration feedback, daily/weekly completion with server reset
timestamps, and reload persistence of tasks, completion, budget and a Unicode
note. Physical Unicode/pipe entry, cancelling an edit and Escape were checked.
The original user data were restored and hash-verified, and the temporary QA
addon was removed. See [the test record](docs/CLIENT_TESTING.md) for exact scope.

Known validation limits: real reset crossings, multiple characters, combat,
extreme UI scales, long sessions, full restart/logout permutations and the full
bag/durability matrix remain unverified. Alpha files require download through the
project website after approval; the portal says they are not visible in the
CurseForge client. No public screenshots have been uploaded.
