## The Spawn of the Deep's grab (Necropathy's SpawnKit: "grabs and holds the
## nearest summon"): every `every` s (first `first` s after it arrives), when a
## living blocker body stands within `range` px, a tentacle reaches for the
## nearest one (a teal line, `windup` s); then it squeezes that body for `hold`
## s: `damage` (x its weaken) every `tick` s (TdCombat.damage_body). It walks
## and fights on while it holds; killing it frees the body. Args: first, every,
## range (px), windup, hold, tick (s), damage. vars: "next", "at" (game s the
## tentacle closes), "body" (the BlockBody reached for / held), "until" (game s
## the hold ends), "tick" (game s of the next squeeze).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var b: BlockBody = e.vars.get("body", null)  # The body reached for / held.
	if float(e.vars["at"]) > 0.0 and game.time >= float(e.vars["at"]):
		e.vars["at"] = 0.0
		if b != null and b.alive:
			e.vars["until"] = game.time + float(a["hold"])
			e.vars["tick"] = game.time
			EnemyTrait.note(game, "eye_grabs")
			Sfx.play("deep_freeze")
	if game.time < float(e.vars["until"]):
		if b == null or not b.alive:
			e.vars["until"] = 0.0
		elif game.time >= float(e.vars["tick"]):
			e.vars["tick"] = float(e.vars["tick"]) + float(a["tick"])
			TdCombat.damage_body(game, b, float(a["damage"]) * e.damage_mult(), e)
			Kit.line(game, e.position, b.pos, 0.0, true, Acts.data("eye")["LOOK"]["tentacle_tint"])
		return
	if float(e.vars["at"]) > 0.0 or game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var best: BlockBody = null  # Nearest body in reach.
	var bd := INF
	for o: BlockBody in game.bodies_near(e.position, float(a["range"])):
		var d := o.pos.distance_squared_to(e.position)
		if d < bd:
			bd = d
			best = o
	if best == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["at"] = game.time + float(a["windup"])
	e.vars["body"] = best
	Kit.line(game, e.position, best.pos, float(a["windup"]), false, Acts.data("eye")["LOOK"]["tentacle_tint"])
