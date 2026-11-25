## Cannonade (the Black Tide; Necropathy Cannonade / Dead Men's Broadside):
## marks up to `marks` packs (+ the Corsair Queen's Queen's Ransom, innate
## "marks_extra") within `reach` px of the tap, densest first and `spread` px
## apart (the foe with the most foes within `radius` px marks each pack); a
## soul-lit ring shows `delay` s while a spectral ball falls, then every foe
## within `radius` px of the mark takes `damage`. No foe in reach = no cast.
## Row: SpellData "cannonade".
extends TdSpell

## Falling balls: [map px, landing game s, cast game s].
var _balls: Array = []


func cast(pos: Vector2) -> bool:
	var cands := game.foes_near(pos, float(row["reach"]))  # Foes in reach.
	if cands.is_empty():
		return false
	var r := float(row["radius"])  # Blast radius (px).
	var score := {}  # Foe -> pack size.
	for e: TdEnemy in cands:
		score[e] = game.foes_near(e.position, r).size()
	cands.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool:
		return int(score[a]) > int(score[b]) or (int(score[a]) == int(score[b]) and game.progress(a) > game.progress(b)))
	var n := int(row["marks"]) + int(CharacterModifiers.innate("marks_extra", 0))  # Marks wanted.
	var marks: Array[Vector2] = []  # Chosen marks.
	for e: TdEnemy in cands:
		if marks.size() >= n:
			break
		var free := true  # Far enough from the other marks.
		for m: Vector2 in marks:
			free = free and m.distance_to(e.position) >= float(row["spread"])
		if free:
			marks.append(e.position)
	for m: Vector2 in marks:
		_balls.append([m, game.time + float(row["delay"]), game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_balls.size() - 1, -1, -1):
		var b: Array = _balls[i]
		if game.time < float(b[1]):
			continue
		_balls.remove_at(i)
		var at: Vector2 = b[0]
		var r := float(row["radius"])  # Blast radius (px).
		for e: TdEnemy in game.foes_near(at, r):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
		Sfx.play("cannon_hit")
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, at, r * 2.6, TdVfxData.IMPACT_TIME * 1.4, TdVfxData.SPELLS[id]["tint"], "corpse_explosion")
			var ring := game.vfx.add(TdVfx.Kind.RING, at, r, TdVfxData.RING_TIME, TdVfxData.SPELLS[id]["tint"])  # The REAL radius.
			if ring != null:
				ring.size0 = r * 0.3
			game.vfx.shake(2.0)


func draw(ci: CanvasItem) -> void:
	var tg := SpriteBank.texture("telegraphs/target")  # Landing circle.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var r := float(row["radius"])  # Blast radius (px).
	for b: Array in _balls:
		var at: Vector2 = b[0]
		var p := clampf((game.time - float(b[2])) / maxf(float(b[1]) - float(b[2]), 0.01), 0.0, 1.0)  # 0..1 to landing.
		if tg != null:
			ci.draw_texture_rect(tg, Rect2(at - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, 0.35 + 0.55 * p))
		var fall := at + Vector2(0, -TdVfxData.TIDE_FALL_H * (1.0 - p))  # The ball dropping from the sky (drawn only).
		SpriteBank.draw_flat(ci, "projectiles/iron_shell", fall, PI * 0.5, Color.WHITE, TdVfxData.TIDE_CANNONBALL_SCALE)


func busy() -> bool:
	return not _balls.is_empty()
