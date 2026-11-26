## The Tide Caller's water line (Necropathy's TideCallerKit: "raises a line of
## water that knocks summons back"): every `every` s (first `first` s after it
## arrives), when a tower that is not stunned stands within `range` px, she
## raises her conch: a telegraphed strike of `radius` px on that tower lands
## `delay` s later through the one shelling path (game.hostile.shell): every
## tower inside is soaked (stunned `disable` s, cause "soaked"), every blocker
## body inside takes `body_damage`. Not while frozen. Args: range, first,
## every, delay (s), radius (px), disable (s), body_damage. vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var t := Kit.nearest_tower(game, e.position, float(a["range"]))  # Her mark.
	if t == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	game.hostile.shell(t.position, float(a["radius"]), float(a["delay"]), float(a["disable"]), "soaked", float(a["body_damage"]))
	Kit.line(game, e.position, t.position, float(a["delay"]), false)
	game.fx.spawn("tide_splash", t.position, float(a["radius"]) * 2.0, float(a["delay"]) + 0.3, Color(0.5, 0.95, 0.9, 0.7))
	e.vis_strike_at = game.time  # Her conch raised (drawn only).
	e.vis_strike_dir = (t.position - e.position).normalized()
	EnemyTrait.note(game, "eye_water_lines")
