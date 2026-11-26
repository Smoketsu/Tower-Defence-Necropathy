## An Arm of Vhal'Neth (Necropathy's ArmKit): a colossal arm risen out of the
## sea beside the road. It never walks (row speed 0) and never fights a post;
## every `every` s (first `first` s after it rises) it marks a lane toward the
## nearest tower within `range` px: `circles` telegraphed strikes of `radius`
## px, `step` px apart from the arm toward it, through the one shelling path
## (game.hostile.shell, `delay` s; towers inside stunned `disable` s, cause
## "grabbed"; bodies inside take `body_damage`). Severed (killed), it wounds
## Vhal'Neth (her trait's arm_severed()). Args: first, every, range (px),
## circles, step (px), radius (px), delay, disable (s), body_damage.
## vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.last_moved = game.time  # It stands by design (not stuck).
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var t := Kit.nearest_tower(game, e.position, float(a["range"]))  # Where it slams.
	if t == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	var dir := (t.position - e.position).normalized()  # Down the lane.
	for i in int(a["circles"]):
		var p := t.position - dir * float(a["step"]) * float(i)  # From the tower back toward the arm.
		game.hostile.shell(p, float(a["radius"]), float(a["delay"]) + 0.12 * float(i), float(a["disable"]), "grabbed", float(a["body_damage"]))
	Kit.line(game, e.position, t.position, float(a["delay"]), false, Acts.data("eye")["LOOK"]["tentacle_tint"])
	game.fx.spawn("vhalneth_slam", t.position, float(a["radius"]) * 3.0, float(a["delay"]) + 0.4)
	e.vis_strike_at = game.time
	e.vis_strike_dir = dir
	EnemyTrait.note(game, "eye_arm_slams")


func on_death(e: TdEnemy, game: TdGame) -> void:
	EnemyTrait.note(game, "eye_arms_severed")
	for o: TdEnemy in game.enemies:
		if o.alive and o.traits != null and o.traits.has_method("arm_severed"):
			o.traits.call("arm_severed", o, game)
	game.fx.spawn("tide_splash", e.position, 120.0, 0.6)
