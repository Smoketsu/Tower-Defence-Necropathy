## Fire Giant (Act VI; Necropathy's FireGiantKit and MuspelGiantKit): every
## `stomp_every` s (first after `stomp_first`) it stamps: a telegraphed circle
## of `radius` px round where it stands lands after `delay` s, stunning every
## tower inside `disable` s (cause "shelled") and burning every body inside for
## `body_damage` (game.hostile.shell()). With `track_every` > 0 (the Fire-Giant
## of the South) it also leaves BURNING TRACKS: every `track_every` s a burning
## footprint of `track_radius` px where it walked (a shell with no delay
## worth dodging: disable `track_disable` s, the same path).
## Args: stomp_first, stomp_every, radius, delay, disable, body_damage,
## track_every, track_radius, track_disable. vars: "next_stomp", "next_track".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_stomp"] = game.time + float(a["stomp_first"])
	e.vars["next_track"] = game.time + float(a["track_every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_stomp"]):
		e.vars["next_stomp"] = game.time + float(a["stomp_every"])
		game.hostile.shell(e.position, float(a["radius"]), float(a["delay"]), float(a["disable"]), "shelled", float(a["body_damage"]))
		EnemyTrait.note(game, "giant_stomps")
		Sfx.play("frost_giant_stomp")
		e.vis_strike_at = game.time  # The stamp (drawn only).
		e.vis_strike_dir = Vector2.DOWN
	if float(a["track_every"]) > 0.0 and game.time >= float(e.vars["next_track"]) and e.holder == null:
		e.vars["next_track"] = game.time + float(a["track_every"])
		game.hostile.shell(e.position, float(a["track_radius"]), 0.4, float(a["track_disable"]), "shelled", 0.0)
		EnemyTrait.note(game, "burning_tracks")
		if game.vfx.on:
			game.fx.spawn("corpse_explosion", e.position, float(a["track_radius"]) * 1.4, 0.8, Acts.data("norse")["LOOK"]["fire_tint"])
