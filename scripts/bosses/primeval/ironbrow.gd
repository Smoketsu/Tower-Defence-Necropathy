## Old Ironbrow, the Horned Titan (Great Plain boss; Necropathy's BossIronbrow):
##   the Charge — every `every` s (`every_broken` after the Break; first after
##                `first`) he lowers his horns for `windup` s (a line down the
##                road), then CHARGES for `time` s at `speed_mult` x: free of
##                every post, goring each post he passes (`gore`); into a map rock
##                (MAP "rocks", within `rock_r` px) he is stunned `rock_stun` s
##                and takes x`stunned_mult` damage while stunned (Kit.charge_step).
##   the Herd   — every `herd_every`-th charge his herd (`herd`) stampedes down
##                the trail nearest him (Stampedes.launch(), `herd_gap` s apart).
##   the Break  — below `break_hp` of his HP, once: a horn snaps (pose 1 from
##                then on) and he charges more often.
## Args in his row. vars: "next", "at" (game s the charge starts; 0 = none),
## "charges", "broken", "charge_until", "gored".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")
const Stampedes := preload("res://scripts/maps/rules/primeval/stampedes.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["charges"] = 0
	e.vars["broken"] = false


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	return amount * float(e.row["args"]["stunned_mult"]) if game.time < e.freeze_until else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	if not bool(e.vars["broken"]) and e.hp / e.max_hp <= float(a["break_hp"]):
		e.vars["broken"] = true
		e.pose = 1
		e.body.queue_redraw()
		game.banner("The Break: Ironbrow's horn snaps, and he charges in fury!")
		game.fx.spawn("structure_break", e.position, 90.0, 0.5)
		EnemyTrait.note(game, "ironbrow_breaks")
	if Kit.charging(e, game):
		Kit.charge_step(e, game, float(a["gore"]), float(a["rock_r"]), float(a["rock_stun"]))
		return
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			Kit.start_charge(e, game, float(a["speed_mult"]), float(a["time"]))
			e.vars["charges"] = int(e.vars["charges"]) + 1
			EnemyTrait.note(game, "ironbrow_charges")
			var rule := Stampedes.of(game)
			if rule != null and int(e.vars["charges"]) % int(a["herd_every"]) == 0:
				rule.call("launch", a["herd"], e.position, float(a["herd_gap"]))
				EnemyTrait.note(game, "ironbrow_herds")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["next"] = game.time + float(a["every_broken" if bool(e.vars["broken"]) else "every"])
		e.vars["at"] = game.time + float(a["windup"])
		var rd := e.follower.road
		Kit.line(game, e.position, rd.point_at(minf(e.follower.dist + e.speed * float(a["speed_mult"]) * float(a["time"]), rd.length)), float(a["windup"]), false)
		Sfx.play("boss_telegraph")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Old Ironbrow falls: the herds of the Great Plain run free")
