## The Bog Mother (the Witchwood's miniboss; Necropathy BogMotherKit), a vast
## drowned witch. THE DRAG: every `drag_every` s weed-ropes seize up to
## `drag_count` living blocker bodies within `drag_reach` px (the weakest first)
## and drown them for `drown_damage` each (a feeding bite: she heals what they
## lose x 0.5). THE MIRE SLAM: every `slam_every` s a telegraphed circle of
## `slam_radius` px closes on the nearest tower within `slam_reach` px for
## `slam_delay` s; towers in it are disabled `slam_disable` s and bodies in it
## take `slam_damage` (game.hostile.shell). Args: drag_every, drag_reach,
## drag_count, drown_damage, slam_every, slam_reach, slam_radius, slam_delay,
## slam_disable, slam_damage. vars: "next_drag", "next_slam" (game s).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_drag"] = game.time + float(a["drag_every"]) * 0.5
	e.vars["next_slam"] = game.time + float(a["slam_every"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time >= float(e.vars["next_drag"]):
		var bodies := game.bodies_near(e.position, float(a["drag_reach"]))  # In reach.
		if not bodies.is_empty():
			e.vars["next_drag"] = game.time + float(a["drag_every"])
			bodies.sort_custom(func(x: BlockBody, y: BlockBody) -> bool: return x.hp < y.hp)
			for i in mini(int(a["drag_count"]), bodies.size()):
				CourtKit.bite(game, e, bodies[i], float(a["drown_damage"]), 0.5)
				CourtKit.mark(game, bodies[i].pos, 30.0, 0.8, CourtKit.tint("pool_tint"))
			EnemyTrait.note(game, "bog_drags")
	if game.time >= float(e.vars["next_slam"]):
		var t := CourtKit.nearest_tower(game, e.position, float(a["slam_reach"]))  # Her slam's mark.
		if t != null:
			e.vars["next_slam"] = game.time + float(a["slam_every"])
			game.hostile.shell(t.position, float(a["slam_radius"]), float(a["slam_delay"]), float(a["slam_disable"]), "shelled", float(a["slam_damage"]))
			e.vis_strike_at = game.time
			e.vis_strike_dir = (t.position - e.position).normalized()
			EnemyTrait.note(game, "bog_slams")
