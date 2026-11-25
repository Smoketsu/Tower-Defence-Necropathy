## SpellData: the necromancer's spells and the ultimate (GDD §5). Spells cost no
## souls, only cooldowns. Each row is cast by scripts/spells/<id>.gd (extends
## TdSpell), loaded by name by SpellCaster. Data only, no logic.
##
## To add a spell: add a SPELLS row and write scripts/spells/<id>.gd.
class_name SpellData
extends RefCounted

## Spells brought into a map when none are chosen (GDD §5: three spells).
const DEFAULT_LOADOUT: Array[String] = ["shadow_bolt", "bone_wall", "corpse_explosion"]

## Spell rows. Common keys:
##   name     — UI name; icon — icons/<id>.
##   cooldown — s between casts (before meta).
##   target   — "enemy" (nearest enemy to the tap), "road" (nearest road point), "point".
##   ready    — false: listed but not built yet (its script is missing); the slot shows it dimmed.
## The rest are the spell's own numbers (see its script).
const SPELLS: Dictionary = {
	"shadow_bolt": {
		"name": "Shadow Bolt", "icon": "shadow_bolt", "cooldown": 4.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"damage": 140.0,  # TUNING (not in GDD) the finisher for leaks
		"pick_radius": 90.0,  # px around the tap searched for the target
		"speed": 700.0,  # px/s of the bolt (flies from the necromancer at the gate)
		"projectile": "projectiles/shadow_bolt",
	},
	"bone_wall": {
		"name": "Bone Wall", "icon": "bone_wall", "cooldown": 18.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"duration": 5.0,  # s the wall blocks the road (GDD §5 "a few seconds")
		"segments": 3,  # wall segments drawn across the road
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
	},
	"corpse_explosion": {
		"name": "Corpse Explosion", "icon": "corpse_explosion", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"damage": 45.0,  # TUNING (not in GDD) per corpse to each enemy in its blast
		"blast_radius": 55.0,  # TUNING (not in GDD) px around each corpse
		"pick_radius": 110.0,  # TUNING (not in GDD) px around the tap searched for corpses
		"max_detonate": 10,  # TUNING (not in GDD) corpses detonated per cast
		"max_corpses": 40,  # TUNING (not in GDD) corpse markers kept at once (pool cap; oldest dropped)
		"corpse_life": 25.0,  # TUNING (not in GDD) s a corpse lies on the road
	},
	"plague_cloud": {
		"name": "Plague Cloud", "icon": "plague_cloud", "cooldown": 16.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"length": 192.0,  # TUNING (not in GDD) px of road covered (GDD §5 "a stretch of road")
		"puffs": 4,  # TUNING (not in GDD) fields along it (spaced length / (puffs - 1) px)
		"radius": 32.0,  # TUNING (not in GDD) px of each field
		"duration": 6.0,  # TUNING (not in GDD) s the cloud lasts
		"tick": 0.5,  # TUNING (not in GDD) s between Rot ticks
		"rot": 9.0,  # TUNING (not in GDD) Rot damage per tick (damage over time, no armour)
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
	},
}

## The ultimate (GDD §5 Dread Rally), cast through SpellCaster like a spell
## (scripts/spells/dread_rally.gd) but charged by kills instead of a cooldown.
const ULTIMATE: Dictionary = {
	"id": "dread_rally", "name": "Dread Rally", "icon": "dread_rally",
	"meter_max": 100.0,  # TUNING (not in GDD) meter units for a full charge
	"charge": {"fodder": 1.0, "elite": 4.0, "miniboss": 20.0, "boss": 0.0},  # TUNING (not in GDD) per kill by rank
	"duration": 8.0,  # GDD §5 "for 8 s"
	"damage_mult": 1.4,  # GDD §5 "+40% damage"
	"rate_mult": 1.4,  # GDD §5 "+40% attack speed"
}
