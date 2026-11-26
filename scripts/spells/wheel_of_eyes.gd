## Wheel of Eyes (Act X spell, the Throne's reward; Necropathy's Wheel of Eyes,
## "a burning wheel rolls out in a line and rebounds"): a wheel of burning eyes
## sets down on the road at the tap (within `max_snap` px) and rolls back along
## it toward the entrance at `speed` px/s for `length` px, then rebounds and
## rolls back to where it started (`rebounds` times; the Blind Saint's innate
## adds `wheel_rebounds`): every foe it passes within `width` px takes
## `damage`, once per pass. Row: SpellData "wheel_of_eyes".
extends TdSpell

## Live wheels: {road: Road, d0: px start, d: px now, dir: -1 toward the
## entrance / +1 back, left: passes left, hit: Array of [TdEnemy, gen] this pass}.
var _wheels: Array[Dictionary] = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap.
	if road == null:
		return false
	var d := road.project(pos)  # Px along it.
	var passes := 1 + roundi(float(row["rebounds"])) + int(CharacterModifiers.innate("wheel_rebounds", 0))  # Passes this cast.
	_wheels.append({"road": road, "d0": d, "d": d, "dir": -1.0, "left": passes, "hit": []})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(dt: float) -> void:
	for i in range(_wheels.size() - 1, -1, -1):
		var w: Dictionary = _wheels[i]
		var rd: Road = w["road"]
		w["d"] = float(w["d"]) + float(w["dir"]) * float(row["speed"]) * dt
		var end := maxf(float(w["d0"]) - float(row["length"]), 0.0)  # Far end of the pass.
		if (float(w["dir"]) < 0.0 and float(w["d"]) <= end) or (float(w["dir"]) > 0.0 and float(w["d"]) >= float(w["d0"])):
			w["left"] = int(w["left"]) - 1
			w["dir"] = -float(w["dir"])
			w["hit"] = []
			if int(w["left"]) <= 0:
				_wheels.remove_at(i)
				continue
			game.fx.spawn("volley_flash", rd.point_at(float(w["d"])), 60.0, 0.3, TdVfxData.SPELLS[id]["tint"])
		var p := rd.point_at(clampf(float(w["d"]), 0.0, rd.length))  # Where it rolls now.
		var hit: Array = w["hit"]
		for e: TdEnemy in game.foes_near(p, float(row["width"])):
			if hit.any(func(h: Array) -> bool: return h[0] == e and int(h[1]) == e.generation):
				continue
			hit.append([e, e.generation])
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			game.stats["wheel_hits"] = int(game.stats.get("wheel_hits", 0)) + 1


func draw(ci: CanvasItem) -> void:
	var px := float(Acts.data("host")["LOOK"]["wheel_px"])  # Drawn size.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for w: Dictionary in _wheels:
		var rd: Road = w["road"]
		var p := rd.point_at(clampf(float(w["d"]), 0.0, rd.length))
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(px, px), Vector2(px, px) * 2.0), false, Color(tint, 0.6))
		var rect := Rect2(p - Vector2(px, px) * 0.6, Vector2(px, px) * 1.2)
		if not SpriteBank.draw_icon_art(ci, "wheel_of_eyes", rect):
			SpriteBank.draw_disc(ci, p, px * 0.5, tint)


func busy() -> bool:
	return not _wheels.is_empty()
