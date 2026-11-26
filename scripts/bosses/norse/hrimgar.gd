## Hrimgar the Draugr-King (Barrow Fields boss; Necropathy's BossHrimgar: "he
## rises three times. Each time he falls he sinks into his barrow and returns
## stronger, unless the necromancer breaks the barrow while he is down. The
## Grave (draugr from every mound), the Barrow Lord (a cleaving greatsword), the
## Last Rising (he drags summons into the mound with him)").
##   lives   — `lives` lives. A blow that would kill him with lives left leaves
##             him at 1 HP: he SINKS (vars "untargetable": every tower loses
##             him through the Long Winter's can_target(), every hit does
##             nothing, he stands frozen, drawn faded) and his barrow (kind
##             `barrow_kind`, a structure) rises `barrow_side` px beside him.
##             After `rise_time` s he rises at rise_hp[life] of his max HP and
##             the barrow sinks; break the barrow first and he stays down (the
##             boss kill path, TdCombat.kill_enemy).
##   mist    — every life: every `mist_every` s (first after `mist_first`) a
##             frost mist lands round him (game.hostile.shell(): towers within
##             `mist_radius` px frozen `mist_disable` s, cause "frozen").
##   life 1  — the Grave: every `call_every` s `call_count` draugr rise behind him.
##   life 2  — the Barrow Lord: every `cleave_every` s, while a post holds him,
##             every body of that post takes `cleave_damage`.
##   life 3  — the Last Rising: every `drag_every` s the body holding him is
##             dragged under (`drag_damage`).
## Args in his row. vars: "life" (0-based), "down_until", "barrow"
## ([TdEnemy, generation] or []), "next_mist", "next_special", "pose_until",
## "untargetable" (while sunk), "vis_alpha" (drawn fade while sunk).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["life"] = 0
	e.vars["down_until"] = 0.0
	e.vars["barrow"] = []
	e.vars["next_mist"] = game.time + float(a["mist_first"])
	e.vars["next_special"] = game.time + float(a["call_every"])
	e.vars["pose_until"] = 0.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if bool(e.vars.get("untargetable", false)):
		return 0.0
	if amount < e.hp or int(e.vars["life"]) >= int(e.row["args"]["lives"]) - 1:
		return amount
	_sink(e, game)
	return maxf(e.hp - 1.0, 0.0)


## He falls and sinks into his barrow (see the header).
func _sink(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["untargetable"] = true
	e.vars["down_until"] = game.time + float(a["rise_time"])
	e.freeze_until = maxf(e.freeze_until, game.time + float(a["rise_time"]))
	var bw := game.waves.spawn_extra(String(a["barrow_kind"]), e.follower.road.id, e.follower.dist, e.follower.lane + float(a["barrow_side"]))
	e.vars["barrow"] = [bw, bw.generation]
	e.vars["vis_alpha"] = 0.35  # Drawn sunk in the mound (TdEnemy._draw_body, visual only).
	e.body.queue_redraw()
	EnemyTrait.note(game, "hrimgar_falls")
	game.banner("Hrimgar sinks into his barrow: break it before he rises!")
	Sfx.play("death_nova")
	if game.vfx.on:
		game.fx.spawn("summon_rise", e.position, 120.0, 0.7, Acts.data("norse")["LOOK"]["barrow_tint"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if bool(e.vars.get("untargetable", false)):
		var bp: Array = e.vars["barrow"]
		if bp.is_empty() or not TdEnemy.valid(bp[0], int(bp[1])):
			e.vars.erase("untargetable")
			e.vars.erase("vis_alpha")
			EnemyTrait.note(game, "hrimgar_barrow_broken")
			game.banner("The barrow is broken: Hrimgar stays in the dark")
			TdCombat.kill_enemy(game, e, null)
			return
		if game.time < float(e.vars["down_until"]):
			return
		e.vars.erase("untargetable")
		e.vars.erase("vis_alpha")
		e.body.queue_redraw()
		e.vars["life"] = int(e.vars["life"]) + 1
		var life := int(e.vars["life"])  # 0-based life now.
		e.hp = 1.0
		TdCombat.heal_enemy(game, e, e.max_hp * float(a["rise_hp"][mini(life, (a["rise_hp"] as Array).size() - 1)]))
		game.remove_enemy(bp[0], false)
		e.vars["barrow"] = []
		e.vars["next_special"] = game.time + 2.0
		EnemyTrait.note(game, "hrimgar_risings")
		game.banner(["", "Hrimgar rises again: the Barrow Lord's greatsword!", "The Last Rising: he drags the dead into the mound"][mini(life, 2)])
		Sfx.play("boss_arrive")
		_pose(e, game, a)
		return
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_mist"]):
		e.vars["next_mist"] = game.time + float(a["mist_every"])
		game.hostile.shell(e.position, float(a["mist_radius"]), float(a["mist_delay"]), float(a["mist_disable"]), "frozen", 0.0)
		EnemyTrait.note(game, "hrimgar_mists")
		if game.vfx.on:
			game.fx.spawn("frost_nova", e.position, float(a["mist_radius"]) * 2.0, float(a["mist_delay"]), Acts.data("norse")["LOOK"]["mist_tint"])
	if game.time < float(e.vars["next_special"]):
		return
	match int(e.vars["life"]):
		0:
			e.vars["next_special"] = game.time + float(a["call_every"])
			for i in int(a["call_count"]):
				var d := maxf(e.follower.dist - float(a["call_gap"]) * float(i + 1), 0.0)  # Px along his road.
				var c := game.waves.spawn_extra(String(a["call_kind"]), e.follower.road.id, d, e.follower.lane + float(i % 2 * 2 - 1) * 8.0)
				game.fx.spawn("summon_rise", c.position, 60.0, 0.5, Acts.data("norse")["LOOK"]["barrow_tint"])
			EnemyTrait.note(game, "hrimgar_calls")
			_pose(e, game, a)
		1:
			if e.holder == null:
				return
			e.vars["next_special"] = game.time + float(a["cleave_every"])
			for b: BlockBody in e.holder.block.bodies:
				if b.alive:
					TdCombat.damage_body(game, b, float(a["cleave_damage"]) * e.damage_mult(), e)
			EnemyTrait.note(game, "hrimgar_cleaves")
			Sfx.play("boss_impact")
			_pose(e, game, a)
			if game.vfx.on:
				game.vfx.add(TdVfx.Kind.ANIM, e.position, float(Acts.data("norse")["LOOK"]["cleave_d"]), 0.4, Color(0.7, 0.9, 1.0), "vael_cleave")
		_:
			if e.holder == null:
				return
			e.vars["next_special"] = game.time + float(a["drag_every"])
			var b := e.holder  # The body he drags under.
			TdCombat.damage_body(game, b, float(a["drag_damage"]) * e.damage_mult(), e)
			EnemyTrait.note(game, "hrimgar_drags")
			Sfx.play("death_nova")
			_pose(e, game, a)
			if game.vfx.on:
				game.fx.spawn("summon_rise", b.pos, 70.0, 0.6, Acts.data("norse")["LOOK"]["barrow_tint"])


## Shows his strike pose for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(e: TdEnemy, game: TdGame) -> void:
	e.vars.erase("vis_alpha")
	var bp: Array = e.vars.get("barrow", [])
	if not bp.is_empty() and TdEnemy.valid(bp[0], int(bp[1])):
		game.remove_enemy(bp[0], false)
