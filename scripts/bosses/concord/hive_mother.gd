## The Hive Mother (Crash Site boss; Necropathy's BossHiveMother /
## HiveMotherData). Three phases by HP (`phase_hp`: [phase 2 from, phase 3
## from] as HP shares):
##   the Brood  — every `egg_every` s (first `egg_first`) she rears (pose 1)
##                for `egg_windup` s over two telegraph rings on her road
##                `egg_spread` px ahead, then `eggs` foes of `egg_kind` hatch
##                there (ConcordKit.hatch()).
##   the Burrow — every `dive_every` s (first `dive_first` s into the phase)
##                she DIVES (the Burrower's dig(): unseen, unheld, `under_mult`
##                x faster) for `under` s, then a mound telegraph of
##                `erupt_radius` px shows for `mound` s and she ERUPTS there
##                (pose 3): bodies within it take `erupt_damage`, towers in it
##                are stunned `erupt_disable` s. The Brood goes on.
##   the Flight — she takes to the air (vars "sprite" = `flight_sprite`; no
##                post holds her any more) and every `acid_every` s rains acid
##                on the `acid_targets` towers nearest her: telegraphed shells
##                (game.hostile.shell(): `acid_radius` px, `acid_delay` s,
##                `acid_disable` s, `acid_damage` to bodies).
## Args in her row. vars: "phase", "next_egg", "egg_at", "next_dive",
## "erupt_at" (game s; 0 = none), "erupt_pos" (map px of the mound), "next_acid", "pose_until", the Burrower's
## "burrow_until" / "hidden_until" / "vis_alpha", "sprite".
extends EnemyTrait

const Burrower := preload("res://scripts/enemies/traits/concord/burrower.gd")
const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 1
	e.vars["next_egg"] = game.time + float(a["egg_first"])
	e.vars["egg_at"] = 0.0
	e.vars["next_dive"] = INF
	e.vars["erupt_at"] = 0.0
	e.vars["next_acid"] = INF
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	Burrower.surface(e, game)
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		if ph == 2:
			game.banner("The Hive Mother burrows: watch for the mound!")
			e.vars["next_dive"] = game.time + float(a["dive_first"])
		else:
			game.banner("The Hive Mother takes flight: no post can hold her, acid rains on your towers!")
			e.vars["sprite"] = String(a["flight_sprite"])
			e.vars["next_dive"] = INF
			e.vars["next_acid"] = game.time + 1.0
			e.body.queue_redraw()
		Sfx.play("hive_scream")
	if ph == 3:
		e.unholdable_until = game.time + 1.0
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
	# The eruption under a post.
	var er := float(e.vars["erupt_at"])
	if er > 0.0:
		if game.time >= er:
			e.vars["erupt_at"] = 0.0
			_erupt(e, game, a)
		return
	if game.time < float(e.vars.get("burrow_until", 0.0)):
		if game.time >= float(e.vars["burrow_until"]) - float(a["mound"]):
			e.vars["erupt_at"] = float(e.vars["burrow_until"])
			e.vars["erupt_pos"] = e.position
			Kit.warn(game, e.position, float(a["erupt_radius"]), float(a["mound"]))
		return
	if game.time < e.freeze_until:
		return
	# The Brood.
	var ea := float(e.vars["egg_at"])
	if ea > 0.0 and game.time >= ea:
		e.vars["egg_at"] = 0.0
		var rd := e.follower.road
		var sp: Array = a["egg_spread"]
		var half := int(a["eggs"]) / 2
		Kit.hatch(game, String(a["egg_kind"]), rd, minf(e.follower.dist + float(sp[0]), rd.length - 20.0), half)
		Kit.hatch(game, String(a["egg_kind"]), rd, minf(e.follower.dist + float(sp[1]), rd.length - 20.0), int(a["eggs"]) - half)
		EnemyTrait.note(game, "hive_egg_waves")
	elif ea <= 0.0 and ph < 3 and game.time >= float(e.vars["next_egg"]):
		e.vars["next_egg"] = game.time + float(a["egg_every"])
		e.vars["egg_at"] = game.time + float(a["egg_windup"])
		var rd := e.follower.road
		for d: float in a["egg_spread"]:
			Kit.warn(game, rd.point_at(minf(e.follower.dist + d, rd.length - 20.0)), 34.0, float(a["egg_windup"]))
		_pose(e, game, 1, float(a["egg_windup"]))
	# The Burrow.
	if ph == 2 and game.time >= float(e.vars["next_dive"]):
		e.vars["next_dive"] = game.time + float(a["dive_every"])
		Burrower.dig(e, game, float(a["under"]) + float(a["mound"]), float(a["under_mult"]))
		EnemyTrait.note(game, "hive_dives")
	# The Flight.
	if ph == 3 and game.time >= float(e.vars["next_acid"]):
		e.vars["next_acid"] = game.time + float(a["acid_every"])
		var ts: Array[Tower] = []
		for t: Tower in game.towers:
			if game.time >= t.disabled_until:
				ts.append(t)
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for i in mini(int(a["acid_targets"]), ts.size()):
			game.hostile.shell(ts[i].position, float(a["acid_radius"]), float(a["acid_delay"]), float(a["acid_disable"]), "shelled", float(a["acid_damage"]))
		EnemyTrait.note(game, "hive_acid_rains")
		Sfx.play("acid_spit")


## She bursts out of the ground (see the header).
func _erupt(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := float(a["erupt_radius"])  # Px.
	var at: Vector2 = e.vars.get("erupt_pos", e.position)  # Where the mound showed.
	for b: BlockBody in game.bodies_near(at, r):
		TdCombat.damage_body(game, b, float(a["erupt_damage"]) * e.damage_mult(), e)
	for t: Tower in game.towers:
		if t.position.distance_to(at) <= r:
			TdCombat.disable_tower(game, t, float(a["erupt_disable"]), "trampled")
	Kit.burst(game, at, r, Color(0.75, 0.6, 0.4), "structure_break")
	_pose(e, game, 3, float(a["pose_time"]))
	EnemyTrait.note(game, "hive_eruptions")
	Sfx.play("burrow_rumble")


## Shows pose `p` for `time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, p: int, time: float) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + time
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Hive Mother falls: the Brood is leaderless")
