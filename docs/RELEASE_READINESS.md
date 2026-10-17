# First Release decision

Updated 17 October 2026. **Not ready for promotion yet; no Release file has
been created or promoted.** The candidate is the current alpha.4 GUI, source
`d94ca15034c3a65117692042dd3db0d365108c1e`, already installed locally.
Its [71 automated checks and CI passed](../data/alpha4-local-validation-20261017.json).
The [client observation](../data/alpha4-client-validation-20261017.json) confirms
rendering, but physical budget/Edit/Cancel input remains unresolved. Direct
callback invocation is not a successful mouse-input test.

## Why a Release matters

CurseForge's [official submission guide](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project)
(checked 17 October) requires at least one Release file before a project syncs
to its app; Release is also its default download channel. The current Alpha-only
project does not meet that eligibility condition. This is separate from whether
the app actually detects, installs and updates addons for the current Forever
beta. That workflow has not been verified. A Release label alone would not prove
app availability, successful installation, adoption or popularity.

The next publication decision should rest on the supported product's essential
interactions and data safety. Participant quotas, a measured improvement
percentage and completion of every peripheral test are research/planning choices,
not platform Release requirements. They are not prerequisites for this decision.
Product value and voluntary reuse still require their own evidence.

## One bounded client check

Use a fresh, explicitly agreed screen window. Confirm exclusive control before
input; the previous test collided with another chat. Do not reinstall unchanged
alpha.4. Preserve a fresh backup and record the current budget, reminder and
task/completion state before any mutation. Do not put personal task data or chat
in public evidence.

1. Open `/scout`. Observe the normal session and task views. Trace one Edit
   button's mouse-down/up/click delivery temporarily if physical clicking still
   fails. Distinguish delivered input from callback behavior before proceeding;
   another direct callback invocation cannot pass this check.
2. Through normal controls, create one uniquely named, disposable test task with
   a 10-minute estimate. Edit its estimate to 20 and Cancel: it must remain 10.
   Edit it again to 120 and Save: only that task must change. Check keyboard
   focus, readable fields and return to the task list.
3. Enter 120 in Custom minutes and Apply; then enter 90 and Apply. The committed
   budget must match each value, displayed recommendations must stay within it,
   and the 120-minute test task must be excluded at 90. At 120 it is eligible,
   but other task priorities may determine the shortlist; do not rewrite the
   owner's estimates to force a result. Cancelled or invalid input must not
   replace the committed budget.
4. Complete and undo the disposable task using normal controls. Verify its
   completed/unfinished state and filter visibility. Close and reopen the window
   to check that focus and the saved edit remain usable. No owner task should
   change.
5. Remove only the disposable task through its confirmation control. Restore the
   original budget, compare the original task/completion state and reminder, and
   clear temporary tracing. If the agreed window includes it, use one `/reload`
   to confirm the restored state persists. Otherwise record persistence as
   pending. Close the addon and chat, release input and tell the owner the screen
   is free.

## Stop and decision rules

Stop input on overlapping control, owner interruption, unsafe game state,
unexpected mutation or a reproducible error. If ordinary clicking still fails,
preserve the event observations and stop the mutation sequence. Diagnose the
actual failure before changing source; do not attribute a delivery problem to
the addon or count a programmatic callback as a physical pass. If another actor
changes data, do not blindly restore an older snapshot over their work.

A first Release can be prepared when normal input, budget behavior, disposable
task edit/cancel/complete/undo, and preservation/persistence of existing data are
supported by recorded observations, with no known blocking error in that path.
Fix any demonstrated defect and verify the affected workflow before promotion.
Keep the broader [client checklist](CLIENT_TESTING.md) as follow-up work; disclose
unobserved reset crossings, alternate-character behavior and other limits
without claiming complete compatibility.

Then prepare the properly versioned Release, accurate notes and exact upload
proposal; respect any required destination-specific confirmation. Do not relabel
an experimental package merely for visibility, reupload an unchanged file or
infer outreach permission. Actual Forever-app installation/update remains a
separate verification before advertising that route. No new source, ZIP,
installation, test execution, upload or channel change accompanied this record.
