# Balance

## Road shapes: every map's road redrawn (Nov 2026; DECISIONS L1-L4)

The owner found the roads generic ("can we make them more themed"). Every one of
the 45 roads was redrawn to a shape that tells its place (DECISIONS L1-L2; plan
and pictures in `/home/user/gw_shots/layouts/`), spots re-placed with the same
counts and road ids (L3), and every map re-tuned with `wave_hp_end` only (L4, the
`--hp-end` probe, seeds 1-4). Act I was redrawn too: its six baseline summaries
are re-recorded below.

Default orders, Necromancer, seeds 1-4, lives kept of 20 (changed `wave_hp_end` in
bold); all 180 runs won, 0 script errors / warnings, `stuck_enemies=0`; every weak
order loses (seed 1); seed 1 run twice gives the same summary on all 45 maps. 107
of 180 runs lose lives (97 before); no map keeps 20 lives on all four seeds. Every
kit order wins on seed 1 (`tide_kit`, `court_kit`, `shogunate_kit`, `norse_kit`,
`dynasty_kit`, `pantheon_kit`, `inferno_kit`, `host_kit`, `eye_kit`, `empire_kit`,
`concord_kit`, `titans_kit`, `year_kit`, Act I's `kit_a` / `kit_b`), unchanged. Route
px: the longest entrance's on-screen walk to the gate.

| Act | Map | Shape (DECISIONS L2) | Route px old -> new | wave_hp_end | s1 | s2 | s3 | s4 | Lose lives | Before (spot fix, s1-s4) |
|---|---|---|---|---|---|---|---|---|---|---|
| I | graveyard | three-quarter oval round the crypt | 2829 -> 2589 | 2.6 -> **2.0** | 20 | 20 | 20 | 10 | 1/4 | 20, 13, 20, 20 |
| I | crimson_march | chevron columns, parade road back west | 2733 -> 2406 | 2.4 -> **1.88** | 15 | 20 | 14 | 20 | 2/4 | 9, 20, 20, 17 |
| I | sanctum | ambulatory, nave, round apse | 3960 -> 4305 | 3.15 -> **2.9** | 20 | 20 | 20 | 17 | 1/4 | 9, 20, 20, 20 |
| II | cutter | gangplanks, cargo zig-zags | 1669 -> 1722 | 4.3 | 17 | 20 | 14 | 20 | 2/4 | 15, 9, 20, 20 |
| II | galleon | hull outline | 2244 -> 2731 | 2.95 | 12 | 15 | 15 | 12 | 4/4 | 17, 17, 12, 20 |
| II | maelstrom | spiral to the eye | 4634 -> 3510 | 4.0 | 20 | 20 | 17 | 20 | 1/4 | 20, 11, 20, 20 |
| III | ravensmoor | crooked moor track | 2929 -> 2745 | 4.2 -> **3.2** | 14 | 14 | 11 | 20 | 3/4 | 12, 14, 12, 15 |
| III | witchwood | mirrored half-rings round the circle | 1519 -> 1459 | 2.8 | 14 | 20 | 17 | 20 | 2/4 | 20, 14, 20, 20 |
| III | castle_sanguis | crenellated rampart, keep spiral | 4597 -> 4853 | 5.3 -> **4.9** | 20 | 17 | 20 | 17 | 2/4 | 17, 20, 20, 14 |
| IV | skid_row | dog-leg alleys, a crossing | 1850 -> 1880 | 3.6 -> **4.2** | 20 | 20 | 20 | 14 | 1/4 | 20, 12, 20, 20 |
| IV | fort_kessler | star fort | 2110 -> 2329 | 3.1 -> **4.1** | 17 | 17 | 20 | 20 | 2/4 | 14, 17, 14, 20 |
| IV | liberty_heights | avenue grid, boulevard, traffic circle | 3090 -> 3312 | 2.2 | 12 | 20 | 17 | 12 | 3/4 | 11, 20, 11, 11 |
| V | province | paddy dikes | 1509 -> 1770 | 2.7 -> **3.2** | 17 | 17 | 20 | 19 | 3/4 | 13, 17, 20, 11 |
| V | kurogane | concentric square baileys | 1565 -> 2150 | 2.8 -> **4.0** | 20 | 20 | 17 | 17 | 2/4 | 15, 14, 20, 20 |
| V | sun_road | rising pilgrim S-bends | 3039 -> 3163 | 4.2 | 14 | 10 | 15 | 20 | 3/4 | 17, 20, 20, 20 |
| VI | barrow_fields | arcs round the barrows | 2474 -> 2388 | 2.5 -> **3.5** | 11 | 7 | 11 | 20 | 3/4 | 18, 20, 10, 19 |
| VI | valgard | wall benches and central aisle | 1839 -> 2060 | 1.9 -> **2.4** | 16 | 20 | 16 | 20 | 2/4 | 10, 10, 10, 10 |
| VI | vigrid | W of diagonal battle lines | 3129 -> 2503 | 3.2 -> **2.3** | 20 | 14 | 11 | 19 | 3/4 | 19, 20, 20, 15 |
| VII | necropolis | stepped pyramid | 3059 -> 2880 | 4.3 -> **4.5** | 20 | 20 | 14 | 20 | 1/4 | 14, 20, 20, 17 |
| VII | lioness_temple | mirrored slaloms, central aisle | 2288 -> 2388 | 3.0 -> **2.2** | 20 | 20 | 11 | 20 | 1/4 | 17, 20, 20, 20 |
| VII | two_truths | the scales (two pans, a post) | 4110 -> 3580 | 3.55 -> **4.0** | 20 | 8 | 20 | 20 | 1/4 | 2, 15, 20, 15 |
| VIII | ilion | landing lanes to the wall gate | 2856 -> 2485 | 2.5 -> **2.75** | 14 | 20 | 20 | 20 | 1/4 | 12, 19, 20, 20 |
| VIII | olympus | narrowing switchbacks | 2536 -> 2682 | 3.4 -> **3.9** | 17 | 20 | 17 | 20 | 2/4 | 20, 20, 20, 16 |
| VIII | underworld | Styx S-bends, the ferry | 2269 -> 2491 | 2.2 | 13 | 12 | 10 | 6 | 4/4 | 20, 19, 17, 20 |
| IX | burning_gate | shrinking flame teeth | 1649 -> 2030 | 5.3 -> **5.6** | 17 | 9 | 20 | 20 | 2/4 | 20, 17, 12, 20 |
| IX | silk_palace | mirrored silk ribbons | 2189 -> 1722 | 4.0 -> **3.4** | 17 | 20 | 16 | 14 | 3/4 | 20, 17, 16, 20 |
| IX | pandemonium | five-pointed star | 2269 -> 2369 | 3.4 -> **3.9** | 20 | 20 | 20 | 14 | 1/4 | 20, 16, 13, 20 |
| X | silver_stair | widening switchback flights | 2919 -> 2842 | 3.0 | 19 | 20 | 20 | 20 | 1/4 | 15, 20, 19, 20 |
| X | wheel_of_thrones | concentric ring arcs | 3999 -> 4289 | 3.6 -> **3.2** | 20 | 17 | 12 | 11 | 3/4 | 8, 11, 20, 9 |
| X | empyrean | rose window lobes, spoke | 1754 -> 1600 | 3.0 -> **2.7** | 10 | 10 | 15 | 7 | 4/4 | 9, 9, 17, 11 |
| XI | harbour | quay and finger piers | 1874 -> 2156 | 3.8 | 12 | 20 | 20 | 20 | 1/4 | 20, 17, 20, 20 |
| XI | archive | stack aisles, the rift | 3409 -> 3520 | 5.6 -> **5.2** | 10 | 14 | 18 | 18 | 4/4 | 15, 19, 20, 20 |
| XI | spire | two tentacle spirals | 2719 -> 2480 | 3.5 -> **3.1** | 19 | 17 | 20 | 17 | 3/4 | 20, 12, 20, 20 |
| XII | wastes | broken highway | 3219 -> 3333 | 4.1 -> **3.6** | 14 | 14 | 14 | 20 | 3/4 | 15, 20, 20, 20 |
| XII | assembly | two conveyor loops | 3279 -> 2796 | 3.6 -> **2.6** | 12 | 20 | 19 | 20 | 2/4 | 20, 18, 20, 20 |
| XII | citadel | circuit traces, central chip | 1965 -> 1806 | 2.95 | 17 | 17 | 15 | 19 | 4/4 | 20, 11, 12, 20 |
| XIII | crash_site | furrows round the crater rim | 1605 -> 1813 | 2.65 -> **2.4** | 10 | 10 | 19 | 7 | 4/4 | 19, 20, 18, 20 |
| XIII | proving_moon | arena oval and dais | 2414 -> 2534 | 3.0 | 20 | 20 | 20 | 14 | 1/4 | 17, 20, 17, 17 |
| XIII | ark | ring corridor and spoke | 1245 -> 1633 | 2.2 | 10 | 20 | 20 | 17 | 2/4 | 20, 14, 15, 17 |
| XIV | fern_basin | the basin's bowl | 1899 -> 1714 | 2.9 -> **2.4** | 20 | 7 | 20 | 14 | 2/4 | 13, 20, 20, 20 |
| XIV | great_plain | sweeping arcs | 2015 -> 2015 | 2.5 -> **2.25** | 20 | 20 | 20 | 11 | 1/4 | 14, 17, 20, 14 |
| XIV | last_day | paths between craters | 1060 -> 1212 | 2.3 | 14 | 15 | 7 | 16 | 4/4 | 17, 12, 20, 16 |
| XV | greenwood | meandering forest trail | 3209 -> 3448 | 2.8 -> **2.4** | 14 | 19 | 19 | 16 | 4/4 | 20, 19, 15, 17 |
| XV | fae_court | three fairy rings | 1925 -> 1958 | 4.2 -> **3.6** | 10 | 10 | 10 | 10 | 4/4 | 17, 17, 20, 14 |
| XV | world_tree | canopy, root line, branch | 4139 -> 4177 | 3.2 -> **2.6** | 14 | 7 | 7 | 14 | 4/4 | 17, 12, 1, 20 |

**Thin margins** (lowest seed under 8 lives, or a cliff within 0.1): Ilion (2.8
loses seed 1: Polyphemus survives and the run snowballs), the Underworld (6 on
seed 4: hoplites' shield fronts leak on the S-bends; a lower `wave_hp_end` does
not help), the Crash Site (the Hive Mother leaks 10 on most seeds; 7 on seed 4),
the Last Day (7 on seed 3), the Empyrean (7 on seed 4), the World-Tree (7 on
seeds 2-3), the Barrow Fields and the Fern Basin (7 on one seed), the Fae Court
(the Summer Queen leaks 10 on every seed: 10 lives each), and steep `wave_hp_end`
cliffs on Castle Sanguis (5.1 loses), the Crimson March (1.92 loses a seed), the
Sanctum (3.2 loses two), the Great Plain (2.5 loses two) and the Assembly Halls
(3.0 loses all). Organic routes that pass each plot once are the hard ones (the
Temple of the Lioness, the Crash Site, the Fae Court, the World-Tree): their
`wave_hp_end` came down most.

## Spot fix: every plot reaches the road (superseded by the road shapes above) (Nov 2026; DECISIONS S1-S4)

The owner reported plots from which no tower hits anything. The spot audit
(`tools/spot_audit.tscn`, `SpotAudit`, thresholds in `SpotAuditData`) found 140
bad spots on 38 maps (145 flags): 95 dead plots (the Banshee, the shortest-range plot tower at
115 px, reaches no road from them), 12 weak (under 52 px of road, 1 s of fodder),
26 under the HUD (top bar, the act's widget corner, the Black Tide's sea band), 9
on a prop, 1 on the road, 1 crowded, and 1 post (the Road to the Sun's last post
40 px before the gate: kept, the rule now flags only a post inside the gate). 139 plots on 38 maps moved
(each to the nearest 5 px grid place passing every test with 110 px of road for the
Banshee; the Maelstrom's plot 0 placed by hand between its row's neighbours), no
plot added or removed, indices kept; Act I passes the audit and is untouched (its
six baseline summaries below are byte-identical). The audit is now a gate in
`MapLoader.validate()` (map_list, every run start) and a CI self-check.

Default orders, Necromancer, seeds 1-4, lives kept of 20 (after the changes in
bold); every run won, 0 errors, `stuck_enemies=0`; every weak order still loses
(seed 1); the same seed twice is identical (Underworld, Ravensmoor seed 1). 97 of
180 runs lose lives (97 before too); no map went to 0 of 4. Retuned (`--hp-end`
probes, seeds 1-4): Necropolis and Olympus lost seed 4 and the Empyrean seed 3 at
their old values (the moved plots had held their default orders' long-range
towers); the Skid Row, Lioness Temple and Fern Basin went to 20 lives on all four
seeds. The Fern Basin's band is narrow (3.0 loses seed 2). Kit orders, seed 1:
39/39 won after `host_kit` puts the Bound Ophan on the Empyrean's plot 9 (its old
plot 4 sat at the dead centre between both roads, where the Ophan dealt 70k; at
the new plot 4 the order lost; on plot 9 it wins 4/4 with 14-20 lives, the Ophan
~20k). Valgard's `norse_kit` keeps 10 lives (17 before).

