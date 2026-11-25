## Banner of the Dead (Act V spell, Shogun Kurogane's reward; Necropathy's
## Banner of the Dead, "summons near it attack faster"): a war banner planted
## at the tap; every tower within `radius` px attacks `rate_mult` x faster for
## `duration` s (TdCombat.rally_tower, read by Tower.recompute()). Towers built
## near it later are not rallied. Row: SpellData "banner_of_the_dead".
extends TdSpell

## Planted banners: [map px, end game s, start game s].
var _banners: Array = []


func cast(pos: Vector2) -> bool:
	var n := 0  # Towers rallied.
	for t: Tower in game.towers:
		if t.position.distance_to(pos) <= float(row["radius"]):
			TdCombat.rally_tower(game, t, float(row["rate_mult"]), float(row["duration"]))
			n += 1
	if n == 0:
		return false
	game.stats["banner_rallied"] = int(game.stats.get("banner_rallied", 0)) + n
	_banners.append([pos, game.time + float(row["duration"]), game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_banners.size() - 1, -1, -1):
		if game.time >= float(_banners[i][1]):
			_banners.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("shogunate")["LOOK"]
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var ring := TdArt.texture("range_ring")  # The banner's real reach.
	var r := float(row["radius"])  # Reach (px).
	for b: Array in _banners:
		var left := clampf((float(b[1]) - game.time) / 0.5, 0.0, 1.0)  # Fades out at the end.
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(Vector2(b[0]) - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, 0.6 * left))
		SpriteBank.draw_flat(ci, "markers/rally_pennant", Vector2(b[0]) + Vector2(0, -float(lk["banner_lift"])), 0.0, Color(tint, left), float(lk["banner_scale"]))


func busy() -> bool:
	return not _banners.is_empty()
