## Achilles, the Unkillable (Shores of Ilion boss; Necropathy's BossAchilles:
## "hits to his front deal 10%; hits from behind deal full damage and stagger
## him"). A phalanx body (phalanx.gd, the act's one facing test) with THE HEEL:
## a hit from behind deals x `heel_mult` and staggers him `stagger` s (at most
## every `stagger_cd` s; TdCombat.stagger_enemy). Three parts of one fight:
##   THE DUEL (HP above `guard_hp`): every `lunge_every` s (first after
##     `lunge_first`) once a post holds him he LUNGES through it: the body takes
##     `lunge_damage`, he breaks free, unholdable x `lunge_speed` for
##     `lunge_time` s (strike pose).
##   THE MYRMIDON CHARGE (down to `rage_hp`): he keeps lunging and every
##     `guard_every` s calls his guard: `guard_count` `guard_kind` hoplites
##     a shield wall `guard_ahead` px in front of him (while fewer than
##     `guard_max` of the run's guards stand).
##   THE RAGE after Patroclus (below `rage_hp`): helmet and shield gone (pose
##     2, the rage still): his front takes `rage_front_mult`, he runs x
##     `rage_speed` faster and lunges every `rage_lunge_every` s.
## Args: those plus the phalanx keys. vars: "stage" (0..2), "next_lunge",
## "next_guard", "stagger_ok", "pose_until" (game s), "guards" ([[TdEnemy, gen]]).
## Counted: events achilles_lunges, achilles_guards, achilles_heel.
extends "res://scripts/enemies/traits/pantheon/phalanx.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["stage"] = 0
	e.vars["next_lunge"] = game.time + float(a["lunge_first"])
	e.vars["next_guard"] = game.time
	e.vars["stagger_ok"] = 0.0
	e.vars["pose_until"] = 0.0
	e.vars["guards"] = []


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]  # His numbers.
	var s := side(e, hit)  # Where it came from.
	if s == Side.BACK:
		EnemyTrait.note(game, "achilles_heel")
		if game.time >= float(e.vars["stagger_ok"]):
			e.vars["stagger_ok"] = game.time + float(a["stagger_cd"])
			TdCombat.stagger_enemy(game, e, float(a["stagger"]))
			game.fx.spawn("holy_impact", e.position, float(PantheonActRules.look()["heel_d"]), 0.4)
		return amount * float(a["heel_mult"])
	if s == Side.FRONT and int(e.vars["stage"]) == 2:
		EnemyTrait.note(game, "phalanx_front")
		return amount * float(a["rage_front_mult"])
	return super(e, game, amount, hit)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose == 3 and game.time >= float(e.vars["pose_until"]):
		e.pose = 2 if int(e.vars["stage"]) == 2 else 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP fraction.
	var st := 0 if f > float(a["guard_hp"]) else (1 if f > float(a["rage_hp"]) else 2)  # Part of the fight.
	if st != int(e.vars["stage"]):
		e.vars["stage"] = st
		if st == 2:
			e.speed *= float(a["rage_speed"])
			e.pose = 2
			e.body.queue_redraw()
		game.banner(["", "Achilles calls his Myrmidons: a wall of shields!", "Patroclus is dead: Achilles rages without helm or shield!"][st])
		Sfx.play("shield_break" if st == 2 else "shield_lock")
	if game.time < e.freeze_until or game.time < e.staggered_until:
		return
	if st >= 1 and game.time >= float(e.vars["next_guard"]) and _guards_alive(e) < int(a["guard_max"]):
		e.vars["next_guard"] = game.time + float(a["guard_every"])
		var r := e.follower.road  # His road.
		var d := minf(e.follower.dist + float(a["guard_ahead"]), r.length - 10.0)  # Where the wall forms.
		for i in int(a["guard_count"]):
			var g := game.waves.spawn_extra(String(a["guard_kind"]), r.id, d, (float(i) - float(int(a["guard_count"]) - 1) * 0.5) * float(a["guard_gap"]))
			if g != null:
				(e.vars["guards"] as Array).append([g, g.generation])
		game.fx.spawn("summon_rise", r.point_at(d), float(PantheonActRules.look()["rise_d"]), 0.5)
		EnemyTrait.note(game, "achilles_guards")
	if e.holder != null and game.time >= float(e.vars["next_lunge"]):
		e.vars["next_lunge"] = game.time + float(a["rage_lunge_every" if st == 2 else "lunge_every"])
		var b := e.holder  # The body he runs through.
		TdCombat.damage_body(game, b, float(a["lunge_damage"]) * e.damage_mult(), e)
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
		e.unholdable_until = game.time + float(a["lunge_time"])
		TdCombat.haste_enemy(game, e, float(a["lunge_speed"]), float(a["lunge_time"]))
		e.pose = 3
		e.vars["pose_until"] = game.time + float(a["lunge_time"])
		e.body.queue_redraw()
		EnemyTrait.note(game, "achilles_lunges")
		game.fx.spawn("vael_cleave", b.pos, float(PantheonActRules.look()["charge_d"]), 0.4)


## His guards still standing.
func _guards_alive(e: TdEnemy) -> int:
	var n := 0  # Standing.
	for g: Array in e.vars["guards"]:
		n += 1 if TdEnemy.valid(g[0], int(g[1])) else 0
	return n


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Achilles falls: an arrow found his heel")
