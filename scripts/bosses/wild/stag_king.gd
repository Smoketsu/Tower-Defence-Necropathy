## The Stag King (Greenwood boss; Necropathy's BossStagKing). Three phases by
## HP (`phase_hp`: [phase 2 from, phase 3 from] as HP shares); each phase keeps
## the attacks of the ones before it:
##   the Hunt        — every `hunt_every` s (first after `hunt_first`) he raises
##                     the horn (pose 1) and the Wild Hunt rides in behind him:
##                     squad `hunt` (rows of [kind, count]) `gap` px apart
##                     (WildKit.call_squad).
##   the Rut         — phase 2: every `rut_every` s (first `rut_first` s into
##                     the phase) he lowers his antlers for `rut_windup` s (a
##                     line along the road), then charges `rut_speed` x for
##                     `rut_time` s through the posts, striking each post's
##                     bodies for `rut_damage` (WildKit's charge).
##   the Antler Crown — phase 3: every `crown_every` s (first `crown_first` s
##                     into the phase) a crown of thorns rises round him after
##                     `crown_windup` s: every tower within `crown_radius` px is
##                     choked `crown_choke` s (TdCombat.disable_tower, cause
##                     "choked") and `crown_seeds` thickets sprout on the nearest
##                     built spots there (the act rule's plant(): tap to burn).
## Not while frozen. Args in his row. vars: "phase", "next_hunt", "next_rut",
## "rut_at", "next_crown", "crown_at", "pose_until" (game s), WildKit's charge vars.
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["phase"] = 1
	e.vars["next_hunt"] = game.time + float(a["hunt_first"])
	e.vars["next_rut"] = INF
	e.vars["rut_at"] = 0.0
	e.vars["next_crown"] = INF
	e.vars["crown_at"] = 0.0
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	Kit.charge_step(e, game, float(a["rut_damage"]))
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		if ph == 2:
			e.vars["next_rut"] = game.time + float(a["rut_first"])
			game.banner("The Rut: the Stag King charges through your posts!")
		else:
			e.vars["next_crown"] = game.time + float(a["crown_first"])
			game.banner("The Antler Crown: thorns rise round the Stag King and choke your towers!")
		EnemyTrait.note(game, "stag_king_phases")
	if float(e.vars["rut_at"]) > 0.0 and game.time >= float(e.vars["rut_at"]):
		e.vars["rut_at"] = 0.0
		Kit.start_charge(e, game, float(a["rut_speed"]), float(a["rut_time"]))
		EnemyTrait.note(game, "stag_king_ruts")
		Sfx.play("roots_grab", e.position, 0.6)
	if float(e.vars["crown_at"]) > 0.0 and game.time >= float(e.vars["crown_at"]):
		e.vars["crown_at"] = 0.0
		_crown(e, game, a)
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_hunt"]):
		e.vars["next_hunt"] = game.time + float(a["hunt_every"])
		Kit.call_squad(e, game, a["hunt"], float(a["gap"]))
		Kit.ring(game, e.position, 90.0, 0.5, Kit.lk()["horn_tint"], true)
		game.fx.spawn("volley_flash", e.position, 110.0, 0.5, Kit.lk()["horn_tint"])
		game.banner("The Hunt rides: the Stag King sounds his horn")
		_pose(e, game, a)
		EnemyTrait.note(game, "stag_king_hunts")
		Sfx.play("spring_horn")
	if game.time >= float(e.vars["next_rut"]) and float(e.vars["rut_at"]) <= 0.0:
		e.vars["next_rut"] = game.time + float(a["rut_every"])
		e.vars["rut_at"] = game.time + float(a["rut_windup"])
		Kit.charge_line(e, game, float(a["rut_windup"]))
	if game.time >= float(e.vars["next_crown"]) and float(e.vars["crown_at"]) <= 0.0:
		e.vars["next_crown"] = game.time + float(a["crown_every"])
		e.vars["crown_at"] = game.time + float(a["crown_windup"])
		Kit.ring(game, e.position, float(a["crown_radius"]), float(a["crown_windup"]), Kit.lk()["warn_tint"], false)
		_pose(e, game, a)


## The Antler Crown lands (see the header).
func _crown(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	Kit.stop_towers(game, e.position, float(a["crown_radius"]), float(a["crown_choke"]), "choked", false)
	Kit.plant_near(game, e.position, float(a["crown_radius"]), int(a["crown_seeds"]), 0.5)
	Kit.ring(game, e.position, float(a["crown_radius"]), 0.5, Kit.lk()["warn_tint"], true)
	game.fx.spawn("wild_bury", e.position, float(a["crown_radius"]) * 1.6, 0.6, Kit.lk()["root_tint"])
	game.vfx.shake(1.5)
	EnemyTrait.note(game, "stag_king_crowns")
	Sfx.play("thicket_grow")


## Shows the horn raised for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Stag King falls: the Greenwood is silent")
