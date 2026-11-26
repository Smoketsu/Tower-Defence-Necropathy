## The Morning Star (Pandemonium's boss, the campaign's last; Necropathy
## BossMorningStar), in two phases:
##   THE ANGEL (HP above `beast_hp`): every `beam_every` s (first after
##     `beam_first`) a beam of light falls on his road `beam_ahead` px ahead:
##     every tower within `beam_radius` px is suppressed to `beam_mult` for
##     `beam_time` s (TdCombat.suppress_tower; the light zone drawn), and a
##     beam of dark blinds the strongest tower in it `dark_disable` s
##     (TdCombat.disable_tower, cause "blinded"); while a post holds him,
##     every `sword_every` s his burning sword cuts every body of it for
##     `sword_damage`.
##   THE BEAST (below): the throne-skull form (pose 2: bosses/morning_star_beast),
##     armour +`beast_armour`, speed x`beast_speed`, his first slam
##     `beast_first` s after the change; every `slam_every` s he
##     slams every body of the post holding him for `slam_damage` and the
##     ground turns to pits around him (`slam_pits` Hell Pits `slam_gap` px
##     apart along his road, the act rule's open_pit()); every `portal_every`
##     s a portal tears open `portal_back` px behind him (the act rule's
##     open_portal(): `portal_squad` every `portal_squad_every` s, `portal_squads`).
## Args in his row. vars: "next_beam", "next_sword", "next_slam", "next_portal", "beast".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_beam"] = game.time + float(a["beam_first"])
	e.vars["next_sword"] = game.time + float(a["sword_every"])
	e.vars["next_slam"] = 0.0
	e.vars["next_portal"] = 0.0
	e.vars["beast"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var lk: Dictionary = Acts.data("inferno")["LOOK"]
	if not bool(e.vars["beast"]) and e.hp <= e.max_hp * float(a["beast_hp"]):
		e.vars["beast"] = true
		e.pose = 2
		e.armour += float(a["beast_armour"])
		e.speed *= float(a["beast_speed"])
		e.vars["next_slam"] = game.time + float(a["beast_first"])
		e.vars["next_portal"] = game.time + float(a["beast_first"]) * 1.5
		e.body.queue_redraw()
		game.banner("The Angel falls and the Beast rises: the throne itself fights!")
		game.fx.spawn("shadow_blast", e.position, 240.0, 0.8, lk["fire_tint"])
		game.vfx.shake(5.0)
		EnemyTrait.note(game, "morning_star_beast")
	if game.time < e.freeze_until:
		return
	if not bool(e.vars["beast"]):
		_angel(e, game, a, lk)
	else:
		_beast(e, game, a, lk)


## The Angel's beams and sword.
func _angel(e: TdEnemy, game: TdGame, a: Dictionary, lk: Dictionary) -> void:
	if game.time >= float(e.vars["next_beam"]):
		e.vars["next_beam"] = game.time + float(a["beam_every"])
		var r := e.follower.road  # His road.
		var p := r.point_at(minf(e.follower.dist + float(a["beam_ahead"]), r.length))  # Where the light falls.
		var rad := float(a["beam_radius"])  # Px.
		var field := CovenantField.of(game)  # Draws the light zone.
		var strongest: Tower = null  # The dark beam's mark.
		for t: Tower in field.towers_near(p, rad):
			TdCombat.suppress_tower(game, t, float(a["beam_mult"]), float(a["beam_time"]))
			if strongest == null or t.damage_done > strongest.damage_done:
				strongest = t
		field.add_zone(p, rad, game.time + float(a["beam_time"]), lk["beam_light"])
		game.fx.spawn("holy_impact", p, rad * 2.0, 0.6)
		if strongest != null:
			TdCombat.disable_tower(game, strongest, float(a["dark_disable"]), "blinded")
			game.fx.spawn("shadow_blast", strongest.position, 90.0, 0.5)
		EnemyTrait.note(game, "morning_star_beams")
	if e.holder != null and game.time >= float(e.vars["next_sword"]):
		e.vars["next_sword"] = game.time + float(a["sword_every"])
		for b: BlockBody in Kit.post_bodies(e):
			TdCombat.damage_body(game, b, float(a["sword_damage"]) * e.damage_mult(), e)
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["sweep_d"]) * 1.4, 0.45, lk["fire_tint"], "vael_cleave")
		EnemyTrait.note(game, "morning_star_swords")


## The Beast's slams, pits and portals.
func _beast(e: TdEnemy, game: TdGame, a: Dictionary, lk: Dictionary) -> void:
	var r := e.follower.road  # His road.
	if game.time >= float(e.vars["next_slam"]):
		e.vars["next_slam"] = game.time + float(a["slam_every"])
		for b: BlockBody in Kit.post_bodies(e):
			TdCombat.damage_body(game, b, float(a["slam_damage"]) * e.damage_mult(), e)
		for k in int(a["slam_pits"]):
			var d := e.follower.dist + float(a["slam_gap"]) * (float(k) - float(int(a["slam_pits"]) - 1) * 0.5)  # Around him.
			if d > 0.0 and d < r.length:
				Kit.pit(game, r.point_at(d), float(a["pit_radius"]), float(a["pit_life"]), float(a["pit_telegraph"]))
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["slam_d"]) * 1.5, 0.5, lk["fire_tint"], "golem_slam")
		game.vfx.add(TdVfx.Kind.CRACK, e.position, 1.6, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.shake(4.0)
		Sfx.play("brute_slam")
		EnemyTrait.note(game, "morning_star_slams")
	if game.time >= float(e.vars["next_portal"]) and Kit.rule(game) != null:
		e.vars["next_portal"] = game.time + float(a["portal_every"])
		var at := r.point_at(maxf(e.follower.dist - float(a["portal_back"]), 0.0))  # Behind him.
		Kit.rule(game).call("open_portal", at, a["portal_squad"], float(a["portal_squad_every"]), int(a["portal_squads"]))
		EnemyTrait.note(game, "morning_star_portals")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Morning Star falls: the throne of hell is yours")
