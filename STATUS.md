# CurseForge number-one project status

Last updated: 11 October 2026, 13:28 Europe/Oslo. First client UI defect fixed and installed; reload verification pending.

## Goal

Reach position 1 on the exact [World of Warcraft popularity list](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity).
**Not achieved.** SessionScout is registered as CurseForge project **1738896**, slug
**sessionscout**, but has no uploaded files and is not visible to others pending
moderation. Its rank is unknown, not zero. DBM leads the previously observed list.
Do not replace the goal with a download-count target or call a prototype success.

## Current product

User direction: **Classic/Forever first**. Prioritize installed Forever 1.60.1.70338,
interface 16001. Retail is secondary and must not be required for the first release.

SessionScout 0.1.0-alpha.1: manual next-session planner, maximum three recommended
tasks, time budget, priority, daily/weekly resets, account/character completion,
per-character reminder, noncombat bag-space and durability information.
The working directory began as an empty Git repository with no existing addon.
An early question asking whether the user has an existing addon/profile is pending.
Use that answer to redirect work if supplied.

## Completed work

- Competitor research and explicit, unvalidated positioning hypothesis.
- Pure Lua 5.1 model, event adapter and native WoW frame UI.
- 15 model tests and 22 mocked WoW integration tests passed under Lua 5.1.
- 19 Python tooling tests passed, including timestamp collision regression.
- Fixed long-label overlap and UTF-8 note truncation found in independent review.
- Built `dist/SessionScout-0.1.0-alpha.1-forever.zip`.
- Current ZIP SHA256: `1143a35967230832078c6e0cea8cdfac81cf698c27b35fba2081f81320ca790b`.
- Installed that source into the verified Forever client's `Interface/AddOns/SessionScout`
  using the guarded installer. File hashes verified; no other addons modified.
- Original editable compass icon and 512px PNG ready under `assets/`.
- Deterministic ZIP builder and offline tests for packaging and ranking records.
- GitHub Actions verification workflow.
- [Initial GitHub CI run passed](https://github.com/jdlarssen/SessionScout/actions/runs/38131794299)
  for source commit `2c1616776c2244f23587c47f1a09d733ee3594ee`.
- [Subsequent GitHub CI run also passed](https://github.com/jdlarssen/SessionScout/actions/runs/38131849735)
  for `5871d1807ce25ac1bc82e72ed0b39881c0fd95d6`, with the same package SHA256.
- Corrected the remaining Retail reference in the README and documented unavailable
  reset APIs in the CurseForge listing draft. No addon source changed in this audit.
- README, MIT license, changelog, listing draft and actual-client test checklist.
- Active hourly heartbeat `curseforge-fremdrift-hver-time` in this chat.
- CurseForge account `jdlarssen` created after the user's explicit confirmation
  to accept Overwolf's Terms of Service and Privacy Policy. Author dashboard verified.
- [SessionScout project 1738896](https://authors.curseforge.com/#/projects/1738896/files)
  created successfully; slug `sessionscout` confirmed in saved General settings.
- Description, summary, original 400px icon, Quests & Leveling / Miscellaneous
  categories, MIT license, enabled comments and public GitHub source link saved.
  Third-party distribution enabled; automatic packaging remains disabled.
  Description explicitly states that Forever 1.60.1 in-game validation is pending.
- First real-client defect fixed: task-list minutes/priority/recurrence/scope were
  invisible under the task name. Each now has its own bounded text line. Corrected
  singular "1 next action" wording. All 22 updated Lua integration tests passed.
  Rebuilt and installed the revised alpha at 13:28; prior addon files preserved
  in `backups/20261011T1128200425015Z-9eeec5271b4b4ea78fa81c3e65b8beee`.
  Installation hashes verified. The running UI still needs `/reload` and visual
  verification of this exact build; no SavedVariables or other addons changed.

## Access and validation limits

- GitHub source repository created: https://github.com/jdlarssen/SessionScout.
  Source pushed and CI passed. This is source distribution, not a CurseForge publication.
- WoW Classic beta 1.60.1.70338 is installed and is now the primary target.
  At 13:23–13:26 Oslo, fresh screenshots showed SessionScout's empty panel and then
  a user-created 10-minute task correctly appearing in a 15-minute plan. The addon
  is now demonstrably loaded. These observations do not establish full functional
  compatibility or absence of Lua errors. See `docs/CLIENT_TESTING.md` for evidence.
  The user is actively using the auction house; an uninterrupted interval for
  keyboard/mouse testing and `/reload` was requested. Do not interfere with those
  concurrent actions. Do not repeatedly reinstall unchanged files.
  The process start time remained unchanged while the addon appeared: it is not
  a reliable indicator of whether the addon has been loaded.
- Browser access, provider authentication, CurseForge account and author access
  are verified. Use the existing project rather than creating a duplicate.
  The portal's Files tab says "Add your first file" and its banner states that a
  moderator must approve the new project before it becomes visible to others.
  No addon ZIP has been uploaded. Never request credentials in chat or copy CLI
  tokens into a browser.
- A direct one-page HTTP listing request returned 403. Do not bypass or repeatedly
  request it; web search/rendered observations can be recorded with provenance.
- No external outreach, money spent, fabricated downloads, ratings or reviews.

## External blocker audit

The same publication gate persisted through three consecutive goal turns: the
original build/install turn and two automatic continuations. In the first
continuation, a fresh native screenshot showed an active Forever group session;
no game input was sent. Browser observation again stopped because the tool could
not safely establish the browser URL. On the second continuation, the live WoW
process still had its pre-install start time (11:42:56 Oslo), CI was complete and
successful, and no client result, author-session evidence or CurseForge project ID
had arrived. This is not a verified wait for a running test or publication job.

The release audit found no additional essential code/packaging action that would
resolve these gates. Preserve the prepared alpha rather than adding speculative
features or repeatedly reinstalling it. The persistent goal should be marked
blocked after this audit; it is not complete. Keep the hourly status automation
active as requested. Resume substantive work when the user supplies client-test
results, makes a safe testing interval available, or restores verified author access.

Latest change: author access and project creation succeeded, and SessionScout
is now visibly loaded in Forever. Functional client validation remains incomplete;
the observed task-list detail defect is patched and awaits live verification. Earlier access/loading blockers are
historical; do not reuse their three-turn count for a new blocked action.

## Next concrete work

1. Incorporate actual Forever client results; fix defects before submission.
2. Capture real client screenshots and upload the accurately labeled alpha to
   existing project 1738896 when technically validated. Update the development
   status in the listing and record the actual supported version before submission.
3. Validate first-run usability and repeat use with willing testers; outreach
   requires explicit user authorization. Targets in RESEARCH.md are not results.
4. Observe actual rank after approval/publication; develop based on real feedback.

Hourly reports must state what actually changed, rank/publication status, next
step and blockers even when unchanged, as explicitly requested by the user.
Keep the machine on and Codex running for local scheduled work. Do not create
duplicate automations or mark the persistent goal complete while rank is unverified.
