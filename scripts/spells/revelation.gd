## Revelation (Act X spell, the Voice's reward; Necropathy's Revelation, "a
## flash that stuns every enemy and weakens them"): a flash of unbearable light
## at the tap: every foe within `radius` px is frozen `stun` s
## (TdCombat.freeze_enemy, rank multipliers apply) and weakened to `weaken` of
## its damage for `weaken_time` s (TdCombat.weaken_enemy); the Unveiled's innate
## also strips `reveal_shred` flat armour for that time (TdCombat.shred_enemy).
## Row: SpellData "revelation".
extends TdSpell

## Flashes drawn: [map px, game s cast].
var _flashes: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Who sees it.
	if foes.is_empty():
		return false
	var shred := float(CharacterModifiers.innate("reveal_shred", 0.0))  # The Unveiled's armour strip.
	for e: TdEnemy in foes:
		TdCombat.freeze_enemy(game, e, float(row["stun"]))
		TdCombat.weaken_enemy(game, e, float(row["weaken"]), float(row["weaken_time"]))
		if shred > 0.0:
			TdCombat.shred_enemy(game, e, shred, float(row["weaken_time"]))
	game.stats["revealed"] = int(game.stats.get("revealed", 0)) + foes.size()
	_flashes.append([pos, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_flashes.size() - 1, -1, -1):
		if game.time > float(_flashes[i][1]) + 0.6:
			_flashes.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var r := float(row["radius"])
	var ring := TdArt.texture("range_ring")  # Its real reach.
	for f: Array in _flashes:
		var k := 1.0 - clampf((game.time - float(f[1])) / 0.6, 0.0, 1.0)  # Fades.
		var p: Vector2 = f[0]
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, 0.55 * k))
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(p - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, k))


func busy() -> bool:
	return not _flashes.is_empty()
