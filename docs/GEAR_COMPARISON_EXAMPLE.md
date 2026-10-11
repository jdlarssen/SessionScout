# Ferine Leggings: what the comparison actually tells us

This example compares equipped **Brawler's Leather Legguards (252516)**
with **Ferine Leggings (6690)** for a level 30 Enhancement Shaman. The candidate
was selected for the experiment; it was not confirmed as the player's original
RFK hunt target. No installation is needed.

On 11 October 2026, the local pilot read these attributes from Forever client
**1.60.1.70338**. Both item tooltips matched the readings. See the anonymous
[observation record](../data/gear-evidence-client-20261011.json) and
[client validation record](../experiments/GearEvidencePilot/TESTING.md).

| Stat | Equipped Brawler's | Candidate Ferine | Change |
| --- | ---: | ---: | ---: |
| Armor | 90 | 96 | +6 |
| Strength | 7 | 0 | -7 |
| Agility | 9 | 0 | -9 |
| Stamina | 7 | 0 | -7 |
| Spirit | 6 | 0 | -6 |
| Intellect | 0 | 12 | +12 |
| Attack power bonus on item | 0 | 26 | +26 |

Ferine adds Intellect and a listed attack power bonus, but loses Strength,
Agility, Stamina and Spirit. These are item attributes, not the resulting total
character stats. A higher weighted score does not erase those losses.

**Why the fixed models prefer Ferine**

Each model multiplies item stats by its own coefficients and adds the results.
Using the weights inspected on 11 October, with unchanged default priorities:

- [WOWF Enhancement PvE](https://wowf.io/en/bis/shaman#enhancement):
  the pilot displayed **+20.680 points**, rounded. The calculation is
  **19.12 → 39.80**. Intellect contributes `12×1.15 = 13.80`
  and attack power `26×1 = 26`. Lost Strength, Agility and Stamina subtract
  `7×2 + 9×0.53 + 7×0.05 = 19.12`. Armor and Spirit have zero weight.
- [Lootified 1.2.0 default static model](https://www.curseforge.com/wow/addons/lootified/files/9112707):
  the pilot displayed **+2.863 points**, rounded. Applying the listed decimal
  weights gives **11.6005 → 14.4640**, a difference of **2.8635 before display
  rounding**. Intellect contributes
  `12×0.512 = 6.144` and attack power `26×0.32 = 8.32`. Lost Strength, Agility,
  Stamina and Spirit subtract
  `7×0.64 + 9×0.4096 + 7×0.2097 + 6×0.3277 = 11.6005`. Armor has zero weight.

The [recorded coefficients and source locations](../experiments/GearEvidencePilot/Data.lua)
make the arithmetic traceable. The models use different scales: **these are not
DPS gains**. Neither calculation adapts its weights to individual talents or
measures rotation, proc or set effects.

**What remains unknown**

[ForeverDB's item page](https://foreverdb.net/item/6690), as inspected that day,
labels the Agathelos acquisition information as Classic data. This experiment
observed no beta drop. It establishes neither current beta availability nor
unavailability, drop rate, farming efficiency, BiS or increased DPS.

This is a technical demonstration, not evidence of a better player decision,
saved effort, voluntary reuse or demand. If you use this explanation for a real
choice, the existing [actual-use feedback form](https://github.com/jdlarssen/SessionScout/issues/new?template=session_feedback.md)
accepts unresolved questions and “my usual tools were enough” too. Reading the
example alone is not addon use.
