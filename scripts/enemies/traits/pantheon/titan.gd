## Bronze Titan (Act VIII; Necropathy's TitanKit, the Twilight of the Gods'
## colossus that steps out of the ground): it rises with a crack (look and
## sound only) and every `stomp_every`-th blow on the body holding it is a
## STOMP: every living body of that post takes `stomp_damage` (x its weaken)
## and makes no strike for `stun` s (BlockBody.next_attack pushed back). Flat
## armour is its row's. Args: stomp_every, stomp_damage, stun (s).
## vars: "blows" (count). Counted as event "titan_stomps".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["blows"] = 0
	Sfx.play("titan_rise")
	game.fx.spawn("golem_slam", e.position, float(PantheonActRules.look()["rise_d"]), 0.5)


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["blows"] = int(e.vars["blows"]) + 1
	if int(e.vars["blows"]) % int(a["stomp_every"]) != 0 or body.block == null:
		return
	for b: BlockBody in body.block.bodies:
		if b.alive:
			TdCombat.damage_body(game, b, float(a["stomp_damage"]) * e.damage_mult(), e)
			b.next_attack = maxf(b.next_attack, game.time + float(a["stun"]))
	EnemyTrait.note(game, "titan_stomps")
	Sfx.play("wrath_fissure")
	if game.vfx.on:
		var lk: Dictionary = PantheonActRules.look()
		game.vfx.add(TdVfx.Kind.ANIM, body.pos, float(lk["stomp_d"]), 0.45, lk["stomp_tint"], "golem_slam")
		game.vfx.add(TdVfx.Kind.CRACK, body.pos, 1.2, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.shake(float(lk["stomp_shake"]))
