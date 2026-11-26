## The Motherboard (Assembly Halls boss; Necropathy's BossMotherboard: "the
## factory's construction titan with two crane arms: it grabs your summons and
## hurls them, drops press-stamps on telegraphed squares, and builds turrets
## mid-fight"). Three parts by HP:
##   Online     — Crane Grab: every `grab_every` s (first after `grab_first`) an arm
##                seizes the first living body of the nearest post within
##                `grab_range` px (`grab_damage` to it) and hurls it at the nearest
##                tower: a telegraphed landing there (game.hostile.shell, `hurl_*`).
##                Press-Stamp: every `stamp_every` s (first `stamp_first`) the
##                presses come down on the `stamps` nearest towers within
##                `stamp_range` px (shells `stamp_*`, a body under one takes
##                `stamp_body`).
##   Full Load  — below `load_hp`: Build Turrets: every `turret_every` s it builds a
##                `turret_kind` beside itself (at most `turret_cap` alive).
##   Overclock  — below `overclock_hp`: every special `overclock_mult` x as often,
##                one more stamp.
## Poses: 1 (arms raised) while a special winds up, 3 (claws down) as it lands.
## Args in its row. vars: "part", "next_grab", "next_stamp", "next_turret", "pose_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["part"] = 1
	e.vars["next_grab"] = game.time + float(a["grab_first"])
	e.vars["next_stamp"] = game.time + float(a["stamp_first"])
	e.vars["next_turret"] = 0.0
	e.vars["pose_until"] = 0.0


func _pose(e: TdEnemy, game: TdGame, p: int, t: float) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + t
	e.body.queue_redraw()


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var part := int(e.vars["part"])  # Part now.
	if part == 1 and e.hp <= e.max_hp * float(a["load_hp"]):
		part = 2
		e.vars["next_turret"] = game.time + 1.0
		game.banner("FULL LOAD: the Motherboard builds turrets around itself")
	if part == 2 and e.hp <= e.max_hp * float(a["overclock_hp"]):
		part = 3
		game.banner("OVERCLOCK: the Motherboard's presses run hot")
	if part != int(e.vars["part"]):
		e.vars["part"] = part
		EnemyTrait.note(game, "motherboard_parts")
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var k := float(a["overclock_mult"]) if part == 3 else 1.0  # Cooldown x.
	if game.time >= float(e.vars["next_grab"]):
		e.vars["next_grab"] = game.time + float(a["grab_every"]) * k
		var grabbed: BlockBody = null  # The body it seizes.
		for b: BlockBody in game.bodies_near(e.position, float(a["grab_range"])):
			if not b.temporary and (grabbed == null or b.pos.distance_squared_to(e.position) < grabbed.pos.distance_squared_to(e.position)):
				grabbed = b
		var ts := Kit.towers_near(game, e.position, float(a["hurl_range"]), true)  # Where to hurl it.
		if grabbed != null and not ts.is_empty():
			var from := grabbed.pos  # Where it was seized.
			TdCombat.damage_body(game, grabbed, float(a["grab_damage"]), e)
			game.hostile.shell(ts[0].position, float(a["hurl_radius"]), float(a["hurl_delay"]), float(a["hurl_disable"]), "shelled", 0.0)
			_pose(e, game, 3, float(a["pose_time"]))
			if game.vfx.on:
				var f := game.vfx.add(TdVfx.Kind.THREAD, from + Vector2(0, -20), 10.0, 0.5, Acts.data("empire")["LOOK"]["line_tint"])
				if f != null:
					f.to = ts[0].position
			EnemyTrait.note(game, "crane_grabs")
			Sfx.play("crane_throw")
	if game.time >= float(e.vars["next_stamp"]):
		var ts := Kit.towers_near(game, e.position, float(a["stamp_range"]))  # Stamped towers.
		if not ts.is_empty():
			e.vars["next_stamp"] = game.time + float(a["stamp_every"]) * k
			var n := int(a["stamps"]) + (1 if part == 3 else 0)  # Presses now.
			for t: Tower in ts.slice(0, n):
				game.hostile.shell(t.position, float(a["stamp_radius"]), float(a["stamp_delay"]), float(a["stamp_disable"]), "shelled", float(a["stamp_body"]))
			_pose(e, game, 1, float(a["stamp_delay"]))
			EnemyTrait.note(game, "press_stamps")
			Sfx.play("press_charge")
	if part >= 2 and game.time >= float(e.vars["next_turret"]):
		e.vars["next_turret"] = game.time + float(a["turret_every"]) * k
		var alive := 0  # Its turrets standing.
		for o: TdEnemy in game.enemies:
			alive += 1 if o.alive and o.kind == String(a["turret_kind"]) else 0
		if alive < int(a["turret_cap"]):
			var r := e.follower.road  # Its road.
			var o := game.waves.spawn_extra(String(a["turret_kind"]), r.id, maxf(e.follower.dist - 24.0, 0.0), float(alive % 2 * 2 - 1) * 26.0)
			game.fx.spawn("summon_rise", o.position, 64.0, 0.45, Acts.data("empire")["LOOK"]["arc_tint"])
			EnemyTrait.note(game, "motherboard_turrets")
			Sfx.play("fabricate")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Motherboard shuts down: the assembly line stops")
