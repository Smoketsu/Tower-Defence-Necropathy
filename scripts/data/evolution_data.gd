## EvolutionData: the hidden tier-6 evolutions (GDD §4.3, pillar "Discovery
## stays"). A level-5 tower whose recipe is met shows Evolve; the recipe is a
## placement or record condition, checked only by Evolutions.recipe_met().
## Never shown to the player before it is found. Data only, no logic.
class_name EvolutionData
extends RefCounted

## Row keys:
##   from      — TowerData id it evolves.
##   name      — UI name; sprite — SpriteData key; icon — icons/<id>.
##   stats     — multipliers on top of the level-5 stats (damage, rate, range, hp).
##   set       — row keys replaced outright (pierce, splash, slow, hold...) and the
##               evolution's own special numbers, read by the class kit
##               (scripts/towers/<class>.gd documents each key).
##   recipe    — {type, ...}; types (Evolutions.recipe_met):
##                 "near"  — a tower of class `class` within `radius` px.
##                 "kills" — this tower has `n` kills.
##                 "near_level" — a tower of class `class` at level >= `level` within `radius`.
##                 "healed" — this tower has restored `n` HP to blockers (Mender).
##                 "damage" — this tower has dealt `n` damage.
##                 "any"   — any of the recipes in `of` (an Array of recipes) is met.
##                 "elite_kills" — this tower has killed `n` elites / minibosses / bosses.
##   tint      — optional Color the class kit draws the evolved sprite with (when it
##               shares its base sprite, e.g. the Bone Aegis).
const EVOLUTIONS: Dictionary = {
	"gravebow": {
		"from": "archer", "name": "Gravebow", "sprite": "summons/gravebow", "icon": "gravebow",
		"stats": {"damage": 1.4, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		"set": {
			"pierce": 2, "projectile": "projectiles/bone_spear",  # GDD §4.1 piercing arrows
			"split_every": 4,  # TUNING (not in GDD) Necropathy: every 4th shot splits
			"split_count": 2,  # TUNING (not in GDD) extra arrows at other enemies in range
			"split_damage": 0.7,  # TUNING (not in GDD) fraction of a shot's damage per split arrow
			"curse_mult": 1.15,  # TUNING (not in GDD) Necropathy curse +15% damage taken from the undead
			"curse_time": 4.0,  # TUNING (not in GDD) s, Necropathy curse_duration
		},
		"recipe": {"type": "kills", "n": 60},  # TUNING (not in GDD) GDD §4.3 example "200 kills", scaled so the March and Sanctum archers reach it too (integration)
	},
	"lich": {
		"from": "mage", "name": "Lich", "sprite": "summons/lich", "icon": "lich",
		"stats": {"damage": 1.5, "range": 1.1},  # TUNING (not in GDD)
		"set": {
			"splash": 70.0,  # TUNING (not in GDD)
			"raise_every": 3,  # TUNING (not in GDD) every 3rd kill rises (Necropathy: 20% chance; deterministic here)
			"risen_max": 3,  # TUNING (not in GDD) Risen standing at once (Necropathy max_alive 6)
			"risen_hp": 90.0,  # TUNING (not in GDD) HP of a Risen body
			"risen_hold": 1,  # TUNING (not in GDD) enemies a Risen holds
			"risen_time": 8.0,  # TUNING (not in GDD) s before it crumbles (Necropathy 12)
			"risen_damage": 12.0,  # TUNING (not in GDD) damage per Risen hit
			"risen_interval": 1.0,  # TUNING (not in GDD) s between Risen hits
		},
		"recipe": {"type": "near", "class": "frost_wraith", "radius": 200.0},  # TUNING (not in GDD) about one plot apart
	},
	"winter_revenant": {
		"from": "frost_wraith", "name": "Winter Revenant", "sprite": "summons/winter_revenant", "icon": "winter_revenant",
		"stats": {"damage": 1.5, "rate": 1.15},  # TUNING (not in GDD)
		"set": {
			"freeze_every": 3, "splash": 50.0,  # TUNING (not in GDD)
			"freeze_radius": 80.0,  # TUNING (not in GDD) Necropathy: Deep Freeze radius +35%
			"shatter_radius": 56.0,  # TUNING (not in GDD) px, Necropathy shatter radius
			"shatter_fraction": 0.22,  # TUNING (not in GDD) of the shattered enemy's max HP, Necropathy
			"shatter_slow": 0.6,  # TUNING (not in GDD) speed multiplier on the survivors (Necropathy chill 0.4 removed)
			"shatter_slow_time": 2.0,  # TUNING (not in GDD) s, Necropathy chill_duration
		},
		"recipe": {"type": "near", "class": "corpse_catapult", "radius": 220.0},  # TUNING (not in GDD)
	},
	"ossuary_engine": {
		"from": "corpse_catapult", "name": "Ossuary Engine", "sprite": "summons/ossuary_engine", "icon": "ossuary_engine",
		"stats": {"damage": 1.4, "rate": 1.1},  # TUNING (not in GDD)
		"set": {
			"projectile": "projectiles/corpse_boulder_burning",
			"boulders": 3,  # GDD §4.1 "three boulders"
			"boulder_spread": 36.0,  # TUNING (not in GDD) px around the aim point
			"field_radius": 30.0,  # TUNING (not in GDD) px of a burning bone-shard field
			"field_time": 3.0,  # TUNING (not in GDD) s it burns
			"field_tick": 0.5,  # TUNING (not in GDD) s between its damage ticks
			"field_fraction": 0.12,  # TUNING (not in GDD) of the boulder's damage per tick
		},
		"recipe": {"type": "damage", "n": 4000},  # TUNING (not in GDD) a damage record: splash damage rarely lands the killing blow
	},
	"keening_lady": {
		"from": "banshee", "name": "Keening Lady", "sprite": "summons/keening_lady", "icon": "keening_lady",
		"stats": {"damage": 1.5, "range": 1.15},  # TUNING (not in GDD)
		"set": {
			"slow": 0.6, "weaken": 0.55,  # TUNING (not in GDD)
			"waves": 3,  # GDD §4.1 "three waves"
			"wave_interval": 0.35,  # TUNING (not in GDD) s, Necropathy
			"wave_growth": 0.3,  # TUNING (not in GDD) radius x1, x1.3, x1.6, Necropathy
			"silence_time": 3.0,  # TUNING (not in GDD) s healers cannot heal (GDD §4.1 "silences healers")
		},
		"recipe": {"type": "near", "class": "mage", "radius": 210.0},  # TUNING (not in GDD) Requiem pair, about one plot apart
	},
	"profane_bishop": {
		"from": "mender", "name": "Profane Bishop", "sprite": "summons/bishop", "icon": "profane_bishop",
		"stats": {"hp": 1.6, "range": 1.15, "rate": 1.2},  # TUNING (not in GDD)
		"set": {
			"burn": 10.0,  # TUNING (not in GDD) damage to every enemy in range each pulse (Necropathy: Bishops burn foes with an aura)
			"revive_haste": 2.0,  # TUNING (not in GDD) s each pulse takes off a fallen body's respawn wait
		},
		"recipe": {"type": "any", "of": [{"type": "healed", "n": 1500}, {"type": "near", "class": "warder", "radius": 210.0}]},  # TUNING (not in GDD) GDD §4.1 "needs a Warder adjacent" (gw2-kit, DECISIONS K6); the healing record stays for rosters without the Warder
	},
	"death_knight": {
		"from": "warrior", "name": "Death Knight", "sprite": "summons/death_knight", "icon": "death_knight",
		"stats": {"damage": 1.5, "hp": 1.5},  # TUNING (not in GDD)
		"set": {
			"hold": 2,  # TUNING (not in GDD)
			"cleave_fraction": 0.5,  # TUNING (not in GDD) Necropathy cleave_fraction
			"lifesteal": 0.15,  # TUNING (not in GDD) Necropathy 0.12
		},
		"recipe": {"type": "near_level", "class": "mender", "level": 3, "radius": 160.0},  # TUNING (not in GDD)
	},
	"bone_colossus": {
		"from": "abomination", "name": "Bone Colossus", "sprite": "summons/bone_colossus", "icon": "bone_colossus",
		"stats": {"damage": 1.4, "hp": 1.6},  # TUNING (not in GDD)
		"set": {
			"hold": 6,  # TUNING (not in GDD)
			"taunt_radius": 210.0,  # TUNING (not in GDD) px: other blocker bodies this close send their hits to it (about one post apart)
			"shrapnel_radius": 90.0,  # TUNING (not in GDD) px, Necropathy
			"shrapnel_mult": 3.0,  # TUNING (not in GDD) x its stomp damage (Necropathy 2.0)
		},
		"recipe": {"type": "near", "class": "warrior", "radius": 200.0},  # TUNING (not in GDD) Flesh Rampart pair
	},
	# --- Later towers (gw2-kit) ---
	"bone_aegis": {
		"from": "warder", "name": "Bone Aegis", "sprite": "summons/warder", "icon": "warder",
		"tint": Color(1.3, 1.15, 0.7),  # TUNING (not in GDD) the Warder in gold (no own art)
		"stats": {"hp": 1.6, "rate": 1.2, "range": 1.1},  # TUNING (not in GDD)
		"set": {
			"barrier_time": 8.0,  # TUNING (not in GDD)
			"thorns": 0.5,  # TUNING (not in GDD) fraction of the damage a barrier absorbs dealt back to the striker
		},
		"recipe": {"type": "near", "class": "mender", "radius": 210.0},  # TUNING (not in GDD) Necropathy's Mender + Warder pair, about one plot apart
	},
	"shadow_reaper": {
		"from": "rogue", "name": "Shadow Reaper", "sprite": "summons/shadow_reaper", "icon": "shadow_reaper",
		"stats": {"damage": 1.3, "rate": 1.6},  # TUNING (not in GDD) Necropathy: halved dash cooldown
		"set": {
			"chain_dashes": 2, "chain_radius": 90.0,  # TUNING (not in GDD) Necropathy chained dashes
			"bleed_dps": 12.0, "bleed_time": 4.0,  # TUNING (not in GDD) Necropathy stacking bleeds
			"kill_reset": 0.6,  # TUNING (not in GDD) Necropathy dash-kill reset
		},
		"recipe": {"type": "elite_kills", "n": 12},  # TUNING (not in GDD) a deed: the elite hunter's record
	},
	"cathedral_horror": {
		"from": "gargoyle", "name": "Cathedral Horror", "sprite": "summons/cathedral_horror", "icon": "cathedral_horror",
		"stats": {"damage": 1.5, "range": 1.1},  # TUNING (not in GDD)
		"set": {
			"splash": 62.0,  # TUNING (not in GDD) Necropathy wider swoop
			"dive_stun": 0.8,  # TUNING (not in GDD) Necropathy dive stun
			"stone_time": 0.9,  # TUNING (not in GDD) Necropathy stone form after landing
		},
		"recipe": {"type": "near", "class": "rogue", "radius": 240.0},  # TUNING (not in GDD) Death from Above pair
	},
	"hellhound": {
		"from": "bone_hound", "name": "Hellhound", "sprite": "summons/hellhound", "icon": "hellhound",
		"stats": {"damage": 1.4, "rate": 1.15},  # TUNING (not in GDD)
		"set": {
			"hound_speed": 270.0,  # TUNING (not in GDD) Necropathy Blood Scent
			"burn_dps": 9.0, "burn_time": 2.0,  # TUNING (not in GDD) Necropathy burning bites
		},
		"recipe": {"type": "near", "class": "banshee", "radius": 220.0},  # TUNING (not in GDD) Baying pair
	},
	"seraph_of_ruin": {
		"from": "fallen_seraph", "name": "Seraph of Ruin", "sprite": "summons/ruin_seraph", "icon": "ruin_seraph",
		"stats": {"damage": 1.35, "range": 1.1},  # TUNING (not in GDD)
		"set": {
			"feathers": 5, "pierce": 1,  # TUNING (not in GDD)
			"ruin_every": 5, "ruin_mult": 3.0, "ruin_radius": 70.0,  # TUNING (not in GDD) Necropathy's dive (effects/seraph_dive)
		},
		"recipe": {"type": "kills", "n": 70},  # TUNING (not in GDD)
	},
	"ossuary_titan": {
		"from": "bone_golem", "name": "Ossuary Titan", "sprite": "summons/ossuary_titan", "icon": "ossuary_titan",
		"stats": {"damage": 1.4, "hp": 1.5},  # TUNING (not in GDD)
		"set": {
			"hold": 5,  # TUNING (not in GDD)
			"slam_every": 2,  # TUNING (not in GDD)
			"hunger_heal": 30.0,  # TUNING (not in GDD)
		},
		"recipe": {"type": "near", "class": "warder", "radius": 220.0},  # TUNING (not in GDD) Necropathy Grave Masonry -> a Warder beside it
	},
	"oni_lord": {
		"from": "bound_oni", "name": "Oni Lord", "sprite": "summons/oni_lord", "icon": "oni_lord",
		"stats": {"damage": 1.4, "hp": 1.4},  # TUNING (not in GDD)
		"set": {
			"hold": 4,  # TUNING (not in GDD)
			"smash_every": 2,  # TUNING (not in GDD)
			"stun_time": 1.4,  # TUNING (not in GDD)
			"quake_radius": 90.0,  # TUNING (not in GDD) px the smash shakes the ground
			"quake_mult": 0.6,  # TUNING (not in GDD) fraction of its damage to each foe in the quake
		},
		"recipe": {"type": "any", "of": [{"type": "elite_kills", "n": 6}, {"type": "kills", "n": 30}]},  # TUNING (not in GDD) Necropathy Oni's Resolve -> a record of slain foes
	},
}
