## CharacterData: the playable necromancers of the pre-map pick (GDD §5
## "Characters"), Necropathy's characters of the launch spells. Each starts
## with its own spell, stronger, and keeps one innate passive. The Gravecaller
## is the default with no innate and baseline numbers: with him a run is
## identical to a run without characters. Read only through
## CharacterModifiers (the one character path). Data only, no logic.
##
## To add a character: add a CHARACTERS row and its id to ORDER, copy its
## sprite, and read any new innate key in CharacterModifiers.
class_name CharacterData
extends RefCounted

## Character played when none is chosen (and by the autotest by default).
const DEFAULT_ID: String = "gravecaller"
## Picker order.
const ORDER: Array[String] = ["gravecaller", "barrow_warden", "carrion_lord", "plague_scholar",
	"doomsayer", "soulbinder", "wither_witch", "grave_herald",
	"undertaker", "fallen_sergeant", "revenant_heroine"]  # The later spells' characters (gw2-kit), appended; Act IV's (w2b-city)

## Character rows. Keys:
##   name         — UI name.
##   short        — optional: shorter name for the pre-map tile when the name does not fit.
##   sprite       — SpriteData key of the portrait.
##   spell        — SpellData id it always brings (slot 1).
##   boost        — its own spell's row keys x these multipliers (only keys the row
##                  has are touched; "cooldown" scales the cooldown). {} = none.
##   innate       — {name, desc, and effect keys}; effect keys read by CharacterModifiers:
##                  blocker_hp (x body HP of blockers), start_souls (+souls at the start),
##                  cooldown (x every spell cooldown); gw2-kit: brand_slow (Death Mark's
##                  brand also slows to this multiplier), chain_extra (+links for Soul
##                  Chains), wither_rot (Wither's aura adds this Rot damage per s),
##                  temp_time (x every temporary Risen's lifetime). {} = none.
##   unlock_after — map id whose boss opens it ("" = open from the start).
const CHARACTERS: Dictionary = {
	"gravecaller": {
		"name": "The Gravecaller", "short": "Gravecaller", "sprite": "player/necromancer", "spell": "shadow_bolt",
		"boost": {},  # GDD §5 "the default with no innate"
		"innate": {},  # GDD §5
		"unlock_after": "",
	},
	"barrow_warden": {
		"name": "Barrow Warden", "sprite": "player/barrow_warden", "spell": "bone_wall",
		"boost": {"duration": 1.3, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Stonebone", "desc": "Blockers +15% body HP", "blocker_hp": 1.15},  # TUNING (not in GDD)
		"unlock_after": "graveyard",  # TUNING (not in GDD)
	},
	"carrion_lord": {
		"name": "Carrion Lord", "sprite": "player/carrion_lord", "spell": "corpse_explosion",
		"boost": {"damage": 1.25, "radius": 1.15, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Grave Harvest", "desc": "+40 souls at the start of a map", "start_souls": 40},  # TUNING (not in GDD)
		"unlock_after": "crimson_march",  # TUNING (not in GDD)
	},
	"plague_scholar": {
		"name": "Plague Scholar", "sprite": "player/plague_scholar", "spell": "plague_cloud",
		"boost": {"damage": 1.25, "dps": 1.25, "duration": 1.2, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Contagion", "desc": "All spell cooldowns 10% shorter", "cooldown": 0.9},  # TUNING (not in GDD)
		"unlock_after": "sanctum",  # TUNING (not in GDD)
	},
	# --- The later spells' characters (gw2-kit; Necropathy character_data.gd innates) ---
	"doomsayer": {
		"name": "Doomsayer", "sprite": "player/doomsayer", "spell": "death_mark",
		"boost": {"dps": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Ill Omen", "desc": "Branded foes are slowed 15%", "brand_slow": 0.85},  # Necropathy "slowed by 15%"
		"unlock_after": "graveyard",  # TUNING (not in GDD)
	},
	"soulbinder": {
		"name": "Soulbinder", "sprite": "player/soulbinder", "spell": "soul_chains",
		"boost": {"damage": 1.25, "pulse": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Conductor", "desc": "Soul Chains bind one more foe", "chain_extra": 1},  # Necropathy "jump to one extra enemy"
		"unlock_after": "crimson_march",  # TUNING (not in GDD)
	},
	"wither_witch": {
		"name": "Wither Witch", "sprite": "player/wither_witch", "spell": "wither",
		"boost": {"shred": 1.3, "duration": 1.2, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Creeping Rot", "desc": "Wither also rots what it touches", "wither_rot": 8.0},  # Necropathy "also inflicts Rot"
		"unlock_after": "crimson_march",  # TUNING (not in GDD)
	},
	"grave_herald": {
		"name": "Grave Herald", "sprite": "player/grave_herald", "spell": "raise_dead",
		"boost": {"hp": 1.25, "count": 1.34, "cooldown": 0.85},  # TUNING (not in GDD) count 3 -> 4
		"innate": {"name": "Restless", "desc": "Every Risen lasts 25% longer", "temp_time": 1.25},  # Necropathy "last 25% longer"
		"unlock_after": "sanctum",  # TUNING (not in GDD)
	},
	# --- Act IV, the Last Line (w2b-city; Necropathy character_data.gd innates). Innate keys
	# read by their spells through CharacterModifiers.innate(): hearse_extra (+hearses a Hearse
	# Run cast), mines_extra (+mines a Bone Mines cast), fist_extra (+fists a Hero's Fist cast). ---
	"undertaker": {
		"name": "The Undertaker", "short": "Undertaker", "sprite": "player/undertaker", "spell": "hearse_run",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Last Ride", "desc": "Hearse Run sends one more hearse", "hearse_extra": 1},  # Necropathy "one more hearse"
		"unlock_after": "skid_row",  # TUNING (not in GDD)
	},
	"fallen_sergeant": {
		"name": "The Fallen Sergeant", "short": "Sergeant", "sprite": "player/fallen_sergeant", "spell": "bone_mines",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Sapper's Hands", "desc": "Bone Mines lays one more mine", "mines_extra": 1},  # Necropathy "two mines where it lays one"
		"unlock_after": "fort_kessler",  # TUNING (not in GDD)
	},
	"revenant_heroine": {
		"name": "The Revenant Heroine", "short": "Heroine", "sprite": "player/revenant_heroine", "spell": "heros_fist",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Back From the Dead", "desc": "Hero's Fist strikes one more foe", "fist_extra": 1},  # Necropathy "strikes one more foe"
		"unlock_after": "liberty_heights",  # TUNING (not in GDD)
	},
}

## Ultimates offered by the pre-map pick (GDD §5: Dread Rally at launch;
## Sovereign's Decree, Eclipse and Grave Tide are later rows). Each id names a
## SpellData.ULTIMATE-style row; only "dread_rally" exists today.
const ULTIMATES: Array[String] = ["dread_rally", "sovereigns_decree", "eclipse", "grave_tide"]  # GDD §5; the later three are SpellData.ULTIMATES rows (gw2-kit)
