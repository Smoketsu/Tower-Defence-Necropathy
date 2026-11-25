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
##   set       — row keys replaced outright (pierce, splash, slow, hold...).
##   recipe    — {type, ...}; types (Evolutions.recipe_met):
##                 "near"  — a tower of class `class` within `radius` px.
##                 "kills" — this tower has `n` kills.
##                 "near_level" — a tower of class `class` at level >= `level` within `radius`.
const EVOLUTIONS: Dictionary = {
	"gravebow": {
		"from": "archer", "name": "Gravebow", "sprite": "summons/gravebow", "icon": "gravebow",
		"stats": {"damage": 1.4, "rate": 1.1, "range": 1.1},  # TUNING (not in GDD)
		"set": {"pierce": 2, "projectile": "projectiles/bone_spear"},  # GDD §4.1 piercing arrows
		"recipe": {"type": "kills", "n": 150},  # TUNING (not in GDD) GDD §4.3 example "200 kills"
	},
	"lich": {
		"from": "mage", "name": "Lich", "sprite": "summons/lich", "icon": "lich",
		"stats": {"damage": 1.5, "range": 1.1},  # TUNING (not in GDD)
		"set": {"splash": 70.0},  # TUNING (not in GDD)
		"recipe": {"type": "near", "class": "frost_wraith", "radius": 180.0},  # TUNING (not in GDD)
	},
	"winter_revenant": {
		"from": "frost_wraith", "name": "Winter Revenant", "sprite": "summons/winter_revenant", "icon": "winter_revenant",
		"stats": {"damage": 1.5, "rate": 1.15},  # TUNING (not in GDD)
		"set": {"freeze_every": 3, "splash": 50.0},  # TUNING (not in GDD) GDD §4.1 shatter: later behaviour
		"recipe": {"type": "near", "class": "corpse_catapult", "radius": 220.0},  # TUNING (not in GDD)
	},
	"ossuary_engine": {
		"from": "corpse_catapult", "name": "Ossuary Engine", "sprite": "summons/ossuary_engine", "icon": "ossuary_engine",
		"stats": {"damage": 1.4, "rate": 1.1},  # TUNING (not in GDD)
		"set": {"projectile": "projectiles/corpse_boulder_burning"},  # GDD §4.1 three boulders: later behaviour
		"recipe": {"type": "kills", "n": 120},  # TUNING (not in GDD)
	},
	"keening_lady": {
		"from": "banshee", "name": "Keening Lady", "sprite": "summons/keening_lady", "icon": "keening_lady",
		"stats": {"damage": 1.5, "range": 1.15},  # TUNING (not in GDD)
		"set": {"slow": 0.6, "weaken": 0.55},  # TUNING (not in GDD)
		"recipe": {"type": "near", "class": "mage", "radius": 180.0},  # TUNING (not in GDD) Requiem pair
	},
	"profane_bishop": {
		"from": "mender", "name": "Profane Bishop", "sprite": "summons/bishop", "icon": "profane_bishop",
		"stats": {"hp": 1.6, "range": 1.15, "rate": 1.2},  # TUNING (not in GDD)
		"set": {},
		"recipe": {"type": "near", "class": "warder", "radius": 150.0},  # GDD §4.1 "needs a Warder adjacent" (Warder is a later tower)
	},
	"death_knight": {
		"from": "warrior", "name": "Death Knight", "sprite": "summons/death_knight", "icon": "death_knight",
		"stats": {"damage": 1.5, "hp": 1.5},  # TUNING (not in GDD)
		"set": {"hold": 2},  # TUNING (not in GDD)
		"recipe": {"type": "near_level", "class": "mender", "level": 3, "radius": 160.0},  # TUNING (not in GDD)
	},
	"bone_colossus": {
		"from": "abomination", "name": "Bone Colossus", "sprite": "summons/bone_colossus", "icon": "bone_colossus",
		"stats": {"damage": 1.4, "hp": 1.6},  # TUNING (not in GDD)
		"set": {"hold": 6},  # TUNING (not in GDD) GDD §4.1 taunt / shrapnel: later behaviour
		"recipe": {"type": "near", "class": "warrior", "radius": 200.0},  # TUNING (not in GDD) Flesh Rampart pair
	},
}
