## Isolde Vane, the Witch of the Red Moon (the Witchwood's boss; Necropathy
## BossIsolde), road version. Three phases:
##   THE WITCH (100% to phase2_hp): every `circle_every` s (first after
##     `circle_first`) hex circles of `circle_r` px on `circle_count` towers
##     within `circle_reach` px (CourtKit.hex: `circle_mult` x damage for
##     `circle_time` s); every `bomb_every` s (first after `bomb_first`)
##     `bomb_count` cauldron bombs on the blocker bodies within `bomb_reach` px
##     (game.hostile.shell: `bomb_radius` px, `bomb_delay` s, `bomb_damage` to
##     bodies), each leaving a blood pool (`pool_radius` px, `pool_life` s,
##     `pool_heal` HP per s to the Court: CourtKit.pool).
##   THE THREE SISTERS (at phase2_hp): she splits into three `sister_kind`
##     (`sister_gap` px apart behind her) and stands hidden among them (vars
##     "hidden_until": no tower sees her, she takes no damage). ALL THREE MUST
##     FALL WITHIN `sisters_window` s OF EACH OTHER: a sister down longer than
##     that while another stands rises again where Isolde waits with
##     `rise_hp` of her life; after `sabbath_wane` s no more rise (a floor so
##     the fight always ends).
##   THE RED MOON (when the last sister falls): she reforms at phase3_hp of her
##     HP and keeps the Blood Moon up until she falls; her circles and bombs
##     come `p3_every_mult` x as often.
## Args in the act data file's "isolde" row. vars: "next_circle", "next_bomb",
## "pose_until", "split_at" (game s), "phase" (1..3), "bombs" ([[map px, land s]]),
## "sisters" ([[TdEnemy, gen]]), "risers" ([fall game s, ...]), "hidden_until".
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_circle"] = game.time + float(a["circle_first"])
	e.vars["next_bomb"] = game.time + float(a["bomb_first"])
	e.vars["pose_until"] = 0.0
	e.vars["split_at"] = 0.0
	e.vars["phase"] = 1
	e.vars["bombs"] = []
	e.vars["sisters"] = []
	e.vars["risers"] = []
	e.vars["hidden_until"] = 0.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	return 0.0 if game.time < float(e.vars["hidden_until"]) else amount


func on_hit(e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if int(e.vars["phase"]) == 1 and e.hp <= e.max_hp * float(a["phase2_hp"]):
		_split(e, game)


## Phase 2: three sisters step out; she hides among them.
func _split(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 2
	e.vars["split_at"] = game.time
	e.vars["hidden_until"] = INF
	e.speed = 0.0
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = INF
	for s: TdEnemy in CourtKit.call_out(game, e, String(a["sister_kind"]), 3, float(a["sister_gap"])):
		_adopt(e, s)
	game.banner("Isolde splits into three sisters: fell them together")
	game.fx.spawn("summon_rise", e.position, 140.0, 0.6, Color(1.0, 0.3, 0.4))
	EnemyTrait.note(game, "isolde_split")


## Ties sister `s` to Isolde `e`.
func _adopt(e: TdEnemy, s: TdEnemy) -> void:
	s.vars["isolde"] = [e, e.generation]
	(e.vars["sisters"] as Array).append([s, s.generation])


## A sister fell (sister.gd): rising is queued while others stand; the last one ends the phase.
func sister_fell(e: TdEnemy, game: TdGame, s: TdEnemy) -> void:
	var standing := 0  # Other sisters alive.
	for pair: Array in e.vars["sisters"]:
		if pair[0] != s and TdEnemy.valid(pair[0], int(pair[1])):
			standing += 1
	if standing > 0:
		(e.vars["risers"] as Array).append(game.time)
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["risers"] = []
	e.vars["phase"] = 3
	e.vars["hidden_until"] = 0.0
	e.unholdable_until = 0.0
	e.speed = float(e.row["speed"])
	e.hp = minf(e.hp, e.max_hp * float(a["phase3_hp"]))
	game.banner("Isolde reforms and calls the Red Moon!")
	game.fx.spawn("summon_rise", e.position, 160.0, 0.6, Color(1.0, 0.2, 0.3))
	EnemyTrait.note(game, "isolde_reformed")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var phase := int(e.vars["phase"])  # Phase now.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var bombs: Array = e.vars["bombs"]  # Bombs in the air: [map px, landing s].
	for i in range(bombs.size() - 1, -1, -1):
		if game.time >= float(bombs[i][1]):
			CourtKit.pool(game, bombs[i][0], float(a["pool_radius"]), float(a["pool_life"]), float(a["pool_heal"]))
			bombs.remove_at(i)
	if phase == 2:
		_sabbath(e, game, a)
		return
	if phase == 3:
		CourtKit.force_moon(game, game.time + 1.0)
	if game.time < e.freeze_until:
		return
	var m := float(a["p3_every_mult"]) if phase == 3 else 1.0  # Faster under the Red Moon.
	if game.time >= float(e.vars["next_circle"]):
		var hexed: Array = []  # Towers marked this cast.
		for i in int(a["circle_count"]):
			var t := CourtKit.nearest_tower(game, e.position, float(a["circle_reach"]), hexed)  # Next mark.
			if t == null:
				break
			hexed.append(t)
			CourtKit.hex(game, t, float(a["circle_r"]), float(a["circle_mult"]), float(a["circle_time"]))
		if not hexed.is_empty():
			e.vars["next_circle"] = game.time + float(a["circle_every"]) * m
			_pose(e, game, float(a["pose_time"]))
	if game.time >= float(e.vars["next_bomb"]):
		var bodies := game.bodies_near(e.position, float(a["bomb_reach"]))  # Her targets.
		if not bodies.is_empty():
			e.vars["next_bomb"] = game.time + float(a["bomb_every"]) * m
			for i in mini(int(a["bomb_count"]), bodies.size()):
				var p := bodies[i].pos  # Where it falls.
				game.hostile.shell(p, float(a["bomb_radius"]), float(a["bomb_delay"]), 0.0, "shelled", float(a["bomb_damage"]))
				bombs.append([p, game.time + float(a["bomb_delay"])])
			_pose(e, game, float(a["pose_time"]))
			EnemyTrait.note(game, "isolde_bombs")


## Phase 2: raise the sisters that fell too early, while the sabbath lasts.
func _sabbath(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var risers: Array = e.vars["risers"]  # Fall times waiting.
	if risers.is_empty():
		return
	if game.time - float(e.vars["split_at"]) > float(a["sabbath_wane"]):
		risers.clear()
		return
	if game.time - float(risers[0]) < float(a["sisters_window"]):
		return
	risers.pop_front()
	var s := CourtKit.call_out(game, e, String(a["sister_kind"]), 1, float(a["sister_gap"]))[0]  # She rises again.
	s.hp = s.max_hp * float(a["rise_hp"])
	_adopt(e, s)
	game.fx.spawn("summon_rise", s.position, 90.0, 0.5, Color(1.0, 0.3, 0.4))
	EnemyTrait.note(game, "sisters_risen")


## Shows the cast pose for `time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, time: float) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + time
	e.body.queue_redraw()
