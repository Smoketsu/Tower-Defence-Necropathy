## Stampede (Act XIV spell, Old Ironbrow's reward; Necropathy's Stampede, "a
## spectral herd thunders down a line"): a spectral herd sets down on the road
## at the tap (within `max_snap` px) and runs back along it toward the entrance
## at `speed` px/s for `length` px: every foe within `width` px of its front
## takes `damage` and is thrown back `knock` px (TdCombat.knock_enemy; bosses,
## minibosses and flyers stand firm), once each. Row: SpellData "stampede".
extends TdSpell

## Live herds: {road: Road, d0: px start, d: px now, hit: Array of [TdEnemy, gen]}.
var _herds: Array[Dictionary] = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap.
	if road == null:
		return false
	var d := road.project(pos)
	_herds.append({"road": road, "d0": d, "d": d, "hit": []})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(dt: float) -> void:
	for i in range(_herds.size() - 1, -1, -1):
		var h: Dictionary = _herds[i]
		var rd: Road = h["road"]
		h["d"] = float(h["d"]) - float(row["speed"]) * dt
		if float(h["d"]) <= maxf(float(h["d0"]) - float(row["length"]), 0.0):
			_herds.remove_at(i)
			game.fx.spawn("golem_slam", rd.point_at(maxf(float(h["d"]), 0.0)), 70.0, 0.35, TdVfxData.SPELLS[id]["tint"])
			continue
		var p := rd.point_at(float(h["d"]))  # The herd's front.
		var hit: Array = h["hit"]
		for e: TdEnemy in game.foes_near(p, float(row["width"])):
			if hit.any(func(x: Array) -> bool: return x[0] == e and int(x[1]) == e.generation):
				continue
			hit.append([e, e.generation])
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			if e.alive:
				TdCombat.knock_enemy(game, e, float(row["knock"]))
			game.stats["stampede_hits"] = int(game.stats.get("stampede_hits", 0)) + 1


func draw(ci: CanvasItem) -> void:
	var px := float(Acts.data("primeval")["LOOK"]["herd_px"])  # Drawn size.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for h: Dictionary in _herds:
		var rd: Road = h["road"]
		for j in 3:  # Three spectral beasts, the front one biggest.
			var p := rd.point_at(clampf(float(h["d"]) + float(j) * px * 0.9, 0.0, rd.length)) + Vector2(0, float(j % 2) * 8.0 - 4.0)
			var s := px * (1.0 - 0.15 * float(j))
			ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(s, s), Vector2(s, s) * 2.0), false, Color(tint, 0.45))
			if not SpriteBank.draw_icon_art(ci, "stampede", Rect2(p - Vector2(s, s) * 0.6, Vector2(s, s) * 1.2)):
				SpriteBank.draw_disc(ci, p, s * 0.4, tint)


func busy() -> bool:
	return not _herds.is_empty()
