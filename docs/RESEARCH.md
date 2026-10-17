# WoW addon product hypotheses and evidence

Research date: 11 October 2026 (Europe/Oslo). This is an initial research snapshot, not proof of demand, compatibility, name availability, or future ranking.

## Horizontal strategy correction — 17 October 2026

The owner challenged concentration on SessionScout. The challenge is supported
by the work record: several hypotheses existed in this document, but completed
work was dominated by one planner, a small local gear explanation and technical
checks. No independent comparative player test has validated a leading product.
The owner's "it helps a little" does not justify treating SessionScout as that
leader. Time already invested is not evidence for further feature investment.

**Operating decision:** keep SessionScout in maintenance and observation; finish
prepared distribution within its actual permissions and fix demonstrated defects.
Use the next discretionary work for a bounded alternative problem investigation.
Separate evidence discovery, feasibility/competitor comparison, and player-value
validation. The earlier five/six-participant gates apply to the last stage, not
to whether any useful source investigation may begin. An unavailable recruitment
channel or pending upload blocks that action, not the whole search for a product.

New public-source screening produced three distinct dispositions:

| Problem | Evidence and counterevidence | Decision |
| --- | --- | --- |
| A dungeon group forms but cannot start | A [Forever player discussion](https://www.reddit.com/r/wowforever/comments/1wzuqwc/please_be_near_the_dungeon_or_around_the_area/) reports repeated long arrival waits, missing summoning helpers and departures. Other participants accept normal travel time or avoid waiting at an entrance before finding a group. [LFG Forever](https://www.curseforge.com/wow/addons/lfg-forever) already advertises filters, player locations and whisper management; [WhereYouAt](https://www.curseforge.com/wow/addons/whereyouat) documents listing-leader location and its other-member limitation. | Investigate disagreement about readiness and responsibilities after group formation. Generic filtering/location is already served; no new finder or ETA promise is justified. |
| Find a guild crafter | An [author/player discussion](https://www.reddit.com/r/classicwow/comments/1rvd95m/addon_i_built_an_addon_to_solve_the_who_can_craft/) reports repeated craft requests and actual GuildCrafts use, including a duplicate-response complaint and reported correction. [GuildCrafts](https://www.curseforge.com/wow/addons/guildcrafts) covers recipe lookup/contact; [Guild Commons](https://us.forums.blizzard.com/en/wow/t/super-useful-guild-commons-addon/2364181) advertises Forever sharing and supply requests. | Park new implementation. An applicable unmet need surviving these alternatives has not been established. Maintainer departure alone is insufficient. |
| Settings disappear on reload | An [unresolved Forever beta report](https://eu.forums.blizzard.com/en/blizzard/t/classic-forever-beta-savedvariables-are-written-on-logoutreload-but-not-loaded-back-%E2%80%93-every-addon-loses-its-settings/17983) describes settings loss across several addons, with no verified resolution. | Reject as a new recovery-addon direction on this evidence. A transient client persistence fault may be outside an addon's ability to fix. |

These are reported incidents and author-described alternatives, not recruited
testers, measured prevalence, runtime comparisons or new market validation.
Sources were inspected on 17 October; relative timestamps on retrieved Reddit
pages are not treated as independently verified creation dates.

**Next bounded comparison:** examine group-start incidents against the native
location check, a direct agreement in chat and LFG Forever. Identify the exact
missing agreement/information, the earliest moment it could help, and whether
the client could obtain it without guessing travel time or intent. The tradeoff
must count the applicant's waiting/setup effort as well as the group's delay.
Stop if existing tools plus a simple agreement adequately cover the cases, or
the remaining issue is unwillingness that UI cannot fix. A surviving concrete
gap can earn a small demonstration; only a later real comparison can establish
time saved, improved starts or voluntary reuse. No messages, installations or
new addon implementation follow from this screening alone.

Keep other hypotheses eligible for replacement or reopening when a new concrete
case warrants it. Prefer repeated value, quick benefit with little administration,
an advantage over the best applicable alternative, a reachable audience, and a
credible expansion path beyond the initial Forever audience. None currently
establishes a route to first place. Spread the search across problems; concentrate
development only after one earns stronger comparative evidence.

### Group-start comparison completed — 17 October 2026

**Decision: park a new group-start addon.** The bounded comparison found four
reported incidents in one discussion, not independent player tests. Travel
without needed flight paths, missing summoning helpers and nearby players still
questing illustrate different causes of delay. One warlock reports solving their
case by changing groups. Outcomes are absent for the other three cases.
The [case and source ledger](../data/group-start-screening-20261017.json) preserves
the individual links, unknowns, alternatives and technical boundaries.

LFG Forever already advertises locations, filtering and whisper management;
WhereYouAt documents leader-location coverage and its limitation. A location
clone would add little to these descriptions. Proximity cannot establish a
departure agreement, and an entrance-readiness requirement may shift waiting
from the group to applicants. None of the cases establishes a costly failure
after a clear departure/helper agreement plus the applicable existing tools.
That is insufficient evidence to invest in a new implementation, not proof that
the coordination problem is solved for everyone.

A static audit used Blizzard-authored source in the Gethe mirror at
[`172a387e3ab85b26e6640d3058d5ec1e6ccd4c63`](https://github.com/Gethe/wow-ui-source/commit/172a387e3ab85b26e6640d3058d5ec1e6ccd4c63),
labelled 1.60.1 (70450), matching the reported installed executable build. This
updates the reference for this investigation only; it does not retroactively
validate the older 70338 client observations or test the current client.

| Available source evidence | Product boundary |
| --- | --- |
| [Map APIs](https://github.com/Gethe/wow-ui-source/blob/172a387e3ab85b26e6640d3058d5ec1e6ccd4c63/Interface/AddOns/Blizzard_APIDocumentationGenerated/MapDocumentation.lua) describe player/party positions and nullable results. | Unknown location stays unknown; location is not travel time or intention. |
| [The shared ready-check command](https://github.com/Gethe/wow-ui-source/blob/172a387e3ab85b26e6640d3058d5ec1e6ccd4c63/Interface/AddOns/Blizzard_ChatFrameBase/Shared/SlashCommands.lua#L1275) checks leader/assistant authority. | Native yes/no declarations are a baseline to beat. Complete Forever dialog inclusion and current runtime behaviour remain untested. |
| Quest and flight-node APIs expose limited observations, chiefly local state; incoming-summon APIs describe an actual summon. | No audited basis for inspecting the whole party's preparation, estimating dependable arrival times, or identifying willing future helpers. |
| Forever uses the vanilla-style finder; the other finder excludes camelot. | Shared Retail applicant structures alone cannot establish Forever behaviour. |

Reopen only on a specific failure that survives the existing workflow comparison
and has an obtainable missing fact or preventable interaction. A later comparison
must include leader administration, applicant waiting and group changes. No new
addon, automatic ETA prototype, installation, message or client interaction was
performed. The follow-on interrupted-activity screen is recorded below. That is
discovery work, not a commitment to build H3 or a new SessionScout feature.

### Interrupted-activity screen completed — 17 October 2026

**Decision: park a new generic recap addon.** Three concrete first-person
reports describe returning to quests after an absence. They are historical
Retail reports, not demonstrated Forever needs, a prevalence sample or a current
comparison with our product. Their missing information concerns quest-chain
position and chronology more than a record of the last session.

| Report | Observed report and outcome | Implication |
| --- | --- | --- |
| [Terokkar after months away](https://www.reddit.com/r/wow/comments/kcqfii/is_there_a_way_to_see_where_you_left_off_on_a/) | Four of five chapters complete; the next quest giver was unclear. The author's update describes Wowhead lookup and visiting NPCs. | Historical chain state and next-step guidance matter; no timed comparison or subsequent addon result. |
| [Shadowlands and Legion return](https://www.reddit.com/r/wow/comments/1lhri0o/any_trick_to_get_back_in_older_expansions_where/) | Empty quest log and forgotten expansion/class-hall progress. Replies suggest BtWQuests and AllTheThings; no original-player resolution is confirmed. | A newly installed event journal cannot by itself supply unrecorded events; historical quest state may be recoverable separately. |
| [Dragonflight content order](https://www.reddit.com/r/wow/comments/1qblh54/comment/nzbhtbk/) | The returning player reports using an external list to play maximum-level content in order after a straightforward leveling campaign. | Intended narrative order is different from last-session recall. |

[BtWQuests](https://www.curseforge.com/wow/addons/btw-quests) directly advertises
chain progression and subsequent-quest guidance. Its actual accuracy and Forever
applicability were not tested here. [Wayscribe](https://www.curseforge.com/wow/addons/wayscribe)
already advertises a Forever recap, notes and map markers. Its description says
pre-install activity is absent from the journal, but `/ws rebuild` also advertises
adding previously finished quest chains. Therefore its cold-start boundary must
not be inflated into a claim that it cannot recover any historical quest state.
The native quest log and personal notes remain comparison baselines, not presumed
solutions to every prerequisite or phasing problem.

A [BtWQuests user's report](https://www.reddit.com/r/wow/comments/1qblh54/comment/nzcdfq5/)
describes backtracking around the Earthen unlock and an absent quest-starting
poster despite using that addon. Exact prerequisites, the cause and the eventual
poster resolution are unknown. Preserve this narrower problem without treating
it as proof of a recap gap or as a current reproducible defect.

**Next bounded task:** compare one resolved missing-next-quest case with exact
quest IDs and known prerequisites against native guidance and the applicable
existing quest tool. Prefer a Classic/Forever case; do not transfer Retail
assumptions without checking applicability. If the evidence cannot distinguish
missing data, presentation and a game bug, make no product claim. Stop if existing
tools suffice or the proposal depends on invented intent. This screen justifies
no new journal, maintained quest database, client test or speculative feature.

## Owner usability report — 15 October 2026

The owner reported having entered tasks and having more than 60 minutes available,
but receiving no suggestion of what to do. Their game screenshot shows ten saved
tasks, a selected 60-minute budget, three visible unfinished tasks estimated at
120 minutes, and two visible completed 30-minute tasks. Only page one of two is
visible; the remaining task contents and exact available time are not established.
The displayed result says that no unfinished task fits 60 minutes. The window
offered only 15/30/60-minute presets, although `/scout 120` already worked.

This is a concrete discoverability failure in the existing manual planning flow.
The owner had entered personal goals and expected a shortlist; the visible
controls did not let them express the longer session. It supports correcting
that interaction, not relaxing time limits or inventing activity recommendations.
It does not establish independent adoption, voluntary retention, planning time
saved, market prevalence, or that H1's core benefit exceeds its setup burden.

Local alpha.3 adds Custom minutes and Apply, plus an explanation of the shortest
unfinished task when nothing fits. The task-selection model is unchanged.
[The client validation record](CLIENT_TESTING.md#custom-budget-correction--alpha3-actual-client-check-remains-pending)
records 62 automated checks and installation; the new controls have not yet been
observed after an in-client reload. A real 90-minute budget must still exclude a
120-minute task. The owner's statement of "more than 60 minutes" alone does not
justify selecting 120 or shortening an estimate to force a recommendation.

The next useful observation is this same owner using their actual available
minutes after reload: can they apply the budget, understand the resulting fit or
no-fit explanation, and choose a suitable next task? Record which task they
choose and whether the shortlist helped beyond reading their existing list; an
unchanged choice or no useful suggestion is also evidence. Displaying a
120-minute task under a 120-minute budget confirms the correction, but does not
by itself validate planning value. Instructions have already been provided, so
this check cannot count as unaided discovery. Actual completion within the time
available and later voluntary reuse remain unobserved.

### Owner follow-up — 17 October 2026

Asked whether the new time field displays correctly and whether its suggestions
help choose a task, the owner replied: "det hjelper litt" (it helps a little).
This is a limited positive self-report from the same owner. It does not identify
the budget, selected task, time saved, exact controls used, or any remaining
problem. It is not an independent-player result or a complete client test.

One follow-up asks what helped and what was still missing when choosing the next
task. That answer is pending. Keep the current correction and use the concrete
answer to choose the next change; the slight reported benefit alone does not
justify a broader recommendation engine or establish that H1 is validated.

On 17 October the existing package was published as an experimental GitHub
prerelease with those client-test limitations disclosed. Publication changes
availability, not the strength of the owner feedback or evidence of adoption.

## Follow-up on specific evidence — 11 October, 20:15 Europe/Oslo

The previously search-only Warrior report is now directly readable in the
[original comment](https://www.reddit.com/r/wowforever/comments/1wrs5yi/comment/pcm8rlg/).
The player reports an Arms-heavy Human Warrior being labelled Fury and questions
Agility-heavy recommendations. Reddit displays the comment as 13 days old; exact
client build, addon version, talent allocation, settings and subsequent outcome
are absent. This verifies that the report exists, not that the current addon has
a reproduced defect. Do not recruit or contact this player without authorization.

A static audit of the pinned [Lootified 1.2.0 file](https://www.curseforge.com/wow/addons/lootified/files/9112707)
resolved the model-selection question for that version. `Core/Player.lua:128-157`
detects the leading positive talent-group expenditure, but `218-234` gives a valid
saved selection precedence. `UI/ListFilter.lua:297-330` already distinguishes the
selected profile from the card labelled "your talents". Missing talent data can
fall back to Arms, the first DPS entry; it does not invariably select Fury.
`Data/BiS.lua:739-750` gives Arms and Fury identical default armor-stat weights and
a shared item table. Their weapon setup differs; custom priorities and simulation
are separate. A label change alone therefore does not establish different default
static armor ordering. The inspected file was uploaded 9 October, later than the
reported episode, so this is neither its reproduced cause nor proof of a fix.

The one source ZIP and five relevant text files are cached only for audit under
ignored `.tools/research/lootified-1.2.0-source-audit/`, SHA256
`6446886ad6fd9a58b5edbf4661aef3fe05970e9f131408c485d320ebf375777c`.
Nothing was executed or installed. The next comparison must record version,
actual allocation, selected versus detected profile, static versus simulation
mode, and custom priorities before attributing any recommendation disagreement.
Use the competitor's existing profile controls as part of the baseline.

A newly observed Warband Companion advert prompted one bounded official-source
check. Its [features](https://www.warband-companion.com/features) describe loot-roll
and personal-loot advice against current gear/BiS plus a contextual advisor. The
[Help Center](https://www.warband-companion.com/help) describes a Windows companion,
addon, overlay and local simulation. Availability claims conflict: feature and
pricing pages label Assist forthcoming, while Help describes a stable release.
The inspected documentation does not establish Forever support or per-drop beta
provenance. Missing documentation is not evidence of absent functionality.

**Experiment implication:** contextual gear advice alone is not a novelty claim.
Retain the bounded comparison and include this alternative if a participant uses
it or applicable support is verified. Ask the participant to identify the active
model, its assumptions and the actual tradeoff before making a real choice;
clearer confidence alone remains insufficient. Neither source justifies another
feature, installation or expansion of supported classes.

The separate Reddit project account is now created and verified. The actual
r/WowUI posting control blocks it on account age and karma, with no numeric
thresholds disclosed. No invitation, reply or recruitment has occurred. This
supersedes the registration-pending notes below; the prepared draft remains local.

## Public player episodes — 11 October, 19:55 Europe/Oslo

A bounded follow-up looked for reported gear-advice uncertainty, rather than
another inventory of addon features. Two primary discussions expose the original
player's later response. They are self-reports from other WoW clients, not
recruited testers or observations of the Forever prototype.

| Episode | Reported problem and subsequent response | What this supports and does not support |
| --- | --- | --- |
| [Feral/Pawn, April 2026](https://www.reddit.com/r/wow/comments/1sart4z/comment/odyxmqs/) | A new player questions a ring recommendation against their interpretation of Wowhead stat priorities. After discussion, the original player reports uninstalling Pawn, plans to follow the guide more closely and asks how to simulate. The discussion is Retail-oriented; exact client/addon version and item IDs are absent. | Conflicting advice affected reported tool choice. No completed simulation, equipment change or better result is reported. Connecting players to existing tools could be sufficient. |
| [Hunter/Pawn, TBC Classic, June 2021](https://www.reddit.com/r/classicwowtbc/comments/o7n1oy/comment/h2zrvys/) | A new casual player asks why Intellect is weighted highly and whether Pawn is always correct. The player's later takeaway distinguishes a quick leveling aid from endgame evaluation and recognizes limitations of fixed weights, with simulation as a future intention. Exact level, build and addon version are absent. | Explanations can change stated understanding and intended workflow. This older TBC case does not establish actual decision accuracy, later behavior, or relevance of its numerical advice to Forever. |

A third lead was initially a search-indexed player comment on the
[Lootified announcement](https://www.reddit.com/r/wowforever/comments/1wrs5yi/lootified_i_made_an_addon_so_i_dont_need_10/):
an Arms-heavy Warrior reportedly sees Fury detection and questions Agility-heavy
advice. The direct page retrieved at that time did not expose that comment. Its exact
version, build, outcome and date were not established reliably; keep it as a lead,
not a reproduced defect or a fully verified third episode. The 20:15 follow-up
above directly verified the comment and narrowed the source interpretation; it
still does not justify claiming a bug in the current competitor version.

**Decision:** retain the small explanation experiment, without expanding its
classes or item list. The useful comparison is whether a player can determine
which assumptions apply, identify the actual tradeoff, and make the next choice
with less unresolved lookup than with their existing tools. A clearer explanation
that only changes confidence is not sufficient evidence of a better decision.
These episodes establish neither prevalence nor a need for a new addon. Community
claims about stat mechanics are not independently verified technical facts.

The owner authorized using a separate project account for the prepared r/WowUI
invitation and explicitly ruled out their personal Reddit account. Registration
is being prepared; no post, reply, recruitment or new prototype feedback has
occurred. The two historical discussions must not be counted as pilot participants.

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

At approximately 18:42 a further bounded check inspected
[r/WoWAddons](https://www.reddit.com/r/wowaddons/) and
[r/WowUI](https://www.reddit.com/r/WowUI/). WoWAddons permits AI use with disclosure
but prohibits fully generated descriptions, so the autonomous draft is not
proposed there. WowUI's stated scope includes interface usage and its displayed
rules require [HELP] for questions and free content. It is the proposed
destination for one gear-comparison-interface research question, pending owner
authorization and actual account/posting checks. This is a channel-fit inference,
not moderator approval. The local draft has been shown to the owner and asks for
recent choices, sources/tools, and remaining uncertainty; satisfactory existing
tools are an equally valid answer. It requests no installation and discloses AI
use. Nothing has been posted and no responses have been collected.

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

### H4 source-case preparation — 11 October 2026, 22:14 onward

Independent work remained available while publication and recruitment waited:
the diagnostic case collection specified above had not been done. The initial
result is [19 attributed source cases](../data/diagnostic-cases-20261011.json).
Eleven are candidates with an explicitly reported, scoped successful outcome;
seven are controls or unresolved reports, and one concerns a developer tool
outside the player pool. Nine candidate cases concern Forever, while two
are historical Classic cases and establish no Forever compatibility. These
are selected reports, not eleven reproduced root causes or eleven research
participants. An author-only barber workaround remains a low-confidence candidate
under the same reported-outcome criterion; it is not an independently verified fix.

Every entry preserves the symptom, known context, outcome source, warranted
next check, existing help and missing evidence. Closed issues, merged fixes,
thanks, and announced releases were not sufficient by themselves. In threads
with several participants, the successful outcome stays attached to the
participant who reported it. No private logs or player identifiers are copied.

The collection covers client/build changes, settings interactions, incompatible
interface metadata, external manager configuration, incomplete updates and
misleading stack paths. A content-pack case distinguishes **installed but not
loaded** from physically missing files; it does not fill the still-missing
confirmed physical-dependency case. A historical missing-base-addon report has
a successful follow-up after installation advice, but does not explicitly report
the installation step; it is retained as a control, not the missing complete
evidence chain. The old shared-library case is retained
as a false-attribution control, not counted as an explicitly successful full
retest. Insufficient evidence and partial fixes remain visible. This narrows
what is ready for comparison without weakening the advance rule above.

#### Information the proposed product could actually obtain

This is a source audit of the pinned Forever mirror, not a fresh runtime test.
The [C_AddOns declarations](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/AddOnsDocumentation.lua)
and [Blizzard addon list](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_AddOnList/AddonList.lua)
support inspecting known addons, selected-character enablement, metadata,
declared dependencies and loadability/reason. Not loaded can be intentional,
including demand loading. A missing list entry does not identify an extraction
error or the directory used by another client installation. Access to another
addon's private table requires that addon's opt-in; do not presume general
access to its internal settings.

| Information | Source required in a fair comparison |
| --- | --- |
| Current client build and addon load state | Game readout, with exact client context. |
| Previous desired settings and the character the player meant | Player account of the incident; current identity alone cannot reconstruct intent. |
| Persistence after restart | A recorded before/after procedure. Lifecycle events do not certify successful disk writes. |
| WowUp registered client, channel and scan result | External manager observation; no in-game access established. |
| Questie tracker/filter choices | Player observation or a separately verified, version-specific integration. |
| Which historical issue/fix applies | Maintained source knowledge with build/version limits. |

The [Forever system-event declarations](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/SystemDocumentation.lua)
do not supply arbitrary SavedVariables file contents, hashes or proof of earlier
disk state. The [watch-list API](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua)
does not replace Questie's own tracker/filter settings used in its
[specific fix](https://github.com/Questie/Questie/pull/7894/files).

For any later manual comparison, label supplied facts as game readout, player
report, external observation or historical source knowledge. Give both options
the same facts available at the chosen point in the incident, hide later outcomes
from participants, and include time spent obtaining missing information. An
answer may correctly request more evidence. Do not count a researcher's access
to external screenshots or the eventual solution as in-game automation.

#### Existing baseline and decision

[BugSack's inspected source](https://github.com/funkydude/BugSack/blob/e707fd126f4dc021dc126546a7911f3bfa736cd6/core.lua)
already displays errors gathered by BugGrabber and supplies concrete guidance
when its own dependencies are missing. That establishes neither general root-cause
accuracy nor the behavior of every BugGrabber implementation. The earlier
0xgle Bugs author-description observation already overlaps understandable errors
and next-step guidance. Its implementation was not available in the inspected
[author repository revision](https://github.com/0xgle/ForeverForge/tree/fb7b9ff47662a993b177cb376b989365deebfefb);
do not infer that advertised features are absent or accurate. No competitor was
installed or exercised here.

An additional direct baseline is [TOG Tools' versioned author changelog](https://www.curseforge.com/wow/addons/togtools/files/9095461/dependencies).
It describes named missing dependencies, separate not-installed/disabled/wrong-version
states, load-on-demand handling and navigation from an error explanation to an
addon-load view. The author explicitly marks the dependency work as not verified
in a client. These are attributed capabilities, not our accuracy measurements.
They do rule out presenting this workflow as an established novel idea. A future
comparison must include this baseline where available, not only a raw error window.

**Decision:** keep H4 exploratory. The case sources already contain useful
maintainer/player advice; assembling them does not demonstrate superior advice,
an unmet market, feasibility of every diagnosis, or willingness to install.
No five-player comparison, competitor runtime comparison, recruitment or new
diagnostic implementation has occurred. The existing two-hour preparation cap
and advance/stop rules still apply.

### H4 task-bank preparation — 11 October, 22:38 Europe/Oslo

The [participant prompt file](../data/diagnostic-prompts-20261011.json) contains
twelve retrospective scenarios: ten selected outcome candidates and two controls
(partial workflow verification and misleading stack attribution). The low-confidence
barber workaround remains in the source ledger but is not selected here. The
[separate researcher file](../data/diagnostic-taskbank-review-20261011.json) maps
each prompt to its source, time boundary, acceptable checks and unsupported claims.
It does not contain participant results or fabricated competitor explanations.

Review exposed a concrete design risk: the source ledger's context sometimes
contains the eventual solution. Those facts are excluded from the participant
file. D01's original report already proposed a fix; D08 has no separately posted
pre-solution account by the confirming participant; D09's original post was edited
to include a solution. Their symptom excerpts are reconstructions, not recovered
prospective snapshots. Other multi-participant threads preserve the identity of
the relevant report without publishing personal identifiers. Current page contents
do not prove that an earlier revision was identical.

The authors have read all outcomes. A later test using these cases could study
whether explanations help people choose warranted next checks, but it cannot
establish accuracy on unseen incidents. Genuine prospective accuracy claims would
require held-out incidents and evaluation criteria fixed before seeing outcomes.
The eventual fix is not necessarily the only defensible initial check.

This completes the useful public-source preparation at this stage, within the
original two-hour cap. It does **not** make the comparison ready. Willing players,
the earlier problem-discovery gate, case-specific competitor outputs, the missing
physical-dependency evidence chain and a reviewed condition/scoring plan remain
required. Public support replies are reference advice, not observations from
TOG Tools/0xgle or a participant's usual workflow. Each case should be seen once
per participant; repeated exposure after advice cannot count as independent
improvement. Retain the existing 4/5 advance rule, rather than substituting case
counts or an assistant's own answers for it. Do not extend this task bank or build
H4 merely to occupy time while those prerequisites are absent.

### H4 offline competitor observation — 11 October, 22:48 Europe/Oslo

The official [TOG Tools v0.10.2 package, file 9095461](https://www.curseforge.com/wow/addons/togtools/files/9095461)
was downloaded once for source inspection. Its actual package license is MIT,
copyright 2026 Pimptasty; the [notice](../data/TOGTools-LICENSE.txt) is retained.
The unchanged `Modules/Diagnostics/ErrorInterpreter.lua` uses ordinary Lua
functions and can run independently. Its Forever TOC declares interface 16001,
but that metadata is not a successful client test. No addon was installed.

The [inputs](../data/togtools-parser-inputs-20261011.json),
[actual outputs](../data/togtools-parser-observations-20261011.json) and
[reproduction script](../tools/observe_tog_parser.py) record a deliberately narrow
observation of **one historical TBC Classic error in two formats**. The original
[H4-016 report](https://www.wowace.com/projects/elkbuffbars?comment=2381) puts
the file/line and missing-method reason on separate lines. The second input is
our explicitly labeled normalization to a single `path:line: reason` line;
it is not another player incident or an automatic TOG Tools conversion.

| Input | Observed parser result | What this establishes |
| --- | --- | --- |
| Original message and Debug-stack format | Generic Lua-error classification; no extracted file/line; ElkBuffBars selected through the stack as report destination. The explanation describes it as the most likely cause. | This particular format loses available file/reason information in this parser version. |
| Same excerpt with the message normalized | Missing-function classification; EnhanceDatabase, ElkBuffBars.lua and line 283 identified; ElkBuffBars selected as file owner/report destination. | The existing parser already explains this error category and offers update/report steps when its expected format is supplied. |

Both outputs list Accountant_Classic in the stack but do **not** select it as
the report destination. They do not identify the later reported Critline
interaction. Reporting to the failing addon's maintainer is still a reasonable
action; failure to name the eventual conflicting addon is not itself a wrong
report destination. The source discussion also lacks a complete successful
retest, so it must not become a binary diagnostic accuracy score.

Execution used Lupa 2.8 / Lua 5.1 with a restricted standard-function environment,
the inspected package/source hashes, and `lookup=nil`. No WoW APIs or client API
mocks were supplied. In particular, this does not exercise TOG Tools' actual
metadata, dependency lookup, collection, UI, installation effort or Forever
runtime. Its absent dependency details here are not a product failure. The task
bank's full-comparison fields remain null; these separately scoped parser outputs
do not fill them. No player or candidate-product comparison occurred.

**Decision:** basic plain-language error explanations are demonstrably present
in an existing implementation. This small formatting limitation does not justify
building a rival addon or establish demand for one. Keep H4 exploratory and stop
this source-only probe here; the next comparison still requires actual player
problems and the full relevant competitor workflow. Do not turn more synthetic
parser probes into apparent progress toward adoption.

### Prepared experiment prompts

- **H1:** “Show a recent session in which choosing what to do took effort. What did you choose, and did it fit the available time?” Use the existing alpha only after recording the baseline.
- **H2:** Record item, observed count, selected goal, verified quantity, and the reason for reserving it. A fictional arithmetic example is 9 held, 4 reserved for goal A, 2 for goal B, and 3 unreserved by these goals. “Unreserved” never means universally safe to sell. Do not automate selling.
- **H3:** Record last observed objective, timestamp, observed progress and remaining requirements, with unknown fields explicit. Ask the player whether they still want that activity. Do not reconstruct an unrecorded past or state inferred intent as fact.
- **H4:** Record observed symptom, available evidence, confirmed outcome, warranted next check and what cannot be concluded. An addon appearing in a stack trace does not by itself establish root cause. Do not automatically disable or modify addons.

### Selection and evidence ledger

After the comparisons, choose at most one candidate for new implementation. Prefer a repeated, consequential problem, measurable improvement over existing tools, low user administration, reliable data, and a plausible audience beyond one character or niche. If no candidate clears the gates, keep the software and evidence, park the candidates, and investigate another problem. Do not combine weak ideas into a larger addon to avoid rejecting them.

A Forever winner would still need sustained retention, authorized discovery channels, and separately verified support for any broader audience. None of the present hypotheses is demonstrated to support the scale required for first place on the overall list. Actual rank on that list remains the final success criterion.

At the original 14:36 revision, none of the four comparative demand tests had
run and no diagnostic cases had been collected. Later work has now assembled
the H4 source ledger above and recorded the owner's real RFK gear-choice
episode. Neither is a comparative demand test. H1 has a technically tested alpha,
without validated adoption or retention; the gear explanation has a local pilot,
without a demonstrated advantage over existing tools. H2–H4 remain unimplemented
research hypotheses. No participants have been recruited or goal reservations
verified. Future entries must retain negative results and distinguish baseline,
setup burden, observed benefit, repeat use and the resulting decision.

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
