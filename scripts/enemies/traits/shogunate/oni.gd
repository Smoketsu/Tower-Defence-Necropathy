## Oni (Necropathy's OniKit, the kanabō smash): flat armour (its row); every
## `smash_every`-th blow on the body holding it is a smash: EVERY living body
## of that post takes `smash_damage` (x its weaken) and is stunned `stun` s (it
## makes no strike: BlockBody.next_attack pushed back). Args: smash_every,
## smash_damage, stun (s). vars: "blows" (count). Shuten-doji extends it.
extends EnemyTrait


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["blows"] = int(e.vars.get("blows", 0)) + 1
	if int(e.vars["blows"]) % int(a["smash_every"]) != 0 or body.block == null:
		return
	for b: BlockBody in body.block.bodies:
		if b.alive:
			TdCombat.damage_body(game, b, float(a["smash_damage"]) * e.damage_mult(), e)
			b.next_attack = maxf(b.next_attack, game.time + float(a["stun"]))
	EnemyTrait.note(game, "oni_smashes")
	Sfx.play("oni_smash")
	if game.vfx.on:
		var lk: Dictionary = Acts.data("shogunate")["LOOK"]
		game.vfx.add(TdVfx.Kind.ANIM, body.pos, float(lk["smash_d"]), 0.45, Color.WHITE, "golem_slam")
		game.vfx.add(TdVfx.Kind.CRACK, body.pos, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.add(TdVfx.Kind.ANIM, body.pos + Vector2(0, -26), float(lk["stun_d"]), float(a["stun"]), lk["stun_tint"], "frost_nova")
		game.vfx.shake(float(lk["smash_shake"]))
