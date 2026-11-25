## Captain Ezekiel Crow, the Gull King, road version (the Smuggler's Cutter's
## boss; Necropathy BossCrow: the Broadside, the Leap, the Fire Ship).
##   BROADSIDE — every `broadside_every` s (the first `broadside_first` s after
##     he arrives) he points his cutlass (windup pose, `telegraph` s) and his
##     sloop's guns shell the `shells` towers nearest him: telegraphed strikes
##     (game.hostile.shell()) of `shell_radius` px landing `shell_delay` s
##     later, disabling them `shell_disable` s.
##   THE LEAP — every `leap_every` s (the first after `leap_first`), when a post
##     with a living body is within `leap_range` px ahead of him or holds him, he
##     crouches `leap_windup` s and leaps: every body of that post takes
##     `leap_damage`, he is let go and lands `leap_dist` px further down the road
##     (never at the gate), unholdable for a moment (strike pose).
##   THE FIRE SHIP — below `fire_hp` of his HP his burning sloop rams the hull:
##     both clocks run x `fire_mult` (once, banner).
## Args in his row. vars: "next_broadside", "next_leap", "phase" ("walk" |
## "point" | "crouch"), "until", "fire" (bool), "pose_until" (game s).
extends EnemyTrait

## The post search shared with Sir Alaric.
const Alaric = preload("res://scripts/bosses/alaric.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_broadside"] = game.time + float(a["broadside_first"])
	e.vars["next_leap"] = game.time + float(a["leap_first"])
	e.vars["phase"] = "walk"
	e.vars["until"] = 0.0
	e.vars["fire"] = false
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var mult := float(a["fire_mult"]) if bool(e.vars["fire"]) else 1.0  # Clock multiplier.
	if not bool(e.vars["fire"]) and e.hp < e.max_hp * float(a["fire_hp"]):
		e.vars["fire"] = true
		game.banner("The Fire Ship rams the hull! Crow fights on in a rage")
		EnemyTrait.note(game, "crow_fire_ship")
		game.fx.spawn("corpse_explosion", e.position, 160.0, 0.6)
	match String(e.vars["phase"]):
		"point":
			if game.time >= float(e.vars["until"]):
				_broadside(e, game, a)
				_walk(e, game, a)
			return
		"crouch":
			if game.time >= float(e.vars["until"]):
				_leap(e, game, a)
			return
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time >= float(e.vars["next_broadside"]):
		e.vars["next_broadside"] = game.time + float(a["broadside_every"]) * mult
		e.vars["phase"] = "point"
		e.vars["until"] = game.time + float(a["telegraph"])
		e.speed = 0.0
		e.pose = 1
		e.body.queue_redraw()
		game.banner("Crow calls a broadside!")
		return
	if game.time >= float(e.vars["next_leap"]):
		var post := e.holder.block if e.holder != null else Alaric._post_ahead(e, game, float(a["leap_range"]))  # The post he leaps.
		if post == null:
			return
		e.vars["next_leap"] = game.time + float(a["leap_every"]) * mult
		e.vars["phase"] = "crouch"
		e.vars["until"] = game.time + float(a["leap_windup"])
		e.vars["post"] = post
		e.speed = 0.0
		e.pose = 1
		e.body.queue_redraw()


## Back to walking (pose 0 after pose_time).
func _walk(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.vars["phase"] = "walk"
	e.speed = float(e.row["speed"])
	e.vars["pose_until"] = game.time + float(a["pose_time"])


## The sloop's guns: shells on the `shells` towers nearest him.
func _broadside(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ts := game.towers.duplicate()  # Towers by distance to him.
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	for i in mini(int(a["shells"]), ts.size()):
		game.hostile.shell((ts[i] as Tower).position, float(a["shell_radius"]), float(a["shell_delay"]), float(a["shell_disable"]), "shelled")
	EnemyTrait.note(game, "crow_broadsides")
	game.sound("boss")


## The leap over the post he crouched at.
func _leap(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var post: RoadBlock = e.vars.get("post", null)  # The post he leaps.
	e.vars.erase("post")
	if post != null:
		for b: BlockBody in post.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["leap_damage"]), e)
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	var from := e.position  # Take-off (drawn only).
	var left := -game.progress(e) - float(e.radius) * 3.0  # Px he may still cover before the gate.
	var d := clampf(float(a["leap_dist"]), 0.0, maxf(left, 0.0))  # Leap length (px).
	if d > 0.0:
		e.follower.advance(d)
		e.position = e.follower.position()
	e.unholdable_until = game.time + 0.5
	EnemyTrait.note(game, "crow_leaps")
	e.pose = 3
	e.body.queue_redraw()
	_walk(e, game, a)
	if game.vfx.on:
		var lk: Dictionary = Acts.data("corsair")["LOOK"]  # Looks.
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["leap_d"]), TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "vael_cleave")
		var st := game.vfx.add(TdVfx.Kind.STREAK, e.position, float(lk["leap_streak_w"]), TdVfxData.TRAIL_LINGER * 2.0, lk["amber"])
		if st != null:
			st.ang = (e.position - from).angle()
			st.size0 = maxf(from.distance_to(e.position), 30.0)
		game.vfx.shake(3.0)
