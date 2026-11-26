## The Hierophant of the Eye's ASCENSION (Necropathy's HierophantKit; it also
## claims the dead like a Chanter: row args "claim_radius", read by the act
## rule). From `first` s after it arrives, once it stands in the reach of at
## least `near` towers that can hit it (in the towers' sight: the counterplay), it stops and channels for
## `channel` s inside a magenta pillar. If it survives and is not broken:
##   calls 0 (the Hierophant) — it tears itself open and rises as a kind
##     `into` (a Spawn of the Deep) in its place, an extra of the current wave;
##     it leaves the road without a kill.
##   calls n (the Grand Hierophant, the Spire miniboss) — `calls` kinds `into`
##     climb out of the sea behind him (`call_gap` px apart), and he walks on.
## Dealing `break` of its max HP during the channel breaks it: it walks again
## and retries `retry` s later. Args: claim_radius, first, channel, break,
## retry, into, calls, call_gap. vars: "next" (game s of the next ritual),
## "until" (game s the channel ends; 0 = none), "hp0" (HP when it began).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	var until := float(e.vars["until"])
	if until > 0.0:
		if float(e.vars["hp0"]) - e.hp >= e.max_hp * float(a["break"]):
			e.vars["until"] = 0.0
			e.vars["next"] = game.time + float(a["retry"])
			Kit.walk(e)
			game.fx.spawn("ink_burst", e.position, 70.0, 0.4, lk["magenta"])
			EnemyTrait.note(game, "eye_ascensions_broken")
			return
		if game.time < until:
			return
		e.vars["until"] = 0.0
		Kit.walk(e)
		EnemyTrait.note(game, "eye_ascensions")
		game.fx.spawn("abyssal_burst", e.position, float(lk["pillar_d"]) * 1.6, 0.6, lk["magenta"])
		Sfx.play("summon_rise")
		var calls := int(a["calls"])  # Kinds called (0 = it becomes one).
		if calls <= 0:
			game.waves.spawn_extra(String(a["into"]), e.follower.road.id, e.follower.dist, e.follower.lane)
			game.remove_enemy(e, false)
			return
		e.vars["next"] = game.time + float(a["retry"])
		for i in calls:
			game.waves.spawn_extra(String(a["into"]), e.follower.road.id, maxf(e.follower.dist - float(a["call_gap"]) * float(i + 1), 0.0), float(i % 2 * 2 - 1) * 8.0)
		game.banner("The Grand Hierophant calls the Spawn of the Deep out of the sea!")
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or not _in_sight(e, game, float(a["near"])):
		return
	e.vars["until"] = game.time + float(a["channel"])
	e.vars["hp0"] = e.hp
	Kit.stand(e)
	game.fx.spawn("abyssal_burst", e.position + Vector2(0, -20), float(lk["pillar_d"]), float(a["channel"]), Color(lk["magenta"], 0.6))
	Kit.ring(game, e.position, float(lk["pillar_d"]) * 0.6, float(a["channel"]), false, "", lk["magenta"])


## True when at least `n` towers can shoot `e` where it stands (range and Tower.can_hit()).
func _in_sight(e: TdEnemy, game: TdGame, n: float) -> bool:
	var k := 0  # Towers in reach.
	for t: Tower in game.towers:
		var r := float(t.stats["range"])  # Its reach (px).
		if t.block == null and t.position.distance_squared_to(e.position) <= r * r and t.can_hit(e):
			k += 1
	return float(k) >= n
