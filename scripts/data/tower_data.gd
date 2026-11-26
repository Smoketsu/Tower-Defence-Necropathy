## TowerData: the eight Act I towers (GDD §4.1), Necropathy's summon classes
## placed on grave plots (ranged / support) or road posts (blockers). Base
## numbers start from Necropathy's UnitData rows and are rescaled for the road;
## all of them are TUNING until the balance pass. Stats reach a tower only
## through Tower.recompute() (the one stat path). Data only, no logic.
##
## To add a tower: add a TOWERS row (and its LEVELS rows), list it in ORDER,
## optionally write scripts/towers/<behavior>.gd (extends TowerBehavior).
class_name TowerData
extends RefCounted

## Build-menu order of the towers.
const ORDER: Array[String] = ["archer", "mage", "frost_wraith", "corpse_catapult", "banshee", "mender", "warrior", "abomination",
	"warder", "rogue", "gargoyle", "bone_hound", "fallen_seraph", "bone_golem",
	"powder_wraith", "blood_spawn", "fallen_hero", "bound_oni",
	"draugr_thane"]  # Later towers (GDD §4.2): appended; locked rows hide in the menus (Unlocks)

## Targeting modes (GDD §4.3), in the order the Target button cycles them.
const TARGET_MODES: Array[String] = ["first", "last", "strongest", "nearest"]

