## Marshal Vael, road version (GDD §6.3 "calls reinforcement squads from side
## lanes while advancing"). Every `call_every` s (first after `call_first`;
## x `enrage_call_mult` below `enrage_hp` of his HP) he raises his sword
## (windup pose) and a squad (`squad`: [{kind, count}]) marches in at the
## start of each road in `lanes` (missing roads: the first entrance). Every
## `wall_every` s he raises his Shieldwall for `wall_time` s (guard pose):
## hits from the front (ShieldFront rule) deal `wall_mult` of their damage.
## Args in TdEnemyData "vael". vars: "next_call", "next_wall", "wall_until", "pose_until" (game s).
extends EnemyTrait

## The front test shared with the Shieldbearer.
const ShieldFront = preload("res://scripts/enemies/traits/shield_front.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_call"] = game.time + float(a["call_first"])
	e.vars["next_wall"] = game.time + float(a["wall_every"])
	e.vars["wall_until"] = 0.0
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and game.time >= float(e.vars["wall_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time >= float(e.vars["next_call"]):
		var enraged := e.hp < e.max_hp * float(a["enrage_hp"])  # Second phase.
		e.vars["next_call"] = game.time + float(a["call_every"]) * (float(a["enrage_call_mult"]) if enraged else 1.0)
		for lane: String in a["lanes"]:
			var road := lane if game.roads.has(lane) else game.first_entrance()  # Where the squad enters.
			for g: Dictionary in a["squad"]:
				for k in int(g["count"]):
					game.waves.spawn_extra(String(g["kind"]), road, -float(k) * float(a["squad_gap"]), game.rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD))
		e.pose = 1
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		e.body.queue_redraw()
		game.banner("Marshal Vael calls his reinforcements!")
		EnemyTrait.note(game, "vael_calls")
	if game.time >= float(e.vars["next_wall"]):
		e.vars["next_wall"] = game.time + float(a["wall_every"])
		e.vars["wall_until"] = game.time + float(a["wall_time"])
		e.pose = 2
		e.body.queue_redraw()
		EnemyTrait.note(game, "vael_shieldwalls")


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	if game.time < float(e.vars["wall_until"]) and not bool(hit.get("dot", false)) and ShieldFront.from_front(e, hit):
		return amount * float(e.row["args"]["wall_mult"])
	return amount
