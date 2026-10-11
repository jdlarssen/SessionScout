-- Local evidence pilot only. These item facts are dated research fixtures,
-- NEVER fallback data for live scoring. The live adapter must obtain complete
-- current item stats itself. Weights intentionally omit unverified coefficients:
-- a nonzero stat without a weight must make Model.Compare fail explicitly.
-- API: ns.Data.candidates = ordered {itemID,slotID,name,dropEvidence} entries;
-- ns.Data.items[numericItemID] = {name,stats,source,sourceBuild,sourceExtracted};
-- ns.Data.models = ordered {id,name,weights,source,inspected,method} entries.
local _, ns = ...
ns.Data = {
    schema = 1,
    fixtureOnly = true,
    case = "Owner equipment, analyst-selected RFK candidates",
    candidates = {
        {
            itemID = 6690, slotID = 7, name = "Ferine Leggings",
            dropConfidence = "Classic-source-only; beta drop not observed",
            dropEvidence = "Agathelos link/rate labeled Classic data by ForeverDB; no observed beta drop verified in this audit",
            source = "https://foreverdb.net/item/6690",
            inspected = "2026-10-11", sourceExtracted = "2026-10-08", sourceBuild = "70291",
        },
        {
            itemID = 6697, slotID = 3, name = "Batwing Mantle",
            dropConfidence = "Classic-source-only; beta drop not observed",
            dropEvidence = "Blind Hunter link/rate labeled Classic data by ForeverDB; no observed beta drop verified in this audit",
            source = "https://foreverdb.net/item/6697",
            inspected = "2026-10-11", sourceExtracted = "2026-10-11", sourceBuild = "70338",
        },
    },
    items = {
        [5964] = {
            name = "Barbaric Shoulders",
            stats = { armor = 76, str = 5, agi = 5, sta = 6 },
            source = "https://foreverdb.net/item/5964",
            sourceBuild = "70338", sourceExtracted = "2026-10-11",
        },
        [252516] = {
            name = "Brawler's Leather Legguards",
            stats = { armor = 90, str = 7, agi = 9, sta = 7, spi = 6 },
            source = "https://foreverdb.net/item/252516",
            sourceBuild = "70291", sourceExtracted = "2026-10-08",
        },
        [6697] = {
            name = "Batwing Mantle",
            stats = { armor = 38, int = 11, agi = 3, sp = 6 },
            source = "https://foreverdb.net/item/6697",
            sourceBuild = "70338", sourceExtracted = "2026-10-11",
            dropEvidence = "Blind Hunter link/rate labeled Classic data by ForeverDB; no observed beta drop verified in this audit",
        },
        [6690] = {
            name = "Ferine Leggings",
            stats = { armor = 96, int = 12, ap = 26 },
            source = "https://foreverdb.net/item/6690",
            sourceBuild = "70291", sourceExtracted = "2026-10-08",
            dropEvidence = "Agathelos link/rate labeled Classic data by ForeverDB; no observed beta drop verified in this audit",
        },
    },
    models = {
        {
            id = "wowf_enhancement_pve", name = "WOWF Enhancement PvE",
            weights = { str = 2, agi = 0.53, sta = 0.05, int = 1.15, spi = 0, ap = 1, sp = 0.2, armor = 0 },
            source = "https://wowf.io/en/bis/shaman#enhancement",
            inspected = "2026-10-11",
            method = "Displayed fixed weights; no simulation",
        },
        {
            id = "lootified_1_2_0_default", name = "Lootified 1.2.0 default static",
            weights = { str = 0.64, agi = 0.4096, sta = 0.2097, int = 0.512, spi = 0.3277, ap = 0.32, sp = 0.2272, armor = 0 },
            source = "https://edge.forgecdn.net/files/9112/707/Lootified-1.2.0.zip",
            inspected = "2026-10-11",
            method = "Data/BiS.lua:1309-1311, Core/Scoring.lua:247-287, default priorities; no simulation or runtime verification",
        },
    },
    limitations = {
        "Item attributes are dated database facts, not live tooltip readings; never use them as live scoring fallbacks.",
        "Candidates were analyst-selected; the player's original hunt target was not confirmed.",
        "Model points use different scales and objectives; they are not measured DPS and cannot be compared across models.",
        "Agreement is conditional on supplied stats and fixed weights; it does not prove BiS, beta drop availability, or farm efficiency.",
        "Proc, set, encounter and rotation effects have not been measured. Weights are not adapted to live talents.",
        "No measured effort saving, changed player decision, voluntary reuse or broader demand is established by these fixtures.",
    },
}
