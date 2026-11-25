## MetaData: permanent progression between maps (GDD §8.2): the save file,
## Soul Ash payouts, the Ossuary upgrade table, the tower families its trees
## act on, and the class Masteries. Read by Meta (save, records, payouts) and
## MetaModifiers (the one path into a run). Data only, no logic.
##
## To add an Ossuary upgrade: add an UPGRADES row and its id to ORDER, then
## read its key in MetaModifiers (the only place a bonus reaches a run).
class_name MetaData
extends RefCounted

## The progress file (separate from Necropathy's, GDD §8.3). Never written
## under --autotest unless --meta-save.
const SAVE_PATH: String = "user://gravewatch_save.cfg"
## Save format version (bump with a migration in Meta.load_save()).
const SAVE_VERSION: int = 2  # 2: the `unlocks` section (gw2-kit; Meta migrates version 1 saves)

## --- Soul Ash (GDD §8.2 "by skulls earned and difficulty") -------------------

## Ash for any cleared map, before the difficulty multiplier.
const CLEAR_BASE: int = 60  # TUNING (not in GDD) integration: the Ossuary in ~20 good clears
## Ash per skull earned on a clear (1..3 skulls), before the difficulty multiplier.
const ASH_PER_SKULL: int = 80  # TUNING (not in GDD) a 3-skull Necromancer Graveyard clear = 300
## Ash per wave cleared on a defeat (GDD §8.2 "a smaller amount by waves survived").
const ASH_PER_WAVE: int = 6  # TUNING (not in GDD) a wave-11 defeat = 66
## Extra ash multiplier per map position in MapRegistry order: map n pays
## 1 + (n - 1) x this (the second map pays x1.25, the third x1.5, as in Necropathy's acts).
const MAP_STEP: float = 0.25  # TUNING (not in GDD)
## Ash per Reckoning wave survived past the map's last wave (paid once, at the end).
const ASH_PER_RECKONING_WAVE: int = 10  # TUNING (not in GDD)

## --- The Ossuary (GDD §8.2 "a new, smaller upgrade table") --------------------

## Ossuary tile order (the screen lists them in this order).
const ORDER: Array[String] = ["start_souls", "lives", "sell_refund", "spell_cooldown", "spell_slot", "respawn",
	"tree_ranged", "tree_aura", "tree_blocker", "ult_charge"]

## Upgrade rows. Keys:
##   name  — tile name (NAME tier, a few words).
##   desc  — one line saying what one level does.
##   icon  — art: "td:<TdArtData role>" or "icons/<id>" (SpriteBank icon).
##   costs — Soul Ash per level, level 1 first (its size = max level).
##   per   — value one level adds to the MetaModifiers bonus key of the same id
##           (souls, lives, fraction, or a multiplier step for the trees).
const UPGRADES: Dictionary = {
	"start_souls": {"name": "Grave Tithe", "desc": "+15 souls at the start of a map", "icon": "td:icon_souls",
		"costs": [60, 120, 200, 300, 450], "per": 15},  # TUNING (not in GDD)
	"lives": {"name": "Bone Gate", "desc": "+2 gate lives", "icon": "td:icon_lives",
		"costs": [100, 220, 400], "per": 2},  # TUNING (not in GDD)
	"sell_refund": {"name": "Thrift", "desc": "+5% souls back on a sale", "icon": "td:icon_sell",
		"costs": [80, 180, 320], "per": 0.05},  # TUNING (not in GDD) 70% -> 85% at max
	"spell_cooldown": {"name": "Quick Rites", "desc": "Spell cooldowns 4% shorter", "icon": "icons/shadow_bolt",
		"costs": [90, 160, 250, 360, 500], "per": 0.04},  # TUNING (not in GDD) -20% at max
	"spell_slot": {"name": "Fourth Rite", "desc": "Bring a fourth spell", "icon": "icons/bone_wall",
		"costs": [700], "per": 1},  # GDD §8.2 "a fourth spell slot"
	"respawn": {"name": "Restless", "desc": "Blockers return 10% sooner", "icon": "icons/warrior",
		"costs": [80, 170, 300], "per": 0.1},  # TUNING (not in GDD)
	"tree_ranged": {"name": "Marksmen", "desc": "Ranged towers +5% damage", "icon": "icons/archer",
		"costs": [120, 240, 420], "per": 0.05},  # TUNING (not in GDD) GDD §8.2 "one tree per tower family"
	"tree_aura": {"name": "Dirges", "desc": "Aura towers +5% damage and heals", "icon": "icons/banshee",
		"costs": [120, 240, 420], "per": 0.05},  # TUNING (not in GDD)
	"tree_blocker": {"name": "Bulwark", "desc": "Blockers +8% body HP", "icon": "icons/abomination",
		"costs": [120, 240, 420], "per": 0.08},  # TUNING (not in GDD)
	"ult_charge": {"name": "Soul Hunger", "desc": "The ultimate charges 10% faster", "icon": "icons/dread_rally",
		"costs": [150, 300, 500], "per": 0.1},  # TUNING (not in GDD) gw2-kit: four ultimates on one meter
}

## Tower family of a tower row (the trees and masteries): "post" spots are
## blockers, "aura" behaviours are auras, everything else is ranged, so new
## tower rows fall into a family without a table edit. Family -> [tree
## upgrade id, stat key its multiplier scales ("damage" or "hp")].
const FAMILIES: Dictionary = {
	"ranged": ["tree_ranged", "damage"],  # TUNING (not in GDD)
	"aura": ["tree_aura", "damage"],  # TUNING (not in GDD) heals scale with "hp" too (see MetaModifiers)
	"blocker": ["tree_blocker", "hp"],  # TUNING (not in GDD)
}

## --- Masteries (GDD §8.2: a class at level 5 in any map opens a permanent bonus) ---

## Multiplier a mastered class gets on its family's stat (damage, or body HP for blockers).
const MASTERY_MULT: float = 1.08  # TUNING (not in GDD)
## Tower level that opens the class's mastery.
const MASTERY_LEVEL: int = 5  # GDD §8.2
