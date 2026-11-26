## Scarmaw, the Great Raptor (Fern Basin boss; Necropathy's BossScarmaw):
##   the Hunt   — every `hunt_every` s (first after `hunt_first`) a pack (`hunt`:
##                [[kind, count], ...]) comes in from the map's entrances in turn,
##                `hunt_gap` s apart (extras of the latest wave).
##   the Leap   — held, every `leap_every` s (first after `leap_first`) she
##                crouches for `windup` s (pose 1, a line), then rakes the body
##                holding her and LEAPS `leap` px past the post (the Razorclaw's
##                leap); every body within `leap_radius` px of her landing takes
##                `leap_damage`.
##   the Ambush — below `ambush_hp` of her HP, every `ambush_every` s she sinks
##                into the ferns for `ambush_time` s (vars "hidden_until": no tower
##                sees her; drawn faded) and comes out with a lunge (a leap,
##                `ambush_lunge` damage to the body holding her).
##   Blood Up   — below `blood_hp`, once: her alpha-guard (`guard_kind`) comes at
##                her side; while it lives she runs `blood_haste` x faster.
## Args in her row. vars: "next_hunt", "hunts", "queue" ([game s, kind, road]),
## "next_leap", "leap_at", "next_ambush", "guard", "guard_gen", "blood", "pose_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")
const Pack := preload("res://scripts/enemies/traits/primeval/pack_leap.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	e.vars["next_hunt"] = game.time + float(a["hunt_first"])
	e.vars["hunts"] = 0
	e.vars["queue"] = []
	e.vars["next_leap"] = game.time + float(a["leap_first"])
	e.vars["leap_at"] = 0.0
	e.vars["next_ambush"] = 0.0
	e.vars["blood"] = false
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	_queue(e, game)
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["leap_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	var hidden := game.time < float(e.vars.get("hidden_until", 0.0))
	if e.vars.has("vis_alpha") and not hidden:
		e.vars.erase("vis_alpha")
		e.body.queue_redraw()
		if e.holder != null:
			Pack.leap(e, game, float(a["leap"]) * 0.5, float(a["ambush_lunge"]), 0.6)
		_pose(e, game, a)
		EnemyTrait.note(game, "scarmaw_ambush_lunges")
	var f := e.hp / e.max_hp
	if f <= float(a["blood_hp"]) and not bool(e.vars["blood"]):
		e.vars["blood"] = true
		var g := game.waves.spawn_extra(String(a["guard_kind"]), e.follower.road.id, maxf(e.follower.dist - 40.0, 0.0), 12.0)
		e.vars["guard"] = g
		e.vars["guard_gen"] = g.generation
		game.banner("Blood Up! Scarmaw's alpha-guard joins the hunt: kill the guard!")
		EnemyTrait.note(game, "scarmaw_blood_up")
	var guard: TdEnemy = e.vars.get("guard", null)
	if TdEnemy.valid(guard, int(e.vars.get("guard_gen", -1))):
		TdCombat.haste_enemy(game, e, float(a["blood_haste"]), 0.3)
	if game.time >= float(e.vars["next_hunt"]):
		e.vars["next_hunt"] = game.time + float(a["hunt_every"])
		_hunt(e, game, a)
	if f <= float(a["ambush_hp"]) and not hidden and game.time >= float(e.vars["next_ambush"]):
		if float(e.vars["next_ambush"]) <= 0.0:
			game.banner("The Ambush: Scarmaw melts into the ferns!")
		e.vars["next_ambush"] = game.time + float(a["ambush_every"])
		e.vars["hidden_until"] = game.time + float(a["ambush_time"])
		e.vars["vis_alpha"] = 0.25
		e.body.queue_redraw()
		Sfx.play("pack_rustle")
		EnemyTrait.note(game, "scarmaw_ambushes")
		return
	var at := float(e.vars["leap_at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["leap_at"] = 0.0
		if e.holder != null and game.time >= e.freeze_until:
			Pack.leap(e, game, float(a["leap"]), float(a["leap_damage"]), 0.8)
			for b: BlockBody in game.bodies_near(e.position, float(a["leap_radius"])):
				TdCombat.damage_body(game, b, float(a["leap_damage"]) * e.damage_mult(), e)
			Kit.ring(game, e.position, float(a["leap_radius"]), 0.4, Kit.lk()["gore_tint"], true)
			EnemyTrait.note(game, "scarmaw_leaps")
		return
	if e.holder != null and game.time >= float(e.vars["next_leap"]) and game.time >= e.freeze_until:
		e.vars["next_leap"] = game.time + float(a["leap_every"])
		e.vars["leap_at"] = game.time + float(a["windup"])
		e.pose = 1
		e.body.queue_redraw()
		Kit.line(game, e.position, e.follower.road.point_at(minf(e.follower.dist + float(a["leap"]), e.follower.road.length)), float(a["windup"]), false)


## Queues one hunting pack from the next entrance (see the header).
func _hunt(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ents: Array[String] = []
	for id: String in game.roads:
		var rd: Road = game.roads[id]
		if rd.entrance and not rd.off_road:
			ents.append(id)
	ents.sort()
	var road := ents[int(e.vars["hunts"]) % ents.size()]
	e.vars["hunts"] = int(e.vars["hunts"]) + 1
	var q: Array = e.vars["queue"]
	var k := 0
	for g: Array in a["hunt"]:
		for i in int(g[1]):
			q.append([game.time + float(a["hunt_gap"]) * float(k), String(g[0]), road])
			k += 1
	game.banner("The Hunt: a pack comes in for Scarmaw!")
	Sfx.play("pack_hiss")
	EnemyTrait.note(game, "scarmaw_hunts")


## Spawns the queued pack members whose time has come.
func _queue(e: TdEnemy, game: TdGame) -> void:
	var q: Array = e.vars["queue"]
	while not q.is_empty() and game.time >= float(q[0][0]):
		var s: Array = q.pop_front()
		game.waves.spawn_extra(String(s[1]), String(s[2]), 0.0, game.rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD))


## Shows the leap pose for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Scarmaw falls: the Fern Basin's hunt is over")
