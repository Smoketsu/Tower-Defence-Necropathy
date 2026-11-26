## The Einherjar Champion (Valgard miniboss; Necropathy's
## EinherjarChampionKit: "the HERO'S SWEEP: a telegraphed circle round himself,
## then every summon in it is struck and thrown out; the CHAMPION'S HORN wakes
## the feast: Einherjar rise beside him"). Every `sweep_every` s (first after
## `sweep_first`) while a post holds him he winds up for `sweep_windup` s (a
## gold circle of `sweep_radius` px, his cast pose) and sweeps: every blocker
## body inside takes `sweep_damage` (x his weaken). Every `horn_every` s (first
## after `horn_first`) he blows his horn: `horn_count` Einherjar of `horn_kind`
## rise on his road behind him, `horn_gap` px apart. Args in his row.
## vars: "next_sweep", "sweep_at", "next_horn", "pose_until".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_sweep"] = game.time + float(a["sweep_first"])
	e.vars["next_horn"] = game.time + float(a["horn_first"])
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var lk: Dictionary = Acts.data("norse")["LOOK"]
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if e.vars.has("sweep_at"):
		if game.time < float(e.vars["sweep_at"]):
			return
		e.vars.erase("sweep_at")
		for b: BlockBody in game.bodies_near(e.position, float(a["sweep_radius"])):
			TdCombat.damage_body(game, b, float(a["sweep_damage"]) * e.damage_mult(), e)
		EnemyTrait.note(game, "champion_sweeps")
		Sfx.play("boss_impact")
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, e.position, float(a["sweep_radius"]) * 2.0, 0.4, lk["sweep_tint"], "sentinel_sweep")
		return
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_horn"]):
		e.vars["next_horn"] = game.time + float(a["horn_every"])
		for i in int(a["horn_count"]):
			var d := maxf(e.follower.dist - float(a["horn_gap"]) * float(i + 1), 0.0)  # Px along his road.
			var c := game.waves.spawn_extra(String(a["horn_kind"]), e.follower.road.id, d, e.follower.lane + float(i % 2 * 2 - 1) * 8.0)
			game.fx.spawn("level_up", c.position, 50.0, 0.5, lk["rise_tint"])
		EnemyTrait.note(game, "champion_horns")
		Sfx.play("horn_call")
		_pose(e, game, a)
	if e.holder != null and game.time >= float(e.vars["next_sweep"]):
		e.vars["next_sweep"] = game.time + float(a["sweep_every"])
		e.vars["sweep_at"] = game.time + float(a["sweep_windup"])
		_pose(e, game, a)
		if game.vfx.on:
			var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["sweep_radius"]), float(a["sweep_windup"]), lk["sweep_tint"])
			if ring != null:
				ring.size0 = float(a["sweep_radius"]) * 0.3
		Sfx.play("boss_telegraph")


## Shows his cast pose for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()
