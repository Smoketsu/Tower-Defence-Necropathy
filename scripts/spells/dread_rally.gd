## Dread Rally, the ultimate (GDD §5): revives every fallen blocker body at
## once and gives all towers +40% damage and attack speed for 8 s (the buff
## itself is applied in Tower.recompute() while TdGame.rally_until runs).
## Row: SpellData.ULTIMATE. Cast anywhere (the position is ignored).
extends TdSpell


func cast(_pos: Vector2) -> bool:
	for t: Tower in game.towers:
		if t.block != null:
			for b: BlockBody in t.block.bodies:
				if not b.alive:
					TdCombat.revive_body(game, b)
	game.start_rally(float(row["duration"]))
	game.fx.spawn("dread_rally", game.necromancer_pos(), 320.0, 0.9)
	game.banner("Dread Rally!")
	return true
