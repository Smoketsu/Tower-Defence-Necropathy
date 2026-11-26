## Abbot Silas Merrow, Voice of the Deep (Gullhaven Harbour boss; Necropathy's
## BossMerrow: the town's priest halfway through his change). Two forms:
##   ROBED (HP above `change_hp`):
##     Sermon     — every `sermon_every` s (first after `sermon_first`) he stops
##                  and preaches for `sermon_time` s (pose 1, the pulpit before
##                  him): every Eye cultist within `sermon_radius` px is hasted
##                  x`sermon_haste` and warded to `sermon_ward` of each hit
##                  (TdCombat.haste_enemy / ward_enemy, refreshed every step).
##                  Losing `sermon_break` of his max HP breaks it off.
##     Brine Wave — every `wave_every` s, walking: a telegraphed wave of
##                  `wave_radius` px lands on each of the `wave_count` nearest
##                  towers within `wave_range` px through the shelling path
##                  (stunned `wave_disable` s, cause "soaked"; bodies inside
##                  take `wave_body`).
##   THE CHANGE (at `change_hp`) — he sheds his robes for `change_time` s
##                  (takes no damage meanwhile), then fights as the changed
##                  thing (vars "sprite" bosses/merrow_changed, speed
##                  x`change_speed`):
##     Limb Lash  — held: every `lash_every` s a line for `lash_windup` s, then
##                  his limbs crack down on the first `lash_targets` living
##                  bodies of the post (`lash_damage` each, x his weaken).
##     Whirl      — every `whirl_every` s a ring of `whirl_radius` px for
##                  `whirl_windup` s, then his limbs whirl through it: bodies
##                  inside take `whirl_damage`, towers inside are stunned
##                  `whirl_disable` s (cause "grabbed").
## Args in his row. vars: "form" (0 robed, 1 changing, 2 changed), "next_sermon",
## "sermon_until", "sermon_hp", "next_wave", "change_until", "next_lash",
## "lash_at", "next_whirl", "whirl_at", "pose_until" (game s).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["form"] = 0
	e.vars["next_sermon"] = game.time + float(a["sermon_first"])
	e.vars["sermon_until"] = 0.0
	e.vars["next_wave"] = game.time + float(a["wave_every"]) * 0.5
	e.vars["lash_at"] = 0.0
	e.vars["whirl_at"] = 0.0
	e.vars["pose_until"] = 0.0
	game.banner("Abbot Merrow climbs his pulpit: the Voice of the Deep preaches!")


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, _hit: Dictionary) -> float:
	return 0.0 if int(e.vars.get("form", 0)) == 1 else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["sermon_until"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	match int(e.vars["form"]):
		0:
			_robed(e, game, a)
		1:
			if game.time >= float(e.vars["change_until"]):
				e.vars["form"] = 2
				e.vars["sprite"] = "bosses/merrow_changed"
				Kit.walk(e)
				e.speed *= float(a["change_speed"])
				e.vars["next_lash"] = game.time + 1.0
				e.vars["next_whirl"] = game.time + 3.0
				game.banner("The Change is done: Merrow's limbs lash and whirl!")
				e.body.queue_redraw()
		2:
			_changed(e, game, a)


func _robed(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var su := float(e.vars["sermon_until"])
	if su > 0.0:
		for o: TdEnemy in game.foes_near(e.position, float(a["sermon_radius"])):
			if o != e:
				TdCombat.haste_enemy(game, o, float(a["sermon_haste"]), 0.3)
				TdCombat.ward_enemy(game, o, float(a["sermon_ward"]), 0.3)
		if game.time >= su or float(e.vars["sermon_hp"]) - e.hp >= e.max_hp * float(a["sermon_break"]) or e.hp <= e.max_hp * float(a["change_hp"]):
			if game.time < su:
				EnemyTrait.note(game, "eye_sermons_broken")
			e.vars["sermon_until"] = 0.0
			Kit.walk(e)
			e.pose = 0
			e.body.queue_redraw()
		return
	if e.hp <= e.max_hp * float(a["change_hp"]):
		e.vars["form"] = 1
		e.vars["change_until"] = game.time + float(a["change_time"])
		Kit.stand(e)
		game.banner("Merrow sheds his robes: THE CHANGE!")
		game.fx.spawn("abyssal_burst", e.position, 160.0, float(a["change_time"]), Acts.data("eye")["LOOK"]["magenta"])
		Sfx.play("boss_telegraph")
		EnemyTrait.note(game, "eye_merrow_changes")
		return
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_sermon"]):
		e.vars["next_sermon"] = game.time + float(a["sermon_every"])
		e.vars["sermon_until"] = game.time + float(a["sermon_time"])
		e.vars["sermon_hp"] = e.hp
		Kit.stand(e)
		e.pose = 1
		e.body.queue_redraw()
		Kit.ring(game, e.position, float(a["sermon_radius"]), float(a["sermon_time"]), false, "", Acts.data("eye")["LOOK"]["magenta"])
		game.banner("The Sermon: the Eye's faithful march faster and harder to hurt")
		EnemyTrait.note(game, "eye_sermons")
		Sfx.play("plague_cast")
		return
	if game.time >= float(e.vars["next_wave"]):
		e.vars["next_wave"] = game.time + float(a["wave_every"])
		var towers: Array[Tower] = []  # Within reach, nearest first.
		for t: Tower in game.towers:
			if t.position.distance_to(e.position) <= float(a["wave_range"]):
				towers.append(t)
		towers.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for i in mini(int(a["wave_count"]), towers.size()):
			game.hostile.shell(towers[i].position, float(a["wave_radius"]), float(a["wave_delay"]), float(a["wave_disable"]), "soaked", float(a["wave_body"]))
			game.fx.spawn("tide_splash", towers[i].position, float(a["wave_radius"]) * 2.4, float(a["wave_delay"]) + 0.3)
		if not towers.is_empty():
			_pose(e, game, a, 1)
			EnemyTrait.note(game, "eye_brine_waves")


func _changed(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var la := float(e.vars["lash_at"])
	if la > 0.0 and game.time >= la:
		e.vars["lash_at"] = 0.0
		if e.holder != null:
			var n := 0  # Bodies struck.
			var far := e.holder.pos  # The line ends at the last body struck.
			for b: BlockBody in e.holder.block.bodies:
				if b.alive and n < int(a["lash_targets"]):
					TdCombat.damage_body(game, b, float(a["lash_damage"]) * e.damage_mult(), e)
					far = b.pos
					n += 1
			Kit.line(game, e.position, far, 0.0, true)
			_pose(e, game, a, 3)
			EnemyTrait.note(game, "eye_limb_lashes")
			Sfx.play("boss_impact")
	var wa := float(e.vars["whirl_at"])
	if wa > 0.0 and game.time >= wa:
		e.vars["whirl_at"] = 0.0
		Kit.walk(e)
		for b: BlockBody in game.bodies_near(e.position, float(a["whirl_radius"])):
			TdCombat.damage_body(game, b, float(a["whirl_damage"]) * e.damage_mult(), e)
		for t: Tower in CovenantField.of(game).towers_near(e.position, float(a["whirl_radius"])):
			TdCombat.disable_tower(game, t, float(a["whirl_disable"]), "grabbed")
		Kit.ring(game, e.position, float(a["whirl_radius"]), 0.4, true, "drowned_tendrils")
		game.vfx.shake(2.5)
		_pose(e, game, a, 3)
		EnemyTrait.note(game, "eye_whirls")
		Sfx.play("boss_impact")
	if la > 0.0 or wa > 0.0 or game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_whirl"]):
		e.vars["next_whirl"] = game.time + float(a["whirl_every"])
		e.vars["whirl_at"] = game.time + float(a["whirl_windup"])
		Kit.stand(e)
		Kit.ring(game, e.position, float(a["whirl_radius"]), float(a["whirl_windup"]), false)
	elif e.holder != null and game.time >= float(e.vars["next_lash"]):
		e.vars["next_lash"] = game.time + float(a["lash_every"])
		e.vars["lash_at"] = game.time + float(a["lash_windup"])
		Kit.line(game, e.position, e.holder.pos, float(a["lash_windup"]), false)


## Shows pose `p` for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary, p: int) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Merrow falls into the surf: the harbour bells fall silent")
