## Amaterasu, the Sun Goddess (Road to the Sun boss; Necropathy's
## BossAmaterasu: "her place in the sky is the phase"). She forces the sky
## through the Sun's Course's one override (set_override()):
##   DAWN (HP above `noon_hp`): day; every `beam_every` s (first after
##     `beam_first`) her mirror throws a beam on the road `beam_ahead` px ahead
##     of her: every tower within `beam_radius` px is suppressed (damage x
##     `beam_mult` for `beam_time` s, TdCombat.suppress_tower; a sun zone drawn).
##   NOON (down to `sunset_hp`): still day; every `shell_every` s sun circles
##     fall on the `shell_count` towers nearest her (game.hostile.shell, cause
##     "blinded": `shell_radius` px, `shell_delay` s, `shell_disable` s).
##   SUNSET (below): the eclipse: she forces NIGHT (towers see only in lantern
##     light) and both attacks come, the beam twice as wide.
## When she falls the sky goes back to the clock. Pose 1 (the mirror raised)
## for `pose_time` s on each cast. Args in her row. vars: "stage" (0..2),
## "next_beam", "next_shell", "pose_until" (game s).
extends EnemyTrait

const Ninja := preload("res://scripts/enemies/traits/shogunate/ninja.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["stage"] = -1
	e.vars["next_beam"] = game.time + float(a["beam_first"])
	e.vars["next_shell"] = game.time + float(a["shell_every"])
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP fraction.
	var st := 0 if f > float(a["noon_hp"]) else (1 if f > float(a["sunset_hp"]) else 2)  # Her place in the sky.
	if st != int(e.vars["stage"]):
		e.vars["stage"] = st
		var s := Ninja.sun(game)  # The act rule.
		if s != null:
			s.call("set_override", 2 if st == 2 else 0)
		game.banner(["Amaterasu rises in the east: the sun breaks the night!", "Noon: the sun stands over the road, circles of fire fall!",
			"Sunset: the eclipse! Night falls again: fight in the lanterns' light"][st])
		EnemyTrait.note(game, "amaterasu_phases")
	if game.time < e.freeze_until:
		return
	if (st == 0 or st == 2) and game.time >= float(e.vars["next_beam"]):
		e.vars["next_beam"] = game.time + float(a["beam_every"])
		var r := e.follower.road  # Her road.
		var p := r.point_at(minf(e.follower.dist + float(a["beam_ahead"]), r.length))  # Where the beam falls.
		var rad := float(a["beam_radius"]) * (2.0 if st == 2 else 1.0)  # Beam radius (px).
		var field := CovenantField.of(game)  # Draws the sun zone.
		for t: Tower in field.towers_near(p, rad):
			TdCombat.suppress_tower(game, t, float(a["beam_mult"]), float(a["beam_time"]))
		field.add_zone(p, rad, game.time + float(a["beam_time"]), Acts.data("shogunate")["LOOK"]["sun_zone"])
		game.fx.spawn("holy_impact", p, rad * 2.0, 0.6)
		_pose(e, game, a)
		EnemyTrait.note(game, "amaterasu_beams")
	if st >= 1 and game.time >= float(e.vars["next_shell"]):
		e.vars["next_shell"] = game.time + float(a["shell_every"])
		var ts := game.towers.duplicate()  # Towers, nearest her first.
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for t: Tower in ts.slice(0, int(a["shell_count"])):
			game.hostile.shell(t.position, float(a["shell_radius"]), float(a["shell_delay"]), float(a["shell_disable"]), "blinded")
		_pose(e, game, a)
		EnemyTrait.note(game, "amaterasu_suns")


## Shows the raised mirror for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	var s := Ninja.sun(game)  # The act rule.
	if s != null:
		s.call("set_override", -1)
	game.banner("Amaterasu falls: the sun goes out")
