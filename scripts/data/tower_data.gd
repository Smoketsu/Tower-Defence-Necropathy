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
const ORDER: Array[String] = ["archer", "mage", "frost_wraith", "corpse_catapult", "banshee", "mender", "warrior", "abomination"]

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
		"damage": 5.0,  # TUNING (not in GDD)
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
		"body_hp": 50.0,  # TUNING (not in GDD) low enough that the column threatens blockers (Mender, respawn, Dread Rally have a job)
		"hold": 1,  # TUNING (not in GDD)
		"hits_all_held": false,
		"respawn": 8.0,  # TUNING (not in GDD) GDD §4.3 "return after a cooldown"
		"volley": {"every": 3, "count": 2, "damage": 0.6, "sprite": "volleys/dagger", "tint": Color(0.9, 0.9, 0.8), "reach": 110.0},  # TUNING (not in GDD)
		"evolution": "death_knight",
	},
	"abomination": {
		"name": "Corpse Abomination", "sprite": "summons/abomination", "icon": "abomination", "spot": "post",
		"cost": 110,  # TUNING (not in GDD)
		"behavior": "abomination",
		"range": 40.0,  # TUNING (not in GDD)
		"damage": 14.0,  # TUNING (not in GDD)
		"interval": 1.4,  # TUNING (not in GDD)
		"target": "first",
		"bodies": 1,
		"body_hp": 200.0,  # TUNING (not in GDD) see the Warrior
		"hold": 4,  # GDD §4.1 "holds 4"
		"hits_all_held": true,  # GDD §4.1 stomp
		"respawn": 12.0,  # TUNING (not in GDD)
		"stagger_time": 0.8,  # TUNING (not in GDD) GDD §4.1 "stomp staggers"
		"volley": {"every": 2, "count": 4, "damage": 0.4, "sprite": "volleys/shard", "tint": Color(0.95, 0.8, 0.7), "reach": 120.0},  # TUNING (not in GDD)
		"evolution": "bone_colossus",
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
