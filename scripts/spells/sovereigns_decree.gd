## Sovereign's Decree, a later ultimate (GDD §5; Necropathy's "every summon
## taunts and takes 50% less damage"): on the Dread Rally meter. Revives every
## fallen blocker body, puts a barrier of `barrier_frac` x its max HP on every
## blocker body (TdCombat.barrier_body) for `duration` s, and weakens every
## enemy held meanwhile to `weaken` (TdCombat.weaken_enemy) and slows every
## enemy on the map to `slow` x its speed (TdCombat.slow_enemy; DECISIONS B2). Row:
## SpellData.ULTIMATES "sovereigns_decree". Cast anywhere.
extends TdSpell

## Game s the decree ends (0 = not active).
var _until: float = 0.0


func cast(_pos: Vector2) -> bool:
	var dur := float(row["duration"])  # Decree length (s).
	for blk: RoadBlock in game.blocks:
		for b: BlockBody in blk.bodies:
			if b.max_hp == INF:
				continue  # A Bone Wall.
			if not b.alive and not b.temporary:
				TdCombat.revive_body(game, b)
			TdCombat.barrier_body(game, b, b.max_hp * float(row["barrier_frac"]), dur)
			if game.vfx.on:
				game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -12), 70.0, 0.5, TdVfxData.SPELLS[id]["tint"], "volley_flash", 0.1)
	_until = game.time + dur
	Sfx.play(String(row["sound"]))
	game.banner(String(row["name"]) + "!")
	return true


func step(_dt: float) -> void:
	if game.time >= _until:
		return
	for blk: RoadBlock in game.blocks:
		for b: BlockBody in blk.bodies:
			for e: TdEnemy in b.held:
				TdCombat.weaken_enemy(game, e, float(row["weaken"]), 0.2)
	for e: TdEnemy in game.enemies:
		if e.alive and not bool(e.row.get("structure", false)):
			TdCombat.slow_enemy(game, e, float(row["slow"]), 0.2)


func draw(ci: CanvasItem) -> void:
	if game.time >= _until:
		return
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var d := TdVfxData.KIT_BARRIER_D  # Shell size (px).
	for blk: RoadBlock in game.blocks:
		for b: BlockBody in blk.bodies:
			if b.alive and b.barrier > 0.0 and game.time < b.barrier_until:
				ci.draw_texture_rect(TdVfx._soft(), Rect2(b.pos - Vector2(d, d) * 0.5 + Vector2(0, -12), Vector2(d, d)), false, Color(tint, 0.6))


func busy() -> bool:
	return game.time < _until
