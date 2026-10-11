# CurseForge number-one project status

Last updated: 11 October 2026, 13:54 Europe/Oslo. Scoped Forever client checks passed; submitted alpha is Processing, pending moderation.

## Goal

Reach position 1 on the exact [World of Warcraft popularity list](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity).
**Not achieved.** SessionScout is CurseForge project **1738896**, slug
**sessionscout**. Alpha file **9128965** has reached server status **Processing**.
The project-moderation banner remains present and public visibility/download
availability are not yet confirmed. The author portal showed zero file downloads
at 13:54; popularity rank remains **unknown**, not zero. DBM led the previously
observed list. Do not substitute a download-count target for the actual goal.

## Current product

User direction: **Classic/Forever first**. The alpha targets Forever 1.60.1,
interface 16001, and was tested in installed client **1.60.1.70338**. Retail and
other Classic flavors are not supported by this package.

SessionScout 0.1.0-alpha.1 is a manual next-session planner: up to three recommended
tasks, time budgets, priorities, daily/weekly completion, shared task definitions,
account/character completion, per-character notes and noncombat bag/durability
context. Its positioning remains a hypothesis until real users validate it.

## Completed work

- Pure Lua 5.1 model, event adapter and native WoW frame UI.
- 15 model, 22 mocked integration and 19 Python tooling checks passed.
- [GitHub CI passed for the UI-fix source](https://github.com/jdlarssen/SessionScout/actions/runs/38135716406),
  commit `d4fe06f3ecfe6559e06a63d3e3e7ec46abbd673f`.
- Deterministic package: `dist/SessionScout-0.1.0-alpha.1-forever.zip`.
  SHA256: `1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
- Guarded installation into the verified Forever client, with prior source
  preserved and installed-file hashes checked.
- Fixed the first actual-client defect: missing task-list metadata. Separate
  bounded title/details lines and singular "1 next action" were visibly verified
  after `/reload` at 13:37.
- Actual-client runtime checks passed for task creation/editing/deletion,
  completion/undo, stored selector values, invalid duration feedback,
  15/30/60/custom 45-minute budgets, at most three fitting recommendations,
  pagination and daily/weekly completion with server-reset timestamps.
- Actual `/reload` verification at 13:48:42 matched the complete account and
  character fixture, including tasks, completion, budget and a Unicode note.
  Physical mouse/keyboard checks covered Edit, Unicode/pipe text entry, Cancel
  and Escape. Full methods and limits are in `docs/CLIENT_TESTING.md`.
- Original account and character data were restored. After the temporary QA
  addon was removed and the client reloaded, both SavedVariables file hashes
  exactly matched independent pre-QA backups at 13:51.
- Original project icon, MIT license, changelog, source/issue links, release
  notes and client-validation record prepared. Full-screen evidence is private;
  no public screenshot media has been uploaded.
- Active hourly heartbeat `curseforge-fremdrift-hver-time` in this chat.

## CurseForge submission

- Verified author account **jdlarssen**, existing project **1738896**, slug
  **sessionscout**. Reuse this project; do not create a duplicate.
- [Author Files page](https://authors.curseforge.com/#/projects/1738896/files).
- Summary, original 400px icon, Quests & Leveling / Miscellaneous categories,
  MIT license, enabled comments and GitHub source link saved. Third-party
  distribution is enabled; automatic packaging is disabled.
- The saved description now reports tested Forever 1.60.1.70338 workflows and
  reload persistence, discloses unverified areas, and explains that editing or
  deleting shared task definitions affects every character.
- File **9128965**, display name **SessionScout 0.1.0-alpha.1 — Forever**,
  was created at 13:52. It is **Alpha**, with only **WoW Forever 1.60.1** selected
  and automatic publication after approval enabled.
- At 13:54 the file changed from Uploading to **Processing**. This confirms
  server receipt, not moderation approval or public publication. The project
  remains hidden pending moderation.
- The author portal explicitly states that **Alpha files are not visible in the
  CurseForge client**. Approved alpha downloads use the project website file page.
- Private evidence: `.tools/evidence/curseforge-alpha-processing.png` and
  `.tools/evidence/curseforge-description-tested.png`.

## Remaining validation and access limits

The scoped checks support an alpha with disclosed limitations, not full
compatibility certification. Real reset crossings, alternate-character behavior,
combat transitions, other UI scales, long sessions, full restart/logout
permutations and the complete bag/durability matrix remain unverified. Additional
long-label and saved Unicode/pipe label cases are listed in the client test record.

A first QA-run note assertion incorrectly expected an immediate native event
following programmatic text assignment. An instrumented rerun confirmed the full
625-byte Unicode input was accepted and saved correctly through the existing
close/reopen path; the shorter reload fixture subsequently passed. No product
change was needed for that test assumption. The original data were restored after
both QA attempts; the temporary companion is no longer installed.

Earlier client-loading and browser-access blockers are resolved. Their historical
three-turn audit must not be reused as grounds for blocking the current submission.
The meaningful external gate is now CurseForge processing/moderation, followed by
actual public download availability and real tester adoption.

A direct one-page HTTP ranking request previously returned 403. Do not bypass or
repeat blocked requests; use permitted rendered observations with provenance.
No external outreach, money spent, fabricated downloads, ratings or reviews.

## Next concrete work

1. Check file 9128965 and project 1738896 for processing/moderation results;
   address actual rejection feedback if supplied. Verify public availability
   before describing the alpha as released.
2. Obtain suitable public screenshots that exclude unrelated private game UI/chat.
3. Validate first-run usability and repeat use with willing testers. Outreach
   requires explicit user authorization; research targets are not adoption results.
4. Observe the real popularity rank after publication and develop from actual
   feedback. Preserve the original number-one goal.

Hourly reports must state actual changes, publication/rank status, next steps and
blockers even when unchanged, as explicitly requested. Keep the machine and Codex
running for local scheduled work. Do not duplicate automations or mark the goal
complete while first place remains unverified.
