# Gear Evidence pilot validation

This is a local discovery experiment, not a released addon or a validated product.
The user's actual problem episode was uncertainty about Enhancement BiS lists
before a roughly 90-minute RFK session. Two analyst-selected RFK candidates make
that question testable against equipped gear. They are not confirmed hunt targets.

## Acceptance checks

- Read current equipment from full client links; never substitute database fixtures.
- Require the observed Forever interface, level 30 Shaman, and positive uniquely
  leading Enhancement talent allocation before showing model scores.
- Show gains and losses in stats, and identify fixed model points as distinct
  from measured DPS, personal simulation, BiS or verified acquisition.
- Preserve separate provenance for current client attributes, fixed model
  coefficients, and Classic-derived boss/drop information.
- Missing, unsupported, restricted, stale or invalid data must prevent scores.
- Closing, changing equipment/talents or entering combat must invalidate results.
- Defer asynchronous item callbacks and discard obsolete requests.
- No SavedVariables, transmission, purchases, automatic equipping or gameplay actions.

## Automated checks

Run `tests/verify.py` from the repository with the existing Python/Lupa Lua 5.1
runtime, or installed `lua5.1` and `luac5.1`. This checks pilot syntax and pilot
test suites only. It does not certify client API behavior.

At 18:16 Europe/Oslo on 11 October 2026, 22 mocked runtime boundary scenarios and
11 pure model tests passed under Lua 5.1. The checks caught two interpretation
gaps that were fixed: inaccessible values not classified as secret, and pending
talent edits. The tests cover synchronous/asynchronous item loading and changed
equipment/request generations as well as invalid, missing and unsupported data.

GitHub CI subsequently passed for commit
`0fffb795b25d98032d2bbd0280017315eeec4946` at approximately 18:35, including the
same 33 pilot checks under Ubuntu's Lua 5.1 and the 56 existing project checks.
The release build retained the previously submitted SessionScout ZIP hash,
confirming that the separate experiment is excluded from that package.
[Run record](https://github.com/jdlarssen/SessionScout/actions/runs/38156082926).

## Client test record

Target: the existing Forever beta client 1.60.1.70338, interface 16001.
The client was observed at character selection before testing on 11 October 2026.
The new folder loaded on entering the world without restarting the executable.
Only six allowlisted pilot files were copied and hash-verified. A later guarded
copy updated the two changed files for the staged-talent check, followed by reload.

Observed between 18:15 and 18:20 Europe/Oslo:

- Both candidates reached READY against actual equipped legs and shoulders.
- All four item stat records matched the visible item tooltips, including the
  equip effects of +26 attack power and +6 spell power. The values are recorded
  in `data/gear-evidence-client-20261011.json` at repository root.
- Ferine Leggings displayed +20.680 WOWF points and +2.863 Lootified points;
  Batwing Mantle displayed +2.490 and +1.718 respectively. These displayed
  values are rounded, use different model scales, and are not measured DPS.
- The talent gate read 26 Enhancement active ranks and zero in the other two
  trees. Both normal startup and reopening after reload passed, including the
  newly installed staged-talent guard.
- Candidate switching, both hover tooltips, scrolling through all source/drop
  notes, Escape closing and manual refresh worked. The observed layout showed
  both model summaries without scrolling at the user's current UI scale.

At 18:25-18:26, a second UI revision was reloaded and inspected. Both candidates
showed the nonzero stat contributions alongside the two model summaries without
scrolling. Dragging the scrollbar revealed complete coefficients, including
ignored zero-weight stats, and dated source/drop notes without overlap.
Mouse-wheel input over the text did not scroll. A narrow handler was added for
both the text and scroll frame, with clamped position and synchronized scrollbar;
its Lua 5.1 syntax and targeted handler mock passed. The changed UI file alone
was backed up, copied and hash-verified at 18:27:58, then reloaded.

At 18:29, clicking the evidence text before using the mouse wheel allowed
scrolling in both directions, and the scrollbar followed. After Refresh cleared
the text focus, the same wheel input over the text did not scroll. The remaining
focus requirement is a known local-pilot limitation: click the text first or
drag the visible scrollbar. These observations do not distinguish a client
focus issue from a limitation of the automated input path. No further speculative
UI changes were made. Both model summaries fit without scrolling at this scale.

Normal logout was submitted after QA. Character selection was visibly confirmed
at 18:32. The six installed pilot files remain available for voluntary local use.

No gameplay, equipment, talent or unrelated addon settings were changed. These
are agent-operated functional checks. They do not verify actual combat
transitions, real cold-cache failures, other UI scales, long sessions, drop
availability or a DPS benefit. Do not initiate combat just to exercise a guard.

## Product evidence still required

Passing code tests is not evidence of a better player decision. The next
comparative observation is whether this explanation resolves a concrete doubt
that the user's existing list/addon leaves unresolved, and whether they choose
to use it again. One owner's feedback cannot establish broad demand or a route
to first place. Preserve negative findings rather than expand the prototype to
make activity look like validation.
