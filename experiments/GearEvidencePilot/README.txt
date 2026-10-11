GearEvidencePilot -- local bounded prototype, not a release

Open /gearevidence outside combat. Select Ferine Leggings (6690, legs) or
Batwing Mantle (6697, shoulder), then use Refresh client data as needed. The
window closes in combat and Escape closes it. The evidence text can be copied
with Ctrl+A / Ctrl+C, including model sources and assumptions.

Scope: Forever Interface 16001, level 30 Shaman, with a positive unique
Enhancement talent-rank lead established from the current trait configuration.
Pending talent edits, or an unavailable committed-state check, block comparison
until changes are applied or discarded and the player refreshes.
The fixed model weights are not a personalized simulation and do not adapt to
your actual talent choices. Model points are not DPS, BiS, confidence estimates,
or a reason to compare scores across different models.
Each score shows its nonzero stat contributions, ordered by absolute size:
stat change multiplied by that model's existing coefficient. Points are rounded
for display. Full coefficients, including explicit zeros for ignored stats,
appear with the model methods and sources. This explains the fixed score without
adding a recommendation or changing its formula.

Current gear is read from its full equipped item link, preserving suffix,
enchant and bonus fields. The candidate ID resolves to a client item link before
stats are read. C_Item item info and stats are the only live stat source.
Data.lua research fixtures are never a fallback for missing or pending data.
Unmapped nonzero stat keys remain unsupported; they are not silently discarded.
Only eligible cloth/leather shoulder or leg armor is considered. Set effects
and unreported enchant/proc/encounter/rotation effects are not evaluated.

Manual opening/refresh/selection reads data. ITEM_DATA_LOAD_RESULT may complete
an already requested visible comparison, with generation, combat and stale
equipment/talent guards. There is no background polling. Missing, pending,
stale, unsupported, restricted or failed item data blocks scores; no item is
assigned invented zero stats. Failed cache loads require a manual refresh to
retry. Closing the window invalidates its snapshot.

The item-source boss/drop claim is Classic-source data. No beta drop has been
verified by this pilot. Model source URLs and inspection dates appear in the UI.

No SavedVariables, telemetry, automatic equipping, selling, inventory writes,
or external dependencies. _G.GearEvidencePilot, its window, state, Refresh and
eventFrame exist for local QA; they are not a supported public API.

Install only the entire GearEvidencePilot folder as a separate local addon when
explicitly intended. It is independent of SessionScout. In-game verification is
required before claiming this prototype works in the target client. Offline
tests or syntax checks do not demonstrate measured DPS, player value or safety
of a broader gear recommendation product. This prototype is not published.
