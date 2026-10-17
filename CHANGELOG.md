# Changelog

## 0.1.0 — first Release, 2026-10-17

Includes the session/task-management redesign below and the custom-minute
control. A fresh physical-input test on Forever 1.60.1.70450 passed normal task
creation, edit/save/cancel, complete/undo, confirmed deletion, 120/90-minute
budgets and invalid-input preservation. One reload and a semantic SavedVariables
comparison verified all 11 original tasks, completion and character settings
unchanged; the disposable task was removed. Only the expected next-ID increment
remained. The earlier click issue was traced to the control tool's coordinate
delivery, with no addon fix required.

The release package differs from tested alpha.4 only in its two version strings.
The same saved-data format and selection model are retained. See the
[client evidence](data/alpha4-input-validation-20261017.json) and
[release notes](docs/RELEASE_0.1.0.txt) for scope and remaining limits.
Published on [GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-forever)
at 08:50:56 UTC. The tag resolves to `b4a0f86e10119ca38a6292d1dc8e5627e0b82479`,
whose CI passed. The CI artifact, local ZIP and uploaded asset all match SHA256
`ba7079a7f56275c434bf81abbe72f6c91860e92228a9d222506a09c16a30573c`.
The same package was submitted once to CurseForge as file **9222143**, Release
for Forever 1.60.1, at 13:34 Europe/Oslo after the owner authorized the concrete
upload. Automatic publication after approval is selected; the initial author
row showed Uploading and showed **Approved** at approximately 13:37. The first
public-file check returned 404 and the public list still showed the alphas.
A follow-up at 13:59 also returned 404. At 20:04 Europe/Oslo, the ordinary
[public file page](https://www.curseforge.com/wow/addons/sessionscout/files/9222143)
showed the correct filename, Release channel, Forever 1.60.1 and Download link.
The project description and installation route were then updated for 0.1.0
and verified publicly. App installation and actual adoption remain unverified.
Existing alpha files are unchanged. See the
[submission record](data/curseforge-release-0.1.0-submission-20261017.json).

## 0.1.0-alpha.4 — unreleased GUI revision

- Separate the default session planner from task management.
- Show task creation/editing only when requested, with explicit field labels.
- Make completed tasks available separately, retaining manual Undo.
- Show recommendation estimates and priorities clearly, and give empty/no-fit
  states direct next actions without changing the user's time or task estimates.

This revision responds to the owner's GUI/UX feedback. It retains the current
selection model and saved-data format. All 71 automated checks passed (15 model,
37 mocked integration, 19 Python), including nine new UI workflow regressions.
A local package and source-derived layout previews were produced. It was
installed for an authorized client test on 17 October. After resolving concurrent
screen use, the session and task-list views rendered in Forever 1.60.1.70450.
A direct Edit callback opened the editor, but physical budget/Edit/Cancel input
did not respond reliably and was unresolved at that initial observation.
That observation was not a full client pass.
It has not been published as a release.

Follow-up at 10:34–10:45 Europe/Oslo resolved physical input and data preservation;
see the 0.1.0 entry above. Alpha.4 remains a preserved test artifact and is not
being published as a separate additional alpha.

## 0.1.0-alpha.3 — experimental CurseForge/GitHub alpha, 2026-10-17

- Add a visible **Custom minutes** field and **Apply** button for session budgets
  from 1 to 240 minutes. Enter also applies the value; presets and `/scout 120`
  remain supported. Invalid values preserve the current budget and explain the range.
- Explain the shortest unfinished task when nothing fits, and distinguish this
  from having completed every task. Estimates are not silently shortened.
- Preserve an unfinished budget entry during timer/inventory refreshes. Escape
  cancels the entry; closing and reopening restores the saved budget.

This fixes a reported usability failure: the owner had unfinished 120-minute
tasks but the visible time choices stopped at 60 minutes. Six new UI regression
cases reproduce that situation and related input/refresh behavior. All 62 model,
mocked integration and Python checks passed, with Lua 5.1 syntax validation.
Installed locally on 15 October in Forever 1.60.1.70374. Actual-client rendering,
keyboard entry and focus checks for this new control are still pending, and the
current client build 1.60.1.70450 had no recorded runtime check at submission.
Later limited alpha.4 observations are recorded separately above.

Published as an explicitly experimental
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever)
on 17 October at 06:58 UTC, using the existing package from source commit
`888a47b7ced501687dda3c7563550800cdf1d7fe`. The public tag resolves to that commit,
and both uploaded asset digests match the prepared draft. The previous alpha
packages remain unchanged. After explicit owner authorization, the same ZIP was
submitted to CurseForge on 17 October at 09:27 Europe/Oslo as file **9219847**,
Alpha for 1.60.1, with automatic publication after approval. The initial file row
showed **Uploading**. At approximately 10:20 Europe/Oslo, the author portal
showed **Approved** and the [public file page](https://www.curseforge.com/wow/addons/sessionscout/files/9219847)
rendered the expected name, Alpha channel, Forever 1.60.1 and Download link.
The project description and README were updated at that time to link that file. No package was rebuilt
or uploaded again; this availability does not establish player adoption.
Alpha.2 remains available there. See the [release scope](docs/CLIENT_TESTING.md)
and [submission record](data/alpha3-curseforge-submission-20261017.json).

## 0.1.0-alpha.2 — 2026-10-11

Available as a
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.2-forever)
for Forever 1.60.1 (interface 16001). The alpha.1 tag and ZIP remain unchanged.
Alpha.2 was submitted separately to CurseForge as file **9132600**, showing
**Under Review** at approximately 22:02 Europe/Oslo on 11 October 2026.
At that time, alpha.1 file **9128965** was also **Under Review**, both files
showed zero downloads, and the project was hidden pending moderator approval.

**Availability update — 12 October:** both files were approved and publicly
visible. Download [alpha.2 on CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9132600).
Both files remain on the Alpha channel; on the website's Files tab, set
**Show alpha files** to **Show** if the list appears empty. Availability through
the CurseForge client app has not been tested. This is a publication-status
update; the release tags and ZIPs are unchanged.

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

**Validation follow-up — 12 October:** reopening an already-visible pilot behind
the planner and clicking an exposed planner behind the pilot passed in the
[recorded client follow-up](docs/CLIENT_TESTING.md#follow-up-on-12-october--two-remaining-foreground-cases-passed).
Manual dragging remains unverified. This was not a full error/taint audit.
The alpha.1 limits below still apply, including actual reset crossings,
multiple characters, combat, extreme UI scales and long sessions.

## 0.1.0-alpha.1 — 2026-10-11

Scoped alpha tested in Forever 1.60.1.70338. Submitted as CurseForge file
**9128965**; confirmed **Under Review** at 18:53 Europe/Oslo.
The same tested ZIP is available as a
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.1-forever).
Public download availability was not yet confirmed on the release date;
see the 12 October availability update above.

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
CurseForge client. No public screenshots had been uploaded on the release date;
an authentic client image with fictional example tasks was subsequently published
in the README and CurseForge description on 12 October.