| Act | Map | Plots moved | wave_hp_end | s1 | s2 | s3 | s4 | Runs losing lives | Before (s1-s4) |
|---|---|---|---|---|---|---|---|---|---|
| I | graveyard | 0 | 2.6 | 20 | 13 | 20 | 20 | 1/4 | 20, 13, 20, 20 |
| I | crimson_march | 0 | 2.4 | 9 | 20 | 20 | 17 | 2/4 | 9, 20, 20, 17 |
| I | sanctum | 0 | 3.15 | 9 | 20 | 20 | 20 | 1/4 | 9, 20, 20, 20 |
| II | cutter | 2 | 4.3 | 15 | 9 | 20 | 20 | 2/4 | 15, 15, 20, 20 |
| II | galleon | 8 | 2.95 | 17 | 17 | 12 | 20 | 3/4 | 12, 17, 12, 20 |
| II | maelstrom | 6 | 4.0 | 20 | 11 | 20 | 20 | 1/4 | 20, 20, 14, 11 |
| III | ravensmoor | 9 | 4.2 | 12 | 14 | 12 | 15 | 4/4 | 20, 20, 15, 14 |
| III | witchwood | 5 | 2.8 | 20 | 14 | 20 | 20 | 1/4 | 14, 14, 20, 20 |
| III | castle_sanguis | 4 | 5.3 | 17 | 20 | 20 | 14 | 2/4 | 14, 20, 20, 17 |
| IV | skid_row | 2 | 3.2 -> **3.6** | 20 | 12 | 20 | 20 | 1/4 | 20, 15, 20, 19 |
| IV | fort_kessler | 5 | 3.1 | 14 | 17 | 14 | 20 | 3/4 | 20, 17, 17, 17 |
| IV | liberty_heights | 0 | 2.2 | 11 | 20 | 11 | 11 | 3/4 | 11, 20, 11, 11 |
| V | province | 1 | 2.7 | 13 | 17 | 20 | 11 | 3/4 | 15, 14, 20, 11 |
| V | kurogane | 1 | 2.8 | 15 | 14 | 20 | 20 | 2/4 | 15, 14, 20, 20 |
| V | sun_road | 1 | 4.2 | 17 | 20 | 20 | 20 | 1/4 | 17, 20, 20, 20 |
| VI | barrow_fields | 1 | 2.5 | 18 | 20 | 10 | 19 | 3/4 | 18, 20, 10, 19 |
| VI | valgard | 6 | 1.9 | 10 | 10 | 10 | 10 | 4/4 | 17, 20, 14, 20 |
| VI | vigrid | 2 | 3.2 | 19 | 20 | 20 | 15 | 2/4 | 19, 17, 20, 15 |
| VII | necropolis | 5 | 4.65 -> **4.3** | 14 | 20 | 20 | 17 | 2/4 | 17, 14, 20, 20 |
| VII | lioness_temple | 5 | 2.8 -> **3.0** | 17 | 20 | 20 | 20 | 1/4 | 13, 20, 11, 20 |
| VII | two_truths | 1 | 3.55 | 2 | 15 | 20 | 15 | 3/4 | 15, 20, 20, 17 |
| VIII | ilion | 1 | 2.5 | 12 | 19 | 20 | 20 | 2/4 | 12, 19, 20, 20 |
| VIII | olympus | 3 | 3.6 -> **3.4** | 20 | 20 | 20 | 16 | 1/4 | 20, 14, 20, 5 |
| VIII | underworld | 11 | 2.2 | 20 | 19 | 17 | 20 | 2/4 | 17, 6, 20, 20 |
| IX | burning_gate | 2 | 5.3 | 20 | 17 | 12 | 20 | 2/4 | 20, 17, 12, 20 |
| IX | silk_palace | 3 | 4.0 | 20 | 17 | 16 | 20 | 2/4 | 20, 17, 15, 20 |
| IX | pandemonium | 0 | 3.4 | 20 | 16 | 13 | 20 | 2/4 | 20, 16, 13, 20 |
| X | silver_stair | 3 | 3.0 | 15 | 20 | 19 | 20 | 2/4 | 15, 20, 19, 20 |
| X | wheel_of_thrones | 1 | 3.6 | 8 | 11 | 20 | 9 | 3/4 | 8, 11, 20, 9 |
| X | empyrean | 2 | 3.2 -> **3.0** | 9 | 9 | 17 | 11 | 4/4 | 12, 18, 18, 20 |
| XI | harbour | 6 | 3.8 | 20 | 17 | 20 | 20 | 1/4 | 20, 16, 20, 20 |
| XI | archive | 2 | 5.6 | 15 | 19 | 20 | 20 | 2/4 | 16, 20, 18, 19 |
| XI | spire | 8 | 3.5 | 20 | 12 | 20 | 20 | 1/4 | 17, 17, 20, 20 |
| XII | wastes | 7 | 4.1 | 15 | 20 | 20 | 20 | 1/4 | 20, 20, 17, 20 |
| XII | assembly | 2 | 3.6 | 20 | 18 | 20 | 20 | 1/4 | 20, 18, 20, 20 |
| XII | citadel | 5 | 2.95 | 20 | 11 | 12 | 20 | 2/4 | 20, 8, 12, 20 |
| XIII | crash_site | 0 | 2.65 | 19 | 20 | 18 | 20 | 2/4 | 19, 20, 18, 20 |
| XIII | proving_moon | 1 | 3.0 | 17 | 20 | 17 | 17 | 3/4 | 17, 20, 17, 17 |
| XIII | ark | 1 | 2.2 | 20 | 14 | 15 | 17 | 3/4 | 20, 14, 15, 17 |
| XIV | fern_basin | 3 | 2.8 -> **2.9** | 13 | 20 | 20 | 20 | 1/4 | 20, 20, 17, 20 |
| XIV | great_plain | 3 | 2.5 | 14 | 17 | 20 | 14 | 3/4 | 20, 17, 20, 17 |
| XIV | last_day | 5 | 2.3 | 17 | 12 | 20 | 16 | 3/4 | 11, 15, 20, 20 |
| XV | greenwood | 1 | 2.8 | 20 | 19 | 15 | 17 | 3/4 | 20, 19, 15, 17 |
| XV | fae_court | 5 | 4.2 | 17 | 17 | 20 | 14 | 3/4 | 17, 17, 20, 14 |
| XV | world_tree | 0 | 3.2 | 17 | 12 | 1 | 20 | 3/4 | 17, 12, 1, 20 |


## Wave 2d integration: all 45 maps (Nov 2026; DECISIONS Z1-Z7)

