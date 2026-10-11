# CurseForge number-one project status

Last updated: 11 October 2026, 12:25 Europe/Oslo. Forever alpha installed locally; CI passed.

## Goal

Reach position 1 on the exact [World of Warcraft popularity list](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity).
**Not achieved.** SessionScout is unpublished, with no registered CurseForge
project ID or slug. Its rank is unknown, not zero. DBM leads the observed list.
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
- README, MIT license, changelog, listing draft and actual-client test checklist.
- Active hourly heartbeat `curseforge-fremdrift-hver-time` in this chat.

## Access and validation limits

- GitHub source repository created: https://github.com/jdlarssen/SessionScout.
  Source pushed and CI passed. This is source distribution, not a CurseForge publication.
- WoW Classic beta 1.60.1.70338 is installed and is now the primary target.
  No actual WoW client testing has occurred. The user has been asked to restart
  the game, enable SessionScout, run `/scout` and report the result. Prepared code
  and installation are not runtime proof. Do not repeatedly reinstall unchanged files.
- Browser connector could not connect to Chrome. Native Computer Use then stopped
  because it could not verify the current browser URL sufficiently for its policy.
  No further UI actions may be taken in that interrupted turn; do not work around
  the browser safety check. CurseForge account access remains unverified.
- A direct one-page HTTP listing request returned 403. Do not bypass or repeatedly
  request it; web search/rendered observations can be recorded with provenance.
- No external outreach, money spent, fabricated downloads, ratings or reviews.

## Next concrete work

1. Incorporate actual Forever client results; fix defects before submission.
2. Resolve Forever client testing and CurseForge author access, then capture real
   screenshots and publish an accurately labeled alpha when technically validated.
3. Validate first-run usability and repeat use with willing testers; outreach
   requires explicit user authorization. Targets in RESEARCH.md are not results.
4. Observe actual rank after registration; develop based on real feedback.

Hourly reports must state what actually changed, rank/publication status, next
step and blockers even when unchanged, as explicitly requested by the user.
Keep the machine on and Codex running for local scheduled work. Do not create
duplicate automations or mark the persistent goal complete while rank is unverified.
