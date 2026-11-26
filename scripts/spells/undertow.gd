## Undertow (Act XI spell, Abbot Merrow's reward; Necropathy's Undertow, "a
## wave rolls out and shoves enemies back; it leaves shallow water that
## slows"): a wave sets down on the road at the tap (within `max_snap` px) and
## rolls back along it toward the entrance at `speed` px/s for `length` px:
## every foe it passes within `width` px takes `damage` once and is shoved
## `push` px back (TdCombat.knock_enemy: not bosses, minibosses, flyers). The
## stretch it rolled stays SHALLOWS for `shallows` s (x the Brine Widow's
## innate shallows_time): foes on it are slowed to `slow`
## (TdCombat.slow_enemy). Row: SpellData "undertow".
extends TdSpell

## Live waves: {road: Road, d0: px start, d: px now, hit: Array of [TdEnemy, gen]}.
var _waves: Array[Dictionary] = []
## Shallows: [Road, px from, px to, end game s].
var _shallows: Array = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap.
	if road == null or road.off_road:
		return false
	var d := road.project(pos)  # Px along it.
	_waves.append({"road": road, "d0": d, "d": d, "hit": []})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(dt: float) -> void:
	for i in range(_waves.size() - 1, -1, -1):
		var w: Dictionary = _waves[i]
		var rd: Road = w["road"]
		w["d"] = float(w["d"]) - float(row["speed"]) * dt
		var end := maxf(float(w["d0"]) - float(row["length"]), 0.0)  # Far end.
		var p := rd.point_at(maxf(float(w["d"]), end))  # The crest now.
		var hit: Array = w["hit"]
		for e: TdEnemy in game.foes_near(p, float(row["width"])):
			if hit.any(func(h: Array) -> bool: return h[0] == e and int(h[1]) == e.generation):
				continue
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			if e.alive:
				TdCombat.knock_enemy(game, e, float(row["push"]))
				hit.append([e, e.generation])
			game.stats["undertow_hits"] = int(game.stats.get("undertow_hits", 0)) + 1
		if float(w["d"]) <= end:
			_shallows.append([rd, end, float(w["d0"]), game.time + float(row["shallows"]) * float(CharacterModifiers.innate("shallows_time", 1.0))])
			_waves.remove_at(i)
	for i in range(_shallows.size() - 1, -1, -1):
		var s: Array = _shallows[i]
		if game.time >= float(s[3]):
			_shallows.remove_at(i)
			continue
		var rd: Road = s[0]
		for e: TdEnemy in game.enemies:
			if e.follower.road == rd and e.follower.dist >= float(s[1]) and e.follower.dist <= float(s[2]) and not bool(e.row.get("flying", false)):
				TdCombat.slow_enemy(game, e, float(row["slow"]), 0.3)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var soft := TdVfx._soft()
	for s: Array in _shallows:
		var rd: Road = s[0]
		var d := float(s[1])
		var fade := clampf((float(s[3]) - game.time) / 1.0, 0.0, 1.0)  # Its last second.
		while d <= float(s[2]):
			var p := rd.point_at(d)
			ci.draw_texture_rect(soft, Rect2(p - Vector2(28, 18), Vector2(56, 36)), false, Color(lk["shallow_tint"], (lk["shallow_tint"] as Color).a * fade))
			d += 28.0
	var crest := SpriteBank.texture("overlays/undertow_crest")  # The rolling crest art.
	var ww := float(lk["wave_w"])
	for w: Dictionary in _waves:
		var rd: Road = w["road"]
		var dd := maxf(float(w["d"]), 0.0)
		var p := rd.point_at(dd)
		ci.draw_texture_rect(soft, Rect2(p - Vector2(ww, ww), Vector2(ww, ww) * 2.0), false, Color(tint, 0.6))
		if crest != null:
			ci.draw_set_transform(p, (-rd.dir_at(dd)).angle(), Vector2.ONE)
			ci.draw_texture_rect(crest, Rect2(Vector2(-ww * 0.5, -ww), Vector2(ww, ww * 2.0)), false)
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func busy() -> bool:
	return not _waves.is_empty() or not _shallows.is_empty()
