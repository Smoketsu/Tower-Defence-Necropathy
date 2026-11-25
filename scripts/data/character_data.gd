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
const ORDER: Array[String] = ["gravecaller", "barrow_warden", "carrion_lord", "plague_scholar"]

## Character rows. Keys:
##   name         — UI name.
##   sprite       — SpriteData key of the portrait.
##   spell        — SpellData id it always brings (slot 1).
##   boost        — its own spell's row keys x these multipliers (only keys the row
##                  has are touched; "cooldown" scales the cooldown). {} = none.
##   innate       — {name, desc, and effect keys}; effect keys read by CharacterModifiers:
##                  blocker_hp (x body HP of blockers), start_souls (+souls at the start),
##                  cooldown (x every spell cooldown). {} = none.
##   unlock_after — map id whose boss opens it ("" = open from the start).
const CHARACTERS: Dictionary = {
	"gravecaller": {
		"name": "The Gravecaller", "sprite": "player/necromancer", "spell": "shadow_bolt",
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
}

## Ultimates offered by the pre-map pick (GDD §5: Dread Rally at launch;
## Sovereign's Decree, Eclipse and Grave Tide are later rows). Each id names a
## SpellData.ULTIMATE-style row; only "dread_rally" exists today.
const ULTIMATES: Array[String] = ["dread_rally"]  # GDD §5
