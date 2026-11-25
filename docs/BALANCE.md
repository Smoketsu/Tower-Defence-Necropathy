# Balance

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

### Act I baseline summaries (the same-seed gate from wave 2a on)

Default build, Necromancer, `--autotest --map=<id> --seed=<n>`; the lines from
`TDAUTOTEST SUMMARY`. A change that must not touch Act I reproduces these byte
for byte.

```
TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=1 build=graveyard_default speed=8
result=won skulls=3 time=454.65s ticks=27279
waves_cleared=22/22 reached=22 lives=20/20
souls_now=71 earned=2864 spent=2943 earned_by=kills:2138,no_leak:726
kills=alaric:1,archer:64,chaplain:28,footman:130,inquisitor:1,purifier:80,recruit:116,templar:46
leaks=
damage_by_source=abomination:381,archer:35523,corpse_catapult:24183,corpse_explosion:6045,frost_wraith:945,mage:31689,shadow_bolt:7365,warrior:3879
towers=plot:4:archer/gravebow:lv5:k87:d18687,post:0:warrior:lv2:k27:d3363,plot:5:archer:lv5:k86:d15233,plot:3:mage:lv5:k42:d31689,post:1:warrior:lv1:k2:d517,plot:8:frost_wraith:lv3:k10:d945,plot:10:corpse_catapult:lv4:k91:d24183,post:2:abomination:lv2:k4:d381,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k12:d1602,plot:11:mage:lv3:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=36/45 chests=1 free_upgrades_left=0
blocker_damage_taken=7568 bodies_lost=52 spells=bone_wall:2,corpse_explosion:31,dread_rally:7,shadow_bolt:114
wave_spawn/clear_s=w1:9.5/22.6 w2:11.9/26.6 w3:10.2/26.4 w4:10.8/25.3 w5:11.3/25.0 w6:11.0/30.8 w7:15.4/36.4 w8:13.8/26.9 w9:12.7/29.2 w10:14.1/50.0 w11:14.9/126.4 w12:10.2/58.4 w13:16.0/75.2 w14:12.4/49.7 w15:13.2/62.2 w16:13.6/39.6 w17:17.8/41.5 w18:12.2/36.7 w19:17.0/30.3 w20:14.9/62.5 w21:18.9/51.0 w22:17.8/68.1
evolutions=1 gravebow synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:2c/0d,corpse_explosion:31c/6045d,dread_rally:7c/0d,shadow_bolt:114c/7365d
blockers_lost=52 respawned=52 healed=858 risen=0 deep_freezes=13 shatters=0 shrapnel=0 corpses_detonated=155
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:2
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=300 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:22 lives_lost:0 body_deaths:52 lives_after_deaths:0 per_death:0.00
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=graveyard difficulty=necromancer seed=2 build=graveyard_default speed=8
result=won skulls=2 time=493.83s ticks=29630
waves_cleared=22/22 reached=22 lives=15/20
souls_now=129 earned=2752 spent=2773 earned_by=kills:2058,no_leak:694
kills=alaric:1,archer:64,chaplain:28,footman:130,purifier:80,recruit:116,templar:46
leaks=inquisitor:1
damage_by_source=abomination:500,archer:33347,corpse_catapult:27487,corpse_explosion:5241,frost_wraith:1262,mage:30306,shadow_bolt:8860,warrior:4329
towers=plot:4:archer:lv5:k69:d16767,post:0:warrior:lv2:k33:d3497,plot:5:archer:lv5:k86:d14926,plot:3:mage:lv5:k45:d30306,post:1:warrior:lv1:k9:d832,plot:8:frost_wraith:lv3:k7:d1262,plot:10:corpse_catapult:lv4:k108:d27487,post:2:abomination:lv2:k3:d500,plot:9:mender:lv1:k0:d0,plot:6:archer:lv2:k14:d1654,plot:11:mage:lv2:k0:d0,post:3:warrior:lv1:k0:d0
build_steps_done=34/45 chests=0 free_upgrades_left=0
blocker_damage_taken=8930 bodies_lost=64 spells=bone_wall:3,corpse_explosion:31,dread_rally:6,shadow_bolt:124
wave_spawn/clear_s=w1:9.5/21.1 w2:11.9/26.8 w3:10.2/26.4 w4:10.8/39.3 w5:11.3/35.7 w6:11.0/42.7 w7:15.4/47.3 w8:13.8/51.5 w9:12.7/36.1 w10:14.1/54.3 w11:14.9/132.0L w12:10.2/52.9 w13:16.0/79.3 w14:12.4/50.6 w15:13.2/62.1 w16:13.6/41.3 w17:17.8/51.1 w18:12.2/51.8 w19:17.0/35.6 w20:14.9/61.8 w21:18.9/52.0 w22:17.8/107.2
evolutions=0  synergies=flesh_rampart:2,killing_field:2
spell_casts/damage=bone_wall:3c/0d,corpse_explosion:31c/5241d,dread_rally:6c/0d,shadow_bolt:124c/8860d
blockers_lost=64 respawned=64 healed=798 risen=0 deep_freezes=19 shatters=0 shrapnel=0 corpses_detonated=127
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=alaric_charges:3
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=220 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:17 end_wave:22 lives_lost:5 body_deaths:64 lives_after_deaths:5 per_death:0.08
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=1 build=march_default speed=8
result=won skulls=1 time=644.60s ticks=38676
waves_cleared=25/25 reached=25 lives=9/20
souls_now=1469 earned=4489 spent=3270 earned_by=kills:3651,no_leak:838
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:229,halberdier:27,purifier:104,recruit:78,shieldbearer:173,templar:35,vael:1,ward_generator:6
leaks=halberdier:2,templar_commander:1
damage_by_source=abomination:85,archer:59871,corpse_catapult:44012,corpse_explosion:6789,frost_wraith:2743,mage:42366,shadow_bolt:8653,warrior:4717
towers=plot:1:archer:lv5:k54:d20500,plot:12:archer:lv5:k68:d19776,post:0:warrior:lv2:k9:d532,plot:4:mage:lv5:k132:d19821,plot:8:mage:lv5:k113:d22014,post:2:warrior:lv1:k9:d1270,post:3:warrior:lv1:k14:d2812,plot:5:archer:lv4:k25:d8659,plot:9:archer:lv4:k28:d10936,plot:10:corpse_catapult:lv3:k161:d44012,post:4:warrior:lv1:k0:d103,plot:6:frost_wraith:lv1:k11:d2743,post:1:abomination:lv1:k0:d85,plot:14:mage:lv1:k6:d531
build_steps_done=40/55 chests=0 free_upgrades_left=0
blocker_damage_taken=12528 bodies_lost=112 spells=bone_wall:13,corpse_explosion:44,dread_rally:12,shadow_bolt:161
wave_spawn/clear_s=w1:15.3/28.9 w2:12.6/37.0 w3:9.4/38.2 w4:17.9/57.6 w5:9.9/39.6 w6:8.5/56.9 w7:11.9/61.7 w8:13.6/67.5 w9:12.5/80.5L w10:11.9/80.2 w11:15.9/61.6 w12:15.9/103.5L w13:15.4/63.2 w14:16.8/70.0 w15:13.6/63.7 w16:18.3/70.9 w17:18.1/41.5 w18:20.0/59.3 w19:19.2/70.7 w20:22.8/66.4 w21:21.9/55.4 w22:19.7/60.5 w23:25.5/63.3 w24:26.2/63.9 w25:15.9/131.2
evolutions=0  synergies=killing_field:2,shatterfall:2
spell_casts/damage=bone_wall:13c/0d,corpse_explosion:44c/6789d,dread_rally:12c/0d,shadow_bolt:161c/8653d
blockers_lost=112 respawned=112 healed=0 risen=0 deep_freezes=41 shatters=0 shrapnel=0 corpses_detonated=175
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=halberd_reach:55,lash_second:30,structures_destroyed:6,vael_calls:11,vael_shieldwalls:11
rule=holy_ward_generators generators_raised=6 destroyed=6
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=175 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:13 end_wave:25 lives_lost:11 body_deaths:112 lives_after_deaths:11 per_death:0.10
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=crimson_march difficulty=necromancer seed=2 build=march_default speed=8
result=won skulls=3 time=610.23s ticks=36614
waves_cleared=25/25 reached=25 lives=20/20
souls_now=197 earned=4565 spent=4618 earned_by=kills:3665,no_leak:900
kills=archer:33,banner_bearer:20,battle_sister:31,chaplain:31,footman:211,halberdier:29,purifier:104,recruit:78,shieldbearer:161,templar:35,templar_commander:1,vael:1,ward_generator:6
leaks=
damage_by_source=archer:67643,corpse_catapult:44024,corpse_explosion:7433,frost_wraith:3204,mage:32166,shadow_bolt:7461,warrior:4649
towers=plot:1:archer/gravebow:lv5:k72:d25462,plot:12:archer/gravebow:lv5:k67:d20609,post:0:warrior:lv2:k9:d469,plot:4:mage:lv5:k95:d13326,plot:8:mage:lv5:k94:d18042,post:2:warrior:lv1:k11:d1446,post:3:warrior:lv1:k9:d2688,plot:5:archer:lv5:k41:d10236,plot:9:archer:lv5:k32:d11336,plot:10:corpse_catapult:lv4:k159:d44024,post:4:warrior:lv2:k0:d46,plot:6:frost_wraith:lv3:k12:d3204,post:1:abomination:lv2:k0:d0,plot:14:mage:lv4:k11:d798,plot:15:mender:lv1:k0:d0
build_steps_done=55/55 chests=1 free_upgrades_left=0
blocker_damage_taken=10780 bodies_lost=97 spells=bone_wall:10,corpse_explosion:43,dread_rally:11,shadow_bolt:153
wave_spawn/clear_s=w1:15.3/28.9 w2:12.6/37.0 w3:9.4/40.8 w4:17.9/59.1 w5:9.9/39.5 w6:8.5/60.9 w7:11.9/59.4 w8:13.6/61.7 w9:12.5/72.5 w10:11.9/76.4 w11:15.9/62.1 w12:15.9/102.2 w13:15.4/66.1 w14:16.8/74.9 w15:13.6/60.8 w16:18.3/68.1 w17:18.1/42.7 w18:20.0/58.1 w19:19.2/61.0 w20:22.8/64.9 w21:21.9/54.2 w22:19.7/59.0 w23:25.5/59.9 w24:26.2/65.4 w25:15.9/96.9
evolutions=2 gravebow,gravebow synergies=killing_field:2,shatterfall:2
spell_casts/damage=bone_wall:10c/0d,corpse_explosion:43c/7433d,dread_rally:11c/0d,shadow_bolt:153c/7461d
blockers_lost=97 respawned=96 healed=0 risen=0 deep_freezes=40 shatters=0 shrapnel=0 corpses_detonated=189
reckoning=false reckoning_wave=0 suppressed_tower_s=0.0
events=halberd_reach:50,lash_second:18,structures_destroyed:6,vael_calls:8,vael_shieldwalls:8
rule=holy_ward_generators generators_raised=6 destroyed=6
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=375 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:0 end_wave:25 lives_lost:0 body_deaths:97 lives_after_deaths:0 per_death:0.00
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=1 build=sanctum_default speed=8
result=won skulls=2 time=688.62s ticks=41317
waves_cleared=25/25 reached=25 lives=17/20
souls_now=703 earned=4170 spent=3717 earned_by=kills:3314,no_leak:856
kills=archer:8,banner_bearer:6,battle_sister:24,cathedral_guardian:1,chaplain:4,confessor_attendant:3,footman:122,halberdier:13,high_confessor:23,purifier:95,radiant_inquisitor:23,recruit:61,sanctified_sentinel:43,seraphine:1,shieldbearer:56,sun_paladin:20,templar:21,ward_crystal:4
leaks=banner_bearer:1
damage_by_source=abomination:264,archer:58222,banshee:1,corpse_catapult:70458,corpse_explosion:7377,frost_wraith:1096,mage:62498,shadow_bolt:14615,warrior:3074
towers=plot:6:archer/gravebow:lv5:k107:d37075,post:2:warrior:lv2:k1:d788,plot:11:archer:lv5:k46:d15527,plot:3:mage:lv5:k80:d41504,plot:5:corpse_catapult:lv4:k111:d65536,post:1:warrior:lv1:k10:d2286,plot:7:mage:lv4:k35:d13140,plot:12:archer:lv4:k9:d5620,plot:10:frost_wraith:lv2:k3:d1096,post:3:abomination:lv1:k0:d264,plot:2:mage:lv3:k8:d7854,plot:13:corpse_catapult:lv3:k9:d4923,plot:8:banshee:lv1:k0:d1
build_steps_done=45/55 chests=1 free_upgrades_left=0
blocker_damage_taken=9588 bodies_lost=80 spells=bone_wall:7,corpse_explosion:40,dread_rally:10,shadow_bolt:172
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/51.8 w3:12.2/82.4 w4:13.5/65.1 w5:13.6/94.4 w6:12.5/66.6 w7:12.3/63.1 w8:12.5/97.5 w9:18.7/95.3 w10:10.5/61.4 w11:15.3/75.3 w12:15.9/88.2 w13:21.9/203.7 w14:17.7/68.9 w15:19.4/162.7 w16:22.1/73.8 w17:20.2/109.2L w18:21.1/138.1 w19:20.2/103.1 w20:22.6/68.0 w21:23.8/101.2 w22:22.8/67.9 w23:24.3/71.1 w24:28.9/89.2 w25:19.4/141.5
evolutions=1 gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:7c/0d,corpse_explosion:40c/7377d,dread_rally:10c/0d,shadow_bolt:172c/14615d
blockers_lost=80 respawned=79 healed=0 risen=0 deep_freezes=41 shatters=0 shrapnel=0 corpses_detonated=165
reckoning=false reckoning_wave=0 suppressed_tower_s=520.3
events=chambers_broken:2,confessor_heal:19376,confessor_revives:23,guardian_beams:17,guardian_slams:6,halberd_reach:30,holy_zones:61,lash_second:16,seraphine_teleports:7,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=496s,544s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=330 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:21 end_wave:25 lives_lost:3 body_deaths:80 lives_after_deaths:3 per_death:0.04
stuck_enemies=0 alive_at_end=0

TDAUTOTEST SUMMARY
map=sanctum difficulty=necromancer seed=2 build=sanctum_default speed=8
result=won skulls=2 time=669.80s ticks=40188
waves_cleared=25/25 reached=25 lives=15/20
souls_now=88 earned=4080 spent=4242 earned_by=kills:3216,no_leak:864
kills=archer:8,banner_bearer:7,battle_sister:21,chaplain:4,confessor_attendant:3,footman:124,halberdier:14,high_confessor:23,purifier:95,radiant_inquisitor:22,recruit:61,sanctified_sentinel:43,seraphine:1,shieldbearer:56,sun_paladin:18,templar:23,ward_crystal:4
leaks=cathedral_guardian:1
damage_by_source=abomination:302,archer:61614,corpse_catapult:68624,corpse_explosion:6840,frost_wraith:1576,mage:64866,shadow_bolt:13801,warrior:3557
towers=plot:6:archer/gravebow:lv5:k93:d36132,post:2:warrior:lv2:k10:d1037,plot:11:archer/gravebow:lv5:k67:d18427,plot:3:mage:lv5:k63:d40942,plot:5:corpse_catapult:lv5:k99:d62843,post:1:warrior:lv1:k10:d2519,plot:7:mage:lv4:k36:d17398,plot:12:archer:lv4:k17:d7054,plot:10:frost_wraith:lv2:k6:d1576,post:3:abomination:lv1:k0:d302,plot:2:mage:lv3:k10:d6527,plot:13:corpse_catapult:lv3:k6:d5781,plot:8:banshee:lv1:k0:d0
build_steps_done=47/55 chests=0 free_upgrades_left=0
blocker_damage_taken=9637 bodies_lost=86 spells=bone_wall:7,corpse_explosion:40,dread_rally:10,shadow_bolt:167
wave_spawn/clear_s=w1:13.8/45.3 w2:10.7/52.6 w3:12.2/82.4 w4:13.5/61.7 w5:13.6/95.0 w6:12.5/66.6 w7:12.3/59.3 w8:12.5/101.8 w9:18.7/95.7 w10:10.5/63.9 w11:15.3/80.4 w12:15.9/97.4 w13:21.9/193.2L w14:17.7/93.6 w15:19.4/158.7 w16:22.1/80.1 w17:20.2/102.6 w18:21.1/142.0 w19:20.2/106.4 w20:22.6/68.2 w21:23.8/119.9 w22:22.8/73.4 w23:24.3/80.1 w24:28.9/90.3 w25:19.4/122.7
evolutions=2 gravebow,gravebow synergies=shatterfall:2
spell_casts/damage=bone_wall:7c/0d,corpse_explosion:40c/6840d,dread_rally:10c/0d,shadow_bolt:167c/13801d
blockers_lost=86 respawned=86 healed=0 risen=0 deep_freezes=48 shatters=0 shrapnel=0 corpses_detonated=142
reckoning=false reckoning_wave=0 suppressed_tower_s=548.0
events=chambers_broken:2,confessor_heal:24498,confessor_revives:22,guardian_beams:16,guardian_slams:4,halberd_reach:27,holy_zones:64,lash_second:17,seraphine_teleports:7,structures_destroyed:4
rule=sanctified_chambers crystals_broken=4/4 chambers_broken_at=597s,573s
meta=none character=gravecaller loadout=shadow_bolt,bone_wall,corpse_explosion ash=330 bonuses= masteries=0 saved=false
leak_curve=first_leak_wave:20 end_wave:25 lives_lost:5 body_deaths:86 lives_after_deaths:5 per_death:0.06
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
