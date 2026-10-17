# Changelog

## 0.1.0 — 2026-10-17

First Release for **WoW Forever 1.60.1**, interface **16001**.

- Separate **This session**, for budgets and suggestions, from **My tasks**, for
  task management.
- Show task creation and editing only when requested, with explicit field labels.
- Add a completed-task view with Undo.
- Show recommendation estimates and priorities, with useful empty and no-fit states.
- Include the Custom minutes control introduced in alpha.3.
- Retain the existing selection model and SavedVariables format.

In-client checks on **1.60.1.70450** passed for task creation, edit/save/cancel,
Done/Undo, confirmed deletion, 120/90-minute budgets and invalid-input preservation.
After `/reload`, semantic SavedVariables comparison confirmed all 11 existing
tasks, completion records and character settings were unchanged. The temporary
test task was absent; only the expected next-ID increment remained.

The package differs from the tested alpha.4 build only in the two version strings
in `Core.lua` and the TOC. All 71 automated checks and CI passed. Source:
`b4a0f86e10119ca38a6292d1dc8e5627e0b82479`.
The CI artifact, local ZIP and GitHub asset have SHA256:
`ba7079a7f56275c434bf81abbe72f6c91860e92228a9d222506a09c16a30573c`.

Available on [CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9222143)
and [GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-forever).
Earlier alpha packages and tags are unchanged. See the
[release record](docs/RELEASE_READINESS.md) for package details, validation and limitations.

## 0.1.0-alpha.4 — unreleased development build

- Introduce the session/task-management redesign included in 0.1.0.
- Preserve task estimates when showing empty or no-fit recommendations.
- Keep the existing selection model and SavedVariables format.

All 71 automated checks passed: 15 model, 37 mocked integration and 19 Python
checks, including nine new UI workflow regressions. Rendering and subsequent
mouse/keyboard task-operation checks passed in Forever **1.60.1.70450**.
The validated UI and logic were released in 0.1.0; alpha.4 was not published
as a separate package.

## 0.1.0-alpha.3 — 2026-10-17

- Add **Custom minutes** and **Apply** for budgets from 1 to 240 whole minutes.
  Enter also applies the value; preset buttons and `/scout 120` remain supported.
- Preserve the current budget on invalid input and explain the accepted range.
- Show the shortest unfinished estimate when nothing fits, and distinguish this
  from having completed every task. Estimates are not silently shortened.
- Preserve unfinished budget entry during timer/inventory refreshes. Escape
  cancels the entry; closing and reopening restores the saved budget.

This addresses tasks longer than the previous visible 60-minute budget limit.
Six new UI regression cases cover that case and input/refresh behavior. All 62
model, mocked integration and Python checks passed, with Lua 5.1 syntax validation.
Installation was checked in Forever **1.60.1.70374**. Rendering, keyboard entry and
focus behavior of this exact alpha package were not validated in the client;
the later alpha.4/0.1.0 checks are recorded above.

Experimental Alpha for Forever 1.60.1, from source
`888a47b7ced501687dda3c7563550800cdf1d7fe`, available on
[CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9219847) and
[GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.3-forever).
The same ZIP is used for both distributions; earlier packages remain unchanged.

## 0.1.0-alpha.2 — 2026-10-11

- Raise the planner as one window when opened, fixing interleaved content when
  overlapping another addon window.
- Prevent periodic refreshes from changing foreground order.
- Package the two-line UI correction and version update; the separate
  GearEvidencePilot test addon is not included.

Scoped overlap checks on Forever **1.60.1.70338** passed for both opening orders,
click-to-front and no foreground stealing over more than 60 seconds. Follow-up
checks on 12 October covered reopening an already-visible overlapping window
and clicking the exposed planner behind it. Lua 5.1 syntax and the existing
integration/runtime boundary checks passed. Manual dragging remains unverified;
these checks were not a full error/taint audit.

Available on [GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.2-forever)
and on [CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9132600)
since 12 October. Channel: Alpha; target: Forever 1.60.1, interface 16001.
The alpha.1 tag and ZIP are unchanged.

## 0.1.0-alpha.1 — 2026-10-11

Initial Alpha for **Forever 1.60.1**, interface **16001**.

- Plan up to three manual tasks within a 15, 30, 60 or custom-minute budget.
- Add, edit, delete, complete and undo tasks with explicit priorities.
- Share task definitions and optionally completion across characters.
- Reset daily and weekly completion using game-provided timestamps.
- Save a per-character next-session note and show noncombat readiness context.
- Display task names and metadata on separate bounded lines.
- Use singular wording when the plan contains one next action.
- Include Lua 5.1 model/integration tests and reproducible packaging.

In-client checks on **1.60.1.70338** passed for task operations, priority,
recurrence and scope selectors, 15/30/60/custom 45-minute budgets, at most three
fitting recommendations, pagination, invalid-duration feedback, daily/weekly
completion with server-reset timestamps, and reload persistence of tasks,
completion, budget and a Unicode note. Unicode/pipe text entry, edit cancellation
and Escape were checked. Test data restoration was hash-verified, and the
temporary QA addon was removed.

Available on [GitHub](https://github.com/jdlarssen/SessionScout/releases/tag/v0.1.0-alpha.1-forever)
and on [CurseForge](https://www.curseforge.com/wow/addons/sessionscout/files/9128965)
since 12 October. A client image with fictional example tasks was added to the
README and CurseForge description on 12 October.

Known validation limits across these releases include actual reset crossings,
multiple-character behavior, combat transitions, extreme UI scales, long sessions,
full restart/logout permutations and the complete bag/durability matrix.
CurseForge app installation/update has not been verified. See the
[client test record](docs/CLIENT_TESTING.md) for the detailed scope.
