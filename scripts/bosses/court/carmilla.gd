## Queen Carmilla and the Elder (Castle Sanguis' boss, the Court's finale;
## Necropathy BossCarmilla), road version. One body, five steps (vars "phase"):
##   1 THE COURT (her HP down to `waking_hp`): `noble_count` `noble_kind` step
##     out behind her on arrival and every `noble_every` s (at most `noble_max`
##     of hers alive). THE MIST DANCE every `mist_every` s (first after
##     `mist_first`): she turns to mist for `mist_time` s (vars "mist_until":
##     unseen, no damage), breaks free and dances `mist_jump` px down the road;
##     every blocker body within `mist_reach` px of where she left and where she
##     reforms is drained for `mist_damage` (she heals `mist_feed` of it).
##   2 THE WAKING: she kneels where she stands (immune, unholdable) for up to
##     `waking_time` s; her bar becomes THE ELDER'S (`elder_hp` x her HP
##     multiplier), starting at `elder_floor` of it and filling `feed_rate` of
##     it per s while she feeds; every `bearer_every` s `bearer_count`
##     `bearer_kind` start `bearer_back` px behind her and walk to her: each that
##     reaches her pours `bearer_heal` of it (pour()). A freeze, a stagger or a
##     silence on her stops the feeding meanwhile; kill the bearers.
##   3 THE VAMPIRE LORD (the Elder's first form, `elder_sprite`): `elder_speed`,
##     `elder_damage`, `elder_radius`; every `lunge_every` s a blood-blade lunge:
##     he leaps `lunge_jump` px and cuts every body within `lunge_reach` px for
##     `lunge_damage`.
##   4 THE TRANSFORMATION (at `horror_at` of the HP he rose with): `change_time` s immune and
##     still (pose 2), then
##   5 THE BAT-WINGED HORROR (`horror_sprite`, `horror_radius`, `horror_speed`,
##     `horror_damage`): every `command_every` s `command_bats` `bat_kind` burst
##     from his wings; every `buffet_every` s his wings strike every body within
##     `buffet_radius` px for `buffet_damage` and stun every tower within
##     `buffet_tower_r` px for `buffet_disable` s; his blows feed him
##     `horror_feed` of them.
## Args in the act data file's "carmilla" row. vars: "phase", "next_mist",
## "next_noble", "mist_until", "wake_until", "next_bearer", "next_lunge",
## "change_until", "next_command", "next_buffet", "pose_until" (game s),
## "nobles" ([[TdEnemy, gen]]), "rose_hp" (the Elder's HP when he rose).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	for k: String in ["mist_until", "wake_until", "next_bearer", "next_lunge", "change_until", "next_command", "next_buffet", "pose_until"]:
		e.vars[k] = 0.0
	e.vars["phase"] = 1
	e.vars["rose_hp"] = 0.0
	e.vars["next_mist"] = game.time + float(a["mist_first"])
	e.vars["next_noble"] = game.time + float(a["noble_every"])
	e.vars["nobles"] = []
	_nobles(e, game, int(a["noble_count"]))


## Calls up to `n` nobles behind her (never more than noble_max of hers alive).
func _nobles(e: TdEnemy, game: TdGame, n: int) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var live: Array = []  # Her nobles still standing.
	for pair: Array in e.vars["nobles"]:
		if TdEnemy.valid(pair[0], int(pair[1])):
			live.append(pair)
	var k := mini(n, int(a["noble_max"]) - live.size())  # How many step out.
	if k > 0:
		for o: TdEnemy in CourtKit.call_out(game, e, String(a["noble_kind"]), k, float(a["noble_gap"])):
			live.append([o, o.generation])
	e.vars["nobles"] = live


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	var ph := int(e.vars["phase"])  # Phase now.
	if ph == 2 or ph == 4 or game.time < float(e.vars["mist_until"]):
		return 0.0
	return amount


