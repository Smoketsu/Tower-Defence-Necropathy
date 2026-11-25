## Old Hollow-Eye (the Treasure Galleon's miniboss, the kraken; Necropathy
## OldHollowEyeKit "every tentacle grabs"): every `every` s (the first `first`
## s after it arrives) a tentacle rises at the nearest tower within `reach` px
## that is not already held: a telegraphed strike (game.hostile.shell()) of
## `radius` px lands `telegraph` s later, seizing every tower inside for
## `disable` s (cause "grabbed") and crushing blocker bodies there for
## `body_damage`. Args in its row. vars: "next" (game s).
extends EnemyTrait

## The nearest-tower search shared with the Voodoo Navigator.
const SeaMark = preload("res://scripts/enemies/traits/corsair/sea_mark.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var t := SeaMark.nearest_tower(game, e.position, float(a["reach"]))  # The seized tower.
	if t == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	game.hostile.shell(t.position, float(a["radius"]), float(a["telegraph"]), float(a["disable"]), "grabbed", float(a["body_damage"]))
	EnemyTrait.note(game, "hollow_eye_grabs")
	e.vis_strike_at = game.time
	e.vis_strike_dir = (t.position - e.position).normalized()
