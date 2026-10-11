# WoW addon product hypotheses and evidence

Research date: 11 October 2026 (Europe/Oslo). This is an initial research snapshot, not proof of demand, compatibility, name availability, or future ranking.

## Bounded client experiment — 11 October, 18:34 Europe/Oslo

The owner's request for continued autonomous work led to a separate local
`GearEvidencePilot`, limited to the two RFK comparisons already investigated.
It now reads live equipped and candidate links/stats, checks the active
Enhancement allocation, and shows each model's contributions, assumptions and
source dates. It is not included in SessionScout's package or submitted as a
second public addon. The [validation record](../experiments/GearEvidencePilot/TESTING.md)
documents 33 automated checks and the actual Forever client observations.

Four visible item tooltips agreed with the stat inputs; both candidate outcomes
matched the earlier calculations. The prototype confirms that the bounded
explanation can be produced from supported client data in this tested case.
It does not validate either model's weights, a DPS increase, beta drops or a
better player decision. An owner-feedback question asks what uncertainty remains
in choosing Ferine Leggings. No reply, comparative advantage, voluntary repeat
use or wider demand has yet been observed. Further work should respond to that
evidence instead of expanding the candidate list or supported classes.

### Feedback intake and channel check — approximately 18:38

Two short GitHub issue templates now separate reproducible technical faults from
actual play-session value and later voluntary reuse. Negative outcomes and no
later opportunity are valid responses. They request anonymous examples rather
than full SavedVariables or unrelated chat. Creating these forms does not mean
any tester has been recruited or any feedback received.

