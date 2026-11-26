## Zeus, King of the Gods (Mount Olympus boss, the end of the Pantheon Trial;
## Necropathy's BossZeus: "lightning storms, the thunderbolt beam, and in phase
## 3 he takes his true colossal form"). Three phases by HP:
##   THE THUNDERER (above `throne_hp`): every `storm_every` s (first after
##     `storm_first`) he raises his bolt (pose 1) and calls a STORM: one bolt on
##     each of the `storm_count` towers nearest him (game.hostile.shell, cause
##     "stunned": `bolt_radius` px, after `bolt_delay` s, disabling
##     `bolt_disable` s, bodies `bolt_damage`); every `beam_every` s the
##     THUNDERBOLT: `beam_count` strikes in a line down the road ahead of him,
##     `beam_gap` px apart (same shell numbers): towers beside the road and
##     the posts on it are hit.
##   THE STORM THRONE (down to `form_hp`): storms bring `storm_extra` more
##     bolts and come x `throne_mult` as often.
##   THE TRUE FORM (below `form_hp`): pose 2 (the colossus still) for the rest
##     of the fight; +`form_armour` flat armour, x `form_speed` speed, and every
##     `stomp_every` s a THUNDER STOMP around himself (`stomp_radius` px,
##     `stomp_delay` s, bodies `stomp_damage`, towers `bolt_disable` s).
## His strikes hit only the necromancer's side (the hostile path). vars:
## "stage" (0..2), "next_storm", "next_beam", "next_stomp", "pose_until".
## Counted: events zeus_storms, zeus_beams, zeus_stomps.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["stage"] = 0
	e.vars["next_storm"] = game.time + float(a["storm_first"])
	e.vars["next_beam"] = game.time + float(a["beam_every"]) * 0.5
	e.vars["next_stomp"] = 0.0
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose == 1 and game.time >= float(e.vars["pose_until"]):
		e.pose = 2 if int(e.vars["stage"]) == 2 else 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP fraction.
	var st := 0 if f > float(a["throne_hp"]) else (1 if f > float(a["form_hp"]) else 2)  # Phase.
	if st != int(e.vars["stage"]):
		e.vars["stage"] = st
		if st == 2:
			e.armour += float(a["form_armour"])
			e.speed *= float(a["form_speed"])
			e.pose = 2
			e.vars["next_stomp"] = game.time + float(a["stomp_every"])
			e.body.queue_redraw()
			game.fx.spawn("evolution", e.position, float(PantheonActRules.look()["form_d"]), 0.8)
		game.banner(["", "The Storm Throne: Zeus calls the sky down harder!", "Zeus takes his true form: the King of the Gods towers over the field!"][st])
		Sfx.play("wrath_thunder")
	if game.time < e.freeze_until or game.time < e.staggered_until:
		return
	if game.time >= float(e.vars["next_storm"]):
		e.vars["next_storm"] = game.time + float(a["storm_every"]) * (float(a["throne_mult"]) if st >= 1 else 1.0)
		var ts := game.towers.duplicate()  # Towers, nearest him first.
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for t: Tower in ts.slice(0, int(a["storm_count"]) + (int(a["storm_extra"]) if st >= 1 else 0)):
			_bolt(game, a, t.position)
		_pose(e, game, a)
		EnemyTrait.note(game, "zeus_storms")
		Sfx.play("wrath_thunder")
	if game.time >= float(e.vars["next_beam"]):
		e.vars["next_beam"] = game.time + float(a["beam_every"])
		var r := e.follower.road  # His road.
		for i in int(a["beam_count"]):
			_bolt(game, a, r.point_at(minf(e.follower.dist + float(a["beam_gap"]) * float(i + 1), r.length)))
		_pose(e, game, a)
		EnemyTrait.note(game, "zeus_beams")
	if st == 2 and game.time >= float(e.vars["next_stomp"]):
		e.vars["next_stomp"] = game.time + float(a["stomp_every"])
		game.hostile.shell(e.position, float(a["stomp_radius"]), float(a["stomp_delay"]), float(a["bolt_disable"]), "stunned", float(a["stomp_damage"]))
		EnemyTrait.note(game, "zeus_stomps")


## One telegraphed bolt at `p` (the hostile shell path) with its lightning look.
func _bolt(game: TdGame, a: Dictionary, p: Vector2) -> void:
	game.hostile.shell(p, float(a["bolt_radius"]), float(a["bolt_delay"]), float(a["bolt_disable"]), "stunned", float(a["bolt_damage"]))
	if game.vfx.on:
		var lk: Dictionary = PantheonActRules.look()
		game.vfx.add(TdVfx.Kind.ANIM, p + Vector2(0, -float(lk["bolt_lift"])), float(lk["bolt_d"]), 0.4, lk["bolt_tint"], "soul_lightning", float(a["bolt_delay"]))


## The raised bolt (pose 1) for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Zeus falls: the thunder is yours to steal")
