## The Throne (Wheel of Thrones boss; Necropathy's BossThrone, a colossal wheel
## within a wheel):
##   the rims  — every hit while the Core is shut counts only `rim_mult`.
##   the Core  — every `core_every` s (first after `core_first`) the wheels part
##               (pose 1, the burning eye drawn over it) for `core_time` s: hits
##               count in full.
##   the Rolling — every `roll_every` s (first after `roll_first`) while shut it
##               rolls: free of any post, unholdable, `speed_mult` x its speed for
##               `roll_time` s, each post it passes struck for `roll_damage`
##               (the Ophan's roll_over()).
##   the Gaze  — every `gaze_every` s while shut its eyes lay `gazes` still
##               shafts of Hallowed Light over the towers nearest it
##               (`gaze_width` px, `gaze_life` s; the act rule's add_shaft()).
## Args in its row. vars: "core_until", "next_core", "next_roll", "roll_until",
## "next_gaze", "rolled", "core_dmg" / "rim_dmg" (summary counters).
extends EnemyTrait

const Ophan := preload("res://scripts/enemies/traits/host/ophan.gd")
const Light := preload("res://scripts/maps/rules/host/hallowed_light.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["core_until"] = 0.0
	e.vars["next_core"] = game.time + float(a["core_first"])
	e.vars["next_roll"] = game.time + float(a["roll_first"])
	e.vars["roll_until"] = 0.0
	e.vars["next_gaze"] = game.time + float(a["gaze_every"])
	e.vars["rolled"] = []


## True while the wheels stand open.
static func core_open(e: TdEnemy, game: TdGame) -> bool:
	return game.time < float(e.vars.get("core_until", 0.0))


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if core_open(e, game):
		return amount
	return amount * float(e.row["args"]["rim_mult"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var open := core_open(e, game)
	if e.pose == 1 and not open:
		e.pose = 0
		e.body.queue_redraw()
		game.banner("The wheels close: the Throne's rims turn every blow aside")
	if game.time < e.freeze_until:
		return
	if not open and game.time >= float(e.vars["next_core"]):
		e.vars["next_core"] = game.time + float(a["core_every"])
		e.vars["core_until"] = game.time + float(a["core_time"])
		e.pose = 1
		e.body.queue_redraw()
		game.banner("The wheels part: strike the Throne's burning Core!")
		game.fx.spawn("holy_impact", e.position, float(Acts.data("host")["LOOK"]["core_d"]) * 2.0, 0.6, Acts.data("host")["LOOK"]["core_tint"])
		EnemyTrait.note(game, "throne_cores")
		return
	if open:
		return
	if game.time >= float(e.vars["next_roll"]):
		e.vars["next_roll"] = game.time + float(a["roll_every"])
		e.vars["roll_until"] = game.time + float(a["roll_time"])
		e.vars["rolled"] = []
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
		e.unholdable_until = game.time + float(a["roll_time"])
		TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["roll_time"]))
		EnemyTrait.note(game, "throne_rolls")
	if game.time < float(e.vars["roll_until"]):
		Ophan.roll_over(e, game, float(a["roll_damage"]))
	var rule := Light.of(game)  # The Hallowed Light (null off-act).
	if rule != null and game.time >= float(e.vars["next_gaze"]):
		e.vars["next_gaze"] = game.time + float(a["gaze_every"])
		var ts := game.towers.duplicate()  # Towers, nearest it first.
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for t: Tower in ts.slice(0, int(a["gazes"])):
			var n := (t.position - e.position).normalized() if t.position != e.position else Vector2.RIGHT  # The gaze's line.
			rule.call("add_shaft", t.position, Vector2(-n.y, n.x), float(a["gaze_width"]), float(a["gaze_life"]))
		EnemyTrait.note(game, "throne_gazes")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Wheel breaks: the Throne falls silent")
