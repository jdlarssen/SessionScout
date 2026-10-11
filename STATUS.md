# CurseForge number-one project status

Last updated: 11 October 2026, 13:04 Europe/Oslo. Author access and project registration complete; publication awaits client evidence.

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
- ZIP SHA256: `1f80edcaaa2477d125cd0d194453855534c05f488c9125dd2ebc2e6f2d8bc8ad`.
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

## Access and validation limits

- GitHub source repository created: https://github.com/jdlarssen/SessionScout.
  Source pushed and CI passed. This is source distribution, not a CurseForge publication.
- WoW Classic beta 1.60.1.70338 is installed and is now the primary target.
  No actual WoW client testing has occurred. The user has been asked to restart
  the game, enable SessionScout, run `/scout` and report the result. Prepared code
  and installation are not runtime proof. Do not repeatedly reinstall unchanged files.
  A fresh read-only screenshot at 13:03:50 Oslo still showed active five-player
  combat in Razorfen Kraul. WowB PID 32524 still started at 11:42:56, before the
  addon's installation at 12:23:15. No game input was sent. A safe test interval
  has been requested; do not restart or interrupt this active group session.
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

Latest access change: the user approved registration, and author access plus
project creation succeeded. The remaining release gate is actual Forever client
validation. The earlier access blockers are historical; do not reuse their
three-turn count for a new blocked action.

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
