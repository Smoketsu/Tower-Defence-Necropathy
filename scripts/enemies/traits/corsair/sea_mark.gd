## Voodoo Navigator (the Black Tide; Necropathy VoodooNavigatorKit "marks a
## spot; the sea strikes it 1.5 s later"): every `every` s she marks the
## nearest tower within `reach` px that is not already disabled, and the sea
## strikes it: a telegraphed shell (game.hostile.shell(), the one path) of
## `radius` px landing `telegraph` s later disables every tower inside for
## `disable` s (cause "grabbed": a tentacle from the deep). A silenced
## navigator cannot mark. Args in her row. vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next"]) or not EnemyTrait.can_heal(e, game) or game.time < e.freeze_until:
		return
	var t := nearest_tower(game, e.position, float(a["reach"]))  # Her mark.
	if t == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	game.hostile.shell(t.position, float(a["radius"]), float(a["telegraph"]), float(a["disable"]), "grabbed")
	EnemyTrait.note(game, "sea_marks")
	e.vis_strike_at = game.time
	e.vis_strike_dir = (t.position - e.position).normalized()


## The nearest tower within `reach` px of `pos` not already disabled, or null (shared with the kraken kits).
static func nearest_tower(game: TdGame, pos: Vector2, reach: float) -> Tower:
	var best: Tower = null  # Nearest so far.
	var best_d := reach  # Its distance (px).
	for t: Tower in game.towers:
		var d := pos.distance_to(t.position)  # Distance (px).
		if d <= best_d and game.time >= t.disabled_until:
			best_d = d
			best = t
	return best
