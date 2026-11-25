## Cathedral Guardian (GDD §6.3, the Sanctum's miniboss): a stone construct.
## While a post holds it, every `slam_every` s it slams: every living body
## of that post takes `slam_damage`. Every `beam_every` s (first after
## `beam_first`) it sweeps a radiant beam: towers within `beam_radius` px are
## suppressed (damage x `beam_mult`) for `beam_time` s.
## Args: slam_every, slam_damage, beam_first, beam_every, beam_radius, beam_time, beam_mult.
## vars: "next_slam", "next_beam" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_slam"] = 0.0
	e.vars["next_beam"] = game.time + float(a["beam_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	if e.holder == null:
		e.vars["next_slam"] = game.time + float(a["slam_every"])
	elif game.time >= float(e.vars["next_slam"]):
		e.vars["next_slam"] = game.time + float(a["slam_every"])
		for b: BlockBody in e.holder.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["slam_damage"]))
		game.fx.spawn("sentinel_sweep", e.position, 120.0, 0.4)
		EnemyTrait.note(game, "guardian_slams")
	if game.time >= float(e.vars["next_beam"]):
		e.vars["next_beam"] = game.time + float(a["beam_every"])
		var field := CovenantField.of(game)  # Draws the beam's mark.
		for t: Tower in field.towers_near(e.position, float(a["beam_radius"])):
			TdCombat.suppress_tower(game, t, float(a["beam_mult"]), float(a["beam_time"]))
		field.add_zone(e.position, float(a["beam_radius"]), game.time + float(a["beam_time"]), Color(1.0, 0.9, 0.5, 0.5))
		EnemyTrait.note(game, "guardian_beams")
