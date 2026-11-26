## Pack Leap (Act XIV spell, Scarmaw's reward; Necropathy's Pack Leap, "a pack
## of bone raptors leaps on the strongest foes"): `raptors` raptors (the Fern
## Huntress's innate adds `leap_extra`) each leap on one of the strongest foes
## within `radius` px of the tap (most HP first; with fewer foes, the strongest
## takes the rest), landing `leap_time` s later: `damage` and a bleed of
## `bleed_dps` for `bleed_time` s (TdCombat.add_dot). Nothing in reach: no cast.
## Row: SpellData "pack_leap".
extends TdSpell

## Leaping raptors: [TdEnemy, its generation, last known map px, landing game s, start px].
var _leaps: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := int(row["raptors"]) + int(CharacterModifiers.innate("leap_extra", 0))  # Raptors this cast.
	for i in n:
		var e: TdEnemy = foes[i % foes.size()]
		var from := pos + Vector2(cos(float(i) * 2.1), sin(float(i) * 2.1)) * float(row["radius"])  # Where it springs from (drawn).
		_leaps.append([e, e.generation, e.position, game.time + float(row["leap_time"]), from])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_leaps.size() - 1, -1, -1):
		var l: Array = _leaps[i]
		var e: TdEnemy = l[0]
		var ok := TdEnemy.valid(e, int(l[1]))
		if ok:
			l[2] = e.position
		if game.time < float(l[3]):
			continue
		_leaps.remove_at(i)
		if ok:
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": l[2]})
			if e.alive:
				TdCombat.add_dot(game, e, float(row["bleed_dps"]), float(row["bleed_time"]), id)
			game.stats["pack_leap_bites"] = int(game.stats.get("pack_leap_bites", 0)) + 1
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, l[2], float(Acts.data("primeval")["LOOK"]["leap_d"]), 0.35, TdVfxData.SPELLS[id]["tint"], "volley_hit")


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for l: Array in _leaps:
		var k := 1.0 - clampf((float(l[3]) - game.time) / float(row["leap_time"]), 0.0, 1.0)  # 0..1 through the leap.
		var p: Vector2 = (l[4] as Vector2).lerp(l[2], k) - Vector2(0, sin(k * PI) * 30.0)  # An arc through the air.
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(18, 18), Vector2(36, 36)), false, Color(tint, 0.6))
		var rect := Rect2(p - Vector2(13, 13), Vector2(26, 26))
		if not SpriteBank.draw_icon_art(ci, "pack_leap", rect):
			SpriteBank.draw_disc(ci, p, 8.0, tint)


func busy() -> bool:
	return not _leaps.is_empty()
