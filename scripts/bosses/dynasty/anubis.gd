## Anubis, Opener of the Way (Necropolis boss; Necropathy's BossAnubis: "the
## Procession: he leads a funeral march of mummies; every jar must be broken to
## end Rebirth. The Embalmer: he wraps the fallen; the cartouche timer is short
## while he does. The Jackal: he drops the wrapped pose and duels"). Three
## phases by his HP:
##   * THE PROCESSION — every `march_every` s (first after `march_first`)
##     `marchers` of `march_kind` step onto the road behind him, `march_gap` px
##     apart (WaveDirector.spawn_extra; they return through Rebirth like any).
##   * THE EMBALMER (below `embalm_hp`) — the marches go on, every Name rises in
##     `embalm_rise` of its time (the act rule's set_rise_mult()) and every
##     `jar_every` s he sets a new Canopic Jar down `jar_ahead` px ahead of him,
##     `jar_side` px beside the road (place_jar()).
##   * THE JACKAL (below `jackal_hp`) — the Names keep their haste; every
##     `lunge_every` s a post holding him is lunged through (corsair/lunge's
##     lunge_through(): `lunge_damage`, unholdable `lunge_time` s at
##     `lunge_speed`).
## Pose 1 while he calls a march or sets a jar. His fall gives the Names their
## time back. Args in his row. vars: "next_march", "next_jar", "next_lunge",
## "pose_until" (game s), "phase" (0..2).
extends EnemyTrait

const Lunge := preload("res://scripts/enemies/traits/corsair/lunge.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_march"] = game.time + float(a["march_first"])
	e.vars["next_jar"] = game.time + float(a["jar_every"]) * 0.3
	e.vars["next_lunge"] = 0.0
	e.vars["pose_until"] = 0.0
	e.vars["phase"] = 0


## The act rule when it is Rebirth (null elsewhere, e.g. a test act).
static func rule(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("place_jar") else null


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var ph := 2 if e.hp < e.max_hp * float(a["jackal_hp"]) else (1 if e.hp < e.max_hp * float(a["embalm_hp"]) else 0)  # Phase by HP.
	if ph != int(e.vars["phase"]):
		e.vars["phase"] = ph
		var r := rule(game)
		if ph >= 1 and r != null:
			r.call("set_rise_mult", float(a["embalm_rise"]))
		game.banner(["", "Anubis embalms the fallen: the Names rise quickly", "Anubis drops his wraps: the Jackal duels!"][ph])
		EnemyTrait.note(game, "anubis_phase%d" % ph)
	if game.time < e.freeze_until:
		return
	if ph < 2 and game.time >= float(e.vars["next_march"]):
		e.vars["next_march"] = game.time + float(a["march_every"])
		for i in int(a["marchers"]):
			var d := maxf(e.follower.dist - float(a["march_gap"]) * float(i + 1), 0.0)  # Behind him.
			game.waves.spawn_extra(String(a["march_kind"]), e.follower.road.id, d, e.follower.lane + float(i % 2 * 2 - 1) * 8.0)
		_pose(e, game, a)
		EnemyTrait.note(game, "anubis_marches")
	if ph == 1 and game.time >= float(e.vars["next_jar"]):
		e.vars["next_jar"] = game.time + float(a["jar_every"])
		var r := rule(game)
		if r != null:
			var road := e.follower.road  # His road.
			var d := minf(e.follower.dist + float(a["jar_ahead"]), road.length - 20.0)
			var dir := road.dir_at(d)
			r.call("place_jar", road.point_at(d) + Vector2(dir.y, -dir.x) * float(a["jar_side"]))
			_pose(e, game, a)
			EnemyTrait.note(game, "anubis_jars")
	if ph == 2 and e.holder != null and game.time >= float(e.vars["next_lunge"]):
		e.vars["next_lunge"] = game.time + float(a["lunge_every"])
		Lunge.lunge_through(e, game, float(a["lunge_damage"]), float(a["lunge_time"]), float(a["lunge_speed"]))
		e.pose = 3
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		EnemyTrait.note(game, "anubis_lunges")


## His cast pose for `pose_time` s (drawn only).
static func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	var r := rule(game)
	if r != null:
		r.call("set_rise_mult", 1.0)
