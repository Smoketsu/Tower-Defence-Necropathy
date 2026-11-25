## The test act's data (ActData id "test", hidden behind --test-act): the
## example of an act data file (docs/ACT_TEMPLATE.md). Acts merges its KINDS
## (enemy rows, same keys as TdEnemyData.KINDS), ORDERS (build orders, same
## keys as BuildOrderData.ORDERS) and MOODS (mood rows, same keys as
## TdMoodData.MOODS; this act uses the Graveyard's through ActData "mood"),
## and its rule reads RULE. Every kind reuses Act I art: the test act exercises
## the framework's hooks, it is not content. Data only, no logic.
extends RefCounted

## Enemy kinds of the test act (keys: TdEnemyData.KINDS).
const KINDS: Dictionary = {
	# A flyer over the road: never held by blockers or walls; drawn lifted with a shadow.
	"test_bat": {
		"name": "Test Flyer", "sprite": "enemies/purifier", "rank": "fodder",
		"hp": 40.0, "speed": 70.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": false, "trait": "", "args": {},
	},
	# A ranged enemy shooting towers (disable) or blockers (damage) through game.hostile.
	"test_gunner": {
		"name": "Test Gunner", "sprite": "enemies/archer", "rank": "elite",
		"hp": 120.0, "speed": 40.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 220.0, "interval": 2.5, "target": "any", "damage": 12.0, "disable": 2.0, "cause": "shot", "speed": 320.0, "arc": false, "look": "arrow"},  # TUNING (not in GDD)
	},
	# An off-road crosser (on an "off_road" + "exit" trail) trampling the towers it passes.
	"test_herd": {
		"name": "Test Herd Beast", "sprite": "enemies/templar", "rank": "fodder",
		"hp": 90.0, "speed": 60.0, "armour": 0.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "trampler",
		"args": {"radius": 60.0, "disable": 3.0},  # TUNING (not in GDD)
	},
	# A claimer: a blocker felled near it rises as a test_thrall (the act rule's on_body_fallen).
	"test_claimer": {
		"name": "Test Claimer", "sprite": "enemies/chaplain", "rank": "elite",
		"hp": 400.0, "speed": 40.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 150.0, "attack_interval": 0.8,  # TUNING (not in GDD) hits hard: fells blockers to test claims
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The hostile thrall a claimed blocker rises as.
	"test_thrall": {
		"name": "Test Thrall", "sprite": "enemies/recruit", "rank": "fodder",
		"hp": 60.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
}

## Build orders of the test act (keys: BuildOrderData.ORDERS).
const ORDERS: Dictionary = {
	"test_default": {
		"spells": true,
		"bonus_souls": 400,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
		],
	},
	# The shared kit on the test act (wave 2a integration): ground-only Rogue and
	# Hounds under flyers, the Gargoyle, a Golem under fire, kit spells and Grave Tide.
	"test_kit": {
		"spells": true,
		"bonus_souls": 600,  # TUNING (not in GDD)
		"loadout": ["raise_dead", "death_mark", "soul_chains", "wither"],
		"ultimate": "grave_tide",
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "fallen_seraph"},
			{"do": "build", "spot": "post:0", "tower": "bone_golem"},
			{"do": "build", "spot": "plot:3", "tower": "rogue"},
			{"do": "build", "spot": "plot:1", "tower": "bone_hound"},
			{"do": "build", "spot": "plot:2", "tower": "gargoyle"},
			{"do": "build", "spot": "plot:4", "tower": "warder"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
		],
	},
	"test_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
		],
	},
}

## The test act rule's numbers (scripts/maps/rules/test/proving.gd).
const RULE: Dictionary = {
	"tier_every": 2,  # TUNING (not in GDD) every Nth wave is one tier higher (wave tier)
	"tier_hp": 0.15,  # TUNING (not in GDD) enemy HP x(1 + tier_hp x tier) on spawn (TdCombat.empower_enemy)
	"blood_wave": 3,  # TUNING (not in GDD) wave (1-based) whose kills heal nearby enemies (heal on kill)
	"kill_heal": 15.0,  # TUNING (not in GDD) HP healed per kill on the blood wave
	"kill_heal_radius": 90.0,  # TUNING (not in GDD) px around the kill
	"claim_kind": "test_claimer",  # TUNING (not in GDD) the kind whose presence claims a fallen blocker
	"claim_radius": 120.0,  # TUNING (not in GDD) px from the fallen body
	"thrall_kind": "test_thrall",  # TUNING (not in GDD) what the claimed blocker rises as
	"night_from": 4,  # TUNING (not in GDD) from this wave towers see only within sight px (visibility)
	"sight": 170.0,  # TUNING (not in GDD) px a tower sees at night
	"shell_every": 9.0,  # TUNING (not in GDD) s between shells on a built tower (telegraphed shelling)
	"shell_delay": 1.5,  # TUNING (not in GDD) s of telegraph
	"shell_radius": 50.0,  # TUNING (not in GDD) px
	"shell_disable": 2.5,  # TUNING (not in GDD) s a shelled tower is disabled
}
