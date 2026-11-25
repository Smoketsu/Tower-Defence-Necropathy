## DifficultyModifiers: the one path through which the difficulty level
## (DifficultyData) changes a run: enemy HP and wave group counts. Static,
## reads the level id the run was started with.
class_name DifficultyModifiers
extends RefCounted


## The level row of difficulty `id` (the default row when unknown).
static func row(id: String) -> Dictionary:
	return DifficultyData.LEVELS.get(id, DifficultyData.LEVELS[DifficultyData.DEFAULT_ID])


## Multiplier on every enemy's HP on difficulty `id`.
static func hp_mult(id: String) -> float:
	return float(row(id)["hp_mult"])


## Enemy count of a wave group of `count` on difficulty `id` (at least 1).
static func group_count(id: String, count: int) -> int:
	return maxi(1, roundi(float(count) * float(row(id)["count_mult"])))