A read-only check of [r/wowforever's displayed community rules](https://www.reddit.com/r/wowforever/)
found a relevant addon category, but also restrictions on predominantly generated
content and recruitment outside designated threads. The dedicated rules URL
returned only an empty rules table; the rules above came from the community
page's sidebar. An autonomous AI-written recruitment post has therefore not been
prepared for publication there, and the addon category alone is not permission
to post it. No messages or moderator requests were sent. A suitable authorized
recruitment channel remains unverified; do not treat public research access as
authority to contact players.

## Autonomous equipment comparison — 11 October, 17:00 Europe/Oslo

The user explicitly authorized PC use as needed and asked us to advance without
waiting for more manual input. The game was at character selection. A brief login
allowed the already installed WhatToWear addon to refresh its equipment/talent
snapshot; normal logout saved it, and character selection was visibly restored.
No gear, talents, addon configuration or source files were changed. The snapshot
is dated 16:53:32 Oslo, level 30 Enhancement, build 70338. It records shoulders
5964 and legs 252516, with Mental Dexterity 3, Ancestral Knowledge 1 and Mental
Quickness 2. Character identifiers and the analysis inputs/results remain local
under ignored `.tools/pilot/`. Equipped gear is no longer a blocker. The owner's
original RFK target is still unknown; the two candidates below were selected by
the analyst from the supplied guide, not attributed to the owner's intent.

The current items are [Barbaric Shoulders](https://foreverdb.net/item/5964) and
[Brawler's Leather Legguards](https://foreverdb.net/item/252516). Their attributes
in this calculation come from the cited database pages, not a fresh in-game
tooltip extraction. Decimal arithmetic was reproduced from explicit inputs in
the local analysis record; no game tests were rerun.

| Conditional replacement | WOWF fixed score, before -> after | Lootified default static score, before -> after |
| --- | --- | --- |
| Barbaric Shoulders -> Batwing Mantle | 12.95 -> 15.44 (+2.49) | 6.5062 -> 8.2240 (+1.7178) |
| Brawler's Leather Legguards -> Ferine Leggings | 19.12 -> 39.80 (+20.68) | 11.6005 -> 14.4640 (+2.8635) |

Both inspected fixed-weight models prefer both replacements under the stated
stats and defaults. Their scales differ, and neither result is measured DPS.
Ferine sacrifices Strength, Agility, Stamina and Spirit for AP and Intellect;
Batwing sacrifices physical/survival stats for Intellect and spell power. These
tradeoffs and the purpose of the weights must accompany a recommendation. Model
agreement does not independently confirm optimal gear, current boss availability,
drop rates, or the time efficiency of farming. No player decision change or reuse
has yet been observed.

### Stronger existing baseline and product decision

The [published Lootified 1.2.0 source](https://www.curseforge.com/wow/addons/lootified/files/9112707)
already implements current-gear comparison, live talent inputs and an optional
item-swap simulation. Its static mode uses fixed weights; its simulation has
rotation, talent and buff assumptions and disclosed missing mechanics. Its RFK
data labels the dungeon collectively confirmed in beta while individual boss
rows supply no observation date/build/source link. This is a provenance
limitation in the inspected source, not proof that the drops are wrong. We did
not install or runtime-test Lootified.

The installed WhatToWear also already offers active-spec comparisons and Shift
explanations. Its own README describes a private provisional build. Source-based
calculations prefer both replacements too, but that model values survival, mana
and healing as well as damage. It must not be treated as an independent DPS
authority. Its files were inspected without modification.

**Decision:** a generic personal BiS list or gear-score tooltip is not a supported
new product gap. Keep the next test focused on whether a short explanation of
the actual tradeoff, model assumptions and acquisition evidence improves a real
decision beyond these existing tools. The prepared case can now be used without
asking the owner to transcribe equipment. Further autonomous work should verify
specific model/data discrepancies or actual reported failures; do not restart
generic competitor searches or wait on gear information already obtained. Demand,
retention and a scalable route to number one remain unverified.

### Follow-up: sensitivity to Intellect weight

The 17:15 follow-up varied only the Intellect coefficient, holding every other
coefficient and supplied item stat fixed. An independent calculation agreed with
the saved script output. In WOWF's model the shoulder gain is `11w - 10.16`,
crossing zero at `w = 0.92364` versus default `1.15`; the legs give `12w + 6.88`
and stay positive for nonnegative `w`. Lootified gives `11w - 3.9142` for shoulders
(zero at `0.35584`, default `0.512`) and `12w - 3.2805` for legs (zero at `0.273375`).
The shoulder verdict changes after a smaller relative reduction of this one
weight in either model. No evidence establishes that these alternative weights
are realistic for the character, so this is not a confidence interval, a talent
simulation, a DPS gain, or proof that either recommendation is generally robust.
This completes the bounded arithmetic check; do not extend it into repeated
arbitrary weight sweeps. Next evidence must concern actual recommendation quality,
decision usefulness or acquisition, not additional calculations of the same case.

## Behavioral discovery — 11 October, 15:12 Europe/Oslo

This entry supersedes the earlier proposed readability comparison as the next
task. The owner described a recent approximately 90-minute dungeon session:
RFK was chosen for expected gear upgrades found through an online BiS list.
The character is a level 30 Enhancement DPS shaman in the Forever beta. The
owner corrected the supplied link to [WOWF's Enhancement list](https://wowf.io/en/bis/shaman#enhancement).
**There is no wrong-specialization finding.** The reported uncertainty is whether
the recommendations are correct when several BiS lists exist.

This episode supplies no reported difficulty choosing an activity within the
available time, so it does not validate H1. It does supply one concrete gear-advice
trust problem worth a bounded manual test. It is a retrospective owner report,
not an independently recruited participant, timed baseline, observed shopping
decision, measured time saving, or evidence of market prevalence. Prior technical
QA of SessionScout is not voluntary product reuse. Raw interview answers are
kept in ignored local research notes.

### Initial audit and its limits

Read-only observations of the specified guide and database on 11 October:

| Question | Evidence and warranted conclusion |
| --- | --- |
| Does the guide address the stated character context? | Its selected view is Enhancement PvE, level 30, Forever. The rendered faction default was Alliance; the user's faction and actual talents are unknown. The page recommends a 0/26/0 build with extra talent points. Do not assume the user has that build. |
| Why is Ferine Leggings scored 39.8? | The guide shows item 6690 with 12 Intellect and 26 Attack Power. Its displayed weights, 1.15 per Intellect and 1 per AP, reproduce 39.8. This explains a weighted score; it is not 39.8 DPS or proof of optimal gear. |
| Why is Batwing Mantle scored 15.4? | The guide shows item 6697 with 11 Intellect, 3 Agility and 6 Spell Power. Displayed weights 1.15, 0.53 and 0.2 reproduce 15.44, rounded to 15.4. The weighting's accuracy for this character has not been validated. |
| Where does WOWF obtain its information? | [Its About page](https://wowf.io/en/about) says names/descriptions come from client files; information such as drop locations is supplemented from Blizzard posts and public sources such as Wowhead. Gear rankings are judgments under consistent rules. This general methodology does not individually establish a current-beta boss drop. |
| Are these item stats supported elsewhere? | [ForeverDB Ferine Leggings](https://foreverdb.net/item/6690) shows matching stats, required level 29, build 1.60.1.70291 and extraction date 8 October. [Batwing Mantle](https://foreverdb.net/item/6697) matches too, required level 29, build 1.60.1.70338 and extraction date 11 October. These are the database's stated provenance, not our own client extraction. |
| Are the boss drops beta-verified? | ForeverDB labels Agathelos/6690 and Blind Hunter/6697 drop information **Classic data**. Its [RFK page](https://foreverdb.net/dungeon/47-razorfen-kraul) has no recorded Forever drops, and its [Blind Hunter page](https://foreverdb.net/rare/4425) discloses missing Forever observations. Missing observations do not establish that the drops are unavailable or that WOWF is wrong. Do not present Classic percentages as current beta rates. |

Item identity/stats, acquisition evidence and personalized benefit are separate
claims. Neither agreement between fan sites nor a score derived from static
weights establishes actual DPS gain or BiS. The specific targeted RFK item and
currently equipped alternative were requested and are still unknown. No personal
upgrade verdict or experiment outcome can yet be recorded.

### Next manual comparison, before implementation

For the owner's actual target and equipped item, prepare one short decision card:
the known stat change, relevant assumptions, current acquisition evidence and
remaining uncertainty. A supported, contradicted or unresolved recommendation is
a valid result. Ask whether this changes the next action or resolves a specific
lookup; record an intention separately from later observed play. Include the cost
of supplying equipment, build and source information. Do not manufacture a timed
baseline from this interview or count researcher-supplied data as automatic addon
capability.

Compare with the existing WOWF workflow and [ForeverDB](https://foreverdb.net/bis),
which already offers provenance labels and gear guidance. [Lootified](https://www.curseforge.com/wow/addons/lootified)
also advertises Forever gear comparison and simulation, with disclosed data and
simulation limits. Those author descriptions are not our runtime tests. A clearer
manual explanation may reveal a useful workflow, or the existing tools may
already solve it. Neither outcome justifies another addon without recurring
benefit and a demonstrated advantage. No new product implementation, installation,
external outreach or market-validation claim follows from this one episode.

## Strategy update — 11 October, 14:52 Europe/Oslo

The user asked us to judge what can plausibly support the number-one goal, rather than adopt an arbitrary requirement to serve 80% of players. **There is no fixed market-share gate.** Seek a large, reachable audience with a recurring problem, an immediately useful solution, voluntary continued use, and a meaningful advantage over the strongest available alternative. A unique feature is insufficient by itself. A new solution to an established problem can remain a candidate when it demonstrably improves the complete workflow.

This update supersedes the provisional ordering in the earlier portfolio below.

### Actual ranking evidence

The exact unfiltered popularity page was successfully read through the rendered browser in this work session. Its selected sort was Popularity, page 1, 20 results. The first ten were DBM, Details, Auctionator, Questie, Raider.IO, RareScanner, BigWigs, Plater, Leatrix Plus and TomTom. A complete 20-project observation is saved in [the ranking record](../data/popularity-20261011T125154952497Z-62c235a519dc446aad1441ea38c47da0.json). SessionScout was **not on that page**; its overall rank remains unknown. The separate author-portal check still showed Under Review, zero file downloads and the project-moderation visibility banner at approximately 14:45.

Primary descriptions suggest several routes to repeated usefulness:

| Observed leader | Trigger and benefit described by its author | Product lesson to investigate |
| --- | --- | --- |
| [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods) | Actionable encounter warnings, with modules for supported content. | Help at the moment an existing activity creates a decision. |
| [Details](https://www.curseforge.com/wow/addons/details) | Automatic combat measurement and analysis. | Obtain useful inputs through normal play; provide value before demanding ongoing manual records. |
| [Auctionator](https://www.curseforge.com/wow/addons/auctionator) | Price information and easier buying/selling. Scans remain an input cost. | Save effort within an established repeated workflow; count the full cost of producing that benefit. |
| [Questie](https://www.curseforge.com/wow/addons/questie) | Quest tracking and map guidance in Classic-family clients. | A coherent audience and persistent content need can matter more than universal appeal. |
| [Raider.IO](https://www.curseforge.com/wow/addons/raiderio) | Progression information while inspecting players or forming groups. | A shared activity may provide reasons to discover and recommend a useful tool. This is not a measured adoption mechanism. |

These are hypotheses inferred from successful projects, with strong selection bias. They do not reveal causal ranking factors or CurseForge's private popularity formula. Lifetime downloads are neither unique players nor a target needed to reach first place. Several top projects serve different activities, so the list does not establish that a fixed percentage of all players must need the same function.

### Decision on material reservations: park implementation

Eight bounded discovery searches and a separate competitor/source audit found genuine inventory confusion but no clear current Forever report of conflicting chosen goals producing a reservation/surplus error. This is absence of supporting evidence in the inspected sample, not proof that nobody has the problem.

| Evidence | What it supports and what it does not |
| --- | --- |
| [Backpack too small, 18 September 2026, Forever](https://us.forums.blizzard.com/en/wow/t/backpack-too-small/2353488) | A player describes quest items, tools, food and crafting materials exhausting space. Vendor/bank trips and larger bags are existing workarounds. It does not identify reservation arithmetic as the cause. |
| [Gold, 3 October 2026, Forever](https://www.reddit.com/r/wowforever/comments/1wwqiyw/gold/) | Selling materials competes with paying for training. Keeping more useful items can impose a cost, so a blanket keep recommendation can worsen the actual problem. |
| [Profession information discussion, 16 July 2026 thread, Classic Anniversary](https://www.reddit.com/r/classicwow/comments/1uy17ed/i_created_an_addon_that_shows_which_recipes_and/) | Reports describe repeated external lookups and uncertainty about useful materials. Other users like ProfessionTips or want less tooltip clutter. This supports accurate context, with satisfied substitutes; it is not Forever quantity-allocation validation. |
| [KeepOrSell](https://www.curseforge.com/wow/addons/keeporsell) | Its current author page lists Forever 1.60.1 and documents quest/profession item protection with reasons. Generic “keep this and explain why” is already available as an advertised product. |
| [TOG Profession Master source](https://github.com/Pimptasty/TOGProfessionMaster/blob/a81d31e7c86a7b2e46a76e314bbdc931370bd5d1/GUI/ReagentTracker.lua) | `BuildReagentList()` combines selected recipe quantities and ingredient counts. This is source evidence that aggregate crafting demand is not new. It is not our runtime test. |
| [TOG Bank](https://www.curseforge.com/wow/addons/togbankclassic) and [Hammerprice](https://www.curseforge.com/wow/addons/hammerprice) | Author descriptions include Forever support, combined material lists (TOG Bank explicitly includes arbitrary quest hand-ins) and retention quantities in operations. A Forever adaptation alone is not an established gap. |
| [MuleMate](https://www.curseforge.com/wow/addons/mulemate) | An indexed author-page excerpt describes Classic Era collection-quest protection, personal reserves and excess quantities. Direct opening failed. Treat this as a competition lead, not verified functionality or Forever support. |

Individual Reddit comment timestamps were not confirmed; dates above identify threads. These self-selected public statements do not replace participant comparisons or establish population prevalence. No outreach was performed.

The API audit also adds a cost: pinned Forever [quest objective structures](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua) provide numeric progress but no item ID in `QuestObjectiveInfo`. Current bag quantities and [selected recipe schematics](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/TradeSkillUIDocumentation.lua) have source support, but a complete reliable future-quest/material map has not been established. A recipe selected to satisfy a quest is a dependency, not an additional independent consumptive goal. Missing stock, reusable tools, alternatives and stale remote inventory further limit simple summation. None of these source checks was a new in-client test.

**Decision:** do not implement H2 or invent verified Forever examples for a demonstration. Reopen it only when a real repeated case survives comparison with applicable existing tools, including goal setup and maintenance. The same accounting can remain a testable usability idea without being our presumed route to first place.

### Broader discovery and next selection

Six further bounded searches for cross-class problems found the following. A separate lookup on UI placement found additional direct competition.

| Real need | Counterevidence and disposition |
| --- | --- |
| Readable, sensibly placed quest windows, especially on ultrawide displays | A player describes this in the [6 October Forever discussion](https://www.reddit.com/r/wowforever/comments/1wz7mng/comment/pe9fw2i/). [Dialogue UI](https://www.curseforge.com/wow/addons/dialogueui) is a reported satisfactory alternative, and [Movable Windows Forever](https://www.curseforge.com/wow/addons/movable-windows-forever) explicitly covers windows and bags with persistent positions. Compare actual tasks before considering any additional layout product. |
| Hard-to-see quest objects | The same discussion includes a [specific visibility complaint](https://www.reddit.com/r/wowforever/comments/1wz7mng/comment/pe9gha6/). [Forever Loot Sparkles](https://www.curseforge.com/wow/addons/forever-loot-sparkles) advertises a direct solution. No new unmet function established. |
| Quest/map clarity and travel effort | Players report using Questie; [Travelcraft](https://www.curseforge.com/wow/addons/travelcraft) already advertises Forever routes, travel times and transport options. A generic guide or travel timer is not a demonstrated opening. |
| Waiting for contested quest interactions | The [8 October escort discussion](https://www.reddit.com/r/wowforever/comments/1x0qwpl/blizzard_pls/) describes waiting and accidental queue-jumping. An addon cannot simply change server quest-credit, respawn or layering rules. Do not promise to solve the underlying problem through UI alone. |

The [same Forever discussion](https://www.reddit.com/r/wowforever/comments/1wz7mng/no_addons_forever/) also contains players satisfied with the native UI and no addons. We must include that outcome when evaluating a candidate. Another contemporary addon-wishlist post had no visible responses when inspected; it supplied no player evidence. No 80% claim or unique winning product has been established.

**Selection rule from here:** require a reproducible gap in an existing frequent workflow, then demonstrate a substantial improvement against both the native interface and the strongest applicable addon. Prioritize time to first benefit, continued net benefit, reliability, low administration, an addressable audience with room to expand, and a credible voluntary discovery path. These are qualitative criteria, not arbitrary weighted ranking predictions. Useful integrations must provide actual functionality; do not create dependencies or update churn to inflate downloads.

**Next experiment priority:** compare a concrete readability/window-placement task with the existing solutions when an appropriate, non-disruptive test context and actual user case are available. This is a problem/competitor comparison, not a decision to build a fifth addon. If the current tools solve it, reject the candidate and record that result. If a gap remains, prepare a minimal demonstration before product implementation. Additional public research should pursue a specific unanswered question, not repeat generic idea searches or re-run these unchanged checks.

SessionScout remains a working alpha for usability/reuse observation while moderation proceeds. Further development of it is contingent on evidence that the benefit exceeds manual task administration. Public availability, initial usefulness, repeated voluntary use, broader supported audiences and actual ranking progress are separate milestones. None has been replaced by an invented download target or a deadline for first place.

## Portfolio decision — 11 October, 14:36 Europe/Oslo

The user asked us to consider multiple product hypotheses. SessionScout is now **one experiment among several**, not the presumed winner. Its completed code and submission reduce the cost of testing it; they do not establish demand or justify continued feature investment. The overall goal remains first place on the original, unfiltered WoW popularity list, with Classic/Forever as the first audience.

Maintain four competing hypotheses and one parked alternative. Conduct problem discovery and small comparisons before choosing the next implementation. These are different player problems, not four features promised for SessionScout. No new addon, feature, installation, or publication follows from this research alone.

| Hypothesis | Player promise and occasion | Strongest uncertainty | Current decision |
| --- | --- | --- | --- |
| H1: Short-session planning — existing SessionScout | “I have 30 minutes; help me choose a few personal goals that fit.” Relevant when a player has competing goals and limited time. | Entering tasks and estimating durations may cost more effort than the shortlist saves. | Keep the submitted alpha as a baseline experiment. No additional speculative features. |
| H2: Goal-specific item reservations | “Tell me how many of this item I need to keep for the goals I selected, and why.” Relevant when sorting bags or considering a sale. | Existing item/recipe tools may already answer sufficiently well; trustworthy quantities and low setup effort are essential. | Initially first new comparison; implementation now parked following the evidence audit above. |
| H3: Resume an interrupted activity | “Show the observed progress I need to continue where I stopped.” Relevant when returning to a character after an interruption or absence. | A journal, quest log, or note may be enough; observed activity does not reveal player intent. | Second comparison if real interrupted-play examples support it. |
| H4: Choose the next addon troubleshooting step | “Explain what this evidence tells me, what remains unknown, and what to check next.” Relevant after a loading problem or runtime error. | Existing tools already explain errors; false attribution and maintaining reliable diagnostic knowledge are serious product weaknesses. | Exploratory. Require resolved comparison cases before any implementation. |

This ordering reflects the cost and feasibility of learning, **not an estimate of market size or likelihood of reaching number one**. H2 tests inventory decisions, H3 continuity between sessions, and H4 reliability. If recent player experiences point to a different costly problem, revise the portfolio instead of forcing those experiences into these ideas. Interest from the project owner is a starting point, not market validation.

### Competition checked for this revision

These are primary author descriptions inspected on 11 October 2026, not our compatibility tests or measured product comparisons. A missing feature in a description does not prove a market gap. Competitor existence and download totals do not establish unmet demand.

| Hypothesis | Direct evidence | Consequence for the experiment |
| --- | --- | --- |
| H1 | [Alt Dashboard Forever](https://www.curseforge.com/wow/addons/alt-dashboard-forever) describes character snapshots, reminders, notes and a compact task list. [ForeverDB Helper](https://foreverdb.net/foreverdb-helper) describes goal tracking and guidance for a next run or profession step. | Compare the time-budgeted shortlist with actual existing planning workflows. “Another task list” is insufficient differentiation. |
| H2 | [ItemTree](https://www.curseforge.com/wow/addons/itemtree) describes Forever item relationships with recipes and quests. [TOG Profession Master](https://www.curseforge.com/wow/addons/togprofessionmaster) describes recipe queues and aggregated reagent requirements. | Test quantities reserved across explicitly selected goals, including the explanation. Do not assume competitors lack this workflow. |
| H3 | [Wayscribe](https://www.curseforge.com/wow/addons/wayscribe) describes a Forever activity journal and a previous-session recap at first daily login. Alt Dashboard also covers notes and reminders. | A generic automatic recap is already offered. Test whether a concise, observed interrupted-task state improves the next decision. |
| H4 | [BugSack](https://www.curseforge.com/wow/addons/bugsack) captures and presents errors with BugGrabber. [0xgle Bugs](https://www.curseforge.com/wow/addons/xgle-bugs-lua-error-catcher) advertises plain-language explanations, next steps and update-regression detection for Forever. | “Errors in understandable language” is already offered. Test accuracy of the next diagnostic step, including an explicit insufficient-evidence outcome. |
| Parked: pre-departure readiness/restocking | [ToppedOff Forever](https://www.curseforge.com/wow/addons/toppedoff-forever) describes supply minimums, durability/bag checks and vendor/bank restocking. [Connoisseur & Restocker](https://www.curseforge.com/wow/addons/connoisseur-restocker) adds named lists and town/merchant/bank reminders. | Park the generic concept. Reopen only for repeated, consequential failures that existing configuration cannot reasonably solve. |

### Cheap tests and advance/stop rules

Start with recent incidents, before presenting a solution: what happened, what the player did, how often it recurs, what it cost, and what they currently use. Record “no problem” and satisfactory workarounds too. Do not treat praise, hypothetical willingness, downloads, or an install as repeat use.

For each candidate, record an initial group of five or six willing target players rather than filtering away negative responses. Advance to a comparison only if a majority can independently describe a recent relevant problem and an unsatisfactory current workaround. A small convenience sample can reject a weak idea; it cannot establish broad demand. No recruitment or third-party messages have been sent or are authorized by this document.

Use matched tasks and alternate comparison order where practical. Include setup time, corrections and maintenance in the cost. Compare with the player's usual workflow and the closest relevant existing tool; if that comparison is unavailable, record it as missing evidence rather than asserting superiority. Do not install competing addons or change anyone's game setup without their agreement. For the first comparison of any new candidate, cap preparation at two hours and each initial participant session at 20 minutes. If a credible comparison cannot be prepared within that budget, record the missing prerequisite and reconsider priority rather than starting a build.

| Candidate | Small comparison, before further development | Proposed advance/stop rule — not achieved results |
| --- | --- | --- |
| H1 | Five willing players choose a next activity under an actual time limit, using their usual workflow and the current alpha. Count task entry and duration estimation in total planning effort. | Advance only if at least 3/5 make a suitable choice with less total effort and voluntarily reuse it at the next two relevant opportunities. Park if manual administration erases the benefit or the shortlist is ignored. |
| H2 | Six willing players each bring real selected goals and eight ambiguous bag items, including competing uses of the same item. Prepare reservation cards manually from player-confirmed or game-verified requirements. Include changed goals and incomplete inventory visibility. Compare against their usual workflow and a relevant item/recipe tool or item lock/filter. | Advance only if at least 4/6 prefer the cards, median total decision time including setup improves by at least 25%, and every reservation is correct. Stop or revise on incorrect advice; park if existing tools are comparably effective or reservations need continual repair. |
| H3 | Five willing players provide observed progress before a break and return to that character later. Manually prepare a short card and compare with their usual quest log, notes or recap. Measure correct reconstruction of the next action and total effort. | Advance only if at least 4/5 receive accurate, actionable context their usual workflow lacks and recover the activity with less effort. Park if a journal or note works as well; reject any design that requires inventing intent. |
| H4 | Assemble 10–12 resolved cases with confirmed outcomes, then compare manual diagnostic explanations with available existing explanations. Include missing dependencies, wrong flavor, innocent stack participants, functioning code with an old interface label, and evidence too incomplete for attribution. Five willing players choose a next check from each matched case. | Advance only if at least 4/5 choose more correct next checks with the candidate and it makes no unsupported confident attribution. Stop for false blame or no comparative improvement. Without reliable resolved cases, keep exploratory. |

These thresholds are provisional screening rules chosen before results, not statistically validated cutoffs. Log every failure and unavailable observation; do not change criteria after seeing results to save a favored idea. A pass warrants a narrow prototype or continued pilot, not a claim of product-market fit. H2–H4 must subsequently demonstrate voluntary reuse at two relevant opportunities; rare troubleshooting events should not be judged against daily-use targets.

Manual experiments must remain honest about automation. Reservation cards should include every user step a real product would require. If a researcher supplies information that a supported client cannot reliably expose, record that dependency and do not count the polished card as proof of a feasible product.

### Prepared experiment prompts

- **H1:** “Show a recent session in which choosing what to do took effort. What did you choose, and did it fit the available time?” Use the existing alpha only after recording the baseline.
- **H2:** Record item, observed count, selected goal, verified quantity, and the reason for reserving it. A fictional arithmetic example is 9 held, 4 reserved for goal A, 2 for goal B, and 3 unreserved by these goals. “Unreserved” never means universally safe to sell. Do not automate selling.
- **H3:** Record last observed objective, timestamp, observed progress and remaining requirements, with unknown fields explicit. Ask the player whether they still want that activity. Do not reconstruct an unrecorded past or state inferred intent as fact.
- **H4:** Record observed symptom, available evidence, confirmed outcome, warranted next check and what cannot be concluded. An addon appearing in a stack trace does not by itself establish root cause. Do not automatically disable or modify addons.

### Selection and evidence ledger

After the comparisons, choose at most one candidate for new implementation. Prefer a repeated, consequential problem, measurable improvement over existing tools, low user administration, reliable data, and a plausible audience beyond one character or niche. If no candidate clears the gates, keep the software and evidence, park the candidates, and investigate another problem. Do not combine weak ideas into a larger addon to avoid rejecting them.

A Forever winner would still need sustained retention, authorized discovery channels, and separately verified support for any broader audience. None of the present hypotheses is demonstrated to support the scale required for first place on the overall list. Actual rank on that list remains the final success criterion.

As of this revision: competitor research is complete enough to define initial tests; **none of the four comparative demand tests has run**. H1 has a technically tested alpha, but no validated adoption or retention. H2–H4 are research hypotheses without implementations. No users have been recruited, diagnostic case set assembled, or reservations verified. The user's recent-play problem report was requested and is pending; priorities remain provisional. Future entries should record date, hypothesis, real incident, baseline, setup burden, observed result, repeat use and the resulting decision.

The sections below retain the original SessionScout research and release checklist. The portfolio rules above supersede its treatment as the default product direction. See [STATUS.md](../STATUS.md) and [CLIENT_TESTING.md](CLIENT_TESTING.md) for completed submission and client checks; checklist items below are not claims that those checks remain undone.

## Goal and baseline

Success means the published project occupies position 1 in the user's exact [CurseForge WoW popularity listing](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity). At this check the first five projects were DBM, Details, Auctionator, Questie, and Raider.IO. DBM displayed 635.4 million lifetime downloads, and the listing contained 10,000+ projects. Popularity and total downloads are separate sorts; lifetime downloads are not a published threshold for reaching first place.

No authoritative public formula for the search popularity sort was found. The [CurseForge reward FAQ](https://support.curseforge.com/support/solutions/articles/9000197902-reward-program-faq) describes internal reward calculations, which must not be assumed to be the search-ranking formula. A new release cannot promise a rank or deadline.

## Current release target

The user selected **Classic/Forever first**. The first release targets the installed **WoW Forever 1.60.1 client, interface 16001**. Installation, testing, packaging metadata, and pilot recruitment should use that target. A Retail installation or Retail validation is not required for this release. Support for other Classic clients or Retail must be separately verified before it is advertised.

The overall number-one goal still refers to the original unfiltered WoW popularity listing. A Forever-first release is an initial audience choice, not a change to that goal. The Retail-focused evidence below is competitive context; it does not establish demand, available game systems, or API compatibility in Forever.

## Original SessionScout positioning to validate

**Choose 15, 30, or 60 minutes; see up to three personal tasks that fit.** Initial audience: Forever players planning leveling, professions, and their next character milestone. User-entered time estimates, priorities, recurrence, and character scope make a small useful product possible without a large game-content database. Keep completion manual until an automatic provider is verified. Noncombat durability and bag-space information supplies immediate context.

This is a differentiation hypothesis. A search did not establish that this need is unsolved. The prototype should earn repeat use before expanding into more game systems.

Useful manual pilot examples are "finish my chosen quest-chain step," "gather ingredients for the recipe I selected," and "do the next attunement or unlock step recorded for this character." Players provide the names, estimates, and completion marks. These are examples of personal planning, not claims that the addon knows Forever quest IDs, recipe requirements, attunement availability, travel times, or optimal routes. Start with one-time tasks; expose daily/weekly completion only with verified reset timing or an explicit unavailable state.

| Candidate need | Current evidence and competition | Decision |
| --- | --- | --- |
| Decide what fits a short session | [Routine](https://www.curseforge.com/wow/addons/midnight-routine) already tracks weekly progress, custom tasks and alts; its page showed 3,182,834 downloads and creation seven months earlier. Its documented features did not describe a time-budgeted shortlist. | Test a deliberately small shortlist; do not describe a generic checklist as novel. |
| Resume progress after time away | [BtWQuests](https://www.wowinterface.com/downloads/info24680-v1.27.1.html) shows quest-chain progress; Routine tracks story chapters. | Personal reminders fit the first product. Automated story guidance needs maintained data. |
| Carry UI/chat setup between characters | [Account Wide Interface Settings](https://www.curseforge.com/wow/addons/account-wide-ui) already offers profiles and synchronization, with documented Midnight restrictions for some settings. | Established competition and mutation risk; defer. |
| Plan housing shopping | [Housing Companion](https://www.curseforge.com/wow/addons/housingcompanion) and [Housing Vendor](https://www.curseforge.com/wow/addons/housing-vendor) already offer lists, materials and collection tools. | Crowded; defer another general catalog. |
| Find commands and settings quickly | [EasyFind](https://www.curseforge.com/wow/addons/easyfind) covers UI, settings, collections and travel; [Terminal](https://www.curseforge.com/wow/addons/terminal) targets Forever. | Broad utility, strong competition; defer. |

## Name check

Searches for `SessionScout` and `Session Scout` with WoW/addon and CurseForge, WoWInterface, and Wago restrictions returned no matching WoW addon in the results inspected. Direct CurseForge search/slug requests were not accessible through the web tool, so those searches did not establish slug availability. On 11 October 2026, the author portal accepted SessionScout and saved slug `sessionscout` as project 1738896. The name is already used outside WoW, including the [Session Scout weather app](https://apps.apple.com/us/app/session-scout-weather-forecast/id6786918682) and [Codex Session Scout](https://github.com/strato-space/codex-session-scout). Successful project registration is not trademark clearance.

## API evidence and limits

[Blizzard's Midnight addon explanation](https://news.blizzard.com/en-gb/article/24246290/combat-philosophy-and-addon-disarmament-in-midnight) describes secret combat values and continued support for presentation customization. It is Retail background, not evidence of identical Forever restrictions. Keep this product out of combat-state decision logic and verify APIs against the actual Forever build. The following initial research used Blizzard-authored files redistributed by the community-maintained Gethe source mirror, pinned to its inspected Retail `live` commit `09b9db7948abc9b9648dedaab51eb0cf3ee67b31`; the mirror is not a Blizzard-operated host. These links do not establish Forever support.

| API | Evidence | Implementation implication |
| --- | --- | --- |
| `C_DateAndTime.GetSecondsUntilDailyReset()` / `GetSecondsUntilWeeklyReset()` | [Generated DateAndTime documentation](https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_APIDocumentationGenerated/DateAndTimeDocumentation.lua): both return non-nil `time_t` seconds. | Use game reset timing; avoid assuming Oslo or US reset weekdays. Guard API availability and invalid runtime values. |
| `C_Container.GetContainerNumFreeSlots(bagIndex)` | [Generated Container documentation](https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_APIDocumentationGenerated/ContainerDocumentation.lua): returns `numFreeSlots` and optional `bagFamily`; `SecretArguments = AllowedWhenUntainted`. | Use known ordinary bag indexes outside combat. Distinguish general slots from specialty/reagent slots; never label their total as universally usable space. |
| `GetInventoryItemDurability(slot)` | [Blizzard EquipmentManager](https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_FrameXML/Mainline/EquipmentManager.lua) consumes `durability, maxDurability` from this global. | Skip slots without valid positive maximum durability. This source usage is evidence of the call, not a guarantee about every build or restriction. |

Target-specific follow-up inspected the mirror's **Forever** branch at commit `943764493e6b16d63ded3ab304150d1f05e58b57`. Its [generated DateAndTime documentation](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/DateAndTimeDocumentation.lua) contains both `C_DateAndTime.GetSecondsUntilDailyReset()` and `GetSecondsUntilWeeklyReset()`, returning non-nil `time_t` seconds. Its [generated Container documentation](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/ContainerDocumentation.lua) contains `C_Container.GetContainerNumFreeSlots(bagIndex)`, returning `numFreeSlots` and optional `bagFamily`, with `SecretArguments = AllowedWhenUntainted`. The namespaced adapters therefore match this Forever source; legacy fallbacks are optional compatibility guards, not a requirement established by this target.

Still feature-detect reset and bag APIs at runtime. If `C_DateAndTime` is absent on another supported or incomplete environment, an available `GetQuestResetTime()` can supply daily timing; it must not be treated as a weekly reset. If no trustworthy weekly timer is available, report that limitation and leave the task incomplete. Any legacy `GetContainerNumFreeSlots` fallback should preserve specialty-bag filtering. Fallback tests simulate API shapes and do not replace the actual game smoke test. The release TOC target is `16001`; publication remains gated on that client test.

## Original SessionScout pilot targets (not achieved results)

1. Pilot: 10 willing Forever 1.60.1 testers, at least 5 using multiple characters; 8 of 10 create a leveling, profession, or character-milestone task and choose a session budget without explanation.
2. Repeat use: at least 6 of 10 voluntarily use the shortlist on three separate days within one week. Obtain self-reports; do not add hidden telemetry.
3. Value: at least 7 of 10 can identify a concrete reduction in planning effort, and record why others stopped using it.
4. Reliability: zero known data-loss or blocking Lua errors in the release matrix; saved tasks survive relog/reload, character switching, and daily/weekly boundaries.
5. After publication: log the actual popularity rank, downloads and report date; check downloads at meaningful intervals and distinguish observations from targets. Downloads alone do not measure unique users or retention.

## Publication gates and growth

- Install and test the packaged ZIP in the installed WoW Forever 1.60.1 client with interface `16001`. Capture real screenshots; mockups must be labeled as mockups. Unit tests cannot establish in-client compatibility. Retail is outside the first release's required test matrix.
- Verify first install, UI scaling, long text, combat entry/exit, `/reload`, logout/login, multiple characters, available reset boundaries, and missing optional APIs. Verify general/specialty bag handling and items without durability; do not assume Retail-only bag types exist.
- Confirm author account access, available project name/slug, ownership metadata, license, supported game versions, issue-report channel, and accurate release notes. Keep credentials out of source and artifacts.
- Follow [Blizzard's addon policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642): free distribution, visible code, no in-addon advertisements/donation requests, and no adverse performance or chat impact.
- Publish a useful tested release; iterate from voluntary feedback, then invest in maintained automatic providers and localization where evidence supports it. Share concrete demonstrations only through authorized channels under their rules. Do not inflate downloads/reviews, create unnecessary dependencies, or ship empty updates for rank manipulation.
- Reassess the concept if repeat use misses the pilot targets. The number-one goal remains open until verified on the exact listing; a built prototype or uploaded project is not completion.
