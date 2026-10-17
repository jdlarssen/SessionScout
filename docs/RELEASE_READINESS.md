# First Release decision

Updated 17 October 2026 after the approximately 10:34–10:45 Europe/Oslo client
follow-up. **0.1.0 is published on GitHub; CurseForge submission is prepared and
awaits the requested new-file upload authorization.** The tested candidate is the installed alpha.4 GUI,
source `d94ca15034c3a65117692042dd3db0d365108c1e`.
Its [71 automated checks and CI passed](../data/alpha4-local-validation-20261017.json).
The [initial client observation](../data/alpha4-client-validation-20261017.json)
at approximately 10:03–10:14 confirmed rendering but left physical input
unresolved; publication was held at that point. The
[physical-input follow-up](../data/alpha4-input-validation-20261017.json)
now supports normal controls, budget validation and preservation/persistence of
the owner's data on Forever **1.60.1.70450**. No source fix or reinstallation was
needed. Direct callback invocation is not counted as a physical-input pass.

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

## Bounded client check — passed

The fresh owner-authorized screen window used the already-installed alpha.4 and
fresh SavedVariables backups. An initial Cancel click produced no mouse events.
Read-only control-centre, cursor and focus inspection showed input delivered
below the intended target. Correcting the computer-use coordinates delivered
mouse-down, mouse-up and click events, and Cancel worked. Subsequent workflow
checks used physical input throughout.

1. A uniquely named disposable 10-minute task was created. Editing to 20 and
   cancelling retained 10; editing to 120 and saving retained 120.
2. Done and Undo worked, with the task appearing in the appropriate completed
   and unfinished filters.
3. Custom minutes accepted 120 and produced a fitting 120-minute recommendation.
   Invalid `0` preserved the committed 120-minute budget. Applying 90 produced
   a fitting 90-minute recommendation and excluded the 120-minute test task.
   No owner estimate was changed to force a recommendation.
4. Only the disposable task was deleted through its confirmation control. Counts
   returned to 7 unfinished and 4 completed. After one `/reload`, `/scout`
   displayed the original 90-minute budget, a matching recommendation and the
   empty character reminder.
5. Semantic comparison of persisted SavedVariables passed: all 11 original
   tasks, all completion/progress data and the complete character data matched
   the fresh backups. The disposable task was absent. The sole account change
   was the expected `nextId` increment from 13 to 14; it was not rolled back.

No visible Lua error was observed; this was not a full error-log or taint audit.
The reload cleared temporary event tracing. The addon and chat were closed,
native input ended at approximately 10:45 and the control kernel was reset.
Private evidence remains in `.tools/evidence/client/alpha4-input-20261017/`;
only the sanitized result should be published. The detailed observations and
broader unobserved checks remain in [Client testing](CLIENT_TESTING.md).

## Stop and decision rules

Stop input on overlapping control, owner interruption, unsafe game state,
unexpected mutation or a reproducible error. If ordinary clicking still fails,
preserve the event observations and stop the mutation sequence. Diagnose the
actual failure before changing source; do not attribute a delivery problem to
the addon or count a programmatic callback as a physical pass. If another actor
changes data, do not blindly restore an older snapshot over their work.

The essential normal-input, task-operation, budget and data-preservation gates
are now supported by recorded observations, with no known blocking error in
that path. **0.1.0** was prepared using the tested UI and logic: only the version
metadata in the TOC and `Core.lua` changed. Archive comparison confirms all other
members are byte-identical to alpha.4. Interface **16001**, the data schema and
target **Forever 1.60.1** are unchanged. Source `b4a0f86` passed CI, and its CI
artifact, local ZIP and uploaded GitHub asset have the same checksum. See the
[publication evidence](../data/release-0.1.0-publication-20261017.json).
No separate alpha.4 publication or unchanged reinstallation is required.

The [release notes](RELEASE_0.1.0.txt) and exact CurseForge upload proposal are
prepared. The browser's new-file upload confirmation is pending. Existing alpha
packages and tags are preserved. GitHub download links now point to verified
0.1.0; CurseForge links remain on verified alpha.3 until its own new file is
publicly verified. Do not infer outreach permission from this decision.

Keep the broader client checklist as follow-up work. Disclose unobserved real
reset crossings, alternate-character behavior, combat transitions, extreme UI
scales, full logout/restart permutations, long-session behavior and the complete
bag/durability matrix. These limits do not establish a known defect or require
inventing new features, but preclude a complete-compatibility claim. Actual
Forever-app installation/update remains a separate verification before
advertising that route. A Release channel does not establish product value,
adoption or popularity.
