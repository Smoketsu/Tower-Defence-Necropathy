## TdEnemyData: the Covenant kinds on the road (GDD §6.1), with Necropathy's
## sprites and walk strips. HP and speed start from Necropathy's EnemyData /
## MarchEnemyData rows and are rescaled for tower damage; every number is
## TUNING until the balance pass. Data only, no logic.
##
## To add an enemy kind: add a KINDS row; for a special rule write
## scripts/enemies/traits/<trait>.gd (extends EnemyTrait) and name it in "trait".
## A boss is a kind of rank "boss" whose trait lives in scripts/bosses/<id>.gd.
class_name TdEnemyData
extends RefCounted

## Kind rows. Keys:
##   name            — UI name (banners, next-wave preview).
##   sprite          — SpriteData key (walk strip "<sprite>_walk" when it exists).
##   rank            — "fodder" | "elite" | "miniboss" | "boss": souls (EconomyData.KILL_SOULS),
##                     lives on a leak (TdRulesData.LEAK_LIVES), ultimate charge (SpellData).
##   hp              — max HP before difficulty scaling.
##   speed           — px/s along the road.
##   armour          — flat damage removed from each hit (GDD §6.1 "flat armour 6").
##   radius          — body radius px (holding, splash, tap picking).
##   damage          — damage per attack on the blocker body holding it.
##   attack_interval — s between those attacks.
##   flying          — true: never held by blockers or walls (later acts' flyers).
##   ignores_walls   — true: walks through Bone Wall (GDD §5 bosses and minibosses).
##   trait           — "" or the id of its EnemyTrait script (traits/ or bosses/).
##   args            — the trait's own numbers (documented in the trait script).
const KINDS: Dictionary = {
	# GDD §6.1 "Baseline fodder" (Necropathy: Covenant Recruit).
	"recruit": {
		"name": "Covenant Recruit", "sprite": "enemies/recruit", "rank": "fodder",
		"hp": 44.0, "speed": 52.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy "armored melee, moderate damage resistance".
	"footman": {
		"name": "Crimson Footman", "sprite": "enemies/footman", "rank": "fodder",
		"hp": 100.0, "speed": 44.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Zealous Archer: on the road a fast, frail walker.
	"archer": {
		"name": "Zealous Archer", "sprite": "enemies/archer", "rank": "fodder",
		"hp": 50.0, "speed": 58.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Purifier: fragile and fast.
	"purifier": {
		"name": "Purifier", "sprite": "enemies/purifier", "rank": "fodder",
		"hp": 60.0, "speed": 72.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Chaplain: heals nearby enemies (GDD §6.1 healer pattern).
	"chaplain": {
		"name": "Covenant Chaplain", "sprite": "enemies/chaplain", "rank": "elite",
		"hp": 150.0, "speed": 42.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 14.0, "interval": 3.0, "radius": 90.0},  # TUNING (not in GDD)
	},
	# GDD §6.1 "Charges: brief speed burst after the first hit".
	"templar": {
		"name": "Templar Knight", "sprite": "enemies/templar", "rank": "elite",
		"hp": 320.0, "speed": 40.0, "armour": 4.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "templar_charge",
		"args": {"speed_mult": 2.4, "time": 1.6},  # TUNING (not in GDD)
	},
	# GDD §6.1 "Nearby enemies move faster" (Crimson March kind, ready for map 2).
	"banner_bearer": {
		"name": "Banner Bearer", "sprite": "enemies/banner_bearer", "rank": "elite",
		"hp": 200.0, "speed": 44.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 90.0, "speed_mult": 1.3, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# Graveyard miniboss (GDD §6.3: picked from an existing elite kind): the Inquisitor.
	"inquisitor": {
		"name": "Covenant Inquisitor", "sprite": "enemies/inquisitor", "rank": "miniboss",
		"hp": 3000.0, "speed": 30.0, "armour": 5.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# GDD §6.3 Sir Alaric: walks the road, charges through one blocker post at intervals.
	"alaric": {
		"name": "Sir Alaric, the Gravebreaker", "sprite": "bosses/alaric", "rank": "boss",
		"hp": 12000.0, "speed": 26.0, "armour": 6.0, "radius": 28.0,  # TUNING (not in GDD)
		"damage": 45.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "alaric",
		"args": {
			"charge_every": 9.0,  # s held before he charges through the post
			"telegraph": 0.9,  # s of the wind-up (pose and warning) before the charge
			"charge_damage": 160.0,  # damage to every body of the post he breaks through
			"charge_speed_mult": 4.0,  # speed multiplier during the charge
			"charge_time": 1.2,  # s the charge lasts (he cannot be held meanwhile)
		},  # TUNING (not in GDD)
	},
}