func on_hit(e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var ph := int(e.vars["phase"])  # Phase now.
	if ph == 1 and e.hp <= e.max_hp * float(a["waking_hp"]):
		_wake(e, game)
	elif ph == 3 and e.hp <= float(e.vars["rose_hp"]) * float(a["horror_at"]):
		e.vars["phase"] = 4
		e.vars["change_until"] = game.time + float(a["change_time"])
		e.speed = 0.0
		_pose(e, game, 2, float(a["change_time"]))
		game.banner("The Elder's skin splits: the Bat-Winged Horror!")
		game.fx.spawn("boss_death", e.position, 160.0, 0.8, Color(1.0, 0.4, 0.4))
		EnemyTrait.note(game, "elder_transforms")


## Phase 2: she kneels and feeds the Elder; the bar becomes his.
func _wake(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var mult := e.max_hp / float(e.row["hp"])  # Her difficulty / wave HP multiplier.
	e.vars["phase"] = 2
	e.vars["wake_until"] = game.time + float(a["waking_time"])
	e.vars["next_bearer"] = game.time
	e.speed = 0.0
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = INF
	e.max_hp = float(a["elder_hp"]) * mult
	e.hp = e.max_hp * float(a["elder_floor"])
	e.queue_redraw()
	_pose(e, game, 1, float(a["waking_time"]))
	CourtKit.mark(game, e.position, 70.0, float(a["waking_time"]), CourtKit.tint("pool_tint"))
	game.banner("Carmilla kneels to wake the Elder: kill her Blood Bearers")
	EnemyTrait.note(game, "carmilla_waking")


## A Blood Bearer reached her: the Elder gains its share. True when it poured.
func pour(e: TdEnemy, game: TdGame) -> bool:
	if int(e.vars["phase"]) != 2:
		return false
	TdCombat.heal_enemy(game, e, e.max_hp * float(e.row["args"]["bearer_heal"]))
	EnemyTrait.note(game, "bearers_poured")
	return true


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	match int(e.vars["phase"]):
		1: _court(e, game, a)
		2: _waking(e, game, a, dt)
		3: _lord(e, game, a)
		4:
			if game.time >= float(e.vars["change_until"]):
				_become(e, String(a["horror_sprite"]), float(a["horror_radius"]), float(a["horror_speed"]), float(a["horror_damage"]))
				e.vars["phase"] = 5
				e.vars["next_command"] = game.time
				e.vars["next_buffet"] = game.time + float(a["buffet_every"]) * 0.5
		5: _horror(e, game, a)


## Phase 1: the mist dance and her nobles.
func _court(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if game.time >= float(e.vars["next_noble"]):
		e.vars["next_noble"] = game.time + float(a["noble_every"])
		_nobles(e, game, int(a["noble_count"]))
	if game.time < e.freeze_until or game.time < float(e.vars["next_mist"]):
		return
	e.vars["next_mist"] = game.time + float(a["mist_every"])
	e.vars["mist_until"] = game.time + float(a["mist_time"])
	e.unholdable_until = e.vars["mist_until"]
	var from := e.position  # Where she dissolved.
	_drain(e, game, from, a)
	if CourtKit.lunge(e, game, float(a["mist_jump"])) > 0.0:
		_drain(e, game, e.position, a)
	CourtKit.mark(game, e.position, float(a["mist_reach"]), float(a["mist_time"]), CourtKit.tint("mark_tint"))
	EnemyTrait.note(game, "carmilla_mists")


## The mist dance drains every body within mist_reach px of `at`.
func _drain(e: TdEnemy, game: TdGame, at: Vector2, a: Dictionary) -> void:
	for b: BlockBody in game.bodies_near(at, float(a["mist_reach"])):
		CourtKit.bite(game, e, b, float(a["mist_damage"]), float(a["mist_feed"]))


## Phase 2: feeding (unless interrupted) and the bearers; ends in the Vampire Lord.
func _waking(e: TdEnemy, game: TdGame, a: Dictionary, dt: float) -> void:
	var hushed := game.time < e.freeze_until or game.time < e.staggered_until or not EnemyTrait.can_heal(e, game)  # Interrupted.
	if not hushed:
		TdCombat.heal_enemy(game, e, e.max_hp * float(a["feed_rate"]) * dt)
	if game.time >= float(e.vars["next_bearer"]):
		e.vars["next_bearer"] = game.time + float(a["bearer_every"])
		for i in int(a["bearer_count"]):
			game.waves.spawn_extra(String(a["bearer_kind"]), e.follower.road.id, maxf(e.follower.dist - float(a["bearer_back"]) - 20.0 * float(i), 0.0), float(i % 3 - 1) * 9.0)
	if game.time < float(e.vars["wake_until"]) and e.hp < e.max_hp:
		return
	e.vars["phase"] = 3
	e.vars["rose_hp"] = e.hp
	e.unholdable_until = 0.0
	e.vars["next_lunge"] = game.time + float(a["lunge_every"])
	_become(e, String(a["elder_sprite"]), float(a["elder_radius"]), float(a["elder_speed"]), float(a["elder_damage"]))
	game.banner("The Elder rises!")
	game.fx.spawn("summon_rise", e.position, 160.0, 0.7, Color(1.0, 0.3, 0.35))
	game.sound("boss")
	EnemyTrait.note(game, "elder_risen")


## Phase 3: the blood-blade lunge.
func _lord(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if game.time < e.freeze_until or game.time < float(e.vars["next_lunge"]):
		return
	e.vars["next_lunge"] = game.time + float(a["lunge_every"])
	CourtKit.lunge(e, game, float(a["lunge_jump"]))
	for b: BlockBody in game.bodies_near(e.position, float(a["lunge_reach"])):
		CourtKit.bite(game, e, b, float(a["lunge_damage"]), 0.0)
	CourtKit.mark(game, e.position, float(a["lunge_reach"]), 0.6, CourtKit.tint("mark_tint"))
	_pose(e, game, 1, float(a["pose_time"]))
	EnemyTrait.note(game, "elder_lunges")


## Phase 5: bats on command and the wing buffet.
func _horror(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if game.time >= float(e.vars["next_command"]):
		e.vars["next_command"] = game.time + float(a["command_every"])
		CourtKit.call_out(game, e, String(a["bat_kind"]), int(a["command_bats"]), 10.0)
		EnemyTrait.note(game, "elder_bats")
	if game.time < e.freeze_until or game.time < float(e.vars["next_buffet"]):
		return
	e.vars["next_buffet"] = game.time + float(a["buffet_every"])
	for b: BlockBody in game.bodies_near(e.position, float(a["buffet_radius"])):
		TdCombat.damage_body(game, b, float(a["buffet_damage"]), e)
		game.vfx.enemy_blow(e, b)
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= float(a["buffet_tower_r"]):
			TdCombat.disable_tower(game, t, float(a["buffet_disable"]), "stunned")
	CourtKit.mark(game, e.position, float(a["buffet_tower_r"]), 0.6, CourtKit.tint("mark_tint"))
	game.vfx.shake(5.0)
	_pose(e, game, 1, float(a["pose_time"]))
	EnemyTrait.note(game, "elder_buffets")


## Takes the Elder's form: sprite, body, pace, blow.
func _become(e: TdEnemy, sprite: String, radius: float, speed: float, damage: float) -> void:
	CourtKit.reshape(e, sprite, radius)
	e.row["damage"] = damage
	e.speed = speed


func on_attack(e: TdEnemy, game: TdGame, _body: BlockBody) -> void:
	if int(e.vars["phase"]) == 5:
		TdCombat.heal_enemy(game, e, float(e.row["damage"]) * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT * float(e.row["args"]["horror_feed"]))


## Shows pose `p` for `time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, p: int, time: float) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + time
	e.body.queue_redraw()
