# Changelog

## Unreleased

- Fix interleaved text and buttons when SessionScout overlaps the local
  GearEvidencePilot. Windows now raise together when opened or brought forward;
  periodic refreshes do not change foreground order. Both opening orders and
  pilot click-to-front passed scoped Forever client checks. Manual dragging and
  two additional foreground cases remain unverified in
  [the client test record](docs/CLIENT_TESTING.md).

This correction is on the development branch, not in the published alpha assets.
A future release needs a new version and filename; preserve the alpha.1 ZIP.

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
