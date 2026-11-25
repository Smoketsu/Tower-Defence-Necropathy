## Halberdier (GDD §6.1 "Hits blockers hard, long reach"): while it walks
## toward a road post it strikes that post's first living body from `reach`
## px away on its own attack cadence, before any body holds it; once held it
## fights its holder normally (its row damage is high).
## Args: reach (px ahead on its road). vars: "next_reach" (game s of its next reach strike).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next_reach"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if e.holder != null or game.time < float(e.vars["next_reach"]) or game.time < e.freeze_until:
		return
	var reach := float(e.row["args"]["reach"])  # Px it reaches ahead.
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id or blk.dist < e.follower.dist or blk.dist - e.follower.dist > reach or game.time >= blk.until:
			continue
		for b: BlockBody in blk.bodies:
			if b.alive:
				e.vars["next_reach"] = game.time + float(e.row["attack_interval"])
				TdCombat.damage_body(game, b, float(e.row["damage"]) * e.damage_mult())
				EnemyTrait.note(game, "halberd_reach")
				return
