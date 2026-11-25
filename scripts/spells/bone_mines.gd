## Bone Mines (Act IV spell, unlocked by General Harrow; Necropathy BoneMines
## "bone mines ... triggered by enemies"): tapped on a road (within
## `max_snap` px), `mines` bone mines are laid along it centred on the tap,
## `spacing` px apart (the Fallen Sergeant's Sapper's Hands adds
## `mines_extra`). A mine arms after `arm` s; the first walking enemy whose
## body comes within `trigger` px sets it off: `damage` to every walking enemy
## within `blast_radius` px (TdCombat; flyers neither trigger nor take it).
## An unexploded mine crumbles after `life` s; at most `max_mines` lie at once
## (the oldest is dropped). Row: SpellData "bone_mines".
extends TdSpell

## Mines on the road: [map px, armed game s, crumbles game s].
var _mines: Array = []
## Recent blasts (drawn only): [map px, game s].
var _blasts: Array = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var n := roundi(float(row["mines"])) + int(CharacterModifiers.innate("mines_extra", 0))  # Mines this cast.
	var d0 := road.project(pos) - float(row["spacing"]) * float(n - 1) * 0.5  # First mine (px along the road).
	for i in n:
		var d := clampf(d0 + float(row["spacing"]) * float(i), 0.0, road.length)  # Along the road (px).
		_mines.append([road.point_at(d), game.time + float(row["arm"]), game.time + float(row["life"])])
	while _mines.size() > int(row["max_mines"]):
		_mines.pop_front()
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_mines.size() - 1, -1, -1):
		var m: Array = _mines[i]
		if game.time >= float(m[2]):
			_mines.remove_at(i)
			continue
		if game.time < float(m[1]) or not _walker_near(m[0], float(row["trigger"])):
			continue
		_mines.remove_at(i)
		for e: TdEnemy in game.foes_near(m[0], float(row["blast_radius"])):
			if not bool(e.row["flying"]):
				TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": m[0]})
		game.stats["mines_blown"] = int(game.stats.get("mines_blown", 0)) + 1
		if game.vfx.on:
			_blasts.append([m[0], game.time])
			game.vfx.add(TdVfx.Kind.ANIM, m[0], float(row["blast_radius"]) * 2.4, TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "corpse_explosion")
			var ring := game.vfx.add(TdVfx.Kind.RING, m[0], float(row["blast_radius"]), TdVfxData.RING_TIME, TdVfxData.SPELLS[id]["tint"])
			if ring != null:
				ring.size0 = 8.0
			game.vfx.shake(TdVfxData.LOB_SHAKE)
	for i in range(_blasts.size() - 1, -1, -1):
		if game.time - float(_blasts[i][1]) > TdVfxData.CRACK_TIME:
			_blasts.remove_at(i)


## True when a walking (not flying) enemy's body is within `r` px of `p`.
func _walker_near(p: Vector2, r: float) -> bool:
	for e: TdEnemy in game.foes_near(p, r + float(row["body_pad"])):
		if not bool(e.row["flying"]) and e.position.distance_to(p) <= r + e.radius:
			return true
	return false


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for m: Array in _mines:
		var p: Vector2 = m[0]
		if not SpriteBank.draw(ci, TdVfxData.CITY_MINE_SPRITE, p, false):
			SpriteBank.draw_disc(ci, p, 5.0, Color(0.9, 0.86, 0.75))
		var armed := game.time >= float(m[1])  # Its lamp blinks once armed.
		var a := (0.5 + 0.5 * sin(game.time * TAU * TdVfxData.CITY_MINE_BLINK_HZ)) if armed else 0.25  # Lamp alpha (drawn only).
		SpriteBank.draw_disc(ci, p + Vector2(0, -3), TdVfxData.CITY_MINE_LAMP_R, Color(tint, a))


func busy() -> bool:
	return not _mines.is_empty() or not _blasts.is_empty()
