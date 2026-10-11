# CurseForge number-one project status

Last updated: 11 October 2026, 12:52 Europe/Oslo. Publication awaits client evidence and author access.

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
- [Subsequent GitHub CI run also passed](https://github.com/jdlarssen/SessionScout/actions/runs/38131849735)
  for `5871d1807ce25ac1bc82e72ed0b39881c0fd95d6`, with the same package SHA256.
- Corrected the remaining Retail reference in the README and documented unavailable
  reset APIs in the CurseForge listing draft. No addon source changed in this audit.
- README, MIT license, changelog, listing draft and actual-client test checklist.
- Active hourly heartbeat `curseforge-fremdrift-hver-time` in this chat.

## Access and validation limits

- GitHub source repository created: https://github.com/jdlarssen/SessionScout.
  Source pushed and CI passed. This is source distribution, not a CurseForge publication.
- WoW Classic beta 1.60.1.70338 is installed and is now the primary target.
  No actual WoW client testing has occurred. The user has been asked to restart
  the game, enable SessionScout, run `/scout` and report the result. Prepared code
  and installation are not runtime proof. Do not repeatedly reinstall unchanged files.
- Browser access recovered in the in-app browser. The user completed GitHub login;
  CurseForge now recognizes the provider identity as `jdlarssen`. Existing-account
  login returned "Sorry, we couldn't find an account with that email". Registration
  is prepared at "Continue as jdlarssen", which states acceptance of Overwolf's
  Terms of Service and Privacy Policy. Action-time confirmation was requested before
  continuing new-account registration. The handoff tab is preserved. No CurseForge
  account creation, author-portal access or project submission has been verified.
  Never request credentials in chat or copy CLI tokens into a browser.
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

Latest access change: both browser observation and GitHub authentication work.
The pending step is consent to new CurseForge account registration, followed by
verification of author-portal access. The user's renewed request starts a fresh
blocker audit; do not reuse the historical three-turn count for a new blocked action.

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
