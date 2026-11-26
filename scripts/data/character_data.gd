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
	"marooned_quartermaster", "corsair_queen", "ghost_helmsman", "moon_huntress", "hedge_witch", "dhampir", "undertaker", "fallen_sergeant", "revenant_heroine", "grave_kunoichi", "ronin_revenant", "shrine_maiden",
	"rune_seer", "shield_maiden_hero", "berserker_hero"]  # The later spells' characters (gw2-kit), appended

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
##                  temp_time (x every temporary Risen's lifetime); w2b-court: moonfang_jaws
##                  (+jaws per Moonfang cast), circle_radius (+share of Hex Circle's radius),
##                  swarm_bats (+bats in Night Swarm), read by those spells. {} = none.
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
	# --- Act II, the Black Tide (w2b-tide; Necropathy character_data.gd innates) ---
	"marooned_quartermaster": {
		"name": "Marooned Quartermaster", "short": "Quartermaster", "sprite": "player/marooned_quartermaster", "spell": "chain_shot",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Spare Shot", "desc": "Chain Shot fires one more chain-shot", "shot_extra": 1},  # Necropathy "one more chain-shot a cast"; key shot_extra: + shots (read by chain_shot.gd)
		"unlock_after": "cutter",  # TUNING (not in GDD)
	},
	"corsair_queen": {
		"name": "The Corsair Queen", "short": "Corsair Queen", "sprite": "player/corsair_queen", "spell": "cannonade",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Queen's Ransom", "desc": "Cannonade marks one more pack", "marks_extra": 1},  # Necropathy "one more mark a volley"; key marks_extra: + marks (read by cannonade.gd)
		"unlock_after": "galleon",  # TUNING (not in GDD)
	},
	"ghost_helmsman": {
		"name": "Ghost Helmsman", "short": "Helmsman", "sprite": "player/ghost_helmsman", "spell": "anchor_drop",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Second Anchor", "desc": "Anchor Drop drops a second anchor", "anchor_extra": 1},  # Necropathy "one more anchor a cast"; key anchor_extra: + anchors (read by anchor_drop.gd)
		"unlock_after": "maelstrom",  # TUNING (not in GDD)
	},
	# --- Act III: the Sanguine Court (w2b-court; Necropathy character_data.gd innates) ---
	"moon_huntress": {
		"name": "The Moon-Cursed Huntress", "short": "Huntress", "sprite": "player/moon_huntress", "spell": "moonfang",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Hunter's Moon", "desc": "Moonfang snaps one more set of jaws", "moonfang_jaws": 1},  # Necropathy "one more jaw per cast"
		"unlock_after": "ravensmoor",  # TUNING (not in GDD)
	},
	"hedge_witch": {
		"name": "The Hedge Witch", "short": "Hedge Witch", "sprite": "player/hedge_witch", "spell": "witch_circle",
		"boost": {"drain": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Hedge Lore", "desc": "Every Hex Circle she draws is a quarter wider", "circle_radius": 0.25},  # Necropathy +25% radius
		"unlock_after": "witchwood",  # TUNING (not in GDD)
	},
	"dhampir": {
		"name": "The Dhampir", "short": "Dhampir", "sprite": "player/dhampir", "spell": "night_swarm",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Half-Blood", "desc": "Night Swarm calls two more bats", "swarm_bats": 2},  # Necropathy "two more bats"
		"unlock_after": "castle_sanguis",  # TUNING (not in GDD)
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
	# --- Act V's characters (w2b-shogun; Necropathy's Shogunate characters) ---
	"grave_kunoichi": {
		"name": "Grave Kunoichi", "short": "Kunoichi", "sprite": "player/grave_kunoichi", "spell": "hundred_shadows",
		"boost": {"damage": 1.25, "count": 1.34, "cooldown": 0.85},  # TUNING (not in GDD) count 3 -> 4
		"innate": {"name": "Hidden Hand", "desc": "+40 souls at the start of a map", "start_souls": 40},  # TUNING (not in GDD)
		"unlock_after": "province",  # Kage
	},
	"ronin_revenant": {
		"name": "Ronin Revenant", "short": "Ronin", "sprite": "player/ronin_revenant", "spell": "banner_of_the_dead",
		"boost": {"rate_mult": 1.1, "duration": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Unbending", "desc": "Blockers +15% body HP", "blocker_hp": 1.15},  # Necropathy's Act V counter-passive name
		"unlock_after": "kurogane",  # Shogun Kurogane
	},
	"shrine_maiden": {
		"name": "Shrine Maiden of Night", "short": "Shrine Maiden", "sprite": "player/shrine_maiden", "spell": "black_sun",
		"boost": {"damage": 1.25, "duration": 1.2, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Stolen Dawn", "desc": "All spell cooldowns 10% shorter", "cooldown": 0.9},  # TUNING (not in GDD)
		"unlock_after": "sun_road",  # Amaterasu
	},
	# --- Act VI, the Hall of the Slain (w2c-norse; Necropathy character_data.gd innates). Innate keys
	# read by their spells through CharacterModifiers.innate(): grasp_hands (+hands a Barrow Grasp
	# cast), spear_jumps (+leaps a Valkyrie Spear cast), gungnir_spears (+spears a Gungnir cast). ---
	"rune_seer": {
		"name": "The Rune-Seer", "short": "Rune-Seer", "sprite": "player/rune_seer", "spell": "barrow_grasp",
		"boost": {"damage": 1.25, "hold": 1.2, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Rune of Binding", "desc": "Barrow Grasp raises two more hands", "grasp_hands": 2},  # Necropathy "two more hands in every ring"
		"unlock_after": "barrow_fields",  # Hrimgar
	},
	"shield_maiden_hero": {
		"name": "The Shield-Maiden", "short": "Shield-Maiden", "sprite": "player/shield_maiden_hero", "spell": "valkyrie_spear",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Shield-Sister", "desc": "Valkyrie Spear leaps to one more foe", "spear_jumps": 1},  # Necropathy "leaps to one more foe"
		"unlock_after": "valgard",  # Sigrun
	},
	"berserker_hero": {
		"name": "The Berserker", "short": "Berserker", "sprite": "player/berserker_hero", "spell": "gungnir",
		"boost": {"damage": 1.25, "cooldown": 0.85},  # TUNING (not in GDD)
		"innate": {"name": "Bear-Shirt", "desc": "Gungnir throws one more spear", "gungnir_spears": 1},  # Necropathy "throws one more spear"
		"unlock_after": "vigrid",  # Odin
	},
}

## Ultimates offered by the pre-map pick (GDD §5: Dread Rally at launch;
## Sovereign's Decree, Eclipse and Grave Tide are later rows). Each id names a
## SpellData.ULTIMATE-style row; only "dread_rally" exists today.
const ULTIMATES: Array[String] = ["dread_rally", "sovereigns_decree", "eclipse", "grave_tide"]  # GDD §5; the later three are SpellData.ULTIMATES rows (gw2-kit)
