## Juggernaut (Act XII heavy elite; Necropathy's JuggernautKit: "an armoured
## flamethrower walker with flat armour; a telegraphed flame cone"): held at a
## post, every `every` s it primes its flamethrower for `windup` s (a red
## glow on the post), then the flame washes over EVERY body of that post for
## `damage` each (x its weaken). Not while frozen or staggered. Its row armour
## is high: Mages and Catapults (armour pierce) answer it. Args: windup,
## every, damage. vars: "next", "at" (game s the flame lands; 0 = none).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next"] = 0.0
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var at := float(e.vars["at"])  # When the flame lands.
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["every"])
		if e.holder == null or game.time < e.freeze_until or game.time < e.staggered_until:
			return
		var post := e.holder  # The body holding it (it may fall below).
		for b: BlockBody in post.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["damage"]) * e.damage_mult(), e)
		e.vis_strike_at = game.time
		e.vis_strike_dir = (post.pos - e.position).normalized()
		EnemyTrait.note(game, "juggernaut_flames")
		Sfx.play("flamethrower")
		game.vfx.add(TdVfx.Kind.ANIM, post.pos + Vector2(0, -10), float(lk["flame_d"]), 0.5, lk["flame_tint"], "empire_blast_red")
		return
	if e.holder != null and game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["at"] = game.time + float(a["windup"])
		var ring := game.vfx.add(TdVfx.Kind.RING, e.holder.pos, float(lk["flame_d"]) * 0.5, float(a["windup"]), lk["flame_tint"])
		if ring != null:
			ring.size0 = float(lk["flame_d"]) * 0.15
