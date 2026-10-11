# CurseForge number-one project status

Last updated: 11 October 2026, 15:12 Europe/Oslo. Owner discovery identified uncertainty about gear advice; one concrete RFK recommendation is being audited. Alpha remains Under Review in the fresh author check.

## Goal

Reach position 1 on the exact [World of Warcraft popularity list](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity).
**Not achieved.** SessionScout is CurseForge project **1738896**, slug
**sessionscout**. Alpha file **9128965** has reached server status **Under Review**.
The project-moderation banner remains present and public visibility/download
availability are not yet confirmed. The author portal showed zero file downloads
at approximately 15:12; popularity rank remains **unknown**, not zero. A rendered
observation of the exact first page this turn confirmed DBM, Details, Auctionator,
Questie and Raider.IO in positions 1–5. SessionScout is not on the observed page.
The complete 20-project record is
`data/popularity-20261011T125154952497Z-62c235a519dc446aad1441ea38c47da0.json`.
This does not establish a numerical rank elsewhere. Do not substitute a
download-count target for the actual goal.

## Current product

User direction: **Classic/Forever first**. The alpha targets Forever 1.60.1,
interface 16001, and was tested in installed client **1.60.1.70338**. Retail and
other Classic flavors are not supported by this package.

SessionScout 0.1.0-alpha.1 is a manual next-session planner: up to three recommended
tasks, time budgets, priorities, daily/weekly completion, shared task definitions,
account/character completion, per-character notes and noncombat bag/durability
context. Its positioning remains a hypothesis until real users validate it.

## Product strategy

Following the user's request to compare several product hypotheses, SessionScout
is one experiment, not the presumed winner. [The research portfolio](docs/RESEARCH.md)
now compares short-session planning, goal-specific item reservations, recovery of
an interrupted activity, and evidence-based addon troubleshooting. Generic
readiness/restocking is parked because direct Forever competitors already cover
much of the proposed behavior.

The user subsequently asked us to judge the route to number one without a fixed
80% audience requirement. Current selection criteria are immediate usefulness in
normal play, recurring net benefit, a demonstrable advantage over existing tools,
reliability, low administration and feasible audience growth. These are product
hypotheses, not the platform's ranking formula.

The material-reservation audit found current Forever competition (including
KeepOrSell, Hammerprice and TOG tools), source-confirmed recipe aggregation, and
real inventory complaints without a demonstrated unmet quantity-conflict case.
H2 implementation is parked. Broader discovery found actual readability,
quest-map, travel and visibility complaints, but existing products or server-side
constraints address or limit each. No unique winning concept has been verified.
See the dated evidence and source limitations in `docs/RESEARCH.md`.

The existing alpha is the H1 baseline. The owner's recent approximately 90-minute
RFK session already had a gear-driven activity choice; no planning difficulty was
reported. The actual reported problem was uncertainty about online BiS advice.
The corrected guide is for Enhancement, matching the stated level 30 DPS shaman.
The next task is a bounded manual audit of one actual target versus current gear,
including source confidence and assumptions, compared with existing gear tools.
The exact target and equipped item are pending. This replaces the earlier
readability priority; it is one owner's discovery case, not validated demand.
No additional speculative feature or addon has been built.

The overall number-one goal is unchanged. Further implementation must earn its
place through comparative value and voluntary reuse, not work already invested.

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
- The 14:08 hourly check refreshed the author portal and confirmed **Under Review**.
  The project-moderation banner remains present, with zero file downloads shown.
  No rejection or corrective action was presented. The latest GitHub head
  `38e7443` passed [CI](https://github.com/jdlarssen/SessionScout/actions/runs/38137437208),
  and the issue tracker had no open issues. No game input, source changes,
  reinstallations or repeated test runs were performed in this hourly check.
- The author portal explicitly states that **Alpha files are not visible in the
  CurseForge client**. Approved alpha downloads use the project website file page.
- Private evidence: `.tools/evidence/curseforge-alpha-processing.png` and
  `.tools/evidence/curseforge-description-tested.png`; the 14:08 moderation
  screenshot is `.tools/evidence/curseforge-alpha-under-review-20261011T1208Z.png`.
- A fresh author-portal page at approximately 14:45 still showed **Under Review**,
  zero downloads and the project-moderation visibility banner. No rejection or
  request for corrections appeared. The later ranking observation used the
  rendered browser successfully; the previously blocked direct HTTP method was
  not repeated. No game input or reinstallations occurred.
- A further fresh author-portal observation at approximately 15:12 still showed
  **Under Review**, zero downloads and the project-moderation visibility banner.
  There was no rejection or correction request. No source changes or game input
  were needed. Overall popularity rank remains unknown; the last exact-list
  observation is the complete 14:52 record above.

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
The meaningful external gate is now CurseForge moderation, followed by
actual public download availability and real tester adoption.

A direct one-page HTTP ranking request previously returned 403. Do not bypass or
repeat blocked requests; use permitted rendered observations with provenance.
No external outreach, money spent, fabricated downloads, ratings or reviews.

## Next concrete work

1. Check file 9128965 and project 1738896 for moderation results;
   address actual rejection feedback if supplied. Verify public availability
   before describing the alpha as released.
2. Incorporate actual Classic/Forever problem episodes when available. A fixed
   80% target is not required. Keep H2 parked unless new evidence exposes an
   unresolved recurring material-allocation problem; do not restart its searches
   or build it just because it was the earlier priority.
3. Complete the owner's concrete gear-advice audit once the target and equipped
   item are known. WOWF score arithmetic can be reproduced; ForeverDB corroborates
   the item stats but labels the inspected RFK drops as Classic data. Do not turn
   missing beta observations into a claim that a drop is impossible, or weighted
   scores into measured DPS. Compare the usefulness with existing tools, record
   no-benefit outcomes, and require stronger evidence before implementation.
   No comparative demand test or participant recruitment has occurred. Outreach
   still requires explicit user authorization.
4. Obtain suitable public alpha screenshots excluding unrelated private UI/chat;
   validate the existing alpha's usability and voluntary reuse when feasible.
   Do not add features merely to fill time while moderation or feedback is pending.
5. Observe the real popularity rank after publication. Select further development
   from comparative evidence, preserve negative results, and keep the original
   number-one goal distinct from release and pilot milestones.

Hourly reports must state actual changes, publication/rank status, next steps and
blockers even when unchanged, as explicitly requested. Keep the machine and Codex
running for local scheduled work. Do not duplicate automations or mark the goal
complete while first place remains unverified.
