## Gorgon (Act VIII, Mount Olympus; Necropathy's GorgonKit: "a petrifying gaze:
## summons in it turn to stone"): every `gaze_every` s (first after
## `gaze_first`) her gaze flies at the nearest tower within `gaze_range` px
## (not already disabled) through the one hostile-fire path: a straight shot
## (look "gaze") that the first blocker / Bone Wall body on its line stops (the
## body takes `body_damage`); a tower it reaches is PETRIFIED for `petrify` s
## (TdCombat.disable_tower, cause "petrified"). Args: gaze_first, gaze_every
## (s), gaze_range (px), petrify (s), body_damage, speed (px/s). vars:
## "next_gaze" (game s). Counted as event "gorgon_gazes".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_gaze"] = game.time + float(e.row["args"]["gaze_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_gaze"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	var best: Tower = null  # Nearest tower in reach.
	var bd := float(a["gaze_range"])  # Its distance (px).
	for t: Tower in game.towers:
		var d := t.position.distance_to(e.position)  # Distance (px).
		if d <= bd and game.time >= t.disabled_until:
			bd = d
			best = t
	if best == null:
		return
	e.vars["next_gaze"] = game.time + float(a["gaze_every"])
	if game.hostile.fire(e.position + Vector2(0, -16), best, {"speed": float(a["speed"]), "damage": float(a["body_damage"]),
			"disable": float(a["petrify"]), "cause": "petrified", "arc": false, "look": "gaze"}):
		EnemyTrait.note(game, "gorgon_gazes")
		e.vis_strike_at = game.time  # The gaze's lunge (drawn only).
		e.vis_strike_dir = (best.position - e.position).normalized()