## Tower rows. Keys (every row has the common ones):
##   name          — UI name.
##   sprite        — SpriteData key of the unit drawn on the spot.
##   icon          — icons/<id> key for menus.
##   spot          — "plot" (beside the road) or "post" (on the road: a blocker).
##   cost          — souls to raise it (level 1); upgrades / evolution scale from it.
##   behavior      — scripts/towers/<id>.gd loaded by name: "projectile" (shoots
##                   the target), "aura" (pulses on everything in range), "blocker",
##                   or the class kit that extends one of them (archer, mage,
##                   frost_wraith, corpse_catapult, banshee, mender, warrior,
##                   abomination; each script documents its special and the
##                   evolution keys it reads from EvolutionData "set").
##   range         — px; targeting radius (blockers: their melee reach, unused).
##   damage        — damage per shot / pulse / body hit.
##   interval      — s between shots / pulses / body hits.
##   target        — default targeting mode (TARGET_MODES).
## Projectile keys:
##   projectile    — SpriteData FLAT key of the shot; projectile_speed px/s.
##   splash        — px; 0 = single target, else everything within it is hit.
##   slow          — speed multiplier (0..1) applied on hit; 1 = none.
##   slow_time     — s the slow lasts.
##   freeze_every  — every Nth hit freezes the target for freeze_time s (0 = never).
##   pierce        — extra enemies a shot passes through (0 = stops on the first).
##   armour_pierce — flat armour ignored by its hits (0+).
##   freeze_radius — Frost Wraith: px around a Deep Freeze bolt's impact frozen at once.
##   arc_time      — Catapult: s a lobbed boulder flies (its landing telegraph shows meanwhile).
##   volley        — Lv3+ volley (Necropathy's bullet heaven pass): {every: shots
##                   between volleys, count: extra shots, damage: fraction of a
##                   shot's damage, sprite: volleys/<id> key, tint: Color,
##                   reach: optional px searched for volley targets (blockers;
##                   default the tower's range)}.
## Aura keys:
##   affects       — "enemies" or "blockers".
##   slow / slow_time — as above, applied to every enemy in range each pulse.
##   weaken        — multiplier (0..1) on the damage those enemies deal; weaken_time s.
##   heal          — HP restored to every blocker body in range each pulse.
##   windup        — Banshee: s it draws breath (the telegraph) before each wail.
## Blocker keys:
##   bodies        — undead standing on the post at level 1 (LEVELS add more).
##   body_hp       — HP of one body.
##   hold          — enemies one body holds at once.
##   hits_all_held — true: each hit strikes every enemy the body holds (a stomp).
##   respawn       — s before a fallen body returns, free (GDD §4.3).
##   stagger_time  — Abomination: s each stomp staggers what it holds (no attacks).
##   evolution     — id of its EvolutionData row (hidden tier 6), "" = none.
## Later-tower keys (gw2-kit, DECISIONS K1-K9; read by Unlocks, Tower and the kits):
##   unlock        — optional Unlocks spec ({"map": id} = beat that map's boss;
##                   {"map": id, "skulls": n}); absent = open from the start.
##   desc          — optional one-line role shown in the Codex.
##   ground_only   — optional, default false: true = never targets flying enemies (the
##                   act framework's key, read by Tower.pick_target(); the Rogue and the
##                   Hounds run on the road; the Gargoyle prefers flyers, DECISIONS K5).
##   family        — optional Ossuary tree family override ("ranged"|"aura"|"blocker").
##   barrier       — Warder: barrier HP put on each blocker body in range per ward (x the "hp" multiplier).
##   barrier_time  — Warder: s a barrier lasts before it fades.
##   dash_time     — Rogue: s its dash out to the target takes (it strikes on arrival).
##   linger        — Rogue: s it stays by its victim before running back (as long again to return).
##   elite_bonus   — Rogue / Hounds: targeting score bonus of elites, minibosses and bosses.
##   bleed_dps / bleed_time — Rogue: bleed damage over time (per s) and its length (s).
##   chain_dashes / chain_radius — Rogue (Shadow Reaper): extra enemies struck within that radius of the victim.
##   kill_reset    — Rogue (Shadow Reaper): fraction of the cooldown refunded when a dash kills.
##   patrol_r / patrol_speed — Gargoyle: radius (px) of its circle over the plot, radians/s around it.
##   dive_time     — Gargoyle: s from take-off to the landing hit.
##   swoop_mark    — Gargoyle: s the landing marks enemies "swooped" (Death from Above / Wild Hunt read it).
##   air_bonus / air_mult — Gargoyle: targeting score bonus and damage multiplier vs flyers.
##   dive_stun     — Gargoyle (Cathedral Horror): s the landing freezes what it hits (0 = none).
##   stone_time    — Gargoyle (Cathedral Horror): s it stands as stone after a landing (visual + no attack).
##   pack          — Bone Hounds: hounds in the pack at level 1 (LEVELS "bodies" override it).
##   hound_speed   — Bone Hounds: px/s a hound runs.
##   kennel_dx / kennel_dy — Bone Hounds: px between hounds resting on the plot, across / in depth.
##   pack_bonus / pack_max — Bone Hounds: + damage fraction per other hound biting the same prey, and its cap.
##   burn_dps / burn_time — Bone Hounds (Hellhound): fire damage over time per bite.
##   feathers      — Fallen Seraph: feathers per shot (each at a different enemy in range).
##   ruin_every / ruin_mult / ruin_radius — Fallen Seraph (Seraph of Ruin): every Nth shot a dive on the
##                   strongest enemy for ruin_mult x damage within ruin_radius px.
##   slam_every / slam_mult — Bone Golem: every Nth strike slams all it holds for slam_mult x damage and staggers them.
##   hunger_heal   — Bone Golem: HP restored to a body when an enemy it holds dies.
##   plant_frac / plant_cut — Bone Golem: below this HP fraction it plants and takes plant_cut of each hit (Bulwark).
##   drink_share   — Blood Spawn: share (0..1) of each strike's damage healed back to the striking body (Bloodthirst).
##   spill_share / spill_radius — Blood Spawn (Nosferatu): share of the drink its body cannot hold given to the
##                   most wounded other blocker body within spill_radius px.
const TOWERS: Dictionary = {
	"archer": {
		"name": "Skeleton Archer", "sprite": "summons/archer", "icon": "archer", "spot": "plot",
		"cost": 70,  # TUNING (not in GDD) GDD §8.1 range 40-140
		"behavior": "archer",
		"range": 165.0,  # TUNING (not in GDD) Necropathy archer 170
		"damage": 12.0,  # TUNING (not in GDD)
		"interval": 0.8,  # TUNING (not in GDD)
		"target": "first",
		"projectile": "projectiles/arrow", "projectile_speed": 520.0,  # TUNING (not in GDD)
		"splash": 0.0, "slow": 1.0, "slow_time": 0.0, "freeze_every": 0, "freeze_time": 0.0,
		"pierce": 0, "armour_pierce": 0.0,
		"volley": {"every": 4, "count": 3, "damage": 0.6, "sprite": "volleys/dagger", "tint": Color(0.6, 1.0, 0.7)},  # TUNING (not in GDD)
		"evolution": "gravebow",
	},
	"mage": {
		"name": "Bone Mage", "sprite": "summons/mage", "icon": "mage", "spot": "plot",
		"cost": 100,  # TUNING (not in GDD)
		"behavior": "mage",
		"range": 135.0,  # TUNING (not in GDD) Necropathy mage 145
		"damage": 20.0,  # TUNING (not in GDD)
		"interval": 1.6,  # TUNING (not in GDD)
		"target": "first",
		"projectile": "projectiles/mage_orb", "projectile_speed": 300.0,  # TUNING (not in GDD)
		"splash": 48.0,  # TUNING (not in GDD) Necropathy mage splash 40
		"slow": 1.0, "slow_time": 0.0, "freeze_every": 0, "freeze_time": 0.0,
		"pierce": 0, "armour_pierce": 3.0,  # TUNING (not in GDD) GDD §6.1: Mage counters Sentinel armour
		"volley": {"every": 3, "count": 4, "damage": 0.4, "sprite": "volleys/orb", "tint": Color(0.6, 0.7, 1.0)},  # TUNING (not in GDD)
		"evolution": "lich",
	},
	"frost_wraith": {
		"name": "Frost Wraith", "sprite": "summons/frost_wraith", "icon": "frost_wraith", "spot": "plot",
		"cost": 90,  # TUNING (not in GDD)
		"behavior": "frost_wraith",
		"range": 125.0,  # TUNING (not in GDD)
		"damage": 8.0,  # TUNING (not in GDD) integration: 5 did almost nothing
		"interval": 1.0,  # TUNING (not in GDD)
		"target": "first",
		"projectile": "projectiles/frost_bolt", "projectile_speed": 420.0,  # TUNING (not in GDD)
		"splash": 30.0,  # TUNING (not in GDD)
		"slow": 0.55, "slow_time": 1.8,  # TUNING (not in GDD) GDD §4.1 "slows, then freezes packs"
		"freeze_every": 6, "freeze_time": 1.2,  # TUNING (not in GDD)
		"freeze_radius": 60.0,  # TUNING (not in GDD) Necropathy Deep Freeze radius; GDD §4.1 "freezes packs"
		"pierce": 0, "armour_pierce": 0.0,
		"volley": {"every": 4, "count": 3, "damage": 0.5, "sprite": "volleys/shard", "tint": Color(0.7, 0.9, 1.0)},  # TUNING (not in GDD)
		"evolution": "winter_revenant",
	},
	"corpse_catapult": {
		"name": "Corpse Catapult", "sprite": "summons/corpse_catapult", "icon": "corpse_catapult", "spot": "plot",
		"cost": 140,  # GDD §8.1 dearest tower
		"behavior": "corpse_catapult",
		"range": 270.0,  # TUNING (not in GDD) GDD §4.1 "very long range"
		"damage": 55.0,  # TUNING (not in GDD)
		"interval": 3.2,  # TUNING (not in GDD)
		"target": "strongest",
		"projectile": "projectiles/corpse_boulder", "projectile_speed": 240.0,  # TUNING (not in GDD)
		"arc_time": 1.1,  # TUNING (not in GDD) GDD §4.1 "with landing telegraph"
		"splash": 62.0,  # TUNING (not in GDD)
		"slow": 1.0, "slow_time": 0.0, "freeze_every": 0, "freeze_time": 0.0,
		"pierce": 0, "armour_pierce": 4.0,  # TUNING (not in GDD)
		"volley": {"every": 2, "count": 2, "damage": 0.5, "sprite": "volleys/shard", "tint": Color(0.95, 0.85, 0.7)},  # TUNING (not in GDD)
		"evolution": "ossuary_engine",
	},
	"banshee": {
		"name": "Banshee", "sprite": "summons/banshee", "icon": "banshee", "spot": "plot",
		"cost": 90,  # TUNING (not in GDD)
		"behavior": "banshee", "affects": "enemies",
		"range": 115.0,  # TUNING (not in GDD)
		"damage": 3.0,  # TUNING (not in GDD) the Dirge's small wail damage per pulse
		"interval": 1.5,  # TUNING (not in GDD)
		"target": "first",
		"slow": 0.75, "slow_time": 1.6,  # TUNING (not in GDD) GDD §4.1 "move slower"
		"weaken": 0.7, "weaken_time": 1.6,  # TUNING (not in GDD) GDD §4.1 "hit weaker"
		"windup": 0.45,  # TUNING (not in GDD) GDD §4.1 Dirge telegraph
		"heal": 0.0,
		"evolution": "keening_lady",
	},
	"mender": {
		"name": "Grave Mender", "sprite": "summons/mender", "icon": "mender", "spot": "plot",
		"cost": 80,  # TUNING (not in GDD)
		"behavior": "mender", "affects": "blockers",
		"range": 130.0,  # TUNING (not in GDD)
		"damage": 0.0,
		"interval": 2.0,  # TUNING (not in GDD)
		"target": "first",
		"slow": 1.0, "slow_time": 0.0, "weaken": 1.0, "weaken_time": 0.0,
		"heal": 18.0,  # TUNING (not in GDD) GDD §4.1 "heals blockers in range"
		"evolution": "profane_bishop",
	},
	"warrior": {
		"name": "Skeleton Warrior", "sprite": "summons/warrior", "icon": "warrior", "spot": "post",
		"cost": 40,  # GDD §8.1 cheapest tower
		"behavior": "warrior",
		"range": 30.0,  # TUNING (not in GDD)
		"damage": 9.0,  # TUNING (not in GDD) Necropathy warrior 10
		"interval": 1.0,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 2,  # GDD §4.1 "holds 2 enemies"
		"body_hp": 90.0,  # TUNING (not in GDD) DECISIONS W2: falls a few times a map; low enough that the column threatens blockers (Mender, respawn, Dread Rally have a job)
		"hold": 1,  # TUNING (not in GDD)
		"hits_all_held": false,
		"respawn": 6.0,  # TUNING (not in GDD) GDD §4.3 "return after a cooldown"; soon, so a fall costs a few leaks (W2)
		"volley": {"every": 3, "count": 2, "damage": 0.6, "sprite": "volleys/dagger", "tint": Color(0.9, 0.9, 0.8), "reach": 110.0},  # TUNING (not in GDD)
		"evolution": "death_knight",
	},
	"abomination": {
		"name": "Corpse Abomination", "sprite": "summons/abomination", "icon": "abomination", "spot": "post",
		"cost": 110,  # TUNING (not in GDD)
		"behavior": "abomination",
		"range": 40.0,  # TUNING (not in GDD)
		"damage": 22.0,  # TUNING (not in GDD) integration: 14 barely registered
		"interval": 1.4,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 1,
		"body_hp": 350.0,  # TUNING (not in GDD) see the Warrior
		"hold": 4,  # GDD §4.1 "holds 4"
		"hits_all_held": true,  # GDD §4.1 stomp
		"respawn": 10.0,  # TUNING (not in GDD)
		"stagger_time": 0.8,  # TUNING (not in GDD) GDD §4.1 "stomp staggers"
		"volley": {"every": 2, "count": 4, "damage": 0.4, "sprite": "volleys/shard", "tint": Color(0.95, 0.8, 0.7), "reach": 120.0},  # TUNING (not in GDD)
		"evolution": "bone_colossus",
	},
	# --- Later towers (GDD §4.2, gw2-kit): appended rows, each locked until its Unlocks spec is met ---
	"warder": {
		"name": "Crypt Warder", "sprite": "summons/warder", "icon": "warder", "spot": "plot",
		"desc": "Support: bone barriers on blockers in range",
		"unlock": {"map": "graveyard"},  # TUNING (not in GDD) DECISIONS K2: Act I clears grow the roster
		"cost": 85,  # TUNING (not in GDD)
		"behavior": "warder", "affects": "blockers", "family": "aura",
		"range": 135.0,  # TUNING (not in GDD)
		"damage": 9.0,  # TUNING (not in GDD) its Lv3 ward darts only
		"interval": 3.5,  # TUNING (not in GDD) s between wards
		"target": "first",
		"barrier": 26.0,  # TUNING (not in GDD) Necropathy Shieldwall: 25% of a warrior's HP
		"barrier_time": 6.0,  # TUNING (not in GDD)
		"projectile_speed": 460.0,  # TUNING (not in GDD) its ward darts
		"volley": {"every": 1, "count": 3, "damage": 1.0, "sprite": "volleys/shard", "tint": Color(0.55, 0.95, 1.0), "reach": 150.0},  # TUNING (not in GDD)
		"evolution": "bone_aegis",
	},
	"rogue": {
		"name": "Grave Rogue", "sprite": "summons/rogue", "icon": "rogue", "spot": "plot",
		"desc": "Leaves its grave to dash at elites, bleeds them",
		"unlock": {"map": "graveyard"},  # TUNING (not in GDD)
		"cost": 95,  # TUNING (not in GDD)
		"behavior": "rogue", "ground_only": true,
		"range": 150.0,  # TUNING (not in GDD)
		"damage": 38.0,  # TUNING (not in GDD) one dash strike
		"interval": 1.9,  # TUNING (not in GDD) s between dashes
		"target": "first",
		"dash_time": 0.2,  # TUNING (not in GDD) Necropathy dash ~0.2 s
		"linger": 0.25,  # TUNING (not in GDD)
		"elite_bonus": 2000.0,  # TUNING (not in GDD) score bonus (px of progress) for elites and up
		"bleed_dps": 7.0, "bleed_time": 3.0,  # TUNING (not in GDD) Necropathy bleed
		"chain_dashes": 0, "chain_radius": 0.0, "kill_reset": 0.0,
		"armour_pierce": 2.0,  # TUNING (not in GDD)
		"projectile_speed": 560.0,  # TUNING (not in GDD) its Lv3 thrown daggers
		"volley": {"every": 2, "count": 3, "damage": 0.45, "sprite": "volleys/dagger", "tint": Color(1.0, 0.35, 0.4)},  # TUNING (not in GDD)
		"evolution": "shadow_reaper",
	},
	"gargoyle": {
		"name": "Crypt Gargoyle", "sprite": "summons/gargoyle", "icon": "gargoyle", "spot": "plot",
		"desc": "Circles in the air, swoops on packs; the answer to flyers",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"cost": 110,  # TUNING (not in GDD)
		"behavior": "gargoyle",
		"range": 155.0,  # TUNING (not in GDD)
		"damage": 30.0,  # TUNING (not in GDD) one landing
		"interval": 2.3,  # TUNING (not in GDD)
		"target": "first",
		"splash": 42.0,  # TUNING (not in GDD) the landing's area
		"patrol_r": 34.0, "patrol_speed": 1.6,  # TUNING (not in GDD) GDD §4.2 "patrols a circle"
		"dive_time": 0.3,  # TUNING (not in GDD)
		"swoop_mark": 3.0,  # TUNING (not in GDD) Necropathy swoop mark
		"air_bonus": 5000.0, "air_mult": 1.6,  # TUNING (not in GDD) GDD §4.2 "the answer to flyers"
		"dive_stun": 0.0, "stone_time": 0.0,
		"projectile_speed": 420.0,  # TUNING (not in GDD) its Lv3 feather shards
		"volley": {"every": 2, "count": 4, "damage": 0.35, "sprite": "volleys/feather", "tint": Color(0.75, 0.7, 0.95)},  # TUNING (not in GDD)
		"evolution": "cathedral_horror",
	},
	"bone_hound": {
		"name": "Bone Hounds", "sprite": "summons/bone_hound", "icon": "bone_hound", "spot": "plot",
		"desc": "A pack that runs down the road after the enemy nearest the gate",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"cost": 80,  # TUNING (not in GDD)
		"behavior": "bone_hound", "ground_only": true,
		"range": 230.0,  # TUNING (not in GDD) GDD §4.2 "chases leaks down the road": the leash
		"damage": 4.2,  # TUNING (not in GDD) one bite; A/B pass (DECISIONS K16): 6 gave ~2x an archer's damage per soul, 3.6 lost the Sanctum, 4.6 still ~20% over the Mage
		"interval": 0.75,  # TUNING (not in GDD) s between one hound's bites
		"target": "first",
		"pack": 3,  # TUNING (not in GDD) Necropathy 3 -> 9 hounds
		"hound_speed": 210.0,  # TUNING (not in GDD)
		"kennel_dx": 20.0, "kennel_dy": 14.0,  # TUNING (not in GDD) px between resting hounds (12 read as one blob)
		"pack_bonus": 0.15, "pack_max": 0.45,  # GDD §6.3 Necropathy Pack Hunt (+15% per packmate, max +45%)
		"elite_bonus": 0.0,
		"burn_dps": 0.0, "burn_time": 0.0,
		"projectile_speed": 380.0,  # TUNING (not in GDD) its Lv3 howl
		"volley": {"every": 6, "count": 3, "damage": 0.8, "sprite": "volleys/wave", "tint": Color(1.0, 0.85, 0.55), "reach": 230.0},  # TUNING (not in GDD)
		"evolution": "hellhound",
	},
	"fallen_seraph": {
		"name": "Fallen Seraph", "sprite": "summons/fallen_seraph", "icon": "fallen_seraph", "spot": "plot",
		"desc": "Black feathers at several foes at once; hits flyers",
		"unlock": {"map": "sanctum"},  # Owner decision (Nov 25 2026): unlocked by beating Seraphine
		"cost": 120,  # TUNING (not in GDD) A/B pass: 130 left the early waves thin
		"behavior": "fallen_seraph",
		"range": 160.0,  # TUNING (not in GDD)
		"damage": 14.0,  # TUNING (not in GDD) per feather
		"interval": 1.1,  # TUNING (not in GDD)
		"target": "first",
		"projectile": "projectiles/seraph_feather", "projectile_speed": 480.0,  # TUNING (not in GDD)
		"feathers": 3,  # TUNING (not in GDD) Necropathy feather ring
		"splash": 0.0, "slow": 1.0, "slow_time": 0.0, "freeze_every": 0, "freeze_time": 0.0,
		"pierce": 0, "armour_pierce": 1.0,  # TUNING (not in GDD)
		"ruin_every": 0, "ruin_mult": 0.0, "ruin_radius": 0.0,
		"volley": {"every": 3, "count": 4, "damage": 0.5, "sprite": "volleys/feather", "tint": Color(0.8, 0.45, 1.0)},  # TUNING (not in GDD)
		"evolution": "seraph_of_ruin",
	},
	"bone_golem": {
		"name": "Bone Golem", "sprite": "summons/bone_golem", "icon": "bone_golem", "spot": "post",
		"desc": "Heavy blocker: plants itself when hurt, feeds on what it holds",
		"unlock": {"map": "sanctum"},  # TUNING (not in GDD)
		"cost": 125,  # TUNING (not in GDD)
		"behavior": "bone_golem",
		"range": 40.0,  # TUNING (not in GDD)
		"damage": 18.0,  # TUNING (not in GDD)
		"interval": 1.5,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 1,
		"body_hp": 500.0,  # TUNING (not in GDD) Abomination 350, but holds fewer (DECISIONS W2)
		"hold": 3,  # TUNING (not in GDD)
		"hits_all_held": false,
		"respawn": 12.0,  # TUNING (not in GDD)
		"slam_every": 3, "slam_mult": 1.5,  # TUNING (not in GDD)
		"stagger_time": 0.6,  # TUNING (not in GDD)
		"hunger_heal": 14.0,  # TUNING (not in GDD) Necropathy Ossuary Hunger
		"plant_frac": 0.5, "plant_cut": 0.35,  # TUNING (not in GDD) Necropathy Bulwark (planted: 30% cut)
		"volley": {"every": 3, "count": 3, "damage": 0.5, "sprite": "volleys/shard", "tint": Color(0.95, 0.9, 0.75), "reach": 120.0},  # TUNING (not in GDD)
		"evolution": "ossuary_titan",
	},
	# --- Act II, the Black Tide (w2b-tide): the act tower, unlocked by Captain Vandermere ---
	"powder_wraith": {
		"name": "Powder Wraith", "sprite": "summons/powder_wraith", "icon": "powder_wraith", "spot": "plot",
		"desc": "Marches a lit keg into the densest pack and bursts, then reforms",
		"unlock": {"map": "maelstrom"},  # DECISIONS K9: the act's summon class, unlocked by its finale's boss
		"cost": 115,  # TUNING (not in GDD)
		"behavior": "powder_wraith", "ground_only": true,
		"range": 190.0,  # TUNING (not in GDD) Necropathy picks a pack within 260 px of its necromancer
		"damage": 40.0,  # Necropathy 40 damage a burst
		"interval": 5.5,  # TUNING (not in GDD) s to reform after a burst (Necropathy 12 s on the open deck)
		"target": "first",
		"splash": 64.0,  # Necropathy 64 px blast
		"march_speed": 150.0,  # Necropathy 150 px/s
		"knock": 45.0,  # TUNING (not in GDD) px down the road (Necropathy 60 px knockback)
		"stagger_time": 0.5,  # TUNING (not in GDD)
		"second_burst": 0.0,  # Magazine Lord: px to the second pack (0 = none)
		"armour_pierce": 3.0,  # TUNING (not in GDD) a keg ignores some armour
		"volley": {"every": 1, "count": 5, "damage": 0.3, "sprite": "volleys/shard", "tint": Color(1.0, 0.6, 0.25), "reach": 110.0},  # Necropathy "a ring of burning shrapnel off every keg"; TUNING (not in GDD)
		"evolution": "magazine_lord",
	},
	# --- Act III: the Sanguine Court (w2b-court) ---
	"blood_spawn": {
		"name": "Blood Spawn", "sprite": "summons/blood_spawn", "icon": "blood_spawn", "spot": "post",
		"desc": "Fast vampire brawlers that heal themselves with every blow",
		"unlock": {"map": "castle_sanguis"},  # DECISIONS K9: the act's summon, unlocked by its finale's boss
		"cost": 90,  # TUNING (not in GDD)
		"behavior": "blood_spawn",
		"range": 30.0,  # TUNING (not in GDD)
		"damage": 10.0,  # TUNING (not in GDD) Necropathy claw rake 9
		"interval": 0.6,  # TUNING (not in GDD) Necropathy 0.75 s, fast
		"target": "first",
		"bodies": 2,
		"body_hp": 120.0,  # TUNING (not in GDD) between the Warrior (90) and the Abomination: it lives on its bites
		"hold": 1,  # TUNING (not in GDD)
		"hits_all_held": false,
		"respawn": 7.0,  # TUNING (not in GDD)
		"drink_share": 0.4,  # TUNING (not in GDD) Necropathy BLOODTHIRST 0.3: share of each blow's damage healed back to the striking body
		"spill_share": 0.0, "spill_radius": 0.0,  # Nosferatu only (EvolutionData "nosferatu")
		"volley": {"every": 4, "count": 3, "damage": 0.6, "sprite": "volleys/dagger", "tint": Color(1.0, 0.25, 0.3), "reach": 110.0},  # TUNING (not in GDD) Necropathy blood_spawn fan volley
		"evolution": "nosferatu",
	},
	# --- Act IV, the Last Line (w2b-city) ---
	"fallen_hero": {
		"name": "Fallen Hero", "sprite": "summons/fallen_hero", "icon": "fallen_hero", "spot": "plot",
		"desc": "A raised Super: flies over the city and slams into the densest pack, cracking armour",
		"unlock": {"map": "liberty_heights"},  # DECISIONS K9: the act's summon, unlocked by its finale boss (Paragon)
		"cost": 130,  # TUNING (not in GDD)
		"behavior": "fallen_hero",
		"range": 175.0,  # TUNING (not in GDD)
		"damage": 34.0,  # TUNING (not in GDD) one slam
		"interval": 2.6,  # TUNING (not in GDD)
		"target": "first",
		"splash": 52.0,  # TUNING (not in GDD) the slam's real radius
		"patrol_r": 26.0, "patrol_speed": 1.3,  # TUNING (not in GDD) Necropathy: he flies round the ring
		"dive_time": 0.35,  # TUNING (not in GDD)
		"swoop_mark": 0.0, "air_bonus": 0.0, "air_mult": 1.0,  # not the Gargoyle's: no swoop mark, no flyer bias
		"dive_stun": 0.0, "stone_time": 0.0,  # Black Paragon sets dive_stun
		"slam_stagger": 0.8,  # TUNING (not in GDD) s slammed foes make no attack
		"slam_shred": 4.0, "shred_time": 4.0,  # TUNING (not in GDD) GDD §7.3 armour shred: flat armour off, s
		"elite_weight": 3.0,  # TUNING (not in GDD) a non-fodder foe counts as this many in the pack score
		"chain_slams": 0, "chain_range": 0.0,  # Black Paragon: packs slammed after the first, px between them
		"projectile_speed": 420.0,  # TUNING (not in GDD) its Lv3 volley
		"volley": {"every": 2, "count": 3, "damage": 0.4, "sprite": "volleys/wave", "tint": Color(0.45, 0.65, 1.0)},  # TUNING (not in GDD)
		"evolution": "black_paragon",
	},
	# --- Act V, the Shogunate (w2b-shogun): unlocked by Amaterasu ---
	"bound_oni": {
		"name": "Bound Oni", "sprite": "summons/bound_oni", "icon": "bound_oni", "spot": "post",
		"desc": "Heavy blocker: every blow hits all it holds, its kanabo smash stuns them",
		"unlock": {"map": "sun_road"},  # Act V's finale boss (DECISIONS K9)
		"cost": 130,  # TUNING (not in GDD)
		"behavior": "bound_oni",
		"range": 40.0,  # TUNING (not in GDD)
		"damage": 20.0,  # TUNING (not in GDD) per held enemy
		"interval": 1.6,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 1,
		"body_hp": 440.0,  # TUNING (not in GDD) between the Abomination (350) and the Golem (500)
		"hold": 3,  # TUNING (not in GDD)
		"hits_all_held": true,  # Necropathy kanabo sweep
		"respawn": 11.0,  # TUNING (not in GDD)
		"smash_every": 3,  # TUNING (not in GDD) every 3rd strike is the smash
		"stun_time": 1.0,  # TUNING (not in GDD) s, Necropathy "a heavy blocker with a stun smash"
		"quake_radius": 0.0, "quake_mult": 0.0,  # Oni Lord only (EvolutionData "oni_lord")
		"volley": {"every": 3, "count": 3, "damage": 0.5, "sprite": "volleys/shard", "tint": Color(1.0, 0.55, 0.4), "reach": 120.0},  # TUNING (not in GDD)
		"evolution": "oni_lord",
	},
	# --- Act VI, the Hall of the Slain (w2c-norse): unlocked by Odin ---
	"draugr_thane": {
		"name": "Draugr Thane", "short": "Thane", "sprite": "summons/draugr_thane", "icon": "draugr_thane", "spot": "post",
		"desc": "Heavy undead jarl: every axe blow chills, every few blows a frost cleave round it",
		"unlock": {"map": "vigrid"},  # Act VI's finale boss (DECISIONS K9)
		"cost": 135,  # TUNING (not in GDD)
		"behavior": "draugr_thane",
		"range": 40.0,  # TUNING (not in GDD)
		"damage": 30.0,  # TUNING (not in GDD) per blow on the first held enemy
		"interval": 1.3,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 1,
		"body_hp": 470.0,  # TUNING (not in GDD) between the Bound Oni (440) and the Golem (500)
		"hold": 3,  # TUNING (not in GDD)
		"hits_all_held": false,
		"respawn": 11.0,  # TUNING (not in GDD)
		"chill_mult": 0.6,  # TUNING (not in GDD) speed share left on a foe its axe strikes (Necropathy axe_slow)
		"chill_time": 2.0,  # TUNING (not in GDD) s of that chill
		"cleave_every": 2,  # TUNING (not in GDD) every 2nd blow is the frost cleave
		"cleave_radius": 70.0,  # TUNING (not in GDD) px round the body the cleave reaches (Necropathy cleave_radius)
		"cleave_mult": 0.8,  # TUNING (not in GDD) share of its damage each foe in the cleave takes
		"cleave_freeze": 0.0,  # Barrow King only (EvolutionData "barrow_king"): s the cleave freezes what it strikes
		"volley": {"every": 3, "count": 3, "damage": 0.5, "sprite": "volleys/shard", "tint": Color(0.6, 0.85, 1.0), "reach": 120.0},  # TUNING (not in GDD)
		"evolution": "barrow_king",
	},
}

