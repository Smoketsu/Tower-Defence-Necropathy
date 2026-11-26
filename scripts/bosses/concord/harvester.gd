## The Harvester (Ark boss, the act's finale; Necropathy's BossHarvester /
## HarvesterData). Three phases:
##   the Council  — (100% to `reaping_hp` of its HP) every `council_turn` s
##                  (first `council_first`) one of the Concord's powers, in turn:
##                  the Brood's swarm (`swarm` foes of `swarm_kind` hatch just
##                  ahead, ConcordKit.hatch()), the Vrask cloak (`cloak_time` s
##                  cloaked while it walks, cloak.gd, `cloak_speed` x faster) and
##                  the Luminous beams (`beams` beams at the towers nearest it
##                  within `beam_range` px through game.hostile.fire(), each
##                  blinding `beam_disable` s; a blocker body in the way stops one).
##   the Reaping  — at `reaping_hp` it rises IMMUNE and stands; `emitters` reap
##                  emitters (concord_reap_emitter, structures with the
##                  saucer's beam standing still) land on its road
##                  `emitter_ahead` px ahead, `emitter_lane` px either side, and
##                  lift the posts and towers near them. It ends when all of
##                  them fall, or after `reaping_max` s (the rest crumble).
##   the Gardener — its true form (vars "sprite" = `true_sprite`), walking
##                  `gardener_speed` x faster; every `gardener_every` s it calls
##                  a flight of `gardener_saucers` saucers (Abduction.call_saucers()).
## Args in its row. vars: "phase", "next_turn", "turn", "cloak_end",
## "emitters" ([TdEnemy, generation]), "reap_end", "next_flight", "base_speed",
## "pose_until", cloak.gd's "cloak_until" / "vis_alpha".
extends EnemyTrait

const Cloak := preload("res://scripts/enemies/traits/concord/cloak.gd")
const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")
const Abduction := preload("res://scripts/maps/rules/concord/abduction.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["phase"] = 1
	e.vars["next_turn"] = game.time + float(a["council_first"])
	e.vars["turn"] = 0
	e.vars["cloak_end"] = 0.0
	e.vars["emitters"] = []
	e.vars["reap_end"] = 0.0
	e.vars["next_flight"] = INF
	e.vars["pose_until"] = 0.0
	e.vars["revealed_until"] = 0.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if int(e.vars.get("phase", 1)) == 2:
		EnemyTrait.note(game, "harvester_immune_hits")
		return 0.0
	return amount


func on_hit(e: TdEnemy, game: TdGame, _amount: float, hit: Dictionary) -> void:
	Cloak.reveal_on_spell(e, game, hit, 2.0)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and int(e.vars["phase"]) != 2:
		e.pose = 0
		e.body.queue_redraw()
	var ph := int(e.vars["phase"])
	if ph == 1:
		Cloak.cloaked(e, game, float(a["cloak_alpha"]), game.time < float(e.vars["cloak_end"]))
		if e.hp <= e.max_hp * float(a["reaping_hp"]):
			_reap(e, game, a)
			return
		if game.time >= float(e.vars["next_turn"]) and game.time >= e.freeze_until:
			e.vars["next_turn"] = game.time + float(a["council_turn"])
			_council(e, game, a, int(e.vars["turn"]) % 3)
			e.vars["turn"] = int(e.vars["turn"]) + 1
	elif ph == 2:
		var live := 0  # Emitters standing.
		for m: Array in e.vars["emitters"]:
			live += 1 if TdEnemy.valid(m[0], int(m[1])) else 0
		if live == 0 or game.time >= float(e.vars["reap_end"]):
			_garden(e, game, a)
	elif game.time >= float(e.vars["next_flight"]):
		e.vars["next_flight"] = game.time + float(a["gardener_every"])
		var rule := Abduction.of(game)
		if rule != null:
			rule.call("call_saucers", int(a["gardener_saucers"]))
			EnemyTrait.note(game, "harvester_flights")


## One power of the Council (0 swarm, 1 cloak, 2 beams).
func _council(e: TdEnemy, game: TdGame, a: Dictionary, which: int) -> void:
	match which:
		0:
			var rd := e.follower.road
			Kit.hatch(game, String(a["swarm_kind"]), rd, minf(e.follower.dist + 50.0, rd.length - 20.0), int(a["swarm"]))
			EnemyTrait.note(game, "council_swarms")
		1:
			e.vars["cloak_end"] = game.time + float(a["cloak_time"])
			TdCombat.haste_enemy(game, e, float(a["cloak_speed"]), float(a["cloak_time"]))
			EnemyTrait.note(game, "council_cloaks")
		_:
			var ts: Array[Tower] = []
			for t: Tower in game.towers:
				if t.position.distance_to(e.position) <= float(a["beam_range"]):
					ts.append(t)
			ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
			for i in mini(int(a["beams"]), ts.size()):
				game.hostile.fire(e.position + Vector2(0, -30), ts[i], {"disable": float(a["beam_disable"]), "cause": "blinded", "look": "lumen", "speed": 600.0})
			EnemyTrait.note(game, "council_beams")
			Sfx.play("beam_fire")
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


## The Reaping begins (see the header).
func _reap(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.vars["phase"] = 2
	e.vars["cloak_end"] = 0.0
	Cloak.cloaked(e, game, 1.0, false)
	e.vars["base_speed"] = e.speed
	e.speed = 0.0
	e.vars["reap_end"] = game.time + float(a["reaping_max"])
	var rd := e.follower.road
	var ems: Array = []
	game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
	var ahead: Array = a["emitter_ahead"]
	for i in mini(int(a["emitters"]), ahead.size()):
		var d := minf(e.follower.dist + float(ahead[i]), rd.length - 30.0)  # Where it lands.
		var m := game.waves.spawn_extra("concord_reap_emitter", rd.id, d, float(a["emitter_lane"]) * (1.0 if i % 2 == 0 else -1.0))
		ems.append([m, m.generation])
		Kit.burst(game, m.position, 40.0, Acts.data("concord")["LOOK"]["plasma"], "beam_hit")
	game.extra_hp_mult = 1.0
	e.vars["emitters"] = ems
	e.pose = 1
	e.body.queue_redraw()
	game.banner("The Reaping: the Harvester is immune while its emitters lift your dead. Break them!")
	EnemyTrait.note(game, "harvester_reapings")
	Sfx.play("harvest_eye")


## The Gardener (see the header).
func _garden(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	for m: Array in e.vars["emitters"]:
		if TdEnemy.valid(m[0], int(m[1])):
			game.fx.spawn("structure_break", (m[0] as TdEnemy).position, 60.0, 0.4)
			game.remove_enemy(m[0], false)
	e.vars["emitters"] = []
	e.vars["phase"] = 3
	e.speed = float(e.vars["base_speed"])
	e.vars["sprite"] = String(a["true_sprite"])
	e.pose = 0
	TdCombat.haste_enemy(game, e, float(a["gardener_speed"]), 600.0)
	e.vars["next_flight"] = game.time + 2.0
	e.body.queue_redraw()
	game.banner("The Gardener: the Harvester shows its true form and calls the saucers!")
	Sfx.play("hive_scream")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Harvester falls: the Concord's reaping ends")
