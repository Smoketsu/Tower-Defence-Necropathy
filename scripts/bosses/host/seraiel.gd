## Seraiel, Warden of the Gate (Silver Stair boss; Necropathy's BossSeraiel).
## Three phases by HP (`phase_hp`: [phase 2 from, phase 3 from] as HP shares):
##   the Sword  — every `sword_every` s (`sword_every_p3` in phase 3; first after
##                `sword_first`) he raises the flaming sword (pose 1) for
##                `windup` s, then sweeps a full circle: bodies within `reach`
##                px take `body_damage`, towers there are stunned `disable` s
##                (the Cherub's sweep, host/cherub.gd).
##   the Gate   — every `gate_every` s (first after `gate_first`) a still shaft
##                of Hallowed Light closes a lane of plots across the road
##                `gate_ahead` px ahead of him (the act rule's add_shaft(),
##                `gate_width` px, burning `gate_life` s); `gates_p3` lanes at
##                once in phase 3 (the second twice as far ahead).
##   the Trial  — each phase he survives sends `trial_judges` Judges (the act
##                rule's send_judges(): Judgment fills).
## Args in his row. vars: "phase" (1..3), "next_sword", "sword_at", "next_gate",
## "pose_until" (game s).
extends EnemyTrait

const Cherub := preload("res://scripts/enemies/traits/host/cherub.gd")
const Lunge := preload("res://scripts/enemies/traits/host/lunge.gd")
const Light := preload("res://scripts/maps/rules/host/hallowed_light.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["phase"] = 1
	e.vars["next_sword"] = game.time + float(a["sword_first"])
	e.vars["sword_at"] = 0.0
	e.vars["next_gate"] = game.time + float(a["gate_first"])
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["sword_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	var rule := Light.of(game)  # The Hallowed Light (null off-act).
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		game.banner(["", "", "The Trial: Seraiel weighs your sins, Judges descend!", "Seraiel's last phase: the Gate closes lane after lane!"][ph])
		if rule != null:
			rule.call("send_judges", int(a["trial_judges"]))
		EnemyTrait.note(game, "seraiel_trials")
	var at := float(e.vars["sword_at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["sword_at"] = 0.0
			Cherub.sweep(e, game, float(a["reach"]), float(a["body_damage"]), float(a["disable"]))
			_pose(e, game, a)
		return
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_sword"]):
		e.vars["next_sword"] = game.time + float(a["sword_every_p3" if ph == 3 else "sword_every"])
		e.vars["sword_at"] = game.time + float(a["windup"])
		Lunge.sweep_ring(game, e.position, float(a["reach"]), float(a["windup"]), false)
		e.pose = 1
		e.body.queue_redraw()
	if rule != null and game.time >= float(e.vars["next_gate"]):
		e.vars["next_gate"] = game.time + float(a["gate_every"])
		var rd := e.follower.road  # His road.
		for i in (int(a["gates_p3"]) if ph == 3 else 1):
			var d := minf(e.follower.dist + float(a["gate_ahead"]) * float(i + 1), rd.length - 1.0)  # Where the lane closes.
			rule.call("add_shaft", rd.point_at(d), rd.dir_at(d), float(a["gate_width"]), float(a["gate_life"]))
		_pose(e, game, a)
		EnemyTrait.note(game, "seraiel_gates")


## Shows the raised sword for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Seraiel falls: the Gate of Pearl stands open")
