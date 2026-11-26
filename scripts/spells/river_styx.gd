## River Styx (Act VIII spell, Hades' reward; Necropathy's RiverStyx: "a river
## line across the foe's way that hurts and slows whatever crosses it"): a band
## of black water `length` px (x 1 + the Ferrywoman's `styx_length`) along the
## road nearest the tap (within `max_snap` px) flows `duration` s; every
## `tick` s every foe within `radius` px of its course takes `damage` (damage
## over time: armour and shields do not stop it) and is slowed to `slow` for
## `slow_time` s (TdCombat). The Ferrywoman's innate (Ferry of Souls,
## `ferry_risen`): a foe slain by the river rises as a Risen there (TempBlockers:
## `risen_hp`, hold 1, `risen_damage` every `risen_interval` s, `risen_time` s).
## Row: SpellData "river_styx".
extends TdSpell

## Live rivers: [Road, from px, to px, end game s, next tick game s, start game s].
var _rivers: Array = []
## Ferry of Souls' Risen (made on first use).
var _risen: TempBlockers = null


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var mid := road.project(pos)  # Centre along the road (px).
	var half := float(row["length"]) * (1.0 + float(CharacterModifiers.innate("styx_length", 0.0))) * 0.5  # Half its length (px).
	_rivers.append([road, maxf(mid - half, 0.0), minf(mid + half, road.length), game.time + float(row["duration"]), game.time, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	if _risen != null:
		_risen.step()
	for i in range(_rivers.size() - 1, -1, -1):
		var rv: Array = _rivers[i]
		if game.time >= float(rv[3]):
			_rivers.remove_at(i)
			continue
		if game.time < float(rv[4]):
			continue
		rv[4] = game.time + float(row["tick"])
		var road: Road = rv[0]
		var rad := float(row["radius"])  # Reach from its course (px).
		var mid := road.point_at((float(rv[1]) + float(rv[2])) * 0.5)  # Its middle.
		for e: TdEnemy in game.foes_near(mid, (float(rv[2]) - float(rv[1])) * 0.5 + rad):
			var d := road.project(e.position)  # Its place along the river's road.
			if d < float(rv[1]) or d > float(rv[2]) or road.point_at(d).distance_to(e.position) > rad:
				continue
			var at := e.position  # Where it fell, if it falls.
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "dot": true})
			if e.alive:
				TdCombat.slow_enemy(game, e, float(row["slow"]), float(row["slow_time"]))
				game.stats["styx_slowed"] = int(game.stats.get("styx_slowed", 0)) + 1
			elif bool(CharacterModifiers.innate("ferry_risen", false)) and not road.off_road:
				if _risen == null:
					_risen = TempBlockers.new(game)
				_risen.raise(road.id, road.project(at), 1, float(row["risen_hp"]), 1, float(row["risen_damage"]),
						float(row["risen_interval"]), float(row["risen_time"]), id)


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var soft := TdVfx._soft()  # Water blob.
	var rad := float(row["radius"])  # Half its width (px).
	var step_px := float(row["blob_step"])  # Px between drawn blobs.
	for rv: Array in _rivers:
		var road: Road = rv[0]
		var left := clampf((float(rv[3]) - game.time) / 0.6, 0.0, 1.0)  # Fades at the end.
		var grow := clampf((game.time - float(rv[5])) / 0.4, 0.0, 1.0)  # Floods in.
		var d := float(rv[1])  # Drawn so far (px).
		while d <= float(rv[2]):
			var p := road.point_at(d)  # Blob centre.
			var wob := sin(game.time * 3.0 + d * 0.05) * 3.0  # Its slow swell (drawn only).
			ci.draw_texture_rect(soft, Rect2(p - Vector2(rad, rad) * grow - Vector2(wob, wob), (Vector2(rad, rad) * grow + Vector2(wob, wob)) * 2.0), false, Color(0.05, 0.07, 0.12, 0.75 * left))
			ci.draw_texture_rect(soft, Rect2(p - Vector2(rad, rad) * 0.6 * grow, Vector2(rad, rad) * 1.2 * grow), false, Color(tint, 0.35 * left))
			d += step_px


func busy() -> bool:
	return not _rivers.is_empty() or (_risen != null and _risen.busy())
