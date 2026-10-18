# Client validation

Last updated: 18 October 2026.

**The 0.1.0 release's essential task, budget and reload checks passed in Forever
beta 1.60.1.70450 (interface 16001).** Broader compatibility checks remain open.
The newer experimental 0.2.0-alpha.1 manual-choice controls have not been tested
in the client; see the [separate test plan](MANUAL_CHOICE_TESTING.md).

## Tested versions and methods

| Artifact | Source / identification | Validation |
| --- | --- | --- |
| `0.1.0-alpha.4` | [`d94ca15034c3a65117692042dd3db0d365108c1e`](https://github.com/jdlarssen/SessionScout/commit/d94ca15034c3a65117692042dd3db0d365108c1e) | Automated checks, actual-client rendering, and physical mouse/keyboard workflows on 17 October in Forever 1.60.1.70450. |
| `0.1.0` | [`b4a0f86e10119ca38a6292d1dc8e5627e0b82479`](https://github.com/jdlarssen/SessionScout/commit/b4a0f86e10119ca38a6292d1dc8e5627e0b82479) | Release archive compared with tested alpha.4; only the two version strings in `Core.lua` and `SessionScout.toc` changed. No logic, UI or saved-data schema change. The version-only archive was not separately reinstalled for the client checks. |
| `0.2.0-alpha.1` | [`9734a72f854d2d9a6bfbbf1869e8b2ce7646a040`](https://github.com/jdlarssen/SessionScout/commit/9734a72f854d2d9a6bfbbf1869e8b2ce7646a040) | 80 automated checks, Lua 5.1 syntax, CI and source-derived layout previews passed. Actual-client input, rendering and persistence checks for the new manual-choice flow remain pending. |

Release archive: `SessionScout-0.1.0-forever.zip`, 47,331 bytes.
SHA256: `ba7079a7f56275c434bf81abbe72f6c91860e92228a9d222506a09c16a30573c`.

The evidence uses three distinct methods:

- **Automated checks:** 15 model, 37 mocked integration and 19 Python checks
  passed, plus Lua 5.1 syntax validation. Mocked widgets validate callbacks and
  state changes, not WoW rendering, focus or physical input. Nine new integration
  workflows cover creation, completion/Undo, filtering and task identity, no-fit
  navigation, draft preservation, deletion confirmation, compact sizing and
  failed recurring-task completion. Draft loss and stale deletion feedback
  found during review were corrected and covered. See the
  [alpha.4 CI run](https://github.com/jdlarssen/SessionScout/actions/runs/39014803768).
- **Actual-client rendering and callback checks:** the game displayed the
  session view, task list and editor. Earlier runtime fixtures also exercised
  real widget callbacks. Programmatic `Button:Click()` or `EditBox:SetText()`
  does not establish physical targeting or keyboard focus. Source-derived
  previews are layout aids, not game screenshots.
- **Physical input checks:** the 17 October workflow below used mouse and
  keyboard input in the game, with visual observations and persisted-data
  comparison. These are functional tests, not usability-study results.

The [0.1.0 release CI run](https://github.com/jdlarssen/SessionScout/actions/runs/39018835464)
also passed; its archive matched the recorded release hash.

## Current client results

The following checks used alpha.4 in Forever **1.60.1.70450** on 17 October.
Account and character SavedVariables were backed up before the disposable-task
workflow.

| Check | Observed result |
| --- | --- |
| Open and navigate | `/scout` opened the session view. My tasks and the editor rendered, and Escape closed the panel. |
| Create and cancel editing | Created a disposable 10-minute task. Changing its estimate to 20 and cancelling retained 10. |
| Save editing | Changing the disposable task to 120 minutes and saving retained 120. |
| Complete and undo | Completion moved the task into the completed filter; Undo returned it to unfinished. |
| Valid custom budget | Applying 120 minutes produced a fitting 120-minute recommendation. The disposable task was eligible; selection of that specific task was not required. |
| Invalid custom budget | Input `0` showed validation and left the committed 120-minute budget unchanged. |
| Budget exclusion | Applying 90 minutes produced a fitting recommendation and excluded the 120-minute disposable task. |
| Delete | Two-step confirmation deleted the disposable task and restored the original task counts. |
| Reload | After one `/reload`, `/scout` retained the committed budget and existing reminder state and displayed a matching recommendation. |

Initially, some physical clicks did not reach the intended controls. Event and
cursor inspection showed input arriving below the target. Corrected coordinates
delivered mouse-down, mouse-up and click events, after which Cancel and the
workflow above passed. No addon code change was needed. An earlier direct Edit
callback had opened the editor, but was not counted as a physical-input pass.

### Data preservation

Fresh before/after SavedVariables copies were hash-checked and their Lua tables
compared recursively after the reload. All pre-existing task definitions,
completion/progress data and character settings were unchanged. The disposable
task was absent. The only account-level difference was `nextId` advancing by one,
as expected after creating and deleting a task.

The existing empty reminder was preserved; editing a new nonempty reminder was
not repeated in this alpha.4 workflow. No visible Lua error appeared, but a full
error-log or taint audit was not performed.

## Earlier regression evidence

These checks describe the versions and builds used at the time. They are not
additional alpha.4 physical-input passes.

| Date / build | Check and result | Limit |
| --- | --- | --- |
| 11 October; Forever 1.60.1.70338 / 16001 | The original task list omitted its metadata line. Separate bounded title and metadata FontStrings corrected it; the result was visually verified after reload, and 22 updated Lua integration checks passed. | This is an earlier layout, not the current split-view UI. |
| 11 October; Forever 1.60.1.70338 / 16001 | A temporary runtime fixture exercised real-client callbacks for six task definitions, invalid minutes, 15/30/60/custom 45-minute budgets, at most three within-budget suggestions, Done/Undo, edit cancel/save, pagination and two-step deletion. Daily and weekly completion stored reset timestamps. | Callback execution is separate from physical input; no actual server-reset crossing was tested. |
| 11 October; Forever 1.60.1.70338 / 16001 | A synchronous note-save assertion initially failed. Correcting the test to use the existing close/save lifecycle preserved all 625 accepted Unicode bytes. A subsequent 265-byte Unicode fixture, task definitions, completion and budget all matched after actual reload. | The first failure was a test assumption, not an addon patch. This does not cover every physical-entry or event-timing case. |
| 11 October; Forever 1.60.1.70338 / 16001 | Physical Edit, Unicode text entry containing a literal pipe, Cancel and Escape worked. Final restoration checks found both SavedVariables file hashes identical to the independent pre-test backups. | The typed task-label edit was cancelled; saving and reloading that label was not tested. |
| 11–12 October; stacking correction [`d6c8251`](https://github.com/jdlarssen/SessionScout/commit/d6c8251) | Top-level window ordering and raising on open corrected interleaved controls when another addon window overlapped. Both opening orders, reopening an already-visible background window, and clicking the exposed planner background passed. A foreground window remained above the planner for more than 60 seconds. | 11 October used build 70338; no fresh exact build was recorded on 12 October. Drag attempts were inconclusive, so dragging remains unverified. |
| 12 October; Forever beta, exact build not freshly recorded | A labelled fictional four-task fixture rendered three suggestions totalling 30 minutes and excluded a 60-minute task. The [saved client image](media/sessionscout-30-minute-plan-forever-20261012.jpg) is an unmodified screenshot of that earlier layout. Original data and temporary UI visibility were restored and checked in memory. | This was a rendering fixture, not normal task creation/completion or a new reload-persistence check. |

Alpha.3's custom-budget correction at source
[`888a47b7ced501687dda3c7563550800cdf1d7fe`](https://github.com/jdlarssen/SessionScout/commit/888a47b7ced501687dda3c7563550800cdf1d7fe)
passed 15 model, 28 mocked integration and 19 Python checks plus Lua syntax
validation. Its installation record identified build 70374. Installation alone
did not verify rendering or input on that build; the physical custom-budget
results above belong to alpha.4 on 70450.

## Remaining client checks

- Actual daily/weekly server-reset crossings, including unavailable reset APIs.
- Two-character shared task definitions, separate character completion and notes,
  and shared completion scope.
- Full logout/login and restart persistence, beyond the recorded reload tests.
- Combat transitions, protected-action errors and a full Lua-error/taint audit.
- Low and high UI scales, long-label wrapping/tooltips, and saving/reloading
  Unicode or literal-pipe task-label edits through physical input.
- New nonempty reminder editing in the current UI; full creation, completion
  and persistence sequences for 30- and 60-minute task fixtures.
- Successful dragging; long-session timer and memory behaviour; repeated
  opening/closing under observation.
- Complete bag-family and durability cases, including specialty/reagent bags,
  empty equipment slots, items without durability and broken items.
- CurseForge-app installation and update behaviour.

These scoped results do not establish full Forever compatibility, usefulness,
player adoption or compatibility with other WoW clients.

## Reproducing a client check

1. Back up account and character SessionScout SavedVariables before changing
   test data. Record the addon version/source, client version, interface number,
   date and whether the check uses callbacks or physical input.
2. Open `/scout`. In My tasks, create a clearly labelled disposable task. Check
   edit Cancel and Save, Done/Undo, the completed filter and deletion confirmation.
3. Set Custom minutes to 120 and Apply. Confirm a 120-minute task is eligible;
   apply 90 and confirm it is excluded. Invalid `0` must leave the previous valid
   budget unchanged. Use known test estimates rather than altering real tasks.
4. Delete the disposable task, restore the original budget/reminder, then
   `/reload`. Compare persisted definitions, progress and character settings
   with the backup. A newly allocated task ID may advance the counter even
   after deletion.
5. Record each observed result and any Lua error. Keep untested cases explicitly
   open. For a bug report, include reproduction steps, expected/actual behaviour
   and client/addon versions; remove personal data from screenshots or logs.
