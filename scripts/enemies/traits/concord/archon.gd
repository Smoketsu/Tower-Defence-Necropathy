## The Luminous Archon (Necropathy's LuminousArchonKit): a shield of light
## worth `shield` x his max HP soaks his first hits (lumen.gd soak()), and every
## `every` s (first `first` s after he arrives), unless frozen or staggered, he
## aims his SWEEPING BEAM at the farthest tower within `range` px: a faint line
## for `windup` s, then every tower within `width` px of that line (out to
## `range` px) is blinded for `disable` s (TdCombat.disable_tower, cause
## "blinded"). Args: shield, first, every, windup (s), range, width (px), disable (s).
## vars: lumen.gd's "shield", "next", "beam_at" (game s), "aim" (map px).
extends EnemyTrait

const Lumen := preload("res://scripts/enemies/traits/concord/lumen.gd")
const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["shield"] = -1.0
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["beam_at"] = 0.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	return Lumen.soak(e, game, amount, hit)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var at := float(e.vars["beam_at"])  # When the beam fires (0 = none).
	if at > 0.0:
		if game.time >= at:
			e.vars["beam_at"] = 0.0
			sweep(e, game, Vector2(e.vars["aim"]), float(a["range"]), float(a["width"]), float(a["disable"]))
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var far: Tower = null  # The farthest tower in range.
	for t: Tower in game.towers:
		var d := e.position.distance_to(t.position)
		if d <= float(a["range"]) and (far == null or d > e.position.distance_to(far.position)):
			far = t
	if far == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["beam_at"] = game.time + float(a["windup"])
	e.vars["aim"] = far.position
	Kit.line(game, e.position, e.position + (far.position - e.position).normalized() * float(a["range"]), float(a["windup"]), false)
	Sfx.play("beam_charge")


## Fires a beam from `e` toward `aim`, `reach` px long: towers within `width` px
## of it are blinded `disable` s; returns how many (the Harvester reuses it).
static func sweep(e: TdEnemy, game: TdGame, aim: Vector2, reach: float, width: float, disable: float) -> int:
	var dir := (aim - e.position).normalized() if aim != e.position else Vector2.RIGHT  # Beam direction.
	var end := e.position + dir * reach  # Beam end.
	var n := 0  # Towers blinded.
	for t: Tower in game.towers:
		var rel := t.position - e.position
		var along := rel.dot(dir)  # Px along the beam.
		if along >= 0.0 and along <= reach and absf(rel.dot(Vector2(-dir.y, dir.x))) <= width:
			TdCombat.disable_tower(game, t, disable, "blinded")
			n += 1
	Kit.line(game, e.position, end, 0.0, true)
	game.fx.spawn("beam_hit", end, 70.0, 0.4, Acts.data("concord")["LOOK"]["light"])
	EnemyTrait.note(game, "archon_beams")
	Sfx.play("beam_fire")
	return n
