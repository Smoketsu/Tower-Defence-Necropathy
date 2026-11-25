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
##   unlock   — optional Unlocks spec (gw2-kit): the pre-map pick offers it only once met.
##   desc     — optional one line for the pre-map pick and the Codex.
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
	# --- Later spells (GDD §5 "Later", gw2-kit) ---
	"death_mark": {
		"name": "Death Mark", "icon": "death_mark", "cooldown": 9.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "Brands a foe; if it dies branded, a Risen rises there",
		"unlock": {"map": "graveyard"},  # TUNING (not in GDD)
		"pick_radius": 90.0,  # px around the tap searched for the target
		"dps": 26.0,  # TUNING (not in GDD) brand damage per second (damage over time)
		"duration": 6.0,  # TUNING (not in GDD) s the brand burns
		"risen_hp": 120.0,  # TUNING (not in GDD) HP of the Risen a branded death raises
		"risen_hold": 1,  # TUNING (not in GDD) enemies it holds
		"risen_damage": 14.0,  # TUNING (not in GDD) per hit
		"risen_interval": 1.0,  # TUNING (not in GDD) s between hits
		"risen_time": 8.0,  # TUNING (not in GDD) s before it crumbles
		"risen_max": 4,  # TUNING (not in GDD) Risen of this spell standing at once
	},
	"soul_chains": {
		"name": "Soul Chains", "icon": "soul_chains", "cooldown": 15.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Chains a pack: slows it and arcs soul lightning through it",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"pick_radius": 110.0,  # TUNING (not in GDD) px around the tap searched for the first link
		"links": 6,  # TUNING (not in GDD) enemies chained
		"link_reach": 90.0,  # TUNING (not in GDD) px from one link to the next
		"damage": 40.0,  # TUNING (not in GDD) the first arc, to every link
		"slow": 0.5, "duration": 3.5,  # TUNING (not in GDD) GDD §5 "slows"
		"pulse": 12.0, "tick": 0.7,  # TUNING (not in GDD) arc damage to every link each tick while chained
	},
	"wither": {
		"name": "Wither", "icon": "wither", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A withering aura on a plot: shreds armour around it",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"pick_radius": 90.0,  # TUNING (not in GDD) px around the tap searched for a spot (GDD §5 "a chosen plot")
		"radius": 120.0,  # TUNING (not in GDD) px of the aura
		"duration": 9.0,  # TUNING (not in GDD) s it lasts
		"tick": 0.5,  # TUNING (not in GDD) s between pulses
		"shred": 5.0,  # TUNING (not in GDD) flat armour removed while inside (refreshed each pulse)
		"dps": 6.0,  # TUNING (not in GDD) wither damage per second (damage over time)
		"rot_dps": 0.0,  # Wither Witch's Creeping Rot adds its own (CharacterModifiers)
	},
	"raise_dead": {
		"name": "Raise Dead", "icon": "raise_dead", "cooldown": 22.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Three Risen climb out of the road and hold it",
		"unlock": {"map": "sanctum"},  # TUNING (not in GDD)
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"count": 3,  # TUNING (not in GDD) GDD §5 "temporary blockers"
		"hp": 100.0,  # TUNING (not in GDD)
		"hold": 1,  # TUNING (not in GDD)
		"damage": 12.0,  # TUNING (not in GDD)
		"interval": 1.0,  # TUNING (not in GDD)
		"duration": 10.0,  # TUNING (not in GDD)
	},
	# --- Act V spells (w2b-shogun; Necropathy's Shogunate rewards) ---
	"hundred_shadows": {
		"name": "Hundred Shadows", "icon": "hundred_shadows", "cooldown": 18.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Shadow clones step out of the road and cut down what comes near",
		"unlock": {"map": "province"},  # Kage's reward
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"count": 3,  # TUNING (not in GDD) clones per cast
		"damage": 22.0,  # TUNING (not in GDD) per strike
		"tick": 0.6,  # TUNING (not in GDD) s between one clone's strikes
		"radius": 110.0,  # TUNING (not in GDD) px a clone reaches
		"duration": 7.0,  # TUNING (not in GDD) s they fight
		"sprite": "player/grave_kunoichi",  # the clones' look
	},
	"banner_of_the_dead": {
		"name": "Banner of the Dead", "short": "Banner", "icon": "banner_of_the_dead", "cooldown": 24.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A war banner: towers near it attack faster for a while",
		"unlock": {"map": "kurogane"},  # Shogun Kurogane's reward
		"radius": 170.0,  # TUNING (not in GDD) px of towers rallied
		"rate_mult": 1.3,  # TUNING (not in GDD) attack speed x
		"duration": 9.0,  # TUNING (not in GDD) s
	},
	"black_sun": {
		"name": "Black Sun", "icon": "black_sun", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A dark sun hangs over the road and beams the thickest pack",
		"unlock": {"map": "sun_road"},  # Amaterasu's reward
		"radius": 150.0,  # TUNING (not in GDD) px it reaches
		"damage": 34.0,  # TUNING (not in GDD) per beam to each foe in the splash
		"splash": 40.0,  # TUNING (not in GDD) px around the beamed foe
		"tick": 0.8,  # TUNING (not in GDD) s between beams
		"duration": 8.0,  # TUNING (not in GDD) s it hangs
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

## The later ultimates (GDD §5 "Sovereign's Decree, Eclipse and Grave Tide are
## later unlocks on the same meter"; gw2-kit). Each is cast by
## scripts/spells/<id>.gd on the Dread Rally meter (ULTIMATE meter_max / charge);
## chosen in the pre-map pick (SpellCaster.ultimate_id). Common keys: name,
## short (optional tile name when the name is too long),
## icon, desc, unlock (Unlocks spec), sound (Sfx id); the rest are its own numbers.
const ULTIMATES: Dictionary = {
	"sovereigns_decree": {
		"name": "Sovereign's Decree", "short": "Decree", "icon": "sovereigns_decree", "sound": "ult_decree",
		"desc": "Revives every blocker; barriers on all of them, held foes weakened",
		"unlock": {"map": "graveyard", "skulls": 3},  # TUNING (not in GDD)
		"duration": 8.0,  # Necropathy "for 8 s"
		"barrier_frac": 0.5,  # TUNING (not in GDD) barrier HP as a fraction of each body's max HP (Necropathy "50% less damage")
		"weaken": 0.5,  # TUNING (not in GDD) damage multiplier on enemies held meanwhile
	},
	"eclipse": {
		"name": "Eclipse", "icon": "eclipse", "sound": "ult_eclipse",
		"desc": "Darkness: every foe freezes, then takes more damage",
		"unlock": {"map": "crimson_march", "skulls": 3},  # TUNING (not in GDD)
		"freeze": 3.0,  # TUNING (not in GDD) Necropathy 4 s (rank multipliers apply)
		"curse_mult": 1.3,  # Necropathy "+30% damage"
		"curse_time": 9.0,  # TUNING (not in GDD) freeze + Necropathy's 6 s
	},
	"grave_tide": {
		"name": "Grave Tide", "icon": "grave_tide", "sound": "ult_tide",
		"desc": "For a while every foe that dies rises as a Risen for you",
		"unlock": {"map": "sanctum", "skulls": 3},  # TUNING (not in GDD)
		"duration": 10.0,  # Necropathy "for 10 s"
		"risen_hp": 80.0,  # TUNING (not in GDD)
		"risen_damage": 12.0,  # TUNING (not in GDD)
		"risen_interval": 1.0,  # TUNING (not in GDD)
		"risen_time": 8.0,  # TUNING (not in GDD) Necropathy 12 s
		"risen_max": 10,  # TUNING (not in GDD) Risen standing at once
	},
}