The five Part Three act branches were merged and checked against their own
reports first (identical; Act I's six summaries byte-identical, every Act II-X
map's lives per seed as in the 30-map table below). Then the cliffs were traced
to their causes with the new `--hp-end=X` autotest probe (no file edit) and
fixed with roster data, and every new map re-tuned (DECISIONS Z4):

| Map | Cause found | Change | wave_hp_end |
|---|---|---|---|
| citadel | the Line of Fire feeding itself: ten Line Troopers on the front tower; Valkyrie 2.0 leaked | trooper disable 0.7 -> 0.5 s; Valkyrie 2.0 3400 -> 2800 | 2.65 -> 2.95 (no map lost up to 3.15) |
| archive | Gibbering splits born late, faster than their parent | lesser 38 -> 32, least 46 -> 34 px/s | 5.5 -> 5.6 (no map lost up to 5.9) |
| spire | three-Spawn waves (their grabs empty the posts) | those waves bring two | 3.7 -> 3.5 |
| ark | the Harvester leaked 10 lives in 3 of 4 seeds; Vault Beast swarms leaked every seed | Harvester 10500 -> 8000, Archon 4000 -> 3400, Vault Beast 56 -> 44 px/s | 2.2 (kept) |
| crash_site / proving_moon | the Hive Mother and Vrask'Tal leaked | 11000 -> 9000, 9000 -> 8000 | 2.65 / 3.0 (kept) |
| last_day (and the Titan maps) | skyraider flocks outran the towers | skyraider 64 -> 54 px/s | 2.4 -> 2.3 |
| fern_basin | Scarmaw's leak ended seed 2 at +0.2 | Scarmaw 7000 -> 6200 | 2.8 (kept) |
| world_tree | the Green Mother called a Treant every 15 s (twelve a fight, leaked every seed) | calls every 20 s, the Gardener 4500 -> 4000 | 2.9 -> 3.2 |
| wastes / assembly | easier after the trooper change; the Beta Build leaked | Beta Build 4000 -> 3400 | 3.9 -> 4.1 / 3.35 -> 3.6 |

Bands at +0.2 (seeds 1-4, `--hp-end`): no map lost on the Citadel, Archive,
Spire, Ark, Fern Basin, Great Plain, Last Day, Harbour, Wastes, Fae Court,
Greenwood, Proving Moon and Crash Site; still narrow: the Assembly (3.8 loses 2
of 4: the run starves its economy after an early leak) and the World-Tree (3.4
loses seed 3; seed 3 keeps 1 life at 3.2). The World-Tree loses the second most
lives of the 45 maps (7.5 a run, after the Wheel of Thrones' 8.0) against the
heaviest roster.

### Act towers against their Act I equivalents (Z5)

`--swap=<from>:<to>` against `--swap=<from>:<from>`, seeds 1-2 (lives; damage per soul spent):

| Act tower | vs | Map 1 | Map 2 | Map 3 | Change |
|---|---|---|---|---|---|
| Spawn of the Deep (XI) | Abomination | harbour 20, 16; 18-22 vs 20, 16; 22-28 | archive 11, 20; 4-8 vs 16, 20; 5-9 | spire 20, 19; 20-22 vs 17, 20; 18-23 | none |
| Grave Drone (XII) | Archer | wastes 20, 20; 36-39 vs 20, 20; 27 | assembly 9, 12; 37 vs 20, 13; 31 | citadel 14, 20; 40 vs 20, 8; 34-37 | none |
| Iron Revenant (XII) | Abomination | wastes 20, 2; 58 vs 20, 20; 32-36 | assembly 11, 20; 21-26 vs 20, 13; 11-13 | citadel 17, 20; 9-11 vs 20, 8; 4-7 | none (mixed, not behind) |
| Ghost Saucer (XIII) | Mage | crash_site 20, 20; 34 vs 19, 11; 17-18 | proving_moon 17, 17; 24 vs 17, 20; 18-19 | ark 19, 16; 46-47 vs 11, 19; 28-30 | none |
| Bonehorn (XIV) | Catapult | fern_basin 20, 20; 26 vs 20, 20; 34-35 | great_plain 20, 20; 41-44 vs 20, 17; 32-37 | last_day 20, 5; 14-22 vs 11, 15; 37 | damage 52 -> 58: now 29-30 / 38-41 / 15-16 per soul (last_day 17, 13 lives) |
| Ossuary Oak (XV) | Catapult | greenwood 20, 20; 51 vs 20, 19; 54-63 | fae_court 15, 17; 130-136 vs 17, 17; 88-89 | world_tree 20, 20; 47-53 vs 17, 12; 48-49 | none |

The Bonehorn stays under the Catapult on the Last Day: its spot there sits near
the start of the road it charges back along, so its charge is short.

### Kit orders (seeds 1-2, lives kept; 30/30 won, 0 errors)

| Order | Map 1 | Map 2 | Map 3 |
|---|---|---|---|
| eye_kit | harbour 20, 20 | archive 20, 20 | spire 20, 20 |
| empire_kit | wastes 20, 20 | assembly 20, 20 | citadel 20, 20 |
| concord_kit | crash_site 19, 20 | proving_moon 20, 20 | ark 20, 20 |
| titans_kit | fern_basin 20, 20 | great_plain 20, 20 | last_day 20, 20 |
| year_kit | greenwood 20, 20 | fae_court 20, 20 | world_tree 20, 20 |

(Measured before the final Ark / Crash Site values 2.2 / 2.65, at 2.4 / 2.7: both maps are easier now.)

### Necromancer, default orders, seeds 1-4 (lives kept of 20)

Every run 0 script errors, `stuck_enemies=0`, the summary printed once; the same
seed twice gives the same summary on all 45 maps; every weak order loses.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| I | graveyard | 2.6 | 3014 | 20 | 13 | 20 | 20 | 1/4 | 3/4 | footman 2, inquisitor 1 | lost w7 |
| I | crimson_march | 2.4 | 4503 | 9 | 20 | 20 | 17 | 2/4 | 3/4 | halberdier 3, templar_commander 1 | lost w7 |
| I | sanctum | 3.15 | 4242 | 9 | 20 | 20 | 20 | 1/4 | 3/4 | cathedral_guardian 1, radiant_inquisitor 1, sun_paladin 1 | lost w7 |
| II | cutter | 4.3 | 4026 | 15 | 15 | 20 | 20 | 2/4 | 2/4 | bosun_gorran 2 | lost w4 |
| II | galleon | 2.95 | 3950 | 12 | 17 | 12 | 20 | 3/4 | 2/4 | old_hollow_eye 2, tide_grappler 1, tide_swashbuckler 2 | lost w4 |
| II | maelstrom | 4.0 | 4730 | 20 | 20 | 14 | 11 | 2/4 | 4/4 | tide_hull_crab 5 | lost w7 |
| III | ravensmoor | 4.2 | 4114 | 20 | 20 | 15 | 14 | 2/4 | 3/4 | blood_knight 1, old_greymane 1, werewolf 1 | lost w5 |
| III | witchwood | 2.8 | 3954 | 14 | 14 | 20 | 20 | 2/4 | 4/4 | blood_knight 3, werewolf 1 | lost w3 |
| III | castle_sanguis | 5.3 | 5010 | 14 | 20 | 20 | 17 | 2/4 | 4/4 | vampire_noble 3 | lost w7 |
| IV | skid_row | 3.2 | 3904 | 20 | 15 | 20 | 19 | 2/4 | 3/4 | big_sal 1, street_thug 1 | lost w4 |
| IV | fort_kessler | 3.1 | 4548 | 20 | 17 | 17 | 17 | 3/4 | 4/4 | attack_helicopter 2, city_tank 1 | lost w5 |
| IV | liberty_heights | 2.2 | 4336 | 11 | 20 | 11 | 11 | 3/4 | 4/4 | aurora 2, blitz 3, city_tank 4 | lost w4 |
| V | province | 2.7 | 3875 | 15 | 14 | 20 | 11 | 3/4 | 3/4 | kunoichi 4, ninja 2, samurai 1, shuten_doji 1 | lost w4 |
| V | kurogane | 2.8 | 4808 | 15 | 14 | 20 | 20 | 2/4 | 2/4 | general_left 2, ninja 1 | lost w4 |
| V | sun_road | 4.2 | 5396 | 17 | 20 | 20 | 20 | 1/4 | 4/4 | kunoichi 1 | lost w6 |
| VI | barrow_fields | 2.5 | 3876 | 18 | 20 | 10 | 19 | 3/4 | 3/4 | barrow_wight 1, norse_draugr 3, norse_frost_giant 1, norse_wolf 2 | lost w5 |
| VI | valgard | 1.9 | 4056 | 17 | 20 | 14 | 20 | 2/4 | 4/4 | norse_berserker 3 | lost w5 |
| VI | vigrid | 3.2 | 4079 | 19 | 17 | 20 | 15 | 3/4 | 3/4 | muspel_giant 1, norse_berserker 1, norse_einherjar 1 | lost w5 |
| VII | necropolis | 4.65 | 3910 | 17 | 14 | 20 | 20 | 2/4 | 4/4 | jackal_warrior 3 | lost w6 |
| VII | lioness_temple | 2.8 | 3902 | 13 | 20 | 11 | 20 | 2/4 | 4/4 | bastet_hunter 3, jackal_warrior 2, nile_archer 1 | lost w5 |
| VII | two_truths | 3.55 | 4129 | 15 | 20 | 20 | 17 | 2/4 | 3/4 | devourers_whelp 1, jackal_warrior 1 | lost w8 |
| VIII | ilion | 2.5 | 3828 | 12 | 19 | 20 | 20 | 2/4 | 3/4 | pan_hero 1, polyphemus 1, shade_of_dead 1 | lost w6 |
| VIII | olympus | 3.6 | 3992 | 20 | 14 | 20 | 5 | 2/4 | 4/4 | amazon 3, hoplite 3, pan_hero 3 | lost w6 |
| VIII | underworld | 2.2 | 4436 | 17 | 6 | 20 | 20 | 2/4 | 3/4 | bronze_titan 2, cerberus 1, claimed_shade 1, shade_hoplite 3, tartarus_warden 1, wolf_of_rome 1 | lost w5 |
| IX | burning_gate | 5.3 | 4686 | 20 | 17 | 12 | 20 | 2/4 | 3/4 | damned_soul 3, gatekeeper 1, hell_imp 1, lava_hound 2 | lost w4 |
| IX | silk_palace | 4.0 | 4850 | 20 | 17 | 15 | 20 | 2/4 | 4/4 | hell_imp 2, twin_agrat 2 | lost w5 |
| IX | pandemonium | 3.4 | 4756 | 20 | 16 | 13 | 20 | 2/4 | 4/4 | damned_soul 2, hell_knight 1, lava_hound 2, succubus 2 | lost w5 |
| X | silver_stair | 3.0 | 4548 | 15 | 20 | 19 | 20 | 2/4 | 4/4 | host_judge 1, host_power 3 | lost w7 |
| X | wheel_of_thrones | 3.6 | 4754 | 8 | 11 | 20 | 9 | 3/4 | 3/4 | host_cherub 2, host_dominion 3, host_dominion_of_the_spheres 1, host_ophan 4 | lost w8 |
| X | empyrean | 3.2 | 5016 | 12 | 18 | 18 | 20 | 3/4 | 3/4 | host_power 2, host_seventh_herald 1, host_virtue 5 | lost w4 |
| XI | harbour | 3.8 | 3972 | 20 | 16 | 20 | 20 | 1/4 | 4/4 | eye_chanter 1, eye_deep_kin 1 | lost w5 |
| XI | archive | 5.6 | 3762 | 16 | 20 | 18 | 19 | 3/4 | 4/4 | eye_gibbering_least 3, eye_gibbering_lesser 3, eye_ink_wraith 1 | lost w7 |
| XI | spire | 3.5 | 3876 | 17 | 17 | 20 | 20 | 2/4 | 4/4 | eye_spawn 2 | lost w6 |
| XII | wastes | 4.1 | 3870 | 20 | 20 | 17 | 20 | 1/4 | 4/4 | empire_mortar_walker 1 | lost w7 |
| XII | assembly | 3.6 | 3850 | 20 | 18 | 20 | 20 | 1/4 | 4/4 | empire_line_trooper 2 | lost w8 |
| XII | citadel | 2.95 | 4124 | 20 | 8 | 12 | 20 | 2/4 | 3/4 | empire_juggernaut 3, empire_kill_drone 1, empire_valkyrie_duelist 1, empire_valkyrie_prime 1 | lost w6 |
| XIII | crash_site | 2.65 | 4030 | 19 | 20 | 18 | 20 | 2/4 | 4/4 | concord_broodling 3 | lost w4 |
| XIII | proving_moon | 3.0 | 3769 | 17 | 20 | 17 | 17 | 3/4 | 4/4 | concord_vrask_hunter 3 | lost w4 |
| XIII | ark | 2.2 | 4282 | 20 | 14 | 15 | 17 | 3/4 | 2/4 | concord_grey_overseer 1, concord_luminous_archon 2, concord_vault_beast 1 | lost w4 |
| XIV | fern_basin | 2.8 | 4081 | 20 | 20 | 17 | 20 | 1/4 | 4/4 | prim_razorclaw_alpha 1 | lost w4 |
| XIV | great_plain | 2.5 | 3893 | 20 | 17 | 20 | 17 | 2/4 | 4/4 | prim_horncharger 1, prim_tyrant 1 | lost w5 |
| XIV | last_day | 2.3 | 3980 | 11 | 15 | 20 | 20 | 2/4 | 4/4 | prim_horncharger 1, prim_razorclaw 2, prim_razorclaw_alpha 1, prim_tyrant 2 | lost w4 |
| XV | greenwood | 2.8 | 4396 | 20 | 19 | 15 | 17 | 3/4 | 4/4 | wild_fae_knight 7, wild_hunt_hound 2 | lost w4 |
| XV | fae_court | 4.2 | 4358 | 17 | 17 | 20 | 14 | 3/4 | 3/4 | wild_fae_knight 1, wild_great_stag 2, wild_winter_prince 1 | lost w3 |
| XV | world_tree | 3.2 | 4472 | 17 | 12 | 1 | 20 | 3/4 | 3/4 | wild_dryad 1, wild_fae_knight 2, wild_gardener 1, wild_great_stag 2, wild_hunt_hound 3, wild_sprout 1, wild_treant 2, wild_wild_rider 1, wild_will_o_wisp 1 | lost w4 |

Each map loses lives in 1-3 of 4 runs (97 of 180 runs). Acts I-X are unchanged
from the wave 2c table (identical lives per seed). Within each new act map 3
loses the most lives on average (the Spire's 1.5 against the Archive's 1.75 is
within the noise; the Citadel 5.0, the Ark 3.5, the Last Day 3.5, the World-Tree 7.5).

### Wave 2d checks

- `--reckoning` ends cleanly (the gate falls at Reckoning wave 29-32) and
  `--meta=max` keeps 26/26 lives on the Harbour, Wastes, Crash Site, Fern Basin,
  Greenwood and World-Tree.
- Initiate (seeds 1-2; Spire, Citadel, Ark, Last Day, World-Tree): 10/10 won (16-20 lives).
- Lich (seeds 1-2, same maps, before the final Ark value): 8/10 won (the Ark 11,
  14; the Last Day 5, 3; the Spire 8, 6; the World-Tree 17, 20); the Citadel loses
  both (waves 9 and 15: the Line of Fire with Lich's extra troopers). Not chased.
- The 15 new characters, one run each on their act's maps: 15/15 won with 20 lives, 0 errors.
- `towers_check` / `meta_check` (the chain through the World-Tree, every act
  tower's unlock, v1 -> v2 migration) / `acts_check` pass.

Frame time (`tools/gw_perf.js`, headless software-GL Chromium at 1280 x 720, the
late map at x1, quiet machine): Sanctum 81.8 / 79.8 ms (two passes, mean 80.8).

| Map | ms | x Sanctum | Enemies | Map | ms | x Sanctum | Enemies |
|---|---|---|---|---|---|---|---|
| harbour | 77.5 | 0.96 | 24 | proving_moon | 68.6 | 0.85 | 39 |
| archive | 102.3 | 1.27 | 67 | ark | 67.5 | 0.84 | 20 |
| spire | 86.1 | 1.07 | 43 | fern_basin | 78.8 | 0.98 | 26 |
| wastes | 74.4 | 0.92 | 17 | great_plain | 74.4 | 0.92 | 29 |
| assembly | 72.4 | 0.90 | 36 | last_day | 71.1 | 0.88 | 26 |
| citadel | 72.8 | 0.90 | 23 | greenwood | 72.5 | 0.90 | 13 |
| crash_site | 72.4 | 0.90 | 27 | fae_court | 75.0 | 0.93 | 15 |
| | | | | world_tree | 79.1 | 0.98 | 29 |

Every new map is within the 1.3x budget; the Archive (1.27x, 67 enemies: Gibbering
splits and ink) is the closest; nothing was changed. (The Sanctum measured ~30%
faster than in wave 2c on this machine, so compare ratios, not ms.)

### Bosses without attack-pose art

Every boss now has art for its strike pose (3). Twelve reuse their cast / attack
art (DECISIONS Z9: Seraphine and her Avatar, Abbot Merrow, Kestrel, Deus Ex
Machina, Zeus, Hades, Amaterasu, Seraiel, Scarmaw, Old Gravejaw, the Green
Mother); 28 got a generated strike sprite (DECISIONS Z10: Captain Crow, Admiral
Marrec, Captain Vandermere, Vargr, Isolde Vane, Queen Carmilla, Don Marrow,
General Harrow, Paragon, Kage, Hrimgar, Sigrun, Odin, Fenrir, Anubis, Sekhmet,
Osiris and Ammit, Moloch, Lilith, the Morning Star, the Throne, the Voice,
Vhal'Neth, Vrask'Tal, the Harvester, Old Ironbrow, the Stag King, the Summer
Queen). Still on their form's still when striking: the second forms drawn as
pose 2 (Lilith's demon, the Morning Star's Beast, Harrow's command car).


## Wave 2c integration: all 30 maps (Nov 2026; DECISIONS Y1-Y9)

The five Part Two act branches were merged and checked against their own
reports first (identical). Then one rule each for leaks and full posts, the act
towers measured against their Act I equivalents, the kit orders fixed and every
map re-tuned:

| Rule | Before | After |
|---|---|---|
| Boss leak (Y3) | the map is lost (every boss fight all-or-nothing: Fenrir, Lilith) | 10 lives (`LEAK_LIVES["boss"]`); row `leak_lives` (Fenrir 5) |
| Full post (Y3) | a miniboss walked past a post whose bodies were all full (Polyphemus, Cerberus, the Einherjar Champion, the Herald, the Gatekeeper leaked in ~half the seeds) | a miniboss pushes a lesser enemy out of a body and is held (`BUMPING_RANKS`; bosses not: a held boss emptied the post) |
| Kit orders (Y5) | `tide_kit`, `court_kit`, `norse_kit`, `dynasty_kit`, `inferno_kit`, `host_kit` lost one or two maps | every kit wins its three maps (seeds 1-2) |

Miniboss leaks over seeds 1-4, before -> after: Polyphemus 2 -> 1, Cerberus 2
-> 1, the Gatekeeper 2 -> 1, the Herald of the Seventh Trumpet 2 -> 1, the
Einherjar Champion 2 -> 0. No boss leaks in the table below.

### Act towers against their Act I equivalents (Y4)

`--swap=<from>:<to>` on the act's three maps, seeds 1-2, against `--swap=<from>:<from>`
(the same order with the summary's `tower_value`). Lives kept (L = lost); damage per soul spent.

| Act tower | vs | Before (lives swap / control; dmg per soul) | Change | After |
|---|---|---|---|---|
| Powder Wraith (II) | Catapult | lost 5/6; 20-33 vs 33-72 | damage 40 -> 48, reform 5.5 -> 3.6 s | 42-61 per soul; still loses the Cutter (ground-only: the Cutter's flyers) |
| Blood Spawn (III) | Warrior | 9-20 vs 14-20, mixed | none | - |
| Fallen Hero (IV) | Mage | 20 vs 11-20, 22-48 vs 25-46 | none (a little stronger, the dearer tower) | - |
| Bound Oni (V) | Abomination | 3-17 vs 14-20 | hold 3 -> 4, blow 20 -> 24 | 6-20 (province is its hardest map) |
| Draugr Thane (VI) | Abomination | L-20 vs L-20, mixed | hold 3 -> 4 | 7-20, one loss in 6 |
| Ushabti Sentinel (VII) | Abomination | 7-20 vs 13-20 | cost 120 -> 105 | 6-20 |
| Myrmidon Shades (VIII) | Abomination | 4-19 vs 12-20 | none: weaker per soul than the Abomination, not the reason `pantheon_kit` keeps 20 lives (its order builds more posts) | - |
| Bound Succubus (IX) | Mage | 5-20 vs 16-20; 28-34 vs 25-42 | none | - |
| Archfiend (IX) | Abomination | equal (16-20 both) | none | - |
| Bound Ophan (X) | Catapult | lost 6/6; 25-35 vs 42-84 | damage 28 -> 40, interval 3.0 -> 2.6 s | won 6/6, 60-73 per soul |

### Kit orders (seeds 1-2, lives kept; final data, 48/48 won, 0 errors)

| Order | Map 1 | Map 2 | Map 3 |
|---|---|---|---|
| tide_kit | cutter 20, 20 | galleon 12, 20 | maelstrom 20, 20 |
| court_kit | ravensmoor 20, 20 | witchwood 20, 20 | castle_sanguis 20, 20 (default order + Blood Spawn) |
| shogunate_kit | province 17, 14 | kurogane 20, 20 | sun_road 20, 14 |
| norse_kit | barrow_fields 20, 20 (default + Thane) | valgard 17, 20 | vigrid 20, 20 (default + Thane) |
| dynasty_kit | necropolis 2, 14 | lioness_temple 10, 20 | two_truths 11, 20 |
| pantheon_kit | ilion 20, 20 | olympus 20, 20 | underworld 20, 20 |
| inferno_kit | burning_gate 11, 14 | silk_palace 20, 20 (default + Archfiend) | pandemonium 20, 20 |
| host_kit | silver_stair 20, 20 | wheel_of_thrones 20, 20 | empyrean 20, 20 |

The kits that keep 20 lives play the act's spells and an act tower on top of a
sound order; they are the reward for unlocking the act, not the balance target.

### Necromancer, default orders, seeds 1-4 (lives kept of 20)

Every run 0 script errors, `stuck_enemies=0`, the summary printed once.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| I | graveyard | 2.6 | 3014 | 20 | 13 | 20 | 20 | 1/4 | 3/4 | footman 2, inquisitor 1 | lost w7 |
| I | crimson_march | 2.4 | 4503 | 9 | 20 | 20 | 17 | 2/4 | 3/4 | halberdier 3, templar_commander 1 | lost w7 |
| I | sanctum | 3.15 | 4242 | 9 | 20 | 20 | 20 | 1/4 | 3/4 | cathedral_guardian 1, radiant_inquisitor 1, sun_paladin 1 | lost w7 |
| II | cutter | 4.3 | 4026 | 15 | 15 | 20 | 20 | 2/4 | 2/4 | bosun_gorran 2 | lost w4 |
| II | galleon | 2.95 | 3950 | 12 | 17 | 12 | 20 | 3/4 | 2/4 | old_hollow_eye 2, tide_grappler 1, tide_swashbuckler 2 | lost w4 |
| II | maelstrom | 4.0 | 4730 | 20 | 20 | 14 | 11 | 2/4 | 4/4 | tide_hull_crab 5 | lost w7 |
| III | ravensmoor | 4.2 | 4114 | 20 | 20 | 15 | 14 | 2/4 | 3/4 | blood_knight 1, old_greymane 1, werewolf 1 | lost w5 |
| III | witchwood | 2.8 | 3954 | 14 | 14 | 20 | 20 | 2/4 | 4/4 | blood_knight 3, werewolf 1 | lost w3 |
| III | castle_sanguis | 5.3 | 5010 | 14 | 20 | 20 | 17 | 2/4 | 4/4 | vampire_noble 3 | lost w7 |
| IV | skid_row | 3.2 | 3904 | 20 | 15 | 20 | 19 | 2/4 | 3/4 | big_sal 1, street_thug 1 | lost w4 |
| IV | fort_kessler | 3.1 | 4548 | 20 | 17 | 17 | 17 | 3/4 | 4/4 | attack_helicopter 2, city_tank 1 | lost w5 |
| IV | liberty_heights | 2.2 | 4336 | 11 | 20 | 11 | 11 | 3/4 | 4/4 | aurora 2, blitz 3, city_tank 4 | lost w4 |
| V | province | 2.7 | 3875 | 15 | 14 | 20 | 11 | 3/4 | 3/4 | kunoichi 4, ninja 2, samurai 1, shuten_doji 1 | lost w4 |
| V | kurogane | 2.8 | 4808 | 15 | 14 | 20 | 20 | 2/4 | 2/4 | general_left 2, ninja 1 | lost w4 |
| V | sun_road | 4.2 | 5396 | 17 | 20 | 20 | 20 | 1/4 | 4/4 | kunoichi 1 | lost w6 |
| VI | barrow_fields | 2.5 | 3876 | 18 | 20 | 10 | 19 | 3/4 | 3/4 | barrow_wight 1, norse_draugr 3, norse_frost_giant 1, norse_wolf 2 | lost w5 |
| VI | valgard | 1.9 | 4056 | 17 | 20 | 14 | 20 | 2/4 | 4/4 | norse_berserker 3 | lost w5 |
| VI | vigrid | 3.2 | 4081 | 19 | 17 | 20 | 15 | 3/4 | 3/4 | muspel_giant 1, norse_berserker 1, norse_einherjar 1 | lost w5 |
| VII | necropolis | 4.65 | 3910 | 17 | 14 | 20 | 20 | 2/4 | 4/4 | jackal_warrior 3 | lost w6 |
| VII | lioness_temple | 2.8 | 3902 | 13 | 20 | 11 | 20 | 2/4 | 4/4 | bastet_hunter 3, jackal_warrior 2, nile_archer 1 | lost w5 |
| VII | two_truths | 3.55 | 4129 | 15 | 20 | 20 | 17 | 2/4 | 3/4 | devourers_whelp 1, jackal_warrior 1 | lost w8 |
| VIII | ilion | 2.5 | 3828 | 12 | 19 | 20 | 20 | 2/4 | 3/4 | pan_hero 1, polyphemus 1, shade_of_dead 1 | lost w6 |
| VIII | olympus | 3.6 | 3992 | 20 | 14 | 20 | 5 | 2/4 | 4/4 | amazon 3, hoplite 3, pan_hero 3 | lost w6 |
| VIII | underworld | 2.2 | 4436 | 17 | 6 | 20 | 20 | 2/4 | 3/4 | bronze_titan 2, cerberus 1, claimed_shade 1, shade_hoplite 3, tartarus_warden 1, wolf_of_rome 1 | lost w5 |
| IX | burning_gate | 5.3 | 4686 | 20 | 17 | 12 | 20 | 2/4 | 3/4 | damned_soul 3, gatekeeper 1, hell_imp 1, lava_hound 2 | lost w4 |
| IX | silk_palace | 4.0 | 4850 | 20 | 17 | 15 | 20 | 2/4 | 4/4 | hell_imp 2, twin_agrat 2 | lost w5 |
| IX | pandemonium | 3.4 | 4756 | 20 | 16 | 13 | 20 | 2/4 | 4/4 | damned_soul 2, hell_knight 1, lava_hound 2, succubus 2 | lost w5 |
| X | silver_stair | 3.0 | 4548 | 15 | 20 | 19 | 20 | 2/4 | 4/4 | host_judge 1, host_power 3 | lost w7 |
| X | wheel_of_thrones | 3.6 | 4754 | 8 | 11 | 20 | 9 | 3/4 | 3/4 | host_cherub 2, host_dominion 3, host_dominion_of_the_spheres 1, host_ophan 4 | lost w8 |
| X | empyrean | 3.2 | 5016 | 12 | 18 | 18 | 20 | 3/4 | 3/4 | host_power 2, host_seventh_herald 1, host_virtue 5 | lost w4 |

Every default order wins on every seed; every weak order loses. Each map loses
lives in 1-3 of 4 runs (31 of 60 runs in Part One, 31 of 60 in Part Two). Part
Two's step up is in what the towers face (its rows' HP, armour, second lives
and the act rules), with the same loss pattern as Part One (the brief: "a step
above the Road to the Sun in enemy HP, with the same loss pattern").

Cliffs: Vigrid's came from three fire giants stomping at once on waves 11-12
(DECISIONS Y6); after the fix its band is still narrow (3.1: 0/8 losses; 3.2:
1/8 lost runs; 3.4: 7/8 lost): the Norse late waves are elite-heavy (3 lives
each), so a fallen post cascades. The Hall of Two Truths' Scales no longer feed
themselves (Dynasty side HP x1.08, rise x0.85). The Burning Gate's Gatekeeper is
held now (pushed into a full post) and died in 3 of 4 seeds. Within each act map
3 is not easier than map 1 on average lives lost except Act VI (Barrow Fields
3.25, Vigrid 2.25 per run: Vigrid sits at the top of its narrow band).

### Wave 2c checks

- Same seed twice: identical summaries on all 30 maps (seed 1). Speed 3 and
  speed 8 give the same summary (Sanctum, Cutter, Ravensmoor, Skid Row,
  Province, Barrow Fields, Necropolis, Ilion, Burning Gate, Silver Stair).
- `--reckoning` ends cleanly on those ten maps (gate falls at Reckoning wave
  6-8); `--meta=max` keeps 26/26 lives on all ten.
- Initiate (seeds 1-2; Graveyard, Cutter, Castle Sanguis, Liberty Heights, Road
  to the Sun, Vigrid, Hall of Two Truths, Underworld, Pandemonium, Empyrean):
  20/20 won with 20 lives.
- Lich (seeds 1-2, after `hp_mult` 1.15 -> 1.1, DECISIONS Y6): Graveyard 2/2,
  Cutter 2/2, Castle Sanguis 2/2, Liberty Heights 2/2, Road to the Sun 2/2,
  Barrow Fields 1/2, Hall of Two Truths 2/2, Underworld 2/2 (2, 9 lives),
  Pandemonium 1/2, Silver Stair 2/2; Vigrid 0/2 and the Empyrean 0/2 (the two
  Part Two finales stay out of reach on Lich for the default orders). At 1.15
  Lich won 6 of 20; Lich's extra enemies (count x1.1) pay souls, so lowering the
  count made it harder, not easier.
- The 15 new characters, one run each on their act's maps: 14 won (the
  Pharaoh's Shade with 3 lives on the Hall), the Unveiled lost the Empyrean
  (seed 1, wave 12: the default order without its Corpse Explosion); 0 errors.
- `WEAK=1 tools/run_all_maps.sh`: 60/60 (every default won, every weak order lost, 0 errors, 0 stuck);
  `towers_check` / `meta_check` (the unlock chain through the Empyrean, every
  act tower's unlock, v1 -> v2 migration) / `acts_check` pass.

Frame time (`tools/gw_perf.js`, headless software-GL Chromium at 1280 x 720, the
late map at x1, quiet machine; DECISIONS Y7): Sanctum 108.8 / 114.4 ms (two
passes, mean 111.6); Graveyard 91.8, Crimson March 109.4.

| Map | ms | x Sanctum | Enemies | Map | ms | x Sanctum | Enemies |
|---|---|---|---|---|---|---|---|
| barrow_fields | 118.9 | 1.07 | 30 | olympus | 94.0 | 0.84 | 21 |
| valgard | 109.7 | 0.98 | 20 | underworld | 100.9 | 0.90 | 23 |
| vigrid | 124.8 | 1.12 | 44 | burning_gate | 96.5 | 0.86 | 5 |
| necropolis | 101.3 | 0.91 | 35 | silk_palace | 102.0 | 0.91 | 41 |
| lioness_temple | 98.6 | 0.88 | 17 | pandemonium | 104.4 | 0.94 | 15 |
| two_truths | 113.3 | 1.02 | 92 | silver_stair | 116.0 | 1.04 | 23 |
| ilion | 96.3 | 0.86 | 38 | wheel_of_thrones | 112.0 | 1.00 | 42 |
| | | | | empyrean | 117.2 | 1.05 | 18 |

Every Part Two map is within 1.12x the Sanctum (the 1.3x budget); the Norse
maps (the Winter layer) and the Host's (the Light's shafts) cost the most per
enemy, both already cached textures drawn in pieces, so nothing was changed.
Web build: `index.pck` 17.3 MB, `index.wasm` 35.4 MB (the engine), `index.js`
0.33 MB; the pck is under 25 MB (nothing trimmed; the nine
`generation_ledger.*.translation` files are no longer packed, `docs/.gdignore`).

### Bosses without attack-pose art

Strike poses (pose 3) were generated for 28 bosses in the boss-poses pass (DECISIONS Z10): Captain
Crow, Admiral Marrec, Captain Vandermere, Vargr, Isolde Vane, Queen Carmilla, Don Marrow, General Harrow,
Paragon, Kage, Hrimgar, Sigrun, Odin, Fenrir, Anubis, Sekhmet, Osiris (and Ammit's sprite), Moloch, Lilith,
the Morning Star, the Throne, the Voice, Vhal'Neth, Vrask'Tal, the Harvester, Old Ironbrow, the Stag King,
the Summer Queen. Still without a strike pose (their strike shows the still): Seraphine (cast pose only),
Amaterasu, Zeus, Hades, Seraiel, Kestrel, Deus Ex Machina, Scarmaw, Old Gravejaw, the Green Mother, Abbot
Merrow (his changed form has one), and the second forms drawn as pose 2 (Lilith's demon, the Morning Star's
Beast, Harrow's command car, Carmilla / the Elder's forms, the Throne's core, the Voice's unveiled form).


## Wave 2d: Act XIV, the Age of Titans (w2d-titans, DECISIONS T14)

Necromancer, default orders, seeds 1-4 (lives kept of 20; 0 script errors,
`stuck_enemies=0` in every run). Income from `tools/map_list.tscn`. Measured on
a shared 4-core machine (frame times not measured here; the integration
re-measures them).

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| XIV | fern_basin | 2.8 | 4081 | 20 | 10 | 17 | 4 | 3/4 | 4/4 | prim_scarmaw 2, prim_tyrant 2, prim_skyraider 2, prim_razorclaw 1 | lost w4 |
| XIV | great_plain | 2.5 | 3893 | 20 | 14 | 14 | 20 | 2/4 | 4/4 | prim_clubtail 2, prim_horncharger 2 | lost w5 |
| XIV | last_day | 2.4 | 3980 | 14 | 9 | 11 | 11 | 4/4 | 4/4 | prim_skyraider 9, prim_tyrant 3, prim_horncharger 3, prim_razorclaw_alpha 2, prim_razorclaw 2 | lost w4 |

Cliff checks (`wave_hp_end` +0.2, seeds 1-2): the Fern Basin at 3.0 won 19 / 17,
the Great Plain at 2.6 won 11 / 17 (measured before the last herd nerf, T14.7). Before the boss kits were reworked the Fern
Basin was a cliff (2.6 won 4/4, 2.9 lost 4/4: Ironjaw and Scarmaw leaks cascaded);
Ironjaw now 3600 HP at speed 22 with her nest in the towers' reach, Scarmaw 7000.
The step up from Part Two is in the kit, not the raw HP (Part Two's ends are
3.0-3.6): herds that disable plots, charges and swallows that empty posts, the
tower stuns of roars / gusts / sweeps, hidden crocs, meteors.

`titans_kit` (the default with the first Corpse Catapult a Bonehorn raised to
the Fossil Tyrant, the Abomination on the post beside it, Meteor Call and
Stampede): fern_basin 20, 20; great_plain 20, 20; last_day 20, 20 (seeds 1-2),
evolution and Thundering Herd in the summary.

Act tower (`--swap=corpse_catapult:bonehorn` against `--swap=corpse_catapult:corpse_catapult`,
seeds 1-2; lives, damage per soul):

| Map | Bonehorn | Catapult (control) |
|---|---|---|
| fern_basin | 20, 20; 28.1-29.4 | 20, 20; 27.7-30.8 |
| great_plain | 20, 20; 42.6-44.3 | 20, 14; 34.1-34.9 |
| last_day | 17, 17; 18.0-19.9 | 14, 9; 37.3-39.7 |

First pass (damage 38, interval 2.6): 13.8-39.6 per soul, the Fern Basin lost 10
lives; damage 52, interval 2.3, width 30 now. On the Last Day its spot (the
Catapult's, by the gate) leaves a short road to charge down, so its damage per
soul is half the Catapult's while it keeps more lives (its knockback).


## Wave 2c: Act IX, the Inferno (w2c-inferno, DECISIONS T9)

Necromancer, default orders, seeds 1-4 (lives kept of 20; 0 script errors,
`stuck_enemies=0` in every run). Income from `tools/map_list.tscn`. Measured on
a shared 4-core machine (frame times not measured here; the integration
re-measures them).

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak |
|---|---|---|---|---|---|---|---|---|---|---|---|
| IX | burning_gate | 5.3 | 4686 | 20 | 12 | 11 | 20 | 2/4 | 2/4 | damned_soul 6, gatekeeper 2, hell_imp 1 | lost w4 |
| IX | silk_palace | 4.0 | 4850 | 14 | 20 | 20 | 20 | 1/4 | 4/4 | succubus 1, twin_agrat 1 | lost w5 |
| IX | pandemonium | 3.4 | 4756 | 20 | 16 | 13 | 20 | 2/4 | 4/4 | damned_soul 2, hell_knight 1, lava_hound 2, succubus 2 | lost w5 |

The `wave_hp_end` values do not rise through the act because the rosters do:
the Palace adds succubi (body charms) and Lilim pits, Pandemonium adds diving
Fallen Angels, the Seraph General and four portals; the Burning Gate's two
roads meet under most of its plots, so it needs the steepest ramp. The
binaries to watch: a boss that reaches the gate costs every life (Lilith at
13000 / 11500 / 10000 HP lost 2 of 4 seeds; 9000 loses none), and the
Gatekeeper is never held long enough above ~5.5 (he then walks on every seed).
`inferno_kit` (Archfiends on the posts, the Bound Succubus and its Lilim
Matriarch, Brimstone / Corpse Explosion / Fall from Grace) wins the Burning
Gate (11) and Pandemonium (20) and loses the Palace at wave 18, like
`tide_kit` / `court_kit` on their acts.

## Wave 2b integration: all 15 maps (Nov 2026; DECISIONS X1-X9)

The four act branches measured their maps against different incomes and had
cut miniboss HP hard because a slow miniboss trailed the column on "first"
targeting and walked to the gate. The integration unified three rules, then
re-tuned every map with `wave_hp_end` only (plus miniboss row HP):

| Rule | Before | After |
|---|---|---|
| Income (X2) | start 250-450, fodder 3 (Act V 5-10), map totals 3330-5310 | from Act II on fodder kinds pay 5 (row `souls`; Act V tiers 6-10), start 300; `map_list` prints and checks `INCOME` (3700-5600) |
| Miniboss HP (X3) | row HP x the wave ramp (x1.5-2.1) | row HP is the real HP (no ramp), 3200-5800 |
| "First" targeting (X3) | progress only | + 260 px for a miniboss / boss in range |
| Held miniboss blows on bodies (X3) | x2.0 | x2.0 x 0.6 |
| Evolve steps (X4) | an unmet recipe blocked the rest of the order | deferred and retried every tick |

Miniboss row HP (before -> after; "before" was ramped in play): Inquisitor 2700
-> 3200, Templar Commander 1500 -> 2600, Cathedral Guardian 3000 -> 4000, Bosun
Gorran 2300 -> 4200, Old Hollow-Eye 1450 -> 4600, Ghost Bosun 1800 -> 5000, Old
Greymane 2100 -> 3400, Bog Mother 2000 -> 4000, Chiropteran King 2200 -> 5200,
Big Sal 2200 -> 4600, Mammoth 3400 -> 3600 (never held: a vehicle), Atlas 3200
-> 5400, Shuten-doji 2600 -> 5000, General of the Left 1500 -> 3200 (charges
through posts), the Kirin 2500 -> 5800. Map `wave_hp_end` before -> after:
Sanctum 3.0 -> 3.15, Cutter 2.72 -> 4.3, Galleon 2.7 -> 2.95, Maelstrom 3.2 ->
4.0, Ravensmoor 2.75 -> 4.2, Witchwood 2.2 -> 2.8, Castle Sanguis 3.35 -> 5.3,
Skid Row 3.0 -> 3.2, Fort Kessler 2.75 -> 3.1, Province 2.35 -> 2.7, Kurogane
2.5 -> 2.8, Road to the Sun 3.6 -> 4.2 (Graveyard, Crimson March, Liberty
Heights unchanged). Other data: Ravensmoor's fourth coffin moved from beside
the gate (1120, 520) to (680, 640) (its Vampire Noble leaked 3 lives on every
seed); Liberty Heights' boss wave no longer brings a second Atlas (a second
miniboss paid a second chest; a tank instead).

Necromancer, default orders, seeds 1-4 (lives kept of 20; every run 0 script
errors, `stuck_enemies=0`; Income = `MapLoader.income()`):

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| I | graveyard | 2.6 | 3014 | 20 | 4 | 20 | 20 | 1/4 | 4/4 | archer 1, chaplain 3, footman 6 | lost w7 |
| I | crimson_march | 2.4 | 4503 | 9 | 20 | 20 | 17 | 2/4 | 3/4 | halberdier 3, templar_commander 1 | lost w7 |
| I | sanctum | 3.15 | 4242 | 3 | 20 | 12 | 20 | 2/4 | 2/4 | cathedral_guardian 2, radiant_inquisitor 3, sanctified_sentinel 1, sun_paladin 1 | lost w7 |
| II | cutter | 4.3 | 4026 | 15 | 3 | 20 | 20 | 2/4 | 2/4 | bosun_gorran 2, tide_boarding_bruiser 2, tide_grappler 1, tide_swashbuckler 1 | lost w4 |
| II | galleon | 2.95 | 3950 | 12 | 20 | 12 | 20 | 2/4 | 2/4 | old_hollow_eye 2, tide_grappler 1, tide_swashbuckler 1 | lost w4 |
| II | maelstrom | 4.0 | 4730 | 20 | 20 | 17 | 11 | 2/4 | 4/4 | tide_hull_crab 4 | lost w7 |
| III | ravensmoor | 4.2 | 4114 | 20 | 20 | 20 | 14 | 1/4 | 4/4 | blood_knight 1, werewolf 1 | lost w5 |
| III | witchwood | 2.8 | 3954 | 14 | 14 | 20 | 20 | 2/4 | 4/4 | blood_knight 3, werewolf 1 | lost w3 |
| III | castle_sanguis | 5.3 | 5010 | 14 | 20 | 20 | 17 | 2/4 | 4/4 | vampire_noble 3 | lost w7 |
| IV | skid_row | 3.2 | 3904 | 20 | 15 | 20 | 19 | 2/4 | 3/4 | big_sal 1, street_thug 1 | lost w4 |
| IV | fort_kessler | 3.1 | 4548 | 20 | 17 | 17 | 17 | 3/4 | 4/4 | attack_helicopter 2, city_tank 1 | lost w5 |
| IV | liberty_heights | 2.2 | 4336 | 11 | 20 | 8 | 11 | 3/4 | 4/4 | aurora 3, blitz 3, city_tank 4 | lost w4 |
| V | province | 2.7 | 3875 | 15 | 14 | 20 | 11 | 3/4 | 3/4 | kunoichi 4, ninja 2, samurai 1, shuten_doji 1 | lost w4 |
| V | kurogane | 2.8 | 4808 | 15 | 14 | 20 | 20 | 2/4 | 2/4 | general_left 2, ninja 1 | lost w4 |
| V | sun_road | 4.2 | 5396 | 17 | 20 | 20 | 15 | 2/4 | 3/4 | kirin 1, kunoichi 1 | lost w6 |


Every default order wins on every seed; every weak order loses. Each map loses
lives in 1-3 of 4 runs and no map loses the same lives to one scripted unit on
every seed (the old Gorran / coffin noble / Kirin walk-throughs are gone: the
minibosses die mid-map in 2-4 of 4 runs). The difficulty is a band rather than
a ramp in lives (2-5 lives lost per map on average); the rise from Act I to V
is in what the towers face (wave HP end 2.2-2.8 on the map-1/2 orders that
build fewer towers, 4-5.3 on the act finales with the long roads). Known: no
cliff (`leak_curve` per_death 0.0-0.16; Castle Sanguis falls off at 5.6).

Spot checks: Initiate (seeds 1-2, all 15 maps) 30/30 won with 20 lives. Lich
(seeds 1-2): Graveyard 1/2, Cutter 0/2, Maelstrom 1/2, Ravensmoor 0/2, Castle
Sanguis 2/2, Skid Row 1/2, Liberty Heights 2/2 (5, 14), Province 2/2, Road to the
Sun 2/2 (12, 9). `--meta=max` 26/26 lives on one map per act; `--reckoning` ends
cleanly on one map per act; speed 3 and speed 8 give the same summary (one map
per act); the same seed twice is identical on all 15 maps. Kit orders:
`tide_kit` loses the Cutter and `court_kit` loses Castle Sanguis now that those
maps press harder (both win the other two maps; `shogunate_kit` wins all three).

Frame time (DECISIONS X5, `tools/gw_perf.js`, headless software-GL Chromium,
late map at x1): Sanctum ~101 ms; every other map 81-122 ms, the worst Castle
Sanguis at 1.21x (78 enemies), Road to the Sun 1.12x, Maelstrom 1.10x.

Act I before (wave 2a baselines) / after (seeds 1-2 lives): Graveyard 20, 15 ->
20, 4; Crimson March 9, 20 -> 9, 20; Sanctum 17, 15 -> 3, 20. The new baselines
are below.

## Blocker HP fix and Act I rebalance (wave 2a integration, Nov 2026; DECISIONS W1-W3)

Until wave 2a every new blocker body (each Warrior / Abomination / Golem body
built or added by a level up) started at body_hp squared: 2500 HP instead of
50, 40000 instead of 200 (DECISIONS K15). The first bodies of a post were
near-immortal and held minibosses and bosses until the towers killed them;
a body that had died once came back at its true 50 HP and fell again in
seconds. The owner saw exactly that ("blockers never died; once they died they
were lost quickly"). The older tables below were measured with that bug, so
every number in them leaned on it.

The fix (`blocker.gd` sets max_hp before the health share) and the data that
make a blocker's fall a normal, recoverable event instead:

| Lever | Before | After |
|---|---|---|
| `TdRulesData.BLOCKER_HIT_MULT` (held enemies' hits on bodies) | 4.0 | 2.0 |
| Warrior body_hp / respawn | 50 / 8 s | 90 / 6 s |
| Abomination body_hp / respawn | 200 / 12 s | 350 / 10 s |
| Bone Golem body_hp / respawn | 300 / 14 s | 500 / 12 s |
| Miniboss HP / damage: Inquisitor | 3000 / 30 | 2700 / 20 |
| Templar Commander | 4200 / 32 | 1500 / 20 |
| Cathedral Guardian (slam) | 5600 / 30 (60) | 3000 / 12 (25) |
| Boss HP / damage: Alaric | 9000 / 45 | 8200 / 30 |
| Marshal Vael | 12000 / 45 | 8000 / 30 |
| Seraphine | 16000 / 40 | 13000 / 28 |
| Lich HP multiplier | 1.1 | 1.15 |

Why: minibosses and bosses had been tuned to be held for as long as the towers
needed by a body that could not die. With true HP they are held about 10-20 s
per map (posts fall and come back) and the towers must finish them, so their
HP came down to what the default orders' towers deal in that window (the
Templar Commander is held least: its road has one post early; the miniboss HP
also gets the wave HP ramp, x1.5-1.9). Their blows on bodies came down with the
global hit multiplier so a post stalls them for a few seconds instead of
folding at once. Lich went up because without the bug the old Lich was no
harder than Necromancer on the Sanctum (4/4 wins).

Before / after (`--autotest`, Necromancer seeds 1-8, others 1-2 or 1-4).
Columns: wins; lives kept in the wins; runs that lost any life; permanent
bodies lost per map; lives lost per body death; runs lost within two waves of
their first leak (the cliff; weak orders are meant to fall off it).

Before (bug present):

| Map | Difficulty | Order | Wins | Lives kept | Runs leaking | Bodies lost | Lives / death | Cliff losses |
|---|---|---|---|---|---|---|---|---|
| crimson_march | initiate | default | 2/2 | 20-20 | 0/2 | 49-50 | 0.000 | 0 |
| crimson_march | lich | default | 3/4 | 2-3 | 4/4 | 58-145 | 0.157 | 0 |
| crimson_march | necromancer | default | 8/8 | 14-20 | 3/8 | 97-112 | 0.020 | 0 |
| crimson_march | necromancer | kit_a | 2/2 | 19-20 | 1/2 | 84-91 | 0.006 | 0 |
| crimson_march | necromancer | kit_b | 2/2 | 17-20 | 1/2 | 91-92 | 0.016 | 0 |
| crimson_march | necromancer | march_weak | 0/2 | - | 2/2 | 0-0 | - | 1 |
| graveyard | initiate | default | 2/2 | 20-20 | 0/2 | 16-23 | 0.000 | 0 |
| graveyard | lich | default | 4/4 | 9-20 | 1/4 | 58-65 | 0.044 | 0 |
| graveyard | necromancer | default | 8/8 | 20-20 | 0/8 | 46-59 | 0.000 | 0 |
| graveyard | necromancer | kit_a | 2/2 | 20-20 | 0/2 | 39-44 | 0.000 | 0 |
| graveyard | necromancer | kit_b | 2/2 | 20-20 | 0/2 | 35-49 | 0.000 | 0 |
| graveyard | necromancer | weak | 0/2 | - | 2/2 | 0-0 | - | 2 |
| sanctum | initiate | default | 2/2 | 20-20 | 0/2 | 53-54 | 0.000 | 0 |
| sanctum | lich | default | 1/4 | 11-11 | 4/4 | 62-102 | 0.238 | 3 |
| sanctum | necromancer | default | 8/8 | 5-20 | 4/8 | 78-92 | 0.057 | 0 |
| sanctum | necromancer | kit_a | 2/2 | 20-20 | 0/2 | 72-73 | 0.000 | 0 |
| sanctum | necromancer | kit_b | 0/2 | - | 2/2 | 45-47 | 0.435 | 2 |
| sanctum | necromancer | sanctum_weak | 0/2 | - | 2/2 | 0-0 | - | 2 |

After (fix + data above):

| Map | Difficulty | Order | Wins | Lives kept | Runs leaking | Bodies lost | Lives / death | Cliff losses |
|---|---|---|---|---|---|---|---|---|
| crimson_march | initiate | default | 2/2 | 20-20 | 0/2 | 49-56 | 0.000 | 0 |
| crimson_march | lich | default | 1/4 | 7-7 | 4/4 | 41-153 | 0.169 | 1 |
| crimson_march | necromancer | default | 8/8 | 9-20 | 4/8 | 89-117 | 0.045 | 0 |
| crimson_march | necromancer | kit_a | 2/2 | 15-20 | 1/2 | 83-95 | 0.028 | 0 |
| crimson_march | necromancer | kit_b | 2/2 | 20-20 | 0/2 | 79-84 | 0.000 | 0 |
| crimson_march | necromancer | march_weak | 0/2 | - | 2/2 | 0-0 | - | 1 |
| graveyard | initiate | default | 2/2 | 20-20 | 0/2 | 27-31 | 0.000 | 0 |
| graveyard | lich | default | 1/4 | 15-15 | 4/4 | 73-89 | 0.202 | 0 |
| graveyard | necromancer | default | 8/8 | 5-20 | 4/8 | 48-64 | 0.080 | 0 |
| graveyard | necromancer | kit_a | 2/2 | 20-20 | 0/2 | 42-44 | 0.000 | 0 |
| graveyard | necromancer | kit_b | 2/2 | 20-20 | 0/2 | 45-47 | 0.000 | 0 |
| graveyard | necromancer | weak | 0/2 | - | 2/2 | 0-0 | - | 2 |
| sanctum | initiate | default | 2/2 | 20-20 | 0/2 | 35-35 | 0.000 | 0 |
| sanctum | lich | default | 1/4 | 3-3 | 4/4 | 43-113 | 0.274 | 0 |
| sanctum | necromancer | default | 8/8 | 15-20 | 4/8 | 71-88 | 0.028 | 0 |
| sanctum | necromancer | kit_a | 2/2 | 20-20 | 0/2 | 61-68 | 0.000 | 0 |
| sanctum | necromancer | kit_b | 2/2 | 20-20 | 0/2 | 57-59 | 0.000 | 0 |
| sanctum | necromancer | sanctum_weak | 0/2 | - | 2/2 | 0-0 | - | 2 |

Reading it: default orders win all three maps on all 8 seeds; each map loses
some lives in half the runs (a miniboss leak is 5 lives, recoverable); weak
orders still lose by wave 7; Initiate keeps every life; Lich wins 1 run in 4 on
every map (hard) and its losses run down over 4-7 waves instead of the old
cliff (Sanctum Lich: 3 cliff losses before, 0 after); kit_a and kit_b win
everywhere (kit_b lost the Sanctum before). A body death costs 0.03-0.08 lives
on Necromancer (0.17-0.27 on Lich): one fall is a handful of leaks at most.
Bodies fall 30-120 times a map (every post several times; back in 6-12 s), the
churn the Mender, Dread Rally and Sovereign's Decree answer.

The autotest's `leak_curve=` line (first leak wave, end wave, lives lost,
permanent body deaths, lives lost within 15 s of a death, per death) reports
this on every run.

## Wave 2d: Act XI, the Ancient Eye (w2d-eye; DECISIONS T11)

Necromancer, default orders, seeds 1-4 (lives kept of 20); 0 script errors,
`stuck_enemies=0`, same seed twice identical (Harbour seed 1).

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 / s2 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| XI | harbour | 3.8 | 3972 | 20 | 16 | 20 | 20 | 1/4 | 4/4 | eye_chanter 1, eye_deep_kin 1 | lost w5 / w5 |
| XI | archive | 5.5 | 3762 | 20 | 20 | 13 | 16 | 2/4 | 4/4 | eye_chanter 1, eye_gibbering_mass 1, eye_spore_pilgrim 1, eye_gibbering_least 3, eye_gibbering_lesser 1 | lost w7 / w7 |
| XI | spire | 3.7 | 3912 | 11 | 17 | 12 | 14 | 4/4 | 4/4 | eye_spawn 8, eye_deep_kin 2 | lost w6 / w6 |

Cliff checks (+0.2): the Harbour at 4.0 kept 12 / 19 / 12 / 20 (the Harbourmaster
at 4400 HP, speed 22, killed 4/4); the Archive at 5.7 kept 9 / 19 / 13 / 14 (6.0:
15 / 1, the split masses' late waves: the band ends there); Ul-Thalos at 3.8
kept 14 / 14 / lost (wave 13) / 20: its early economy is the thin spot (a slow
first ten waves; an early Spawn leak costs 3). Ul-Thalos at 3.6 kept 17 / 20 /
20 / 16. The archive's road is 3449 px (the others ~1900-2760), hence its higher
`wave_hp_end`.

`--swap=abomination:spawn_of_the_deep` against `--swap=abomination:abomination`
(seeds 1-2, lives / damage per soul): Harbour 13 / 21.7 vs 12 / 28.5 and 19 /
21.7 vs 19 / 24.5; Archive 20 / 1.8 vs 20 / 1.8 and 17 / 3.5 vs 20 / 3.1 (its
post sits by the gate, little reaches it); Ul-Thalos 20 / 21.8 vs 17 / 25.1 and
15 / 21.1 vs 10 / 23.9 (measured at `wave_hp_end` 4.0 / 5.5 / 3.4). The Spawn
holds as well as the Abomination per soul; its damage goes into freezes.

Kit order `eye_kit` (seeds 1-2): harbour 20, 20 (Leviathan both); archive 20,
20; spire 20, 20 (default + Spawn of the Deep). Characters (seed 1): the Brine
Widow on the Harbour 20, the Heretic Scribe on the Archive 20, the Tide Widow on
Ul-Thalos 20 (measured before the final Harbour / Ul-Thalos HP).
## Act XII, the Electronic Empire (wave 2d, w2d-empire; DECISIONS T12)

Necromancer, default orders, seeds 1-4 (lives kept of 20); 0 script errors,
`stuck_enemies=0`, the same seed twice identical (Wastes s1), Act I baselines
byte-identical.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| XII | wastes | 3.9 | 3870 | 17 | 20 | 15 | 20 | 2/4 | 3/4 | empire_mortar_walker 1, empire_trojan_horse 1 | lost w1 |
| XII | assembly | 3.35 | 3850 | 12 | 20 | 20 | 11 | 2/4 | 2/4 | empire_beta_build 2, empire_mortar_walker 1, empire_aegis_bot 1, empire_juggernaut 1 | lost w1 |
| XII | citadel | 2.65 | 4124 | 20 | 20 | 14 | 9 | 2/4 | 3/4 | empire_valkyrie_duelist 2, empire_spotter 1, empire_kill_drone 1, empire_valkyrie_prime 1 | lost w2 |

Cliff check at `wave_hp_end` +0.2 (final data, seeds 1-4): the Wastes at 4.1
lose one seed (s1; 15 / 20 / 20 on the others), the Assembly at 3.55 wins all
four (15, 20, 9, 9), the Citadel at 2.85 loses two (20, 15, lost, lost): the
finale's band is the narrowest (two columns, Valkyrie 2.0 and Deus Ex Machina's
10-life leak stack up), like Vigrid's in Part Two.
Raw HP sits below the Empyrean on the finale: the Line of Fire's disables
(~10-20 % tower downtime, `hostile=` / `act_rule=` lines; 29-37 % of the shots
that land are stopped by bodies), the two columns, the jams, Valkyrie 2.0 and
Deus Ex Machina are the step up (T12.7).

### Act towers (Y4 swap, seeds 1-2, lives kept; damage per soul from `tower_value`)

| Swap | wastes | assembly | citadel |
|---|---|---|---|
| archer:archer (control) | 17, 20; 24-26 | 12, 20; 30 | 20, 20; 31-35 |
| archer:grave_drone | 20, 17; 32-33 | 20, 6; 33 | 20, 12; 41-44 |
| abomination:abomination (control) | 17, 20; 34-37 | 12, 20; 5-9 | 20, 20; 2-4 |
| abomination:iron_revenant (first pass: hold 3, one target) | 0, 1 | 12, 20 | 15, 12 |
| abomination:iron_revenant (final: hold 4, all held) | 12, 20; 59 | 20, 20; 13-22 | 15, 12; 5-10 |

The Grave Drone (60 souls) deals the Archer's damage per soul or better; the
Iron Revenant now holds like the Abomination with its shells on top (the Citadel
post:5 sits by the gate, where neither tower sees much). `empire_kit` (seeds 1)
wins all three maps (20 / 20 each): the Deus Revenant on the Wastes, the Wraith
Drone on the Assembly and the Citadel; Death Ray and Scrap Swarm cast (Hollow
Puppet loses the third slot to the Gravecaller's Shadow Bolt, as every kit's
third spell does; `--character=marionette --build=empire_kit` casts all three).

### Act I baseline summaries (the same-seed gate; re-recorded by the road-shape redraw, DECISIONS L4)

Default build, Necromancer, `--autotest --map=<id> --seed=<n>`; the lines from
`TDAUTOTEST SUMMARY`. A change that must not touch Act I reproduces these byte
for byte. The road-shape redraw changed them on purpose (new roads, spots, wave_hp_end and the
Sanctum's chambers, DECISIONS L1-L4); the wave 2c set is in git history.

```
TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=1 build=graveyard_default speed=8
result=won skulls=3 time=480.52s ticks=28831
waves_cleared=22/22 reached=22 lives=20/20
souls_now=122 earned=2864 spent=2892 earned_by=kills:2138,no_leak:726
kills=alaric:1,archer:64,chaplain:28,footman:130,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=
damage_by_source=abomination:148,archer:27131,corpse_catapult:35911,corpse_explosion:5623,frost_wraith:3000,mage:3387,shadow_bolt:7979,warrior:5948
towers=plot:4:archer/gravebow:lv5:k71:d17715,post:0:warrior:lv2:k33:d4338,plot:5:archer:lv5:k41:d7040,plot:3:mage:lv5:k29:d3387,post:1:warrior:lv1:k23:d1610,plot:8:frost_wraith:lv3:k13:d3000,plot:10:corpse_catapult:lv4:k136:d35911,post:2:abomination:lv2:k1:d148,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k9:d2377,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=35/45 chests=1 free_upgrades_left=0
blocker_damage_taken=9730 bodies_lost=63 spells=bone_wall:8,corpse_explosion:32,dread_rally:7,shadow_bolt:120
wave_spawn/clear_s=w1:9.5/16.8 w2:11.9/26.7 w3:10.2/34.7 w4:10.8/53.1 w5:11.3/46.9 w6:11.0/77.1 w7:15.4/61.1 w8:13.8/62.1 w9:12.7/44.1 w10:14.1/65.9 w11:14.9/98.2 w12:10.2/75.3 w13:16.0/62.2 w14:12.4/43.4 w15:13.2/63.5 w16:13.6/38.6 w17:17.8/62.8 w18:12.2/45.8 w19:17.0/31.1 w20:14.9/69.6 w21:18.9/65.1 w22:17.8/93.9
evolutions=1 gravebow synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:8c/0d,corpse_explosion:32c/5623d,dread_rally:7c/0d,shadow_bolt:120c/7979d
blockers_lost=63 respawned=62 healed=1872 risen=0 deep_freezes=28 shatters=0 shrapnel=0 corpses_detonated=117
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:3
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=300 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:22 lives_lost:0 body_deaths:63 lives_after_deaths:0 per_death:0.00
minibosses=inquisitor:170:3200:held19:killed@269
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=2 build=graveyard_default speed=8
result=won skulls=3 time=479.00s ticks=28740
waves_cleared=22/22 reached=22 lives=20/20
souls_now=122 earned=2864 spent=2892 earned_by=kills:2138,no_leak:726
kills=alaric:1,archer:64,chaplain:28,footman:130,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=
damage_by_source=abomination:189,archer:27127,corpse_catapult:36386,corpse_explosion:6550,frost_wraith:3564,mage:4049,shadow_bolt:8002,warrior:6377
towers=plot:4:archer/gravebow:lv5:k71:d17495,post:0:warrior:lv2:k44:d4687,plot:5:archer:lv5:k35:d7163,plot:3:mage:lv5:k36:d4049,post:1:warrior:lv1:k19:d1690,plot:8:frost_wraith:lv3:k17:d3564,plot:10:corpse_catapult:lv4:k124:d36386,post:2:abomination:lv2:k2:d189,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k2:d2470,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=35/45 chests=1 free_upgrades_left=0
blocker_damage_taken=10840 bodies_lost=65 spells=bone_wall:8,corpse_explosion:32,dread_rally:7,shadow_bolt:120
wave_spawn/clear_s=w1:9.5/16.8 w2:11.9/27.7 w3:10.2/34.8 w4:10.8/53.6 w5:11.3/46.7 w6:11.0/77.1 w7:15.4/61.1 w8:13.8/62.2 w9:12.7/39.4 w10:14.1/70.0 w11:14.9/102.9 w12:10.2/73.9 w13:16.0/69.1 w14:12.4/46.3 w15:13.2/63.6 w16:13.6/37.6 w17:17.8/61.4 w18:12.2/46.2 w19:17.0/37.0 w20:14.9/71.0 w21:18.9/64.4 w22:17.8/92.4
evolutions=1 gravebow synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:8c/0d,corpse_explosion:32c/6550d,dread_rally:7c/0d,shadow_bolt:120c/8002d
blockers_lost=65 respawned=65 healed=2358 risen=0 deep_freezes=28 shatters=0 shrapnel=0 corpses_detonated=111
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:3,bumped:2
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=300 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:22 lives_lost:0 body_deaths:65 lives_after_deaths:0 per_death:0.00
minibosses=inquisitor:170:3200:held24:killed@273
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=1 build=march_default speed=8
result=won skulls=2 time=584.33s ticks=35060
waves_cleared=25/25 reached=25 lives=15/20
souls_now=130 earned=4379 spent=4499 earned_by=kills:3513,no_leak:866
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:199,halberdier:29,purifier:104,recruit:78,shieldbearer:153,templar:35,vael:1,ward_generator:5
leaks=templar_commander:1
damage_by_source=archer:61523,corpse_catapult:28187,corpse_explosion:5191,frost_wraith:2152,mage:30132,shadow_bolt:6855,warrior:5590
towers=plot:1:archer/gravebow:lv5:k119:d16633,plot:12:archer:lv5:k63:d21160,post:0:warrior:lv2:k4:d264,plot:4:mage:lv5:k89:d10467,plot:8:mage:lv5:k114:d15560,post:2:warrior:lv1:k11:d2538,post:3:warrior:lv1:k18:d2700,plot:5:archer:lv5:k5:d11893,plot:9:archer:lv5:k38:d11838,plot:10:corpse_catapult:lv4:k120:d28187,post:4:warrior:lv2:k0:d88,plot:6:frost_wraith:lv3:k2:d2152,post:1:abomination:lv2:k0:d0,plot:14:mage:lv4:k14:d4105,plot:15:mender:lv1:k0:d0
build_steps_done=55/55 chests=0 free_upgrades_left=0
blocker_damage_taken=12146 bodies_lost=115 spells=bone_wall:9,corpse_explosion:41,dread_rally:11,shadow_bolt:146
wave_spawn/clear_s=w1:15.3/30.4 w2:12.6/37.9 w3:9.4/39.9 w4:17.9/57.4 w5:9.9/40.7 w6:8.5/62.6 w7:11.9/57.9 w8:13.6/64.6 w9:12.5/65.6 w10:11.9/71.4 w11:15.9/59.4 w12:15.9/91.1L w13:15.4/54.3 w14:16.8/56.1 w15:13.6/56.0 w16:18.3/56.6 w17:18.1/37.4 w18:20.0/52.2 w19:19.2/51.0 w20:22.8/57.4 w21:21.9/49.6 w22:19.7/53.7 w23:25.5/58.1 w24:26.2/56.3 w25:15.9/71.0
evolutions=1 gravebow synergies=
spell_casts/damage=bone_wall:9c/0d,corpse_explosion:41c/5191d,dread_rally:11c/0d,shadow_bolt:146c/6855d
blockers_lost=115 respawned=114 healed=0 risen=0 deep_freezes=50 shatters=0 shrapnel=0 corpses_detonated=180
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=bumped:1,halberd_reach:49,lash_second:22,structures_destroyed:5,vael_calls:6,vael_shieldwalls:6
rule=holy_ward_generators generators_raised=6 destroyed=5
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=275 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:16 end_wave:25 lives_lost:5 body_deaths:115 lives_after_deaths:5 per_death:0.04
minibosses=templar_commander:195:2600:held9:gone@286
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=2 build=march_default speed=8
result=won skulls=3 time=579.12s ticks=34747
waves_cleared=25/25 reached=25 lives=20/20
souls_now=107 earned=4475 spent=4618 earned_by=kills:3575,no_leak:900
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:193,halberdier:29,purifier:104,recruit:78,shieldbearer:149,templar:35,templar_commander:1,vael:1,ward_generator:6
leaks=
damage_by_source=archer:61482,corpse_catapult:29533,corpse_explosion:5332,frost_wraith:4282,mage:27340,shadow_bolt:6505,warrior:5206
towers=plot:1:archer/gravebow:lv5:k98:d12784,plot:12:archer/gravebow:lv5:k61:d24432,post:0:warrior:lv2:k6:d107,plot:4:mage:lv5:k81:d9114,plot:8:mage:lv5:k101:d13519,post:2:warrior:lv1:k15:d2406,post:3:warrior:lv1:k26:d2639,plot:5:archer:lv5:k10:d13172,plot:9:archer:lv5:k48:d11094,plot:10:corpse_catapult:lv4:k135:d29533,post:4:warrior:lv2:k0:d55,plot:6:frost_wraith:lv3:k1:d4282,post:1:abomination:lv2:k0:d0,plot:14:mage:lv4:k16:d4707,plot:15:mender:lv1:k0:d0
build_steps_done=55/55 chests=1 free_upgrades_left=0
blocker_damage_taken=10014 bodies_lost=100 spells=bone_wall:3,corpse_explosion:38,dread_rally:11,shadow_bolt:145
wave_spawn/clear_s=w1:15.3/29.1 w2:12.6/37.6 w3:9.4/39.9 w4:17.9/47.0 w5:9.9/33.5 w6:8.5/49.3 w7:11.9/47.7 w8:13.6/53.4 w9:12.5/65.6 w10:11.9/53.1 w11:15.9/49.9 w12:15.9/94.2 w13:15.4/52.3 w14:16.8/53.7 w15:13.6/50.3 w16:18.3/53.3 w17:18.1/36.9 w18:20.0/51.9 w19:19.2/48.9 w20:22.8/55.5 w21:21.9/50.0 w22:19.7/51.9 w23:25.5/51.5 w24:26.2/54.5 w25:15.9/65.8
evolutions=2 gravebow,gravebow synergies=
spell_casts/damage=bone_wall:3c/0d,corpse_explosion:38c/5332d,dread_rally:11c/0d,shadow_bolt:145c/6505d
blockers_lost=100 respawned=100 healed=0 risen=0 deep_freezes=47 shatters=0 shrapnel=0 corpses_detonated=152
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=bumped:1,halberd_reach:49,lash_second:21,structures_destroyed:6,vael_calls:5,vael_shieldwalls:5
rule=holy_ward_generators generators_raised=6 destroyed=6
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=375 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:100 lives_after_deaths:0 per_death:0.00
minibosses=templar_commander:195:2600:held15:killed@289
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=1 build=sanctum_default speed=8
result=won skulls=3 time=683.28s ticks=40997
waves_cleared=25/25 reached=25 lives=20/20
souls_now=53 earned=4208 spent=4405 earned_by=kills:3308,no_leak:900
kills=archer:8,banner_bearer:7,battle_sister:25,cathedral_guardian:1,chaplain:4,confessor_attendant:3,footman:128,halberdier:13,high_confessor:23,purifier:95,radiant_inquisitor:23,recruit:62,sanctified_sentinel:44,seraphine:1,shieldbearer:51,sun_paladin:19,templar:20,ward_crystal:2
leaks=
damage_by_source=abomination:85,archer:66552,banshee:4,corpse_catapult:49902,corpse_explosion:5793,frost_wraith:5351,mage:62960,shadow_bolt:13996,warrior:2497
towers=plot:6:archer/gravebow:lv5:k102:d41196,post:2:warrior:lv2:k11:d1322,plot:11:archer:lv5:k54:d12298,plot:3:mage:lv5:k28:d43908,plot:5:corpse_catapult:lv5:k143:d46131,post:1:warrior:lv1:k7:d1175,plot:7:mage:lv5:k38:d9336,plot:12:archer:lv5:k18:d13058,plot:10:frost_wraith:lv2:k9:d5351,post:3:abomination:lv1:k0:d85,plot:2:mage:lv4:k0:d9716,plot:13:corpse_catapult:lv3:k13:d3771,plot:8:banshee:lv1:k0:d4
build_steps_done=50/55 chests=1 free_upgrades_left=0
blocker_damage_taken=9064 bodies_lost=82 spells=bone_wall:7,corpse_explosion:42,dread_rally:10,shadow_bolt:171
wave_spawn/clear_s=w1:13.8/44.6 w2:10.7/53.9 w3:12.2/99.0 w4:13.5/76.2 w5:13.6/130.5 w6:12.5/91.8 w7:12.3/69.7 w8:12.5/151.0 w9:18.7/159.7 w10:10.5/78.2 w11:15.3/116.4 w12:15.9/136.5 w13:21.9/178.1 w14:17.7/108.5 w15:19.4/115.5 w16:22.1/76.5 w17:20.2/79.5 w18:21.1/119.7 w19:20.2/94.7 w20:22.6/70.6 w21:23.8/103.4 w22:22.8/77.3 w23:24.3/65.7 w24:28.9/90.1 w25:19.4/136.2
evolutions=1 gravebow synergies=killing_field:2
spell_casts/damage=bone_wall:7c/0d,corpse_explosion:42c/5793d,dread_rally:10c/0d,shadow_bolt:171c/13996d
blockers_lost=82 respawned=82 healed=0 risen=0 deep_freezes=63 shatters=0 shrapnel=0 corpses_detonated=121
reckoning=false reckoning_wave=0 suppressed_tower_s=283.8
events=bumped:1,confessor_heal:17628,confessor_revives:25,guardian_beams:15,guardian_slams:1,halberd_reach:20,holy_zones:32,lash_second:7,seraphine_teleports:8,structures_destroyed:2
rule=sanctified_chambers crystals_broken=2/4 chambers_broken_at=never,never
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=450 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:82 lives_after_deaths:0 per_death:0.00
minibosses=cathedral_guardian:222:4000:held11:killed@400
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=2 build=sanctum_default speed=8
result=won skulls=3 time=674.50s ticks=40470
waves_cleared=25/25 reached=25 lives=20/20
souls_now=110 earned=4202 spent=4342 earned_by=kills:3302,no_leak:900
kills=archer:8,banner_bearer:7,battle_sister:23,cathedral_guardian:1,chaplain:5,confessor_attendant:3,footman:126,halberdier:13,high_confessor:23,purifier:100,radiant_inquisitor:23,recruit:60,sanctified_sentinel:43,seraphine:1,shieldbearer:56,sun_paladin:20,templar:19,ward_crystal:2
leaks=
damage_by_source=abomination:427,archer:67014,banshee:16,corpse_catapult:50711,corpse_explosion:5736,frost_wraith:4580,mage:63002,shadow_bolt:13707,warrior:3371
towers=plot:6:archer/gravebow:lv5:k111:d38839,post:2:warrior:lv2:k15:d2121,plot:11:archer:lv5:k54:d16555,plot:3:mage:lv5:k41:d44503,plot:5:corpse_catapult:lv5:k121:d44133,post:1:warrior:lv1:k2:d1249,plot:7:mage:lv5:k27:d9661,plot:12:archer:lv5:k23:d11621,plot:10:frost_wraith:lv2:k12:d4580,post:3:abomination:lv1:k1:d427,plot:2:mage:lv4:k0:d8838,plot:13:corpse_catapult:lv3:k13:d6578,plot:8:banshee:lv1:k0:d16
build_steps_done=50/55 chests=1 free_upgrades_left=0
blocker_damage_taken=11160 bodies_lost=96 spells=bone_wall:14,corpse_explosion:41,dread_rally:10,shadow_bolt:169
wave_spawn/clear_s=w1:13.8/44.7 w2:10.7/53.3 w3:12.2/103.1 w4:13.5/77.5 w5:13.6/138.4 w6:12.5/99.7 w7:12.3/82.4 w8:12.5/145.0 w9:18.7/161.6 w10:10.5/95.8 w11:15.3/124.4 w12:15.9/153.5 w13:21.9/219.4 w14:17.7/120.3 w15:19.4/172.2 w16:22.1/78.2 w17:20.2/118.2 w18:21.1/145.2 w19:20.2/112.9 w20:22.6/83.2 w21:23.8/111.6 w22:22.8/75.0 w23:24.3/62.0 w24:28.9/87.9 w25:19.4/127.4
evolutions=1 gravebow synergies=killing_field:2
spell_casts/damage=bone_wall:14c/0d,corpse_explosion:41c/5736d,dread_rally:10c/0d,shadow_bolt:169c/13707d
blockers_lost=96 respawned=96 healed=0 risen=0 deep_freezes=61 shatters=0 shrapnel=0 corpses_detonated=118
reckoning=false reckoning_wave=0 suppressed_tower_s=369.6
events=bumped:4,confessor_heal:19136,confessor_revives:29,guardian_beams:18,guardian_slams:7,halberd_reach:29,holy_zones:40,lash_second:9,seraphine_teleports:9,structures_destroyed:2
rule=sanctified_chambers crystals_broken=2/4 chambers_broken_at=never,never
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=450 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:96 lives_after_deaths:0 per_death:0.00
minibosses=cathedral_guardian:222:4000:held50:killed@441
stuck_enemies=0 alive_at_end=0
```

# Earlier balance (integration pass, Nov 2026; measured with the blocker bug)

Numbers from the autotest bot (`--autotest`, default build order of each map,
Necromancer unless noted). "Lives" = lives kept of 20; a boss leak ends the map.
Seeds 1-8 for the default difficulty, 1-4 for Lich, 1-2 for Initiate /
Deathlord. Commands: see README "Autotest".

## Levers (all data)

- Wave HP ramp: non-boss HP x lerp(0.75, end, wave / last wave)
  (`TdRulesData.WAVE_HP_START` / `WAVE_HP_END`, map key `wave_hp_end`:
  Graveyard 2.6, Crimson March 2.4, Sanctum 3.0). Before it, every default run
  kept 20/20 lives while Lich collapsed in the first 4-6 minutes.
- Difficulty: Initiate HP x0.75 / count x0.85, Lich x1.1 / x1.1, Deathlord
  x1.5 / x1.3.
- Against the towers branch's stronger blocker hits (x4): Halberdier 10
  damage, Alaric 9000 HP; Frost Wraith 8 and Abomination 22 damage; Gravebow
  recipe 60 kills.

## Results

| Map | Difficulty | Seeds | Wins | Lives kept (wins) | Map time | Evolutions (default bot) |
|---|---|---|---|---|---|---|
| Graveyard | Initiate | 1-2 | 2/2 | 20 | 6.9 min | - |
| Graveyard | Necromancer | 1-8 | 8/8 | 20 (45-60 blocker bodies lost) | 7.6-8.2 min | Gravebow |
| Graveyard | Lich | 1-4 | 4/4 | 9-20 | 8.2-8.6 min | Gravebow |
| Graveyard | Deathlord | 1-2 | 0/2 | - (wave 7 / Alaric) | | |
| Crimson March | Initiate | 1-2 | 2/2 | 20 | 9.9 min | |
| Crimson March | Necromancer | 1-8 | 8/8 | 14-20 (4 of 8 lose lives) | 10.3-11.1 min | Gravebow x1-2 |
| Crimson March | Lich | 1-4 | 3/4 | 2-3 | 11.5 min | Gravebow |
| Crimson March | Deathlord | 1-2 | 0/2 | - (wave 7) | | |
| Sanctum | Initiate | 1-2 | 2/2 | 20 | 10.6 min | |
| Sanctum | Necromancer | 1-8 | 8/8 | 5-20 (5 of 8 lose lives) | 11.3-11.9 min | Gravebow x1-2 |
| Sanctum | Lich | 1-4 | 1/4 | 11 | 12 min | |
| Sanctum | Deathlord | 1-2 | 0/2 | - (wave 3) | | |

Losing orders: `weak`, `march_weak`, `sanctum_weak` lose on every seed tried
(waves 1-3, under 2 minutes). Reckoning (`--reckoning`, seed 1): ends at
Reckoning wave 13 (Graveyard), 11 (March), 8 (Sanctum).

Test orders: `towers_a` (four shooters + Lich / Winter Revenant) wins the
Graveyard; `evolve_all` reaches six evolutions with its bonus souls;
`towers_b` (support + blockers, little damage) loses on every map: support
towers multiply a damage core, they do not replace it.

## Tower contribution (default runs, typical damage share)

Archer / Gravebow and Mage carry (60-70%), Catapult 10-25% (more on the
Sanctum), spells ~15% (Shadow Bolt, Corpse Explosion), blockers mostly hold.
Frost Wraith, Banshee and Mender are utility: slow / freeze uptime, weaken,
healing (towers_b: ~5000 HP healed, Death Knight and Profane Bishop reached).

## Known weak spots

- The bot's default orders are fixed scripts; Lich on the Sanctum is won by
  1 seed in 4. A human who adapts placement should do better.
- Graveyard on Necromancer is the gentlest map: the bot loses blockers but no
  lives.
- The tipping point is sharp: once leaks start, a run can lose all 20 lives in
  two waves.

## Meta and Soul Ash

- `--meta=max` (every Ossuary level and mastery): seed 1 keeps 26/26 lives on
  all three maps and loses 10-22 blocker bodies instead of 50-100: clearly
  easier, still a fight on Lich / Deathlord.
- Soul Ash (I8): a 3-skull Necromancer clear pays 300 / 375 / 450 (Graveyard /
  March / Sanctum), Lich x1.5, Deathlord x2; a defeat pays 6 per wave cleared.
  The whole Ossuary (7,380) takes ~20 good clears.
- Gravecaller with no meta gives the same summaries as before the menus merge
  (checked on all three maps, seed 1).

## Act II, the Black Tide (w2b-tide)

Necromancer, default orders, `--seed=1..4` (lives left / 20, all won):

| Map | s1 | s2 | s3 | s4 | weak (s1, s2) |
|---|---|---|---|---|---|
| cutter | 15 | 15 | 15 | 15 | lost, lost |
| galleon | 14 | 12 | 5 | 20 | lost, lost |
| maelstrom | 15 | 11 | 8 | 14 | lost, lost |

Act I default summaries (seeds 1, 2) reproduce the baselines above byte for byte. Details: DECISIONS T2-11.
## Act III, the Sanguine Court (wave 2b, w2b-court)

Necromancer, default orders, meta none, Gravecaller, seeds 1-4 (lives left of 20):

| Map | s1 | s2 | s3 | s4 | wave_hp_end | Notes |
|---|---|---|---|---|---|---|
| Ravensmoor | 17 | 17 | 17 | 17 | 2.75 | the 3 lives are a Vampire Noble out of a sleeping coffin at the first Blood Moon (wave 6) |
| The Witchwood | 12 | 17 | 20 | 11 | 2.2 | leaks from wave 12-18 (knights, the Bog Mother on some seeds) |
| Castle Sanguis | 20 | 20 | 17 | 17 | 3.35 | spiral road: waves overlap (clear times 100-200 s); at 3.45-3.6 one seed in two collapses from wave 17 (a cliff), so 3.35 |

Weak orders (`<map>_weak`, seeds 1-2) lose on wave 5 / 3 / 7. `court_kit` (seed 1;
Castle Sanguis also with `--character=dhampir`) wins all three and evolves the
Nosferatu on each. Act I baseline summaries unchanged (seeds 1-2, all three maps).
Known: Castle Sanguis loses fewer lives than Ravensmoor with these orders (its
default order builds more towers on a longer road); the bot's default orders
never build the act tower.
## Act IV, the Last Line (w2b-city, wave 2b)

Necromancer, default orders, `--seed=1..4` (lives kept of 20; every run 0 script errors, `stuck_enemies=0`):

| Map | s1 | s2 | s3 | s4 | Weak order (s1, s2) |
|---|---|---|---|---|---|
| Skid Row (`skid_row_default`) | won 12 | won 15 | won 20 | won 20 | lost, lost |
| Fort Kessler (`fort_kessler_default`) | won 15 | won 15 | won 12 | won 15 | lost, lost |
| Liberty Heights (`liberty_heights_default`) | won 11 | won 12 | won 8 | won 14 | lost, lost |

Act I's six baseline summaries above are byte-identical on this branch. No
cliff: first leaks on waves 17-20, lives go a few at a time (`leak_curve`
per_death 0.1-0.2). What leaks is the act's threat (vehicles, Supers, the
Mammoth, Big Sal), never plain fodder. Liberty Heights evolves Black Paragon in
every run; the Origin Story synergy is active in its order.
## Act V, the Shogunate (w2b-shogun, wave 2b)

Necromancer, default orders, `--autotest`, seeds 1-4 (lives kept / 20; the
leaks; `leak_curve` first leak wave). Wave HP ramp end: Province 2.35,
Kurogane 2.5, Road to the Sun 3.6 (Act I Sanctum 3.0; Act V kinds are tougher
per unit and the night halves what towers can see).

| Map | Seed 1 | Seed 2 | Seed 3 | Seed 4 | Weak order | Kit order (seed 1) |
|---|---|---|---|---|---|---|
| province | won 20 | won 9 (kunoichi x2, Shuten-doji; w21) | won 20 | won 13 (w21) | lost w~6, 0 stuck | won 17, no Oni Lord (kills too low) |
| kurogane | won 20 | won 20 | won 19 (samurai) | won 15 (General of the Left) | lost, 0 stuck | won 20, 1 Oni Lord; Ronin: won 4, 2 Oni Lords |
| sun_road | won 14 (the Kirin, ninja; w18) | won 15 (the Kirin) | won 15 (the Kirin) | won 14 (the Kirin, ninja) | lost w6, 0 stuck | won 20, 2 Oni Lords |

Levers that moved it (see DECISIONS T5-2, T5-6): ninja douse one lantern
each (the bot was spending 500+ souls relighting), soldier `souls` (income
~2000 -> ~3400 a map), teppo disable 1.6 -> 0.8 s, cavalry charges once
(Kiba-musha leaks cost 3 lives each), miniboss HP (Shuten 2600, General 1500,
Kirin 2500) and Kage 6000 / speed 26. The Road to the Sun was re-laid after the Web check (its bottom run passed under the spell bar; runs now at y 590 / 450 / 310 / 170) and re-tuned: at 3.4 nothing leaked, at 3.6 the Kirin walks through every seed (5 lives) and nothing else threatens; the Kirin is the map's whole margin. Known: the Province's losses come in
its last two waves (a late lump, not an early cliff); the minibosses are the
swing factor on Kurogane and the Road (5 lives when one walks through).
Act I summaries: byte-identical to the baseline (seeds 1-2, three maps).

## Wave 2c: Act VI, the Hall of the Slain (w2c-norse; DECISIONS T6)

Necromancer, default orders, seeds 1-4 (lives kept of 20; 0 script errors,
`stuck_enemies=0`; Income = `MapLoader.income()`):

| Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Weak s1 / s2 |
|---|---|---|---|---|---|---|---|---|---|
| barrow_fields | 2.5 | 3876 | 17 | 11 | 11 | 14 | 4/4 | 2/4 (Wight) | lost w5 / w5 |
| valgard | 1.95 | 4056 | 10 | 20 | 13 | 20 | 2/4 | 2/4 (Champion) | lost w5 / w5 |
| vigrid | 2.9 | 4081 | 20 | 15 | 20 | 20 | 1/4 | 3/4 (Fire-Giant) | lost w5 / w5 |

The `wave_hp_end` values are below Act V's on purpose: the Norse rows are
tougher per unit (raider 84 HP vs ashigaru 72, shield-maiden 220 with a 0.7
front shield, einherjar that die twice) and the act stacks tower debuffs (the
Long Winter's cold to x0.7 away from the fires, seer blinds, frost-giant
boulders, valkyrie dives, fire-giant stomps), so Part Two's step up is in what
the towers face, not in the ramp. Vigrid has a cliff: 3.15 loses all four
seeds (the Fire-Giant of the South leaks, then the giants), 2.9 wins all four.
`norse_kit` (Draugr Thanes on every post, the Barrow King, Cold Iron, Valkyrie
Spear and Gungnir) wins the Barrow Fields (18 lives, Barrow King evolved) and
loses Valgard (Sigrun leaks at the end) and Vigrid (wave 17), like
`tide_kit` / `court_kit` on their harder maps. Act I's six baseline summaries
are byte-identical on this branch; the same seed twice is identical on all
three maps.

## Act VII, the Necropolis Dynasty (w2c-dynasty, wave 2c)

Necromancer, default order, seeds 1-4 (lives left), weak order seeds 1-2:

| Map | wave_hp_end | INCOME | s1 | s2 | s3 | s4 | Miniboss killed | Weak |
|---|---|---|---|---|---|---|---|---|
| necropolis | 4.55 | 3910 | 9 | 20 | 17 | 20 | sand_colossus 3/4 | lost w6 |
| lioness_temple | 2.8 | 3902 | 13 | 20 | 17 | 20 | lion_warden 4/4 | lost w5 |
| two_truths | 3.55 | 4129 | 15 | 14 | 20 | 17 | devourers_whelp 3/4 | lost w8 |

Every default order wins 4/4, lives lost in 2/4, 2/4, 3/4 runs; weak orders
lose. Leaks are Jackal Warriors (3 lives each), a Bastet Hunter, the odd
miniboss; no scripted leak (the Whelp at 3800 and the Colossus at 4600 walked
to the gate on 3-4 seeds and were cut). Rebirth per run: 100-145 Names laid,
35-55 returns, all 5 jars broken on the Necropolis and Hall (4 on the Temple).
The `wave_hp_end` numbers are not comparable with Act V's: the Dynasty's
fodder returns at 70% HP near a jar, and the Temple's bottom avenue runs 900 px
to a west gate with few plots. `dynasty_kit` (Ushabti posts, the three act
spells): Temple won 20/20, Hall won 20/20 (seed 1), Necropolis lost (w22).
## Act VIII, the Olympian Republic (w2c-pantheon, wave 2c)

Necromancer, default orders, `--autotest`, seeds 1-4 (lives kept / 20; the leaks;
`leak_curve` first leak wave). Income (`map_list`): Ilion 3828, Olympus 3992,
Underworld 4436. Wave HP ramp end: Ilion 2.5, Olympus 3.6, Underworld 2.3
(DECISIONS T8-11: the shields, Glory and the wrath make the kinds far tougher than
their row HP; at 4.4-4.8 every default order lost by wave 7-16).

| Map | Seed 1 | Seed 2 | Seed 3 | Seed 4 | Miniboss killed | Weak (s1, s2) | Kit order (s1) |
|---|---|---|---|---|---|---|---|
| ilion | won 12 (Polyphemus, hero; w12) | won 19 (w13) | won 20 | won 15 (Polyphemus; w19) | 2/4 | lost w5-6, 0 stuck | won 20, Legion of Tartarus |
| olympus | won 20 | won 14 (amazon, hero; w18) | won 20 | won 5 (amazon x2, hoplite x3, hero x2; w8) | 4/4 | lost w6, 0 stuck | won 20, Legion of Tartarus |
| underworld | won 17 (titan; w18) | won 4 (titans, Cerberus, shade hoplites; w6) | won 3 (titans, Cerberus, heroes; w17) | won 20 | 2/4 | lost w5, 0 stuck | won 20, no evolution (ran out of souls for it) |

Every default order wins every seed; lives are lost in 3/4, 2/4 and 3/4 runs; the
weak orders lose; no cliff (`per_death` 0.00-0.18). Same seed twice: identical
(Ilion s1). Act I summaries: byte-identical to the baseline (seeds 1-2, three maps).
Known: Polyphemus walks through when the posts on his road are full (5 lives,
2/4 seeds); the kit order (Myrmidon Shades instead of Warriors) keeps all 20
lives on every map: the Myrmidons out-block the Warriors the default orders use
(their wall and spear are the act's reward; watch them in the integration).
Frame time (`tools/gw_perf.js`, shared machine, five agents running: unreliable):
Sanctum w20 112 ms (74 enemies), Underworld w22 91 ms (33 enemies), 0.81x.
Screenshots: `/home/user/gw_shots/w2c_pantheon_*.png` (1280x720 and 844x390 touch).
## Act X, the Celestial Host (wave 2c, w2c-host; DECISIONS T10)

Necromancer, default orders, seeds 1-4 (lives kept of 20; every run 0 script
errors, `stuck_enemies=0`; Income = `MapLoader.income()`). Frame times not
measured on a quiet machine (five act agents share the cores): the integration
re-measures.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 / s2 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X | silver_stair | 3.2 | 4548 | 17 | 17 | 14 | 17 | 4/4 | 4/4 | dominion 3, cherub 1, judge 1 | lost w7 / w7 |
| X | wheel_of_thrones | 3.6 | 4754 | 6 | 20 | 20 | 20 | 1/4 | 3/4 | dominion 2, cherub 1, dominion_of_the_spheres 1 | lost w8 / w8 |
| X | empyrean | 3.2 | 5016 | 13 | 13 | 18 | 20 | 3/4 | 2/4 | virtue 4, power 2, seventh_herald 2 | lost w4 / w4 |

Act X's waves carry less raw HP than the Road to the Sun's (sun_road 4.2 on
tougher rows): the step up is the Hallowed Light (haste, Grace, weakened
towers), the swords and trumpets that stun towers and posts, the unholdable
Ophans and Judgment's Judges at the bosses. First tries at 4.4-5.0 with the
first road layouts lost by wave 5-13: the first Silver Stair and Empyrean
roads were short (1200-1300 px), so both were re-laid as long switchbacks
(T10.7). Boss HP: Seraiel 9500, the Throne 5500 behind x0.25 rims (Core 8 s
of every 14), the Voice 12000 (it never moves; a fight of about 160 s).

`host_kit` (seed 1; the first catapult a Bound Ophan, evolved early): Silver
Stair won 20/20 (Throne of Bones), Empyrean won 12/20 (Throne of Bones),
Wheel of Thrones lost at wave 21 (its first catapult stands at the hub, where
the Ophan's 170 px reach covers less). Seed 1 twice gives the same summary;
Act I's six baseline summaries are byte-identical.

## Act XIII, the Concord of Stars (wave 2d, w2d-concord; DECISIONS T13)

Necromancer, default orders, seeds 1-4 (lives kept of 20; every run 0 script
errors, `stuck_enemies=0`; Income = `MapLoader.income()`). Frame times not
measured on a quiet machine (five act agents share the cores): the integration
re-measures.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| XIII | crash_site | 2.65 | 4030 | 19 | 20 | 8 | 10 | 3/4 | 4/4 | concord_broodling 3, concord_hive_mother 2 | lost w4 |
| XIII | proving_moon | 3.0 | 3769 | 7 | 20 | 17 | 17 | 3/4 | 4/4 | concord_vrask_hunter 4, concord_vrask_tal 1 | lost w4 |
| XIII | ark | 2.2 | 4282 | 9 | 7 | 17 | 3 | 4/4 | 4/4 | concord_harvester 3, concord_vault_beast 7, concord_grey_overseer 2, concord_burrower 1 | lost w4 |

Cliff check at `wave_hp_end` + 0.2 (seeds 1-2): Crash Site 18 / 10, Proving
Moon 17 / 4, Ark 15 / 1: every run still won, losses grow gradually (no cliff).
The Ark is the act's hardest map (4/4 runs lose lives, one more than the 1-3
target: the Harvester's Reaping and the Ark's three saucers a flight).

Raw HP per wave sits under the Empyrean's 3.2 multiplier, but the rows are
tougher (Burrower 150 / armour 3 against the Virtue's 115 / 2; Lumen Sentinel
480 + a 35 % shield; Vrask Hunters cloaked) and the act rule takes towers and
bodies out of the fight: the step up over Part Two is Abduction (20-33 saucers
a run, 10-27 lifts), the Grey Drones' and Luminous beams' stuns, the Burrowers
that dig under the posts and the cloaked Vrask. First tries at 2.9-3.3 lost by
wave 9-17 (Ark, Proving Moon); the Proving Moon was re-laid from a forked road
(posts on overlapping roads hold only one road) into a spiral (T13.7). Boss HP:
the Hive Mother 11000 (Flight unholdable from 30 %), Vrask'Tal 9000, the
Harvester 10500 (immune through the Reaping).

Ghost Saucer against the Mage (`--swap=mage:ghost_saucer` vs `--swap=mage:mage`,
seeds 1-2; lives, then damage per soul at the swapped spot): Crash Site 20, 16 /
19, 20 (34.6 / 33.1); Proving Moon 17, 17 / 7, 20 (23.7 / 23.1); Ark 14, 8 / 9, 7
(44.3 / 46.6). `concord_kit` (Ghost Saucer raised to Lv 5 early, Black
Mothership, Bone Beetles and Soul Caster): won 6/6, lives 17, 18 / 20, 20 / 20,
20. Seed 1 twice gives the same summary; Act I's six baseline summaries are
byte-identical. Vrask'Tal and the Harvester have no attack-pose art (the Hive
Mother has `cast` / `strike`).
## Act XV, the Turning Year (w2d-year, Nov 2026; DECISIONS T15)

Necromancer, default orders, seeds 1-4 (lives kept of 20); 0 script errors,
`stuck_enemies=0`, the same seed twice identical (World-Tree seed 1). Act I's
six baseline summaries above are byte-identical after the act.

| Act | Map | wave_hp_end | Income | s1 | s2 | s3 | s4 | Runs losing lives | Miniboss killed | Leaks (4 seeds) | Weak s1 / s2 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| XV | greenwood | 2.8 | 4396 | 20 | 19 | 15 | 17 | 3/4 | 4/4 | wild_fae_knight 7, wild_hunt_hound 2 | lost w4 / w4 |
| XV | fae_court | 4.2 | 4358 | 17 | 17 | 20 | 14 | 3/4 | 3/4 | wild_great_stag 2, wild_fae_knight 1, wild_winter_prince 1 | lost w3 / w3 |
| XV | world_tree | 2.9 | 4472 | 17 | 11 | 10 | 17 | 4/4 | 4/4 | wild_treant 4, wild_fae_knight 3, wild_will_o_wisp 3, wild_dryad 2, claimed_shade 1 | lost w4 / w4 |

Cliff check at `wave_hp_end` +0.2 (seeds 1-4): the Greenwood at 3.0 won 4/4
(19, 2, 8, 15); the Fae Court at 4.4 won 4/4 (20, 20, 14, 20); the World-Tree
at 3.1 won 3/4 (14, 12, lost, 9). No boss leaks at the chosen values; at a
first draft the Summer Queen (speed 20) and the Green Mother (16500 HP) leaked
on most seeds (DECISIONS T15.3). The World-Tree, the campaign's last map, is
the act's hardest on lives lost (5.25 a run against the Greenwood's 2.25 and the
Fae Court's 3); the Fae Court carries the most raw HP because its endless
Summer never brings thickets.

### Act tower: Ossuary Oak against the Corpse Catapult (Y4)

`--swap=corpse_catapult:ossuary_oak` against `--swap=corpse_catapult:corpse_catapult`
(the same default order), seeds 1-2; damage per soul of the swapped tower
against the control's catapults:

| Map | Oak lives | Control lives | Oak dmg / soul | Catapult dmg / soul (control) |
|---|---|---|---|---|
| greenwood | 20, 20 | 20, 19 | 51.1, 51.1 | 54.0, 62.9 |
| fae_court | 15, 17 | 17, 17 | 135.7, 130.1 | 89.2, 87.5 |
| world_tree | 20, 8 | 17, 11 | 49.7, 51.7 | 49.4, 46.6 |

The Oak deals about the Catapult's damage per soul (more on the Fae Court's
long winding road) and roots what it hits; no change made.

### Kit order `year_kit` (seeds 1-2, lives kept; Oak evolved to the World-Root Warden, Wild Hunt and Root and Rot cast)

| Order | greenwood | fae_court | world_tree |
|---|---|---|---|
| year_kit | 20, 20 | 20, 20 | 20, 20 |
