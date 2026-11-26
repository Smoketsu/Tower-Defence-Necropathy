## Odin the All-Father (Vigrid boss, the act's finale; Necropathy's BossOdin:
## "THE WOLF: Fenrir hunts and swallows; Odin stands watch, untargetable and
## unharmed. THE ALL-FATHER: Fenrir is chained at his side; Odin walks, throws
## GUNGNIR (only a Bone Wall across its path stops it) and sends his RAVENS.
## RAGNARÖK: both fight; the arena burns; when one falls the other follows").
## On spawn he calls Fenrir (kind `wolf_kind`, scripts/bosses/norse/fenrir.gd)
## `wolf_gap` px ahead of him on his road.
##   the Wolf      — he walks `stand_dist` px in and stands (vars
##                   "untargetable": hidden from every tower by the Long
##                   Winter's can_target(), every hit does nothing) while Fenrir
##                   runs the road.
##   the All-Father — when Fenrir falls below `chain_hp` of his HP, Fenrir is
##                   chained where he stands (frozen and out of reach) and Odin
##                   walks: every `spear_every` s (first after `spear_first`)
##                   he throws Gungnir at the highest-level tower within
##                   `spear_range` px (game.hostile.fire(), straight: the first
##                   post or Bone Wall body on its line takes `spear_damage`
##                   instead; a tower it reaches is stunned `spear_disable` s);
##                   every `raven_every` s `raven_count` ravens fly ahead.
##   Ragnarok      — below `ragnarok_hp` of his HP Fenrir is unchained and both
##                   come on; every `fire_every` s `fire_count` towers (in turn)
##                   are marked by burning ground (game.hostile.shell():
##                   `fire_radius` px, `fire_delay` s, `fire_disable` s,
##                   `fire_damage` to bodies). When one of them falls, the other
##                   follows `doom_time` s later (vars "doom_at", the boss kill
##                   path).
## Args in his row. vars: "phase" ("wolf" | "allfather" | "ragnarok"), "wolf"
## ([TdEnemy, generation]), "next_spear", "next_raven", "next_fire", "fire_i",
## "doom_at", "untargetable", "pose_until".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var w := game.waves.spawn_extra(String(a["wolf_kind"]), e.follower.road.id, e.follower.dist + float(a["wolf_gap"]), e.follower.lane)
	w.vars["odin"] = [e, e.generation]
	e.vars["wolf"] = [w, w.generation]
	e.vars["phase"] = "wolf"
	e.vars["untargetable"] = true
	e.vars["next_spear"] = 0.0
	e.vars["next_raven"] = 0.0
	e.vars["next_fire"] = 0.0
	e.vars["fire_i"] = 0
	e.vars["pose_until"] = 0.0
	game.banner("Fenrir runs before the All-Father: Odin watches, out of reach")


## Fenrir, or null once he has fallen.
static func wolf_of(e: TdEnemy) -> TdEnemy:
	var wp: Array = e.vars.get("wolf", [])
	return wp[0] if not wp.is_empty() and TdEnemy.valid(wp[0], int(wp[1])) else null


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, _hit: Dictionary) -> float:
	return 0.0 if bool(e.vars.get("untargetable", false)) else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.vars.has("doom_at"):
		if game.time >= float(e.vars["doom_at"]):
			e.vars.erase("untargetable")
			EnemyTrait.note(game, "odin_doomed")
			TdCombat.kill_enemy(game, e, null)
		return
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var wolf := wolf_of(e)  # Fenrir, or null.
	match String(e.vars["phase"]):
		"wolf":
			e.speed = 0.0 if e.follower.dist >= float(a["stand_dist"]) else float(e.row["speed"])
			if wolf == null or wolf.hp < wolf.max_hp * float(a["chain_hp"]):
				e.vars["phase"] = "allfather"
				e.vars.erase("untargetable")
				e.speed = float(e.row["speed"])
				e.vars["next_spear"] = game.time + float(a["spear_first"])
				e.vars["next_raven"] = game.time + float(a["raven_every"]) * 0.5
				if wolf != null:
					wolf.vars["chained"] = true
					wolf.vars["untargetable"] = true
				game.banner("Fenrir is chained: the All-Father takes the field with Gungnir")
				Sfx.play("boss_arrive")
				EnemyTrait.note(game, "odin_allfather")
		"allfather":
			if e.hp < e.max_hp * float(a["ragnarok_hp"]):
				e.vars["phase"] = "ragnarok"
				e.vars["next_fire"] = game.time + 1.0
				if wolf != null:
					wolf.vars.erase("chained")
					wolf.vars.erase("untargetable")
				game.banner("Ragnarok! The wolf is loose and the field burns")
				Sfx.play("horn_call")
				EnemyTrait.note(game, "odin_ragnarok")
		"ragnarok":
			if game.time >= float(e.vars["next_fire"]) and not game.towers.is_empty():
				e.vars["next_fire"] = game.time + float(a["fire_every"])
				for k in int(a["fire_count"]):
					var t: Tower = game.towers[(int(e.vars["fire_i"]) + k * 7) % game.towers.size()]
					game.hostile.shell(t.position, float(a["fire_radius"]), float(a["fire_delay"]), float(a["fire_disable"]), "shelled", float(a["fire_damage"]))
				e.vars["fire_i"] = int(e.vars["fire_i"]) + 1
				EnemyTrait.note(game, "ragnarok_fires")
	if String(e.vars["phase"]) == "wolf" or game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_spear"]):
		var best: Tower = null  # Highest-level tower in reach (nearest on a tie).
		for t: Tower in game.towers:
			if t.position.distance_to(e.position) <= float(a["spear_range"]) and (best == null or t.level > best.level or (t.level == best.level and t.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position))):
				best = t
		if best != null:
			e.vars["next_spear"] = game.time + float(a["spear_every"])
			game.hostile.fire(e.position + Vector2(0, -20), best, {"speed": a["spear_speed"], "damage": a["spear_damage"], "disable": a["spear_disable"], "cause": "stunned", "arc": false, "look": "gungnir"})
			EnemyTrait.note(game, "odin_gungnir")
			Sfx.play("spear_cast")
			_pose(e, game, a)
	if game.time >= float(e.vars["next_raven"]):
		e.vars["next_raven"] = game.time + float(a["raven_every"])
		for i in int(a["raven_count"]):
			var c := game.waves.spawn_extra(String(a["raven_kind"]), e.follower.road.id, e.follower.dist + 20.0 + 18.0 * float(i), e.follower.lane + float(i - 1) * 12.0)
			game.fx.spawn("spore_cloud", c.position, 40.0, 0.4, Color(0.3, 0.3, 0.4, 0.8))
		EnemyTrait.note(game, "odin_ravens")


## Shows his strike pose for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(e: TdEnemy, game: TdGame) -> void:
	var wolf := wolf_of(e)  # Fenrir follows him.
	if wolf != null and not wolf.vars.has("doom_at"):
		wolf.vars["doom_at"] = game.time + float(e.row["args"]["doom_time"])
		wolf.vars.erase("chained")
		wolf.vars.erase("untargetable")
		game.banner("The All-Father falls: the wolf will follow him")
