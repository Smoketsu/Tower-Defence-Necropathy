## Sir Alaric, the Gravebreaker, road version (GDD §6.3 "walks the road,
## charges through one blocker post at intervals"). Every `charge_every` s
## (the first after `charge_first`), when a road post with a living body is
## within `charge_range` px ahead of him on his road, or a post holds him, he
## stops and winds up for `telegraph` s (windup pose, banner), then charges:
## every living body of that post takes `charge_damage`, he is let go and
## runs at `charge_speed_mult` for `charge_time` s, unholdable (charge pose).
## Args in TdEnemyData "alaric". vars: "phase" ("walk" | "windup" | "charge"),
## "until" (game s the phase ends), "ready" (game s the next charge may start),
## "block" (RoadBlock wound up on).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["phase"] = "walk"
	e.vars["until"] = 0.0
	e.vars["ready"] = game.time + float(e.row["args"]["charge_first"])
	e.vars["block"] = null


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	match String(e.vars["phase"]):
		"walk":
			if game.time < float(e.vars["ready"]):
				return
			var target := e.holder.block if e.holder != null else _post_ahead(e, game, float(a["charge_range"]))  # The post he breaks.
			if target == null:
				return
			e.vars["phase"] = "windup"
			e.vars["until"] = game.time + float(a["telegraph"])
			e.vars["block"] = target
			e.speed = 0.0  # Plants his feet for the wind-up.
			e.pose = 1
			e.body.queue_redraw()
			game.banner("Sir Alaric winds up a charge!")
		"windup":
			if game.time >= float(e.vars["until"]):
				var block: RoadBlock = e.vars["block"]  # The post he breaks through.
				for b: BlockBody in block.bodies:
					if b.alive:
						TdCombat.damage_body(game, b, float(a["charge_damage"]))
				if e.holder != null:
					e.holder.held.erase(e)
					e.holder = null
				e.speed = float(e.row["speed"])
				e.unholdable_until = game.time + float(a["charge_time"])
				TdCombat.haste_enemy(game, e, float(a["charge_speed_mult"]), float(a["charge_time"]))
				game.fx.spawn("vael_cleave", e.position, 120.0, 0.4)
				EnemyTrait.note(game, "alaric_charges")
				e.vars["phase"] = "charge"
				e.vars["until"] = e.unholdable_until
				e.vars["block"] = null
				e.pose = 2
				e.body.queue_redraw()
		"charge":
			if game.time >= float(e.vars["until"]):
				e.vars["phase"] = "walk"
				e.vars["ready"] = game.time + float(a["charge_every"])
				e.pose = 0
				e.body.queue_redraw()


## The nearest road post ahead of `e` on its road within `reach` px that has a living body, or null.
static func _post_ahead(e: TdEnemy, game: TdGame, reach: float) -> RoadBlock:
	var best: RoadBlock = null  # Nearest matching post.
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id or blk.dist < e.follower.dist or blk.dist - e.follower.dist > reach or not blk.holds_bosses:
			continue
		var alive := false  # Some body stands.
		for b: BlockBody in blk.bodies:
			alive = alive or b.alive
		if alive and (best == null or blk.dist < best.dist):
			best = blk
	return best
