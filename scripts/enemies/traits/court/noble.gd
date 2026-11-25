## Vampire Noble (the Countess; Necropathy NOBLE): every `drain_every` s, when a
## blocker body stands within `drain_range` px, she locks a blood-drain beam on
## the weakest one for `drain_time` s: every `drain_tick` s it takes
## `drain_damage` and she heals what it lost (CourtKit.bite, a red thread).
## Once per life below `mist_at` of her HP she turns to mist for `mist_time` s
## (vars "mist_until": the act rule hides her from every tower, she takes no
## damage) and reforms `mist_jump` px down the road (CourtKit.lunge).
## Args: drain_range, drain_every, drain_time, drain_tick, drain_damage,
## mist_at, mist_time, mist_jump.
## vars: "next_drain", "drain_until", "next_tick" (game s), "drain" ([BlockBody]),
## "misted" (bool), "mist_until" (game s).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_drain"] = game.time + float(e.row["args"]["drain_every"]) * 0.5
	e.vars["drain_until"] = 0.0
	e.vars["next_tick"] = 0.0
	e.vars["drain"] = []
	e.vars["misted"] = false
	e.vars["mist_until"] = 0.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	return 0.0 if game.time < float(e.vars["mist_until"]) else amount


func on_hit(e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if bool(e.vars["misted"]) or e.hp >= e.max_hp * float(a["mist_at"]):
		return
	e.vars["misted"] = true
	e.vars["mist_until"] = game.time + float(a["mist_time"])
	e.unholdable_until = e.vars["mist_until"]
	CourtKit.lunge(e, game, float(a["mist_jump"]))
	CourtKit.mark(game, e.position, 40.0, float(a["mist_time"]), CourtKit.tint("mark_tint"))
	EnemyTrait.note(game, "noble_mists")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until or game.time < e.staggered_until or game.time < float(e.vars["mist_until"]):
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["drain_until"]):
		if game.time >= float(e.vars["next_tick"]):
			e.vars["next_tick"] = float(e.vars["next_tick"]) + float(a["drain_tick"])
			for b: BlockBody in e.vars["drain"]:
				if b.alive and b.pos.distance_to(e.position) <= float(a["drain_range"]) * 1.2:
					CourtKit.bite(game, e, b, float(a["drain_damage"]), 1.0)
		return
	if game.time < float(e.vars["next_drain"]):
		return
	var b := CourtKit.weakest_body(game, e.position, float(a["drain_range"]))  # Her prey.
	if b == null:
		return
	e.vars["next_drain"] = game.time + float(a["drain_every"])
	e.vars["drain_until"] = game.time + float(a["drain_time"])
	e.vars["next_tick"] = game.time
	e.vars["drain"] = [b]
	EnemyTrait.note(game, "noble_drains")
