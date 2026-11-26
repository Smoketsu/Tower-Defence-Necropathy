## DifficultyData: the four difficulty levels, names kept from Necropathy (GDD
## §8.2). Applied only through DifficultyModifiers. Data only, no logic.
class_name DifficultyData
extends RefCounted

## Difficulty used when none is chosen (Necromancer = the standard game).
const DEFAULT_ID: String = "necromancer"
## Menu order.
const ORDER: Array[String] = ["initiate", "necromancer", "lich", "deathlord"]
## Level rows. Keys:
##   name      — UI name.
##   hp_mult   — multiplier on every enemy's HP.
##   count_mult — multiplier on every wave group's enemy count (rounded, at least 1).
##   ash_mult  — Soul Ash multiplier (meta progression, later).
const LEVELS: Dictionary = {
	"initiate": {"name": "Initiate", "hp_mult": 0.75, "count_mult": 0.85, "ash_mult": 0.75},  # TUNING (not in GDD)
	"necromancer": {"name": "Necromancer", "hp_mult": 1.0, "count_mult": 1.0, "ash_mult": 1.0},  # GDD §8.2 baseline
	"lich": {"name": "Lich", "hp_mult": 1.1, "count_mult": 1.1, "ash_mult": 1.5},  # TUNING (not in GDD) DECISIONS Y6: hp 1.15 -> 1.1 (Lich lost 14 of 20 spot runs)
	"deathlord": {"name": "Deathlord", "hp_mult": 1.5, "count_mult": 1.3, "ash_mult": 2.0},  # TUNING (not in GDD)
}
