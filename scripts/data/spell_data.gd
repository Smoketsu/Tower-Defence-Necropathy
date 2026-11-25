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
	# --- Act IV, the Last Line (w2b-city; Necropathy's Act VIII spells) ---
	"hearse_run": {
		"name": "Hearse Run", "icon": "hearse_run", "cooldown": 16.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral hearse drives back up the road through the enemy",
		"unlock": {"map": "skid_row"},  # Necropathy: slaying Don Marrow unlocks Hearse Run
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"length": 260.0,  # TUNING (not in GDD) px of road it drives, from the tap back toward the entrance
		"drive_time": 1.1,  # TUNING (not in GDD) s it takes
		"damage": 75.0,  # TUNING (not in GDD) to each enemy it runs over (once per hearse)
		"stagger": 1.0,  # TUNING (not in GDD) s each one makes no attack
		"hit_radius": 26.0,  # TUNING (not in GDD) px from the hearse that counts as run over
		"hearses": 1,  # Necropathy one hearse a cast (the Undertaker's Last Ride adds one)
		"hearse_gap": 0.35,  # TUNING (not in GDD) s between two hearses of one cast
	},
	"bone_mines": {
		"name": "Bone Mines", "icon": "bone_mines", "cooldown": 14.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Bone mines along the road go off under the enemy",
		"unlock": {"map": "fort_kessler"},  # Necropathy: slaying General Harrow unlocks Bone Mines
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"mines": 3,  # TUNING (not in GDD) mines laid per cast (the Fallen Sergeant's Sapper's Hands adds one)
		"spacing": 42.0,  # TUNING (not in GDD) px between mines along the road
		"arm": 0.5,  # Necropathy ARM_TIME 0.5 s
		"trigger": 18.0,  # TUNING (not in GDD) px: an enemy's body within this of a mine sets it off (flyers never do)
		"body_pad": 30.0,  # px added to the trigger search (>= the largest walking body radius)
		"blast_radius": 52.0,  # TUNING (not in GDD) px
		"damage": 85.0,  # TUNING (not in GDD) to every enemy in the blast (armour applies; it goes round shields)
		"life": 30.0,  # TUNING (not in GDD) s an unexploded mine lies there
		"max_mines": 15,  # TUNING (not in GDD) mines on the road at once (oldest dropped)
	},
	"heros_fist": {
		"name": "Hero's Fist", "icon": "heros_fist", "cooldown": 12.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral fist slams the strongest foe and flings it through the rest",
		"unlock": {"map": "liberty_heights"},  # Necropathy: defeating Paragon unlocks Hero's Fist
		"pick_radius": 130.0,  # TUNING (not in GDD) px around the tap searched for the strongest foe
		"damage": 230.0,  # TUNING (not in GDD) the slam
		"stun": 1.0,  # TUNING (not in GDD) s the struck foe is frozen (rank multipliers apply)
		"fling_radius": 70.0,  # TUNING (not in GDD) px round it where the flung foe strikes the others
		"fling_damage": 60.0,  # TUNING (not in GDD) to each of those
		"fists": 1,  # Necropathy one fist (the Revenant Heroine adds one, at the next strongest)
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
