## Sir Alaric, the Gravebreaker, road version (GDD §6.3): he walks the road
## and blockers can hold him, but `charge_every` s after he is first held he
## winds up for `telegraph` s (windup pose), then charges through the post:
## every body of that block takes `charge_damage`, he is let go and runs on at
## `charge_speed_mult` for `charge_time` s, during which nothing can hold him.
## Args in TdEnemyData "alaric". vars: "phase" ("walk" | "windup" | "charge"),
## "until" (game s the current phase ends), "block" (RoadBlock wound up on).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["phase"] = "walk"
	e.vars["until"] = 0.0
	e.vars["block"] = null


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	match String(e.vars["phase"]):
		"walk":
			if e.holder != null:
				if float(e.vars["until"]) <= 0.0:
					e.vars["until"] = game.time + float(a["charge_every"])  # Starts counting when first held.
				elif game.time >= float(e.vars["until"]):
					e.vars["phase"] = "windup"
					e.vars["until"] = game.time + float(a["telegraph"])
					e.vars["block"] = e.holder.block
					e.pose = 1
					e.body.queue_redraw()
					game.banner("Sir Alaric winds up a charge!")
		"windup":
			if game.time >= float(e.vars["until"]):
				var block: RoadBlock = e.vars["block"]  # The post he breaks through.
				if block != null:
					for b: BlockBody in block.bodies:
						if b.alive:
							TdCombat.damage_body(game, b, float(a["charge_damage"]))
				if e.holder != null:
					e.holder.held.erase(e)
					e.holder = null
				e.unholdable_until = game.time + float(a["charge_time"])
				TdCombat.haste_enemy(game, e, float(a["charge_speed_mult"]), float(a["charge_time"]))
				game.fx.spawn("vael_cleave", e.position, 120.0, 0.4)
				e.vars["phase"] = "charge"
				e.vars["until"] = e.unholdable_until
				e.pose = 3
				e.body.queue_redraw()
		"charge":
			if game.time >= float(e.vars["until"]):
				e.vars["phase"] = "walk"
				e.vars["until"] = 0.0
				e.pose = 0
				e.body.queue_redraw()
