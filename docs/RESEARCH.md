# SessionScout: product hypothesis and evidence

Research date: 11 October 2026 (Europe/Oslo). This is an initial research snapshot, not proof of demand, compatibility, name availability, or future ranking.

## Goal and baseline

Success means the published project occupies position 1 in the user's exact [CurseForge WoW popularity listing](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity). At this check the first five projects were DBM, Details, Auctionator, Questie, and Raider.IO. DBM displayed 635.4 million lifetime downloads, and the listing contained 10,000+ projects. Popularity and total downloads are separate sorts; lifetime downloads are not a published threshold for reaching first place.

No authoritative public formula for the search popularity sort was found. The [CurseForge reward FAQ](https://support.curseforge.com/support/solutions/articles/9000197902-reward-program-faq) describes internal reward calculations, which must not be assumed to be the search-ranking formula. A new release cannot promise a rank or deadline.

## Current release target

The user selected **Classic/Forever first**. The first release targets the installed **WoW Forever 1.60.1 client, interface 16001**. Installation, testing, packaging metadata, and pilot recruitment should use that target. A Retail installation or Retail validation is not required for this release. Support for other Classic clients or Retail must be separately verified before it is advertised.

The overall number-one goal still refers to the original unfiltered WoW popularity listing. A Forever-first release is an initial audience choice, not a change to that goal. The Retail-focused evidence below is competitive context; it does not establish demand, available game systems, or API compatibility in Forever.

## Positioning to validate

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

## Validation targets (not achieved results)

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
