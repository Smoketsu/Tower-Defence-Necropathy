## Ground slam (the Sand Colossus; Necropathy's SandColossusKit "a ground slam
## | burst; stay at range"): every `every` s (first after `first`), unless
## frozen, while a post holds it or a tower stands within `radius` px, it
## raises its fists and slams: a telegraphed strike on itself through the one
## shelling path (game.hostile.shell(): the closing circle for `windup` s, then
## every tower inside is stunned `disable` s and every blocker body inside
## takes `body_damage`). A boss / miniboss shows pose 1 meanwhile. Args: first,
## every, radius, windup, disable, body_damage. vars: "next", "pose_until".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	if e.holder == null and not _tower_near(e, game, float(a["radius"])):
		return
	e.vars["next"] = game.time + float(a["every"])
	slam(e, game, e.position, float(a["radius"]), float(a["windup"]), float(a["disable"]), float(a["body_damage"]))


## True when a tower stands within `r` px of `e`.
static func _tower_near(e: TdEnemy, game: TdGame, r: float) -> bool:
	for t: Tower in game.towers:
		if t.position.distance_squared_to(e.position) <= r * r:
			return true
	return false


## A telegraphed slam at `at` (shared with the bosses' leaps): the shell, the windup pose, the note.
static func slam(e: TdEnemy, game: TdGame, at: Vector2, r: float, windup: float, disable: float, body_damage: float) -> void:
	game.hostile.shell(at, r, windup, disable, "stunned", body_damage * e.damage_mult())
	e.pose = 1
	e.vars["pose_until"] = game.time + windup
	e.body.queue_redraw()
	EnemyTrait.note(game, "slams")
