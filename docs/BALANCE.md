# Balance

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

### Act I baseline summaries (the same-seed gate; re-recorded by the wave 2b integration, DECISIONS X3)

Default build, Necromancer, `--autotest --map=<id> --seed=<n>`; the lines from
`TDAUTOTEST SUMMARY`. A change that must not touch Act I reproduces these byte
for byte. Wave 2b changed them on purpose (miniboss targeting / hold / row HP,
deferred evolve steps, the `minibosses=` line); the wave 2a set is in git history.

```
TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=1 build=graveyard_default speed=8
result=won skulls=3 time=447.15s ticks=26829
waves_cleared=22/22 reached=22 lives=20/20
souls_now=85 earned=2864 spent=2929 earned_by=kills:2138,no_leak:726
kills=alaric:1,archer:64,chaplain:28,footman:130,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=
damage_by_source=abomination:108,archer:36122,corpse_catapult:24486,corpse_explosion:6791,frost_wraith:979,mage:29520,shadow_bolt:6416,warrior:3951
towers=plot:4:archer/gravebow:lv5:k88:d18626,post:0:warrior:lv2:k29:d3522,plot:5:archer:lv5:k71:d15666,plot:3:mage:lv5:k46:d29520,post:1:warrior:lv1:k1:d428,plot:8:frost_wraith:lv3:k6:d979,plot:10:corpse_catapult:lv4:k111:d24486,post:2:abomination:lv2:k1:d108,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k3:d1830,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=35/45 chests=1 free_upgrades_left=0
blocker_damage_taken=7210 bodies_lost=52 spells=bone_wall:1,corpse_explosion:32,dread_rally:7,shadow_bolt:112
wave_spawn/clear_s=w1:9.5/22.6 w2:11.9/26.6 w3:10.2/26.4 w4:10.8/25.3 w5:11.3/25.0 w6:11.0/30.8 w7:15.4/36.4 w8:13.8/26.9 w9:12.7/29.2 w10:14.1/50.0 w11:14.9/87.2 w12:10.2/60.8 w13:16.0/75.9 w14:12.4/45.7 w15:13.2/52.0 w16:13.6/43.0 w17:17.8/44.8 w18:12.2/38.1 w19:17.0/30.9 w20:14.9/54.2 w21:18.9/47.9 w22:17.8/60.6
evolutions=1 gravebow synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:1c/0d,corpse_explosion:32c/6791d,dread_rally:7c/0d,shadow_bolt:112c/6416d
blockers_lost=52 respawned=50 healed=760 risen=0 deep_freezes=8 shatters=0 shrapnel=0 corpses_detonated=148
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:1
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=300 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:22 lives_lost:0 body_deaths:52 lives_after_deaths:0 per_death:0.00
minibosses=inquisitor:170:3200:held10:killed@258
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=2 build=graveyard_default speed=8
result=won skulls=1 time=486.85s ticks=29211
waves_cleared=22/22 reached=22 lives=4/20
souls_now=201 earned=2733 spent=2682 earned_by=kills:2081,no_leak:652
kills=alaric:1,archer:63,chaplain:25,footman:124,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=archer:1,chaplain:3,footman:6
damage_by_source=abomination:452,archer:32877,corpse_catapult:24509,corpse_explosion:7796,frost_wraith:1640,mage:30582,shadow_bolt:8365,warrior:4528
towers=plot:4:archer:lv5:k77:d16891,post:0:warrior:lv2:k41:d3608,plot:5:archer:lv5:k72:d14600,plot:3:mage:lv5:k27:d30582,post:1:warrior:lv1:k7:d920,plot:8:frost_wraith:lv3:k5:d1640,plot:10:corpse_catapult:lv4:k111:d24509,post:2:abomination:lv2:k1:d452,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k13:d1386,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=34/45 chests=1 free_upgrades_left=0
blocker_damage_taken=8584 bodies_lost=59 spells=bone_wall:3,corpse_explosion:31,dread_rally:6,shadow_bolt:122
wave_spawn/clear_s=w1:9.5/21.1 w2:11.9/26.8 w3:10.2/26.4 w4:10.8/39.3 w5:11.3/35.7 w6:11.0/42.7 w7:15.4/47.3 w8:13.8/51.5 w9:12.7/36.1 w10:14.1/54.3 w11:14.9/122.4 w12:10.2/59.5 w13:16.0/85.6L w14:12.4/62.2L w15:13.2/62.1 w16:13.6/39.9 w17:17.8/49.0 w18:12.2/34.5 w19:17.0/32.7 w20:14.9/52.9 w21:18.9/49.9 w22:17.8/100.3
evolutions=0  synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:3c/0d,corpse_explosion:31c/7796d,dread_rally:6c/0d,shadow_bolt:122c/8365d
blockers_lost=59 respawned=59 healed=996 risen=0 deep_freezes=20 shatters=0 shrapnel=0 corpses_detonated=145
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:3
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=140 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:17 end_wave:22 lives_lost:16 body_deaths:59 lives_after_deaths:16 per_death:0.27
minibosses=inquisitor:170:3200:held18:killed@293
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
result=won skulls=1 time=682.63s ticks=40958
waves_cleared=25/25 reached=25 lives=3/20
souls_now=250 earned=3990 spent=3990 earned_by=kills:3252,no_leak:738
kills=archer:8,banner_bearer:9,battle_sister:23,chaplain:4,confessor_attendant:3,footman:126,halberdier:13,high_confessor:23,purifier:97,radiant_inquisitor:21,recruit:61,sanctified_sentinel:42,seraphine:1,shieldbearer:60,sun_paladin:18,templar:23,ward_crystal:4
leaks=cathedral_guardian:1,radiant_inquisitor:2,sanctified_sentinel:1,sun_paladin:1
damage_by_source=abomination:648,archer:61559,banshee:8,corpse_catapult:76807,corpse_explosion:5092,frost_wraith:2553,mage:66005,shadow_bolt:14004,warrior:4442
towers=plot:6:archer/gravebow:lv5:k79:d32330,post:2:warrior:lv2:k9:d1934,plot:11:archer/gravebow:lv5:k73:d22527,plot:3:mage:lv5:k70:d41280,plot:5:corpse_catapult:lv4:k99:d69704,post:1:warrior:lv1:k6:d2508,plot:7:mage:lv4:k39:d17506,plot:12:archer:lv4:k18:d6702,plot:10:frost_wraith:lv2:k6:d2553,post:3:abomination:lv1:k1:d648,plot:2:mage:lv3:k8:d7220,plot:13:corpse_catapult:lv3:k10:d7102,plot:8:banshee:lv1:k0:d8
build_steps_done=46/55 chests=0 free_upgrades_left=0
blocker_damage_taken=13270 bodies_lost=105 spells=bone_wall:13,corpse_explosion:44,dread_rally:10,shadow_bolt:171
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/51.8 w3:12.2/82.4 w4:13.5/65.1 w5:13.6/94.7 w6:12.5/68.4 w7:12.3/63.1 w8:12.5/97.5 w9:18.7/144.4 w10:10.5/59.7 w11:15.3/97.3 w12:15.9/152.4 w13:21.9/189.3L w14:17.7/117.9 w15:19.4/163.8L w16:22.1/115.3L w17:20.2/110.2L w18:21.1/149.9 w19:20.2/106.4 w20:22.6/94.6 w21:23.8/131.5 w22:22.8/70.6 w23:24.3/111.2 w24:28.9/107.5 w25:19.4/135.5
evolutions=2 gravebow,gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:13c/0d,corpse_explosion:44c/5092d,dread_rally:10c/0d,shadow_bolt:171c/14004d
blockers_lost=105 respawned=104 healed=0 risen=0 deep_freezes=68 shatters=0 shrapnel=0 corpses_detonated=128
reckoning=false reckoning_wave=0 suppressed_tower_s=579.7
events=chambers_broken:2,confessor_heal:26822,confessor_revives:35,guardian_beams:16,guardian_slams:5,halberd_reach:30,holy_zones:70,lash_second:31,seraphine_teleports:7,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=442s,626s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=210 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:20 end_wave:25 lives_lost:17 body_deaths:105 lives_after_deaths:17 per_death:0.16
minibosses=cathedral_guardian:222:4000:held27:gone@411
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=2 build=sanctum_default speed=8
result=won skulls=3 time=664.68s ticks=39881
waves_cleared=25/25 reached=25 lives=20/20
souls_now=162 earned=4250 spent=4338 earned_by=kills:3350,no_leak:900
kills=archer:8,banner_bearer:8,battle_sister:25,cathedral_guardian:1,chaplain:4,confessor_attendant:3,footman:126,halberdier:13,high_confessor:23,purifier:97,radiant_inquisitor:22,recruit:60,sanctified_sentinel:43,seraphine:1,shieldbearer:55,sun_paladin:19,templar:22,ward_crystal:4
leaks=
damage_by_source=abomination:328,archer:58776,banshee:1,corpse_catapult:75215,corpse_explosion:6345,frost_wraith:1507,mage:66618,shadow_bolt:14075,warrior:3233
towers=plot:6:archer/gravebow:lv5:k97:d38384,post:2:warrior:lv2:k7:d868,plot:11:archer:lv5:k49:d14307,plot:3:mage:lv5:k68:d41414,plot:5:corpse_catapult:lv5:k121:d70873,post:1:warrior:lv1:k5:d2365,plot:7:mage:lv5:k33:d15612,plot:12:archer:lv5:k19:d6085,plot:10:frost_wraith:lv2:k8:d1507,post:3:abomination:lv1:k1:d328,plot:2:mage:lv4:k11:d9592,plot:13:corpse_catapult:lv3:k4:d4342,plot:8:banshee:lv1:k0:d1
build_steps_done=50/55 chests=1 free_upgrades_left=0
blocker_damage_taken=8955 bodies_lost=82 spells=bone_wall:9,corpse_explosion:41,dread_rally:11,shadow_bolt:166
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/52.6 w3:12.2/82.4 w4:13.5/65.2 w5:13.6/95.0 w6:12.5/72.4 w7:12.3/63.1 w8:12.5/101.5 w9:18.7/96.4 w10:10.5/59.7 w11:15.3/89.1 w12:15.9/132.8 w13:21.9/191.5 w14:17.7/108.8 w15:19.4/147.1 w16:22.1/117.7 w17:20.2/107.0 w18:21.1/138.3 w19:20.2/108.0 w20:22.6/64.0 w21:23.8/95.1 w22:22.8/66.7 w23:24.3/72.9 w24:28.9/89.9 w25:19.4/117.6
evolutions=1 gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:9c/0d,corpse_explosion:41c/6345d,dread_rally:11c/0d,shadow_bolt:166c/14075d
blockers_lost=82 respawned=82 healed=0 risen=0 deep_freezes=49 shatters=0 shrapnel=0 corpses_detonated=141
reckoning=false reckoning_wave=0 suppressed_tower_s=534.9
events=chambers_broken:2,confessor_heal:21444,confessor_revives:28,guardian_beams:16,guardian_slams:6,halberd_reach:19,holy_zones:65,lash_second:15,seraphine_teleports:7,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=371s,516s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=450 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:82 lives_after_deaths:0 per_death:0.00
minibosses=cathedral_guardian:222:4000:held35:killed@413
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
