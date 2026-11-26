## Lilith, Queen of the Night (the Palace's boss; Necropathy BossLilith):
##   CHARM WAVE — every `wave_every` s (first after `wave_first`) every living
##     blocker body within `wave_radius` px of her but the one holding her is
##     charmed `wave_time` s and fights its own post at `wave_mult`
##     (TdCombat.charm_body).
##   KISS OF RUIN — every `kiss_every` s (first after `kiss_first`) she blows a
##     kiss at the tower that has dealt the most damage: suppressed to
##     `kiss_mult` of its damage for `kiss_time` s (TdCombat.suppress_tower).
##   BROOD — every `brood_every` s `brood_count` `brood_kind` are born from her
##     wings beside her (`brood_lane` px apart across the road).
##   TRUE FORM — below `demon_hp` of her HP she takes her demon form (pose 2:
##     bosses/lilith_demon): armour +`demon_armour`, hasted x`demon_haste`, and
##     every cooldown above x`demon_rate`.
## Args in her row. vars: "next_wave", "next_kiss", "next_brood", "demon".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_wave"] = game.time + float(a["wave_first"])
	e.vars["next_kiss"] = game.time + float(a["kiss_first"])
	e.vars["next_brood"] = game.time + float(a["brood_every"])
	e.vars["demon"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var lk: Dictionary = Acts.data("inferno")["LOOK"]
	var rate := float(a["demon_rate"]) if bool(e.vars["demon"]) else 1.0  # Cooldown multiplier.
	if not bool(e.vars["demon"]) and e.hp <= e.max_hp * float(a["demon_hp"]):
		e.vars["demon"] = true
		e.pose = 2
		e.armour += float(a["demon_armour"])
		TdCombat.haste_enemy(game, e, float(a["demon_haste"]), 9999.0)
		e.body.queue_redraw()
		game.banner("Lilith casts off her mask: the Mother of Demons in her true form!")
		game.fx.spawn("shadow_blast", e.position, 200.0, 0.7, lk["charm_tint"])
		Sfx.play("lilith_wave")
		EnemyTrait.note(game, "lilith_true_form")
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_wave"]):
		e.vars["next_wave"] = game.time + float(a["wave_every"]) * rate
		var n := 0  # Bodies charmed.
		for b: BlockBody in game.bodies_near(e.position, float(a["wave_radius"])):
			if not b.temporary and b.max_hp != INF and b != e.holder:  # The body holding her keeps her.
				TdCombat.charm_body(game, b, float(a["wave_time"]), float(a["wave_mult"]))
				n += 1
		if game.vfx.on:
			var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["wave_radius"]), 0.6, lk["charm_tint"])
			if ring != null:
				ring.size0 = 20.0
		Sfx.play("lilith_wave")
		EnemyTrait.note(game, "lilith_waves")
		EnemyTrait.note(game, "lilith_wave_bodies", float(n))
	if game.time >= float(e.vars["next_kiss"]) and not game.towers.is_empty():
		e.vars["next_kiss"] = game.time + float(a["kiss_every"]) * rate
		var best: Tower = game.towers[0]  # The tower that hurt her court most.
		for t: Tower in game.towers:
			if t.damage_done > best.damage_done:
				best = t
		TdCombat.suppress_tower(game, best, float(a["kiss_mult"]), float(a["kiss_time"]))
		var f := game.vfx.add(TdVfx.Kind.THREAD, e.position + Vector2(0, -30), float(lk["thread_w"]), 0.5, lk["charm_tint"])
		if f != null:
			f.to = best.position + Vector2(0, -16)
		game.vfx.add(TdVfx.Kind.ANIM, best.position + Vector2(0, -16), float(lk["kiss_d"]), 0.45, lk["charm_tint"], "volley_flash")
		Sfx.play("charm_kiss")
		EnemyTrait.note(game, "lilith_kisses")
	if game.time >= float(e.vars["next_brood"]):
		e.vars["next_brood"] = game.time + float(a["brood_every"]) * rate
		game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
		for k in int(a["brood_count"]):
			game.waves.spawn_extra(String(a["brood_kind"]), e.follower.road.id, e.follower.dist, (float(k) - 1.0) * float(a["brood_lane"]))
		game.extra_hp_mult = 1.0
		EnemyTrait.note(game, "lilith_brood")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Lilith falls: the Queen of the Night is yours")
