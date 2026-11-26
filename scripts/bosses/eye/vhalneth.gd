## Vhal'Neth, the Dreaming Mother (Ul-Thalos boss, the act's last; Necropathy's
## BossVhalneth). She NEVER WALKS (row speed 0): her face lies off the shore
## `stand_dist` px down her road, and the army fights her ARMS (`arm_kind`,
## traits/eye/arm.gd: they rise beside her road and slam telegraphed lanes).
##   Dreaming — on arrival her face lies under the sea (vars "untargetable",
##              the one hidden test; drawn faded, eyes shut): she takes no
##              damage but her arms' wounds. `arms` rise ([px along her road
##              from her, px across]); each severed arm wounds her
##              `wound` x her max HP split between them (arm_severed()). The
##              last arm severed, or her HP at `stir_hp`, wakes her to:
##   Stirring — her face surfaces (targetable, eyes open); the `regrow` arms
##              rise again; her GAZE rests every `gaze_every` s (first after
##              `gaze_first`) on the densest knot of towers: every tower
##              within `gaze_radius` px of it deals `gaze_mult` for
##              `gaze_time` s (TdCombat.suppress_tower).
##   Waking   — at `wake_hp` her face rises roaring (bosses/vhalneth_waking),
##              the `regrow` arms rise once more, and every `roar_every` s her
##              roar stuns every tower within `roar_radius` px of her
##              `roar_stun` s (cause "blinded"). She gazes on.
## Every `call_every` s the drowned answer her: `call` ([kind, count] rows)
## climb out of the sea behind her on her road, `call_gap` px apart (extras
## of her wave). Her arms sink when she falls. Args in her row. vars: "form"
## (0 dreaming, 1 stirring, 2 waking), "arms_raised" (arms of the current
## rising), "next_gaze", "next_roar", "next_call", "pose_until" (game s).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.follower.advance(minf(float(a["stand_dist"]), e.follower.road.length - 1.0))
	e.position = e.follower.position()
	e.last_dist = e.follower.dist
	e.vars["form"] = 0
	e.vars["untargetable"] = true
	e.vars["vis_alpha"] = 0.55
	e.vars["next_gaze"] = INF
	e.vars["next_roar"] = INF
	e.vars["next_call"] = game.time + float(a["call_every"]) * 0.5
	e.vars["pose_until"] = 0.0
	_raise(e, game, a["arms"])
	game.banner("Vhal'Neth dreams beneath the sea: sever her arms!")


## Raises one arm per [px along her road from her, px across] row of `rows`.
func _raise(e: TdEnemy, game: TdGame, rows: Array) -> void:
	var a: Dictionary = e.row["args"]
	var rd := e.follower.road  # Her road.
	for row: Array in rows:
		var d := clampf(e.follower.dist + float(row[0]), 0.0, rd.length - 1.0)  # Where it rises.
		var arm := game.waves.spawn_extra(String(a["arm_kind"]), rd.id, d, float(row[1]))
		if arm != null:
			game.fx.spawn("tide_splash", arm.position, 120.0, 0.6)
	e.vars["arms_raised"] = rows.size()
	Sfx.play("summon_rise")


## Arms of hers still standing.
func _arms(e: TdEnemy, game: TdGame) -> int:
	var n := 0
	for o: TdEnemy in game.enemies:
		n += 1 if o.alive and o.kind == String(e.row["args"]["arm_kind"]) else 0
	return n


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, hit: Dictionary) -> float:
	if int(e.vars.get("form", 0)) == 0 and String(hit.get("source", "")) != "eye_arm_severed":
		return 0.0
	return amount


## An arm of hers was severed: the wound share (called by traits/eye/arm.gd).
func arm_severed(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	var share := float(a["wound"]) * e.max_hp / float(maxi(int(e.vars["arms_raised"]), 1))  # HP the wound costs.
	TdCombat.damage_enemy(game, e, share, {"source": "eye_arm_severed", "dot": true})


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var form := int(e.vars["form"])
	if form == 0 and (_arms(e, game) == 0 or e.hp <= e.max_hp * float(a["stir_hp"])):
		e.vars["form"] = 1
		e.vars.erase("untargetable")
		e.vars["vis_alpha"] = 1.0
		e.vars["sprite"] = "bosses/vhalneth"
		e.vars["next_gaze"] = game.time + float(a["gaze_first"])
		_raise(e, game, a["regrow"])
		game.banner("Vhal'Neth stirs: her eyes open, her Gaze rests on your towers!")
		e.body.queue_redraw()
	elif form == 1 and e.hp <= e.max_hp * float(a["wake_hp"]):
		e.vars["form"] = 2
		e.vars["sprite"] = "bosses/vhalneth_waking"
		e.vars["next_roar"] = game.time + 1.5
		_raise(e, game, a["regrow"])
		game.banner("THE WAKING: Vhal'Neth rises roaring from the sea!")
		game.vfx.shake(4.0)
		e.body.queue_redraw()
	if game.time >= float(e.vars["next_call"]):
		e.vars["next_call"] = game.time + float(a["call_every"])
		var k := 0  # Units placed.
		for g: Array in a["call"]:
			for j in int(g[1]):
				k += 1
				game.waves.spawn_extra(String(g[0]), e.follower.road.id, maxf(e.follower.dist - float(a["call_gap"]) * float(k) - 80.0, 0.0), float(k % 3 - 1) * 8.0)
		EnemyTrait.note(game, "eye_vhalneth_calls")
	if game.time >= float(e.vars["next_gaze"]) and not game.towers.is_empty():
		e.vars["next_gaze"] = game.time + float(a["gaze_every"])
		var r := float(a["gaze_radius"])  # Px.
		var best: Tower = null  # The heart of the densest knot.
		var most := -1
		for t: Tower in game.towers:
			var n := CovenantField.of(game).towers_near(t.position, r).size()
			if n > most:
				most = n
				best = t
		for t: Tower in CovenantField.of(game).towers_near(best.position, r):
			TdCombat.suppress_tower(game, t, float(a["gaze_mult"]), float(a["gaze_time"]))
		game.fx.spawn("vhalneth_gaze", best.position, r * 2.0, float(a["gaze_time"]), lk["gaze_tint"])
		Kit.ring(game, best.position, r, 0.5, true, "", lk["gaze_tint"])
		Kit.line(game, e.position, best.position, 0.0, true, lk["gaze_tint"])
		e.pose = 1
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		EnemyTrait.note(game, "eye_gazes")
		EnemyTrait.note(game, "eye_gaze_towers", float(most))
	if game.time >= float(e.vars["next_roar"]):
		e.vars["next_roar"] = game.time + float(a["roar_every"])
		var n := 0  # Towers stunned.
		for t: Tower in CovenantField.of(game).towers_near(e.position, float(a["roar_radius"])):
			TdCombat.disable_tower(game, t, float(a["roar_stun"]), "blinded")
			n += 1
		Kit.ring(game, e.position, float(a["roar_radius"]), 0.5, true, "abyssal_burst", lk["magenta"])
		game.vfx.shake(3.0)
		EnemyTrait.note(game, "eye_roars")
		Sfx.play("boss_impact")


func on_death(e: TdEnemy, game: TdGame) -> void:
	for o: TdEnemy in game.enemies.duplicate():
		if o.alive and o.hp > 0.0 and o.kind == String(e.row["args"]["arm_kind"]):  # The arm being severed now finishes its own kill.
			game.fx.spawn("tide_splash", o.position, 120.0, 0.6)
			game.remove_enemy(o, false)
	game.banner("Vhal'Neth sinks for the last time: the Eye closes, and the dead are yours")
