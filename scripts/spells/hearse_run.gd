## Hearse Run (Act IV spell, unlocked by Don Marrow; Necropathy HearseRun "a
## spectral hearse drives a lane through the enemies"): tapped on a road
## (within `max_snap` px), a spectral hearse drives from that point back up
## the road toward its entrance, `length` px in `drive_time` s. Every enemy
## within `hit_radius` px of it is run over once: `damage` (TdCombat) and
## staggered `stagger` s (no attacks). Flyers pass above it. `hearses` per
## cast, `hearse_gap` s apart (the Undertaker's Last Ride adds
## `hearse_extra`). Row: SpellData "hearse_run".
extends TdSpell

## Live hearses: [road id, start px along it, end px, start game s, hit: Dictionary TdEnemy -> generation].
var _hearses: Array = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var d := road.project(pos)  # Where it starts (px along the road).
	var n := roundi(float(row["hearses"])) + int(CharacterModifiers.innate("hearse_extra", 0))  # Hearses this cast.
	for i in n:
		_hearses.append([road.id, d, maxf(d - float(row["length"]), 0.0), game.time + float(row["hearse_gap"]) * float(i), {}])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	var dur := float(row["drive_time"])  # Drive length (s).
	for i in range(_hearses.size() - 1, -1, -1):
		var h: Array = _hearses[i]
		var f := (game.time - float(h[3])) / dur  # 0..1 through the drive.
		if f < 0.0:
			continue
		if f > 1.0:
			_hearses.remove_at(i)
			continue
		var p := _pos(h, f)  # Where it is.
		var hit: Dictionary = h[4]
		for e: TdEnemy in game.foes_near(p, float(row["hit_radius"])):
			if bool(e.row["flying"]) or (hit.has(e) and int(hit[e]) == e.generation):
				continue
			hit[e] = e.generation
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			if e.alive:
				TdCombat.stagger_enemy(game, e, float(row["stagger"]))
			game.stats["hearse_hits"] = int(game.stats.get("hearse_hits", 0)) + 1
			if game.vfx.on:
				game.vfx.add(TdVfx.Kind.ANIM, e.position, TdVfxData.CITY_HEARSE_HIT_D, TdVfxData.IMPACT_TIME, TdVfxData.SPELLS[id]["tint"], "volley_hit")


## Map px of hearse `h` at fraction `f` of its drive.
func _pos(h: Array, f: float) -> Vector2:
	var r: Road = game.roads[String(h[0])]
	return r.point_at(lerpf(float(h[1]), float(h[2]), f))


func draw(ci: CanvasItem) -> void:
	var tex := SpriteBank.texture(TdVfxData.CITY_HEARSE_SPRITE)  # The spectral hearse (faces right).
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for h: Array in _hearses:
		var f := (game.time - float(h[3])) / float(row["drive_time"])  # 0..1.
		if f < 0.0 or f > 1.0:
			continue
		var r: Road = game.roads[String(h[0])]
		var d := lerpf(float(h[1]), float(h[2]), f)  # Px along the road.
		var p := r.point_at(d)  # Where it is.
		var dir := -r.dir_at(d)  # It drives against the road's flow.
		var fade := minf(minf(f, 1.0 - f) / TdVfxData.CITY_HEARSE_FADE, 1.0)  # Fades in and out.
		if tex == null:
			continue
		SpriteBank.apply_sharp(ci)
		var flip := dir.x < -0.1  # Facing left.
		var ang := 0.0 if absf(dir.x) >= absf(dir.y) else (PI * 0.5 if dir.y > 0.0 else -PI * 0.5)  # Turned for vertical streets.
		ci.draw_set_transform(p + Vector2(0, TdVfxData.CITY_HEARSE_LIFT), ang, Vector2(-1.0 if flip else 1.0, 1.0))
		ci.draw_texture_rect(tex, Rect2(-tex.get_size() * 0.5, tex.get_size()), false, Color(tint, TdVfxData.CITY_HEARSE_ALPHA * fade))
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func busy() -> bool:
	return not _hearses.is_empty()
