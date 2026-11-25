## Black Sun (Act V spell, Amaterasu's reward; Necropathy's Black Sun, "a dark
## sun fires a short beam at the nearest group"): a dark sun hangs over the
## tap for `duration` s; every `tick` s it beams the foe in reach (`radius` px)
## with the most foes around it: `damage` to it and to every foe within
## `splash` px of it (TdCombat). Row: SpellData "black_sun".
extends TdSpell

## Live suns: [map px, end game s, next beam game s, start game s].
var _suns: Array = []


func cast(pos: Vector2) -> bool:
	_suns.append([pos, game.time + float(row["duration"]), game.time + float(row["tick"]) * 0.5, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_suns.size() - 1, -1, -1):
		var s: Array = _suns[i]
		if game.time >= float(s[1]):
			_suns.remove_at(i)
			continue
		if game.time < float(s[2]):
			continue
		s[2] = game.time + float(row["tick"])
		var best: TdEnemy = null  # Densest foe in reach.
		var best_n := -1  # Foes around it.
		for e: TdEnemy in game.foes_near(s[0], float(row["radius"])):
			var n := game.foes_near(e.position, float(row["splash"])).size()  # Its group.
			if n > best_n:
				best_n = n
				best = e
		if best == null:
			continue
		var at := best.position  # Where the beam falls.
		for e: TdEnemy in game.foes_near(at, float(row["splash"])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": s[0]})
		game.stats["black_sun_beams"] = int(game.stats.get("black_sun_beams", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			var f := game.vfx.add(TdVfx.Kind.STREAK, at, float(Acts.data("shogunate")["LOOK"]["beam_w"]), 0.3, tint)
			if f != null:
				f.ang = (at - Vector2(s[0])).angle()
				f.size0 = Vector2(s[0]).distance_to(at)
			game.vfx.add(TdVfx.Kind.ANIM, at, float(row["splash"]) * 2.0, TdVfxData.IMPACT_TIME, tint, "volley_flash")


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("shogunate")["LOOK"]
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var d := float(lk["black_sun_d"])  # Disc diameter (px).
	var ring := TdArt.texture("range_ring")  # The sun's real reach.
	var rr := float(row["radius"])
	for s: Array in _suns:
		var left := clampf((float(s[1]) - game.time) / 0.5, 0.0, 1.0)  # Fades at the end.
		var pulse := 1.0 + 0.08 * sin((game.time - float(s[3])) * 6.0)  # Corona pulse.
		var p: Vector2 = s[0]
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(d, d) * pulse, Vector2(d, d) * 2.0 * pulse), false, Color(tint, 0.7 * left))
		SpriteBank.draw_disc(ci, p, d * 0.42, Color(0.03, 0.0, 0.06, left))
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(p - Vector2(rr, rr), Vector2(rr, rr) * 2.0), false, Color(tint, 0.35 * left))


func busy() -> bool:
	return not _suns.is_empty()
