## Fallen Angel (Necropathy FallenAngelKit: "dives from above with a burning
## spear"): she flies; every `every` s (first after `first`) she marks the
## tower or blocker body nearest her within `range` px and dives on it: a
## telegraphed strike of `radius` px landing `delay` s later
## (game.hostile.shell: every tower in it disabled `disable` s, every body in
## it takes `body_damage`), with the seraph-dive streak on landing.
## Args: first, every, range, radius, delay, disable, body_damage. vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var rng := float(a["range"])  # Px.
	var at := Vector2.INF  # Where she dives.
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= rng and (at == Vector2.INF or t.position.distance_squared_to(e.position) < at.distance_squared_to(e.position)):
			at = t.position
	var b := Kit.nearest_body(game, e.position, rng)  # Or a body nearer still.
	if b != null and (at == Vector2.INF or b.pos.distance_squared_to(e.position) < at.distance_squared_to(e.position)):
		at = b.pos
	if at == Vector2.INF:
		return
	e.vars["next"] = game.time + float(a["every"])
	game.hostile.shell(at, float(a["radius"]), float(a["delay"]), float(a["disable"]), "shelled", float(a["body_damage"]))
	game.vfx.add(TdVfx.Kind.ANIM, at, float(a["radius"]) * 2.2, 0.4, Acts.data("inferno")["LOOK"]["fire_tint"], "seraph_dive", float(a["delay"]) - 0.2)
	EnemyTrait.note(game, "angel_dives")
