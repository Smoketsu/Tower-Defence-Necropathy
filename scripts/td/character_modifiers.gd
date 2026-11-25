## CharacterModifiers: the one path through which the chosen character
## (CharacterData) changes a run (GDD §5 "Characters"): its own spell forced
## into slot 1 and boosted, and its one innate. Static, set by Main / the
## autotest before a run starts (`current`). The Gravecaller has no boost and
## no innate, so every function here returns its input unchanged for him.
class_name CharacterModifiers
extends RefCounted

## Id of the character of the run being started / played (CharacterData key).
static var current: String = CharacterData.DEFAULT_ID


## The current character's row (the default's when unknown).
static func row() -> Dictionary:
	return CharacterData.CHARACTERS.get(current, CharacterData.CHARACTERS[CharacterData.DEFAULT_ID])


## The value of innate effect key `key` (`fallback` when the character has none).
static func innate(key: String, fallback: Variant) -> Variant:
	return (row()["innate"] as Dictionary).get(key, fallback)


## `base` spells with the character's own spell in slot 1 (moved there if
## already chosen, else replacing the last slot), same length.
static func loadout(base: Array[String]) -> Array[String]:
	var own := String(row()["spell"])  # The character's spell.
	var out: Array[String] = base.duplicate()  # The result.
	if out.is_empty() or out[0] == own:
		return out
	if out.has(own):
		out.erase(own)
	else:
		out.pop_back()
	out.push_front(own)
	return out


## The row a spell instance of `id` reads: a boosted copy for the character's
## own spell, else `r` itself (unchanged, so baseline runs are identical).
static func spell_row(id: String, r: Dictionary) -> Dictionary:
	var boost: Dictionary = row()["boost"]  # Its multipliers.
	if id != String(row()["spell"]) or boost.is_empty():
		return r
	var out := r.duplicate()  # Boosted copy.
	for k: String in boost:
		if k != "cooldown" and out.has(k) and (out[k] is float or out[k] is int):
			out[k] = float(out[k]) * float(boost[k])
	return out


## Multiplier on the cooldown of spell `id` (own-spell boost x innate).
static func cooldown_mult(id: String) -> float:
	var m := float(innate("cooldown", 1.0))  # Innate part.
	if id == String(row()["spell"]):
		m *= float((row()["boost"] as Dictionary).get("cooldown", 1.0))
	return m


## Souls at the start of a map after the innate (`base` already has meta).
static func start_souls(base: int) -> int:
	return base + int(innate("start_souls", 0))


## Scales tower `t`'s stat multipliers `mult` (Tower.recompute()) by the innate.
static func apply_tower(t: Tower, mult: Dictionary) -> void:
	if t.row.has("body_hp"):
		mult["hp"] = float(mult["hp"]) * float(innate("blocker_hp", 1.0))


## Multiplier on every temporary Risen's lifetime (Grave Herald's Restless; 1 = none).
static func temp_time_mult() -> float:
	return float(innate("temp_time", 1.0))
