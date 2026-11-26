## Old Gravejaw, the Tyrant King (Last Day boss, the act's finale; Necropathy's
## BossGravejaw):
##   the Bite   — held, every `bite_every` s (first after `bite_first`) he lowers
##                his jaws for `windup` s (a line), then SWALLOWS the body holding
##                him whole (Kit.swallow(); it returns on its post's respawn).
##   the Roar   — every `roar_every` s (first after `roar_first`) he rears for
##                `roar_windup` s (pose 1, a ring of the real reach), then ROARS:
##                every tower within `roar_radius` px is stunned `roar_stun` s,
##                the swarm answers (`call`, from the entrances, `call_gap` s
##                apart) and a herd (`roar_herd`, `herd_gap` s apart) stampedes down the
##                trail nearest him (Stampedes.launch()).
##   the Mound — `mound_dist` px down his road he stops on the Mound and
##                stands there roaring (speed 0) until the Last Day.
##   the Last Day — below `last_hp` of his HP, once: he leaves the Mound, the meteors fall faster
##                (the rule's meteor_mult x `meteor_mult`) and every
##                `rampage_every` s he RAMPAGES for `rampage_time` s at
##                `speed_mult` x through the posts, goring each (`gore`).
## Args in his row. vars: "next_bite", "bite_at", "next_roar", "roar_at",
## "queue", "last", "next_rampage", "charge_until", "gored".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")
const Stampedes := preload("res://scripts/maps/rules/primeval/stampedes.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	e.vars["next_bite"] = game.time + float(a["bite_first"])
	e.vars["bite_at"] = 0.0
	e.vars["next_roar"] = game.time + float(a["roar_first"])
	e.vars["roar_at"] = 0.0
	e.vars["queue"] = []
	e.vars["last"] = false
	e.vars["next_rampage"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	var q: Array = e.vars["queue"]
	while not q.is_empty() and game.time >= float(q[0][0]):
		var s: Array = q.pop_front()
		game.waves.spawn_extra(String(s[1]), String(s[2]), 0.0, game.rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD))
	var rule := Stampedes.of(game)
	if not bool(e.vars["last"]) and e.speed > 0.0 and e.follower.dist >= float(a["mound_dist"]):
		e.speed = 0.0
		game.banner("Gravejaw stands on the Mound and roars at the burning sky!")
		EnemyTrait.note(game, "gravejaw_mound")
	if not bool(e.vars["last"]) and e.hp / e.max_hp <= float(a["last_hp"]):
		e.vars["last"] = true
		e.speed = float(e.row["speed"])
		e.vars["next_rampage"] = game.time + 2.0
		if rule != null:
			rule.set("meteor_mult", float(a["meteor_mult"]))
		game.banner("The Last Day: the sky burns, and Gravejaw rampages!")
		EnemyTrait.note(game, "gravejaw_last_day")
	if Kit.charging(e, game):
		Kit.charge_step(e, game, float(a["gore"]), 0.0, 0.0)
		return
	var ra := float(e.vars["roar_at"])
	if ra > 0.0:
		if game.time < ra:
			return
		e.vars["roar_at"] = 0.0
		e.pose = 0
		e.body.queue_redraw()
		Kit.roar(e, game, float(a["roar_radius"]), float(a["roar_stun"]))
		_call(e, game, a)
		if rule != null:
			rule.call("launch", a["roar_herd"], e.position, float(a["herd_gap"]))
		EnemyTrait.note(game, "gravejaw_roars")
		return
	var ba := float(e.vars["bite_at"])
	if ba > 0.0:
		if game.time < ba:
			return
		e.vars["bite_at"] = 0.0
		if game.time >= e.freeze_until and Kit.swallow(e, game):
			EnemyTrait.note(game, "gravejaw_swallows")
		return
	if game.time < e.freeze_until:
		return
	if bool(e.vars["last"]) and game.time >= float(e.vars["next_rampage"]):
		e.vars["next_rampage"] = game.time + float(a["rampage_every"])
		Kit.start_charge(e, game, float(a["speed_mult"]), float(a["rampage_time"]))
		EnemyTrait.note(game, "gravejaw_rampages")
		return
	if game.time >= float(e.vars["next_roar"]):
		e.vars["next_roar"] = game.time + float(a["roar_every"])
		e.vars["roar_at"] = game.time + float(a["roar_windup"])
		e.pose = 1
		e.body.queue_redraw()
		Kit.ring(game, e.position, float(a["roar_radius"]), float(a["roar_windup"]), Color.WHITE, false)
		Sfx.play("boss_telegraph")
	elif e.holder != null and game.time >= float(e.vars["next_bite"]):
		e.vars["next_bite"] = game.time + float(a["bite_every"])
		e.vars["bite_at"] = game.time + float(a["windup"])
		Kit.line(game, e.position, e.holder.pos, float(a["windup"]), false)


## Queues the swarm his roar calls, from the entrances in turn.
func _call(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ents: Array[String] = []
	for id: String in game.roads:
		var rd: Road = game.roads[id]
		if rd.entrance and not rd.off_road:
			ents.append(id)
	ents.sort()
	var q: Array = e.vars["queue"]
	var k := 0
	for g: Array in a["call"]:
		for i in int(g[1]):
			q.append([game.time + float(a["call_gap"]) * float(k), String(g[0]), ents[k % ents.size()]])
			k += 1


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Old Gravejaw falls: the Tyrant King's last day is done")
