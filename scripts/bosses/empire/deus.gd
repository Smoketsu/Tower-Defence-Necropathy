## Deus Ex Machina, with Varn, the Root User (Iron Citadel boss, the act's last;
## Necropathy's BossDeusExMachina: "a walking fortress with the Empire's
## founder wired into its core"). Three phases by HP:
##   The Walker     (100% -> `siege_hp`): it strides down the road. The CHAINGUN
##                  every `chain_every` s sprays `chain_count` straight shots
##                  (`chain_shot`) across the working towers within `chain_range`
##                  px (posts in the line stop them); the MISSILE SALVO every
##                  `salvo_every` s paints `salvo_locks` towers within
##                  `salvo_range` px at once (Lock-On, boss override) and fires
##                  `missile` down each line; FOOTFALLS: held at a post, every
##                  `stomp_every` s every body of it takes `stomp_damage`.
##   The Siege Core (-> `founder_hp`): it PLANTS where it stands (sprite
##                  bosses/deus_ex_machina_siege, speed 0) and raises
##                  `drones` Shield Drones (`drone_kind`, flyers that hover by it):
##                  while one flies the core takes no damage; all shot down, it is
##                  exposed `exposed_time` s, then raises them again. The JUDGMENT
##                  LANCE every `lance_every` s paints the farthest tower within
##                  `lance_range` px (a heavy `lance` shot: a post in the line takes
##                  it). HANGAR DOORS every `hangar_every` s release `hangar` kinds at
##                  the entrances.
##   The Founder    (-> 0): the core cracks and Varn takes the frame (sprite
##                  bosses/deus_ex_machina_founder); it walks again (`founder_speed`
##                  x its speed). OVERLOAD PULSES every `pulse_every` s disable every
##                  tower within a radius that grows each pulse (`pulse_r0` +
##                  `pulse_grow` per pulse, at most `pulse_max`) for `pulse_disable`
##                  s; every `tp_every` s it TELEPORTS `tp_dist` px down the road (free
##                  of any post) and fires everything at once (`chain_count` shots).
## Pose 1 (cannons blazing) as the Walker fires. Args in its row. vars: "phase",
## "next_chain", "next_salvo", "next_stomp", "next_lance", "next_hangar",
## "next_pulse", "pulses", "next_tp", "exposed_until", "base_speed", "pose_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["phase"] = 1
	e.vars["next_chain"] = game.time + float(a["chain_first"])
	e.vars["next_salvo"] = game.time + float(a["salvo_first"])
	e.vars["next_stomp"] = 0.0
	e.vars["next_lance"] = 0.0
	e.vars["next_hangar"] = 0.0
	e.vars["next_pulse"] = 0.0
	e.vars["pulses"] = 0
	e.vars["next_tp"] = 0.0
	e.vars["exposed_until"] = 0.0
	e.vars["base_speed"] = e.speed
	e.vars["pose_until"] = 0.0


## Live Shield Drones of this run.
static func drones_alive(e: TdEnemy, game: TdGame) -> int:
	var n := 0  # Drones flying.
	for o: TdEnemy in game.enemies:
		n += 1 if o.alive and o.kind == String(e.row["args"]["drone_kind"]) else 0
	return n


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if int(e.vars.get("phase", 1)) == 2 and drones_alive(e, game) > 0:
		EnemyTrait.note(game, "deus_shielded_hits")
		return 0.0
	return amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var ph := int(e.vars["phase"])  # Phase now.
	if ph == 1 and e.hp <= e.max_hp * float(a["siege_hp"]):
		ph = 2
		e.vars["phase"] = 2
		e.vars["sprite"] = "bosses/deus_ex_machina_siege"
		e.speed = 0.0
		e.vars["exposed_until"] = 0.0
		e.vars["next_lance"] = game.time + 2.0
		e.vars["next_hangar"] = game.time + 4.0
		_raise_drones(e, game)
		game.banner("SIEGE CORE: Deus Ex Machina plants itself. Shoot down its Shield Drones!")
		Sfx.play("deus_transform")
		e.body.queue_redraw()
		EnemyTrait.note(game, "deus_phases")
	elif ph == 2 and e.hp <= e.max_hp * float(a["founder_hp"]):
		ph = 3
		e.vars["phase"] = 3
		e.vars["sprite"] = "bosses/deus_ex_machina_founder"
		e.speed = float(e.vars["base_speed"]) * float(a["founder_speed"])
		e.vars["next_pulse"] = game.time + 2.0
		e.vars["next_tp"] = game.time + float(a["tp_every"])
		game.banner("THE FOUNDER: the core cracks open. Varn, the Root User, takes the machine!")
		Sfx.play("deus_transform")
		e.body.queue_redraw()
		EnemyTrait.note(game, "deus_phases")
	if e.pose == 1 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time < e.freeze_until:
		return
	match ph:
		1:
			_walker(e, game, a)
		2:
			_siege(e, game, a)
		3:
			_founder(e, game, a)


