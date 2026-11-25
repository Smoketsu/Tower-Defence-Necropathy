## Sister of the Red Moon (Isolde's phase 2): a witch who draws hex circles on
## towers like the Crimson Witch (witch.gd args, no heal) and tells Isolde when
## she falls (vars "isolde": [TdEnemy, generation], set by the boss), so the boss
## can raise the fallen ones that did not fall together. Args: range, every,
## circle_r, mult, time.
extends "res://scripts/enemies/traits/court/witch.gd"


func on_death(e: TdEnemy, game: TdGame) -> void:
	var pair: Array = e.vars.get("isolde", [])  # Her boss.
	if not pair.is_empty() and TdEnemy.valid(pair[0], int(pair[1])):
		(pair[0] as TdEnemy).traits.call("sister_fell", pair[0], game, e)