## Per-level multipliers, 5 rows (levels 1-5) per tower. Keys:
##   damage / rate / range — multipliers on the base damage, attack speed
##                           (1 / interval) and range.
##   bodies                — blockers: bodies on the post (replaces the base).
##   hp                    — blockers: multiplier on body_hp; auras: on heal.
## Level 3 also switches on the row's volley (TowerBehavior.volley()).
const LEVELS: Dictionary = {
	"archer": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.0, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.7, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.1, "rate": 1.2, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.6, "rate": 1.35, "range": 1.2},  # TUNING (not in GDD)
	],
	"mage": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.0, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.05, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.1, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.2, "range": 1.2},  # TUNING (not in GDD)
	],
	"frost_wraith": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.3, "rate": 1.1, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.2, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.3, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.4, "range": 1.2},  # TUNING (not in GDD)
	],
	"corpse_catapult": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.0, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.05, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.2, "range": 1.15},  # TUNING (not in GDD)
	],
	"banshee": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.3, "rate": 1.05, "range": 1.08},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.15, "range": 1.22},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.2, "range": 1.3},  # TUNING (not in GDD)
	],
	"mender": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "hp": 1.0},
		{"damage": 1.0, "rate": 1.1, "range": 1.05, "hp": 1.3},  # TUNING (not in GDD)
		{"damage": 1.0, "rate": 1.2, "range": 1.1, "hp": 1.6},  # TUNING (not in GDD)
		{"damage": 1.0, "rate": 1.3, "range": 1.15, "hp": 2.0},  # TUNING (not in GDD)
		{"damage": 1.0, "rate": 1.4, "range": 1.2, "hp": 2.5},  # TUNING (not in GDD)
	],
	"warrior": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 2, "hp": 1.0},
		{"damage": 1.3, "rate": 1.0, "range": 1.0, "bodies": 2, "hp": 1.4},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.0, "bodies": 3, "hp": 1.8},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.2, "range": 1.0, "bodies": 3, "hp": 2.4},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 4, "hp": 3.0},  # TUNING (not in GDD)
	],
	"abomination": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.0},
		{"damage": 1.3, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.4},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.0, "bodies": 1, "hp": 1.8},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.2, "range": 1.0, "bodies": 1, "hp": 2.4},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 1, "hp": 3.0},  # TUNING (not in GDD)
	],
	# --- Later towers ---
	"warder": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "hp": 1.0},
		{"damage": 1.2, "rate": 1.1, "range": 1.05, "hp": 1.3},  # TUNING (not in GDD)
		{"damage": 1.4, "rate": 1.2, "range": 1.1, "hp": 1.6},  # TUNING (not in GDD)
		{"damage": 1.7, "rate": 1.3, "range": 1.15, "hp": 2.0},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.4, "range": 1.2, "hp": 2.5},  # TUNING (not in GDD)
	],
	"rogue": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.05, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.2, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.3, "range": 1.2},  # TUNING (not in GDD)
	],
	"gargoyle": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.05, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.15, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.25, "range": 1.2},  # TUNING (not in GDD)
	],
	"bone_hound": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 3},
		{"damage": 1.3, "rate": 1.05, "range": 1.0, "bodies": 3},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.05, "bodies": 4},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.15, "range": 1.1, "bodies": 4},  # TUNING (not in GDD)
		{"damage": 2.4, "rate": 1.2, "range": 1.15, "bodies": 5},  # TUNING (not in GDD) Necropathy pack grows with levels
	],
	"fallen_seraph": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.3, "rate": 1.05, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.65, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.05, "rate": 1.15, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.25, "range": 1.2},  # TUNING (not in GDD)
	],
	"bone_golem": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.0},
		{"damage": 1.3, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.4},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.0, "bodies": 1, "hp": 1.8},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.2, "range": 1.0, "bodies": 1, "hp": 2.4},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 1, "hp": 3.0},  # TUNING (not in GDD)
	],
	# --- Act II, the Black Tide (w2b-tide) ---
	"powder_wraith": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.05, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.15, "range": 1.12},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.25, "range": 1.15},  # TUNING (not in GDD)
	],
	"blood_spawn": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 2, "hp": 1.0},
		{"damage": 1.3, "rate": 1.05, "range": 1.0, "bodies": 2, "hp": 1.35},  # TUNING (not in GDD)
		{"damage": 1.65, "rate": 1.1, "range": 1.0, "bodies": 3, "hp": 1.7},  # TUNING (not in GDD)
		{"damage": 2.05, "rate": 1.2, "range": 1.0, "bodies": 3, "hp": 2.2},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 3, "hp": 2.8},  # TUNING (not in GDD)
	],
	"fallen_hero": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0},
		{"damage": 1.35, "rate": 1.05, "range": 1.05},  # TUNING (not in GDD)
		{"damage": 1.75, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		{"damage": 2.2, "rate": 1.15, "range": 1.15},  # TUNING (not in GDD)
		{"damage": 2.8, "rate": 1.25, "range": 1.2},  # TUNING (not in GDD)
	],
	"bound_oni": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.0},
		{"damage": 1.3, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.4},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.0, "bodies": 1, "hp": 1.8},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.2, "range": 1.0, "bodies": 1, "hp": 2.4},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 1, "hp": 3.0},  # TUNING (not in GDD)
	],
	"draugr_thane": [
		{"damage": 1.0, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.0},
		{"damage": 1.3, "rate": 1.0, "range": 1.0, "bodies": 1, "hp": 1.4},  # TUNING (not in GDD)
		{"damage": 1.6, "rate": 1.1, "range": 1.0, "bodies": 1, "hp": 1.8},  # TUNING (not in GDD)
		{"damage": 2.0, "rate": 1.2, "range": 1.0, "bodies": 1, "hp": 2.4},  # TUNING (not in GDD)
		{"damage": 2.5, "rate": 1.3, "range": 1.0, "bodies": 1, "hp": 3.0},  # TUNING (not in GDD)
	],
}

## Px between two blocker bodies standing side by side across the road.
const BODY_SPACING: float = 16.0  # TUNING (not in GDD)
## Seconds a tower's squash lasts after it fires (visual only).
const FIRE_SQUASH_TIME: float = 0.12  # TUNING (not in GDD)
## Scale change (fraction) at the peak of that squash (visual only).
const FIRE_SQUASH: float = 0.08  # TUNING (not in GDD)
## Seconds a Banshee wail ring expands on screen (visual only).
const WAIL_RING_TIME: float = 0.35  # TUNING (not in GDD)
## Px a plot tower stands above its spot centre (on the open grave; visual only).
const BODY_LIFT: float = 8.0  # TUNING (not in GDD)
