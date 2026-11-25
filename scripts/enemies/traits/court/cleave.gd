## Cleave (the Blood Knight's halberd; Necropathy's shared cleave path): after
## each of its blows on the body holding it, every other living body on the
## same post takes `cleave` x that blow. Args: cleave (share 0..1).
extends EnemyTrait


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var dmg := float(e.row["damage"]) * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT * float(e.row["args"]["cleave"])  # Cleave per body.
	var hit := false  # Some other body was struck.
	for b: BlockBody in body.block.bodies:
		if b != body and b.alive:
			TdCombat.damage_body(game, b, dmg, e)
			game.vfx.enemy_blow(e, b)
			hit = true
	if hit:
		EnemyTrait.note(game, "cleaves")