## The chaingun: `chain_count` shots across the nearest working towers.
func _chaingun(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ts := Kit.towers_near(game, e.position, float(a["chain_range"]))  # Towers in reach.
	for i in int(a["chain_count"]) if not ts.is_empty() else 0:
		Kit.fire_at(game, e, ts[i % ts.size()], a["chain_shot"])
	if not ts.is_empty():
		Sfx.play("chaingun")
		EnemyTrait.note(game, "deus_chainguns")


func _walker(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if e.holder != null and game.time >= float(e.vars["next_stomp"]):
		e.vars["next_stomp"] = game.time + float(a["stomp_every"])
		var post := e.holder  # The body holding it (it may fall below).
		for b: BlockBody in post.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["stomp_damage"]) * e.damage_mult(), e)
		game.vfx.add(TdVfx.Kind.ANIM, post.pos, 110.0, 0.45, Color(1.0, 0.75, 0.4), "golem_slam")
		game.vfx.shake(3.0)
	if game.time < e.staggered_until:
		return
	if game.time >= float(e.vars["next_chain"]):
		e.vars["next_chain"] = game.time + float(a["chain_every"])
		_chaingun(e, game, a)
		e.pose = 1
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		e.body.queue_redraw()
	if game.time >= float(e.vars["next_salvo"]):
		var ts := Kit.towers_near(game, e.position, float(a["salvo_range"]))  # Towers in reach.
		if ts.is_empty():
			return
		e.vars["next_salvo"] = game.time + float(a["salvo_every"])
		for t: Tower in ts.slice(0, int(a["salvo_locks"])):
			Kit.lock(game, e, t, a["missile"], true)
		Sfx.play("missile_lock")
		EnemyTrait.note(game, "deus_salvos")


## Raises the Shield Drones round the planted core.
func _raise_drones(e: TdEnemy, game: TdGame) -> void:
	var r := e.follower.road  # Its road.
	for i in int(a_of(e)["drones"]):
		var d := clampf(e.follower.dist + float(i - 1) * 30.0, 0.0, r.length - 1.0)  # Beside it.
		game.waves.spawn_extra(String(a_of(e)["drone_kind"]), r.id, d, float(i % 2 * 2 - 1) * 34.0)
	EnemyTrait.note(game, "deus_drone_waves")


## Its args row.
static func a_of(e: TdEnemy) -> Dictionary:
	return e.row["args"]


func _siege(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if drones_alive(e, game) == 0:
		if float(e.vars["exposed_until"]) <= 0.0:
			e.vars["exposed_until"] = game.time + float(a["exposed_time"])
			game.banner("The Siege Core is exposed!")
			Sfx.play("shield_break")
		elif game.time >= float(e.vars["exposed_until"]):
			e.vars["exposed_until"] = 0.0
			_raise_drones(e, game)
	if game.time >= float(e.vars["next_lance"]):
		var ts := Kit.towers_near(game, e.position, float(a["lance_range"]))  # Towers in reach.
		if not ts.is_empty():
			e.vars["next_lance"] = game.time + float(a["lance_every"])
			Kit.lock(game, e, ts[ts.size() - 1], a["lance"], true)
			Sfx.play("lance_charge")
			EnemyTrait.note(game, "deus_lances")
	if game.time >= float(e.vars["next_hangar"]):
		e.vars["next_hangar"] = game.time + float(a["hangar_every"])
		var ents: Array[String] = []  # Entrance roads, sorted for a stable order.
		for id: String in game.roads:
			var rd: Road = game.roads[id]
			if rd.entrance and not rd.off_road:
				ents.append(id)
		ents.sort()
		var i := 0  # Spawned so far.
		for k: String in a["hangar"]:
			game.waves.spawn_extra(k, ents[i % ents.size()], 20.0 + float(i) * 16.0, 0.0)
			i += 1
		game.banner("Hangar doors open: the Citadel sends its last soldiers")
		Sfx.play("hangar_open")
		EnemyTrait.note(game, "deus_hangars")


func _founder(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if game.time >= float(e.vars["next_pulse"]):
		e.vars["next_pulse"] = game.time + float(a["pulse_every"])
		var r := minf(float(a["pulse_r0"]) + float(a["pulse_grow"]) * float(e.vars["pulses"]), float(a["pulse_max"]))  # Px this pulse.
		e.vars["pulses"] = int(e.vars["pulses"]) + 1
		for t: Tower in Kit.towers_near(game, e.position, r, true):
			TdCombat.disable_tower(game, t, float(a["pulse_disable"]), "jammed")
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, r, TdVfxData.RING_TIME * 1.5, Acts.data("empire")["LOOK"]["pulse_tint"])
		if ring != null:
			ring.size0 = r * 0.2
		game.vfx.shake(3.0)
		Sfx.play("overload_pulse")
		EnemyTrait.note(game, "deus_pulses")
	if game.time >= float(e.vars["next_tp"]) and game.time >= e.staggered_until:
		e.vars["next_tp"] = game.time + float(a["tp_every"])
		var room := e.follower.road.length - e.follower.dist - float(a["tp_keep"])  # Px it may jump without reaching the gate.
		if e.follower.road.next_id != "" or room > 0.0:
			game.fx.spawn("summon_rise", e.position, 120.0, 0.4, Acts.data("empire")["LOOK"]["pulse_tint"])
			if e.holder != null:
				e.holder.held.erase(e)
				e.holder = null
			e.follower.advance(minf(float(a["tp_dist"]), room) if e.follower.road.next_id == "" else float(a["tp_dist"]))
			e.position = e.follower.position()
			game.fx.spawn("summon_rise", e.position, 120.0, 0.4, Acts.data("empire")["LOOK"]["pulse_tint"])
			Sfx.play("teleport_land")
			EnemyTrait.note(game, "deus_teleports")
		_chaingun(e, game, a)


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Nothing is deathless. Everything is mine.")
	Sfx.play("deus_fall")
