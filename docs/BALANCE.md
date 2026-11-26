# Balance

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

Their strike pose (3) shows the still sprite: Seraphine (cast pose only), Captain
Crow, Admiral Marrec, Captain Vandermere, Vargr, Isolde Vane, Queen Carmilla, Don
Marrow, General Harrow, Paragon, Kage, Amaterasu, Hrimgar, Sigrun, Odin, Fenrir,
Anubis, Sekhmet, Osiris and Ammit, Zeus, Hades, Moloch, Lilith, the Morning Star,
Seraiel, the Throne, the Voice (27; Alaric, Vael, Achilles and the Shogun have one).


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

### Act I baseline summaries (the same-seed gate; re-recorded by the wave 2c integration, DECISIONS Y3 / Y6)

Default build, Necromancer, `--autotest --map=<id> --seed=<n>`; the lines from
`TDAUTOTEST SUMMARY`. A change that must not touch Act I reproduces these byte
for byte. Wave 2c changed them on purpose (minibosses push a lesser enemy out of
a full post: the Inquisitor on seed 2 of the Graveyard; Seraphine 12000 HP; the
`bumped` event); the wave 2b set is in git history.

```
TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=1 build=graveyard_default speed=8
result=won skulls=3 time=450.52s ticks=27031
waves_cleared=22/22 reached=22 lives=20/20
souls_now=115 earned=2864 spent=2899 earned_by=kills:2138,no_leak:726
kills=alaric:1,archer:64,chaplain:28,footman:130,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=
damage_by_source=archer:35394,corpse_catapult:22915,corpse_explosion:6119,frost_wraith:729,mage:31889,shadow_bolt:6931,warrior:3761
towers=plot:4:archer/gravebow:lv5:k91:d18401,post:0:warrior:lv2:k28:d3390,plot:5:archer:lv5:k82:d15556,plot:3:mage:lv5:k44:d31889,post:1:warrior:lv1:k1:d371,plot:8:frost_wraith:lv3:k10:d729,plot:10:corpse_catapult:lv4:k84:d22915,post:2:abomination:lv2:k0:d0,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k6:d1437,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=35/45 chests=1 free_upgrades_left=0
blocker_damage_taken=6726 bodies_lost=49 spells=corpse_explosion:32,dread_rally:7,shadow_bolt:113
wave_spawn/clear_s=w1:9.5/22.6 w2:11.9/26.6 w3:10.2/26.4 w4:10.8/25.3 w5:11.3/25.0 w6:11.0/30.8 w7:15.4/36.4 w8:13.8/26.9 w9:12.7/29.2 w10:14.1/50.0 w11:14.9/91.2 w12:10.2/55.4 w13:16.0/62.4 w14:12.4/43.7 w15:13.2/57.1 w16:13.6/38.0 w17:17.8/36.9 w18:12.2/34.9 w19:17.0/31.3 w20:14.9/51.3 w21:18.9/48.8 w22:17.8/63.9
evolutions=1 gravebow synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:0c/0d,corpse_explosion:32c/6119d,dread_rally:7c/0d,shadow_bolt:113c/6931d
blockers_lost=49 respawned=49 healed=622 risen=0 deep_freezes=9 shatters=0 shrapnel=0 corpses_detonated=166
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:2,bumped:1
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=300 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:22 lives_lost:0 body_deaths:49 lives_after_deaths:0 per_death:0.00
minibosses=inquisitor:170:3200:held12:killed@262
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=2 build=graveyard_default speed=8
result=won skulls=2 time=495.72s ticks=29743
waves_cleared=22/22 reached=22 lives=13/20
souls_now=87 earned=2710 spent=2773 earned_by=kills:2052,no_leak:658
kills=alaric:1,archer:64,chaplain:28,footman:128,purifier:80,recruit:116,templar:46
leaks=footman:2,inquisitor:1
damage_by_source=abomination:563,archer:33463,corpse_catapult:26644,corpse_explosion:6860,frost_wraith:1849,mage:29928,shadow_bolt:8212,warrior:4413
towers=plot:4:archer:lv5:k79:d16963,post:0:warrior:lv2:k34:d3557,plot:5:archer:lv5:k80:d14819,plot:3:mage:lv5:k34:d29928,post:1:warrior:lv1:k9:d856,plot:8:frost_wraith:lv3:k4:d1849,plot:10:corpse_catapult:lv4:k107:d26644,post:2:abomination:lv2:k2:d563,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k12:d1680,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=34/45 chests=0 free_upgrades_left=0
blocker_damage_taken=8518 bodies_lost=60 spells=bone_wall:3,corpse_explosion:32,dread_rally:6,shadow_bolt:124
wave_spawn/clear_s=w1:9.5/21.1 w2:11.9/26.8 w3:10.2/26.4 w4:10.8/39.3 w5:11.3/35.7 w6:11.0/42.7 w7:15.4/47.3 w8:13.8/51.5 w9:12.7/36.1 w10:14.1/54.3 w11:14.9/130.8L w12:10.2/59.4 w13:16.0/89.5L w14:12.4/50.7 w15:13.2/66.1 w16:13.6/38.6 w17:17.8/49.9 w18:12.2/41.9 w19:17.0/33.8 w20:14.9/54.2 w21:18.9/51.4 w22:17.8/109.1
evolutions=0  synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:3c/0d,corpse_explosion:32c/6860d,dread_rally:6c/0d,shadow_bolt:124c/8212d
blockers_lost=60 respawned=60 healed=852 risen=0 deep_freezes=19 shatters=0 shrapnel=0 corpses_detonated=148
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:2,bumped:3
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=220 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:17 end_wave:22 lives_lost:7 body_deaths:60 lives_after_deaths:7 per_death:0.12
minibosses=inquisitor:170:3200:held18:gone@301
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=1 build=march_default speed=8
result=won skulls=1 time=611.32s ticks=36679
waves_cleared=25/25 reached=25 lives=9/20
souls_now=150 earned=4399 spent=4499 earned_by=kills:3561,no_leak:838
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:211,halberdier:27,purifier:104,recruit:78,shieldbearer:161,templar:35,vael:1,ward_generator:6
leaks=halberdier:2,templar_commander:1
damage_by_source=archer:59995,corpse_catapult:43114,corpse_explosion:6017,frost_wraith:3493,mage:41304,shadow_bolt:8294,warrior:4326
towers=plot:1:archer:lv5:k55:d19873,plot:12:archer/gravebow:lv5:k65:d20120,post:0:warrior:lv2:k11:d519,plot:4:mage:lv5:k118:d19795,plot:8:mage:lv5:k93:d19954,post:2:warrior:lv1:k6:d1152,post:3:warrior:lv1:k9:d2560,plot:5:archer:lv5:k36:d8937,plot:9:archer:lv5:k34:d11065,plot:10:corpse_catapult:lv4:k160:d43114,post:4:warrior:lv2:k0:d95,plot:6:frost_wraith:lv3:k8:d3493,post:1:abomination:lv2:k0:d0,plot:14:mage:lv4:k13:d1556,plot:15:mender:lv1:k0:d0
build_steps_done=55/55 chests=0 free_upgrades_left=0
blocker_damage_taken=11824 bodies_lost=110 spells=bone_wall:12,corpse_explosion:43,dread_rally:11,shadow_bolt:153
wave_spawn/clear_s=w1:15.3/28.9 w2:12.6/37.0 w3:9.4/38.2 w4:17.9/57.6 w5:9.9/39.6 w6:8.5/56.9 w7:11.9/61.7 w8:13.6/67.5 w9:12.5/80.5L w10:11.9/80.2 w11:15.9/61.6 w12:15.9/105.1L w13:15.4/73.2 w14:16.8/72.8 w15:13.6/60.2 w16:18.3/74.6 w17:18.1/43.3 w18:20.0/63.5 w19:19.2/67.0 w20:22.8/63.0 w21:21.9/56.8 w22:19.7/63.9 w23:25.5/68.3 w24:26.2/65.2 w25:15.9/98.0
evolutions=1 gravebow synergies=killing_field:2,shatterfall:2
spell_casts/damage=bone_wall:12c/0d,corpse_explosion:43c/6017d,dread_rally:11c/0d,shadow_bolt:153c/8294d
blockers_lost=110 respawned=109 healed=0 risen=0 deep_freezes=40 shatters=0 shrapnel=0 corpses_detonated=163
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=halberd_reach:61,lash_second:24,structures_destroyed:6,vael_calls:8,vael_shieldwalls:8
rule=holy_ward_generators generators_raised=6 destroyed=6
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=175 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:13 end_wave:25 lives_lost:11 body_deaths:110 lives_after_deaths:11 per_death:0.10
minibosses=templar_commander:195:2600:held16:gone@300
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=2 build=march_default speed=8
result=won skulls=3 time=611.32s ticks=36679
waves_cleared=25/25 reached=25 lives=20/20
souls_now=407 earned=4565 spent=4408 earned_by=kills:3665,no_leak:900
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:211,halberdier:29,purifier:104,recruit:78,shieldbearer:161,templar:35,templar_commander:1,vael:1,ward_generator:6
leaks=
damage_by_source=archer:62534,corpse_catapult:48192,corpse_explosion:5083,frost_wraith:3738,mage:35838,shadow_bolt:7461,warrior:4199
towers=plot:1:archer/gravebow:lv5:k67:d21209,plot:12:archer:lv5:k58:d18901,post:0:warrior:lv2:k10:d504,plot:4:mage:lv5:k121:d15461,plot:8:mage:lv5:k88:d18595,post:2:warrior:lv1:k12:d1100,post:3:warrior:lv1:k8:d2564,plot:5:archer:lv5:k37:d10530,plot:9:archer:lv5:k37:d11894,plot:10:corpse_catapult:lv4:k174:d48192,post:4:warrior:lv2:k0:d32,plot:6:frost_wraith:lv3:k9:d3738,post:1:abomination:lv2:k0:d0,plot:14:mage:lv4:k13:d1783,plot:15:mender:lv1:k0:d0
build_steps_done=55/55 chests=1 free_upgrades_left=0
blocker_damage_taken=10638 bodies_lost=98 spells=bone_wall:11,corpse_explosion:42,dread_rally:12,shadow_bolt:153
wave_spawn/clear_s=w1:15.3/28.9 w2:12.6/37.0 w3:9.4/40.8 w4:17.9/59.1 w5:9.9/39.5 w6:8.5/60.9 w7:11.9/59.4 w8:13.6/61.7 w9:12.5/72.5 w10:11.9/76.4 w11:15.9/62.1 w12:15.9/106.2 w13:15.4/63.7 w14:16.8/78.9 w15:13.6/64.7 w16:18.3/67.1 w17:18.1/46.7 w18:20.0/64.2 w19:19.2/62.5 w20:22.8/58.9 w21:21.9/55.5 w22:19.7/58.3 w23:25.5/57.9 w24:26.2/60.9 w25:15.9/98.0
evolutions=1 gravebow synergies=killing_field:2,shatterfall:2
spell_casts/damage=bone_wall:11c/0d,corpse_explosion:42c/5083d,dread_rally:12c/0d,shadow_bolt:153c/7461d
blockers_lost=98 respawned=98 healed=48 risen=0 deep_freezes=44 shatters=0 shrapnel=0 corpses_detonated=170
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=halberd_reach:58,lash_second:20,structures_destroyed:6,vael_calls:8,vael_shieldwalls:8
rule=holy_ward_generators generators_raised=6 destroyed=6
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=375 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:98 lives_after_deaths:0 per_death:0.00
minibosses=templar_commander:195:2600:held13:killed@301
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=1 build=sanctum_default speed=8
result=won skulls=1 time=688.35s ticks=41301
waves_cleared=25/25 reached=25 lives=9/20
souls_now=254 earned=3994 spent=3990 earned_by=kills:3216,no_leak:778
kills=archer:8,banner_bearer:8,battle_sister:23,chaplain:4,confessor_attendant:3,footman:126,halberdier:13,high_confessor:23,purifier:97,radiant_inquisitor:21,recruit:61,sanctified_sentinel:43,seraphine:1,shieldbearer:60,sun_paladin:17,templar:21,ward_crystal:4
leaks=cathedral_guardian:1,radiant_inquisitor:1,sun_paladin:1
damage_by_source=abomination:788,archer:58423,banshee:8,corpse_catapult:77088,corpse_explosion:5670,frost_wraith:2454,mage:66514,shadow_bolt:13867,warrior:4402
towers=plot:6:archer/gravebow:lv5:k72:d27945,post:2:warrior:lv2:k7:d1827,plot:11:archer/gravebow:lv5:k75:d22881,plot:3:mage:lv5:k69:d41534,plot:5:corpse_catapult:lv4:k99:d67618,post:1:warrior:lv1:k7:d2575,plot:7:mage:lv4:k30:d17306,plot:12:archer:lv4:k19:d7597,plot:10:frost_wraith:lv2:k8:d2454,post:3:abomination:lv1:k3:d788,plot:2:mage:lv3:k13:d7674,plot:13:corpse_catapult:lv3:k13:d9471,plot:8:banshee:lv1:k0:d8
build_steps_done=46/55 chests=0 free_upgrades_left=0
blocker_damage_taken=13179 bodies_lost=103 spells=bone_wall:15,corpse_explosion:42,dread_rally:10,shadow_bolt:172
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/51.8 w3:12.2/82.4 w4:13.5/65.1 w5:13.6/94.7 w6:12.5/68.4 w7:12.3/63.1 w8:12.5/97.5 w9:18.7/144.4 w10:10.5/59.7 w11:15.3/97.3 w12:15.9/152.4 w13:21.9/188.3L w14:17.7/117.4 w15:19.4/161.9 w16:22.1/114.9L w17:20.2/109.1L w18:21.1/153.6 w19:20.2/112.2 w20:22.6/104.6 w21:23.8/134.8 w22:22.8/71.6 w23:24.3/100.7 w24:28.9/117.8 w25:19.4/141.3
evolutions=2 gravebow,gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:15c/0d,corpse_explosion:42c/5670d,dread_rally:10c/0d,shadow_bolt:172c/13867d
blockers_lost=103 respawned=102 healed=0 risen=0 deep_freezes=70 shatters=0 shrapnel=0 corpses_detonated=126
reckoning=false reckoning_wave=0 suppressed_tower_s=616.7
events=bumped:1,chambers_broken:2,confessor_heal:26486,confessor_revives:30,guardian_beams:16,guardian_slams:3,halberd_reach:35,holy_zones:76,lash_second:33,seraphine_teleports:7,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=442s,634s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=210 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:20 end_wave:25 lives_lost:11 body_deaths:103 lives_after_deaths:11 per_death:0.11
minibosses=cathedral_guardian:222:4000:held24:gone@410
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=2 build=sanctum_default speed=8
result=won skulls=3 time=657.27s ticks=39436
waves_cleared=25/25 reached=25 lives=20/20
souls_now=62 earned=4256 spent=4444 earned_by=kills:3356,no_leak:900
kills=archer:8,banner_bearer:9,battle_sister:24,cathedral_guardian:1,chaplain:4,confessor_attendant:3,footman:126,halberdier:13,high_confessor:23,purifier:96,radiant_inquisitor:24,recruit:60,sanctified_sentinel:43,seraphine:1,shieldbearer:54,sun_paladin:18,templar:22,ward_crystal:4
leaks=
damage_by_source=abomination:116,archer:58391,corpse_catapult:75478,corpse_explosion:6543,frost_wraith:1510,mage:65471,shadow_bolt:13703,warrior:3768
towers=plot:6:archer/gravebow:lv5:k96:d38165,post:2:warrior:lv2:k7:d1175,plot:11:archer:lv5:k46:d13764,plot:3:mage:lv5:k73:d41580,plot:5:corpse_catapult:lv5:k114:d70983,post:1:warrior:lv1:k4:d2593,plot:7:mage:lv5:k31:d15328,plot:12:archer:lv5:k17:d6462,plot:10:frost_wraith:lv2:k9:d1510,post:3:abomination:lv1:k0:d116,plot:2:mage:lv4:k10:d8563,plot:13:corpse_catapult:lv3:k6:d4495,plot:8:banshee:lv1:k0:d0
build_steps_done=50/55 chests=1 free_upgrades_left=0
blocker_damage_taken=9315 bodies_lost=86 spells=bone_wall:8,corpse_explosion:43,dread_rally:11,shadow_bolt:164
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/52.6 w3:12.2/82.4 w4:13.5/65.2 w5:13.6/95.0 w6:12.5/72.4 w7:12.3/63.1 w8:12.5/101.5 w9:18.7/96.4 w10:10.5/59.7 w11:15.3/89.1 w12:15.9/132.8 w13:21.9/189.6 w14:17.7/103.1 w15:19.4/146.8 w16:22.1/77.3 w17:20.2/107.0 w18:21.1/142.8 w19:20.2/100.1 w20:22.6/65.2 w21:23.8/98.6 w22:22.8/69.2 w23:24.3/71.4 w24:28.9/91.3 w25:19.4/110.2
evolutions=1 gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:8c/0d,corpse_explosion:43c/6543d,dread_rally:11c/0d,shadow_bolt:164c/13703d
blockers_lost=86 respawned=86 healed=0 risen=0 deep_freezes=52 shatters=0 shrapnel=0 corpses_detonated=141
reckoning=false reckoning_wave=0 suppressed_tower_s=533.8
events=bumped:2,chambers_broken:2,confessor_heal:21598,confessor_revives:27,guardian_beams:16,guardian_slams:5,halberd_reach:23,holy_zones:63,lash_second:12,seraphine_teleports:8,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=411s,526s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=450 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:86 lives_after_deaths:0 per_death:0.00
minibosses=cathedral_guardian:222:4000:held34:killed@411
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
