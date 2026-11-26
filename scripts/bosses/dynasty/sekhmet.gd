## Sekhmet, the Lioness of Retribution (Temple boss; Necropathy's BossSekhmet).
## Three phases by her HP, every attack telegraphed:
##   * THE HUNT — every `leap_every` s (first after `leap_first`) a landing
##     circle opens `leap_px` px ahead of her on her road (the one shelling
##     path: towers inside stunned `leap_disable` s, bodies inside take
##     `leap_damage`); when it lands she is there, over any post between.
##   * THE RED WIND (below `wind_hp`) — she keeps a Sandstorm blowing (the act
##     rule's force_storm()) and runs at `wind_haste`; the leaps go on.
##   * THE FEAST (below `feast_hp`) — she sets three red-wine jars (kind
##     `feast_kind`, structures) beside her road `feast_ahead` px ahead,
##     `feast_side` px off it. While any stands she takes only `feast_mult` of a
##     hit and every `drink_every` s heals `drink_heal` of her max HP per jar.
##     When all three are broken she STUMBLES: x `stumble_mult` damage for
##     `stumble_time` s, then a new set. Mark a jar (tap) to aim the towers at
##     it. Failsafe: `feast_cap` s into the Feast every hit lands in full.
## Args in her row. vars: "next_leap", "leap_at", "leap_to", "next_drink",
## "stumble_until", "feast_at", "pose_until", "phase", "jars".
extends EnemyTrait

const Anubis := preload("res://scripts/bosses/dynasty/anubis.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_leap"] = game.time + float(a["leap_first"])
	e.vars["phase"] = 0
	e.vars["pose_until"] = 0.0
	e.vars["jars"] = []
	e.vars["stumble_until"] = 0.0
	e.vars["next_drink"] = 0.0


## Her wine jars still standing (prunes the broken).
static func _jars(e: TdEnemy) -> Array:
	var live: Array = (e.vars["jars"] as Array).filter(func(p: Array) -> bool: return TdEnemy.valid(p[0], int(p[1])))
	e.vars["jars"] = live
	return live


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var ph := 2 if e.hp < e.max_hp * float(a["feast_hp"]) else (1 if e.hp < e.max_hp * float(a["wind_hp"]) else 0)  # Phase by HP.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		game.banner(["", "The Red Wind: Sekhmet calls the sandstorm", "The Feast: break her wine jars (tap one to aim your towers)"][ph])
		EnemyTrait.note(game, "sekhmet_phase%d" % ph)
		if ph == 2:
			e.vars["feast_at"] = game.time
			_set_jars(e, game, a)
	if ph >= 1:
		var r := Anubis.rule(game)
		if r != null:
			r.call("force_storm")
		TdCombat.haste_enemy(game, e, float(a["wind_haste"]), 0.5)
	if e.vars.has("leap_at") and game.time >= float(e.vars["leap_at"]):
		_land(e, game)
	if ph == 2:
		var live := _jars(e)
		if live.is_empty() and game.time >= float(e.vars["stumble_until"]):
			if float(e.vars.get("stumbled", 0.0)) == 0.0:
				e.vars["stumbled"] = 1.0
				e.vars["stumble_until"] = game.time + float(a["stumble_time"])
				e.pose = 3
				e.vars["pose_until"] = game.time + float(a["stumble_time"])
				game.banner("Sekhmet stumbles, drunk on nothing: strike now!")
				EnemyTrait.note(game, "sekhmet_stumbles")
			else:
				e.vars["stumbled"] = 0.0
				_set_jars(e, game, a)
		elif not live.is_empty() and game.time >= float(e.vars["next_drink"]):
			e.vars["next_drink"] = game.time + float(a["drink_every"])
			TdCombat.heal_enemy(game, e, e.max_hp * float(a["drink_heal"]) * float(live.size()))
			EnemyTrait.note(game, "sekhmet_drinks")
	if game.time < e.freeze_until or e.vars.has("leap_at") or game.time < float(e.vars["next_leap"]):
		return
	e.vars["next_leap"] = game.time + float(a["leap_every"])
	var road := e.follower.road  # Her road (she leaps along it, never off its end).
	var to := minf(e.follower.dist + float(a["leap_px"]), road.length - 60.0)
	if to <= e.follower.dist + 20.0:
		return
	e.vars["leap_to"] = to
	e.vars["leap_at"] = game.time + float(a["leap_delay"])
	game.hostile.shell(road.point_at(to), float(a["leap_radius"]), float(a["leap_delay"]), float(a["leap_disable"]), "stunned", float(a["leap_damage"]) * e.damage_mult())
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["leap_delay"])
	e.body.queue_redraw()


## She lands where the circle closed (over any post between).
func _land(e: TdEnemy, game: TdGame) -> void:
	var to := float(e.vars["leap_to"])
	e.vars.erase("leap_at")
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	if to > e.follower.dist:
		e.follower.dist = to
		e.position = e.follower.position()
	e.vis_strike_at = game.time
	e.vis_strike_dir = e.follower.direction()
	EnemyTrait.note(game, "sekhmet_leaps")


## Sets down a fresh set of wine jars ahead of her.
func _set_jars(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var road := e.follower.road
	var live: Array = []
	var k := 0
	for ahead: float in a["feast_ahead"]:
		var d := minf(e.follower.dist + ahead, road.length - 30.0)
		var dir := road.dir_at(d)
		var side := float(k % 2 * 2 - 1) * float(a["feast_side"])
		var j := Structures.raise(game, String(a["feast_kind"]), road.point_at(d) + Vector2(dir.y, -dir.x) * side)
		live.append([j, j.generation])
		k += 1
	e.vars["jars"] = live
	e.vars["next_drink"] = game.time + float(a["drink_every"])
	EnemyTrait.note(game, "sekhmet_jar_sets")


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]
	if int(e.vars["phase"]) < 2 or game.time - float(e.vars.get("feast_at", game.time)) >= float(a["feast_cap"]):
		return amount
	if game.time < float(e.vars["stumble_until"]):
		return amount * float(a["stumble_mult"])
	if not _jars(e).is_empty():
		return amount * float(a["feast_mult"])
	return amount


func on_death(e: TdEnemy, game: TdGame) -> void:
	for p: Array in _jars(e):
		game.remove_enemy(p[0], false)
