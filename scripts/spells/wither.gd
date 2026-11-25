## Wither (GDD §5 "aura on a chosen plot that shreds armour"): set on the spot
## nearest the tap (within `pick_radius` px), it withers everything within
## `radius` px for `duration` s: every `tick` s each enemy inside has its flat
## armour shredded by `shred` (TdCombat.shred_enemy, a little longer than a
## tick, so it lapses outside) and takes `dps` wither damage over time; the
## Wither Witch's Creeping Rot adds `wither_rot` Rot per s (CharacterModifiers).
## Several casts may stand at once. Row: SpellData "wither".
extends TdSpell

## Live auras: [map px, end game s, next tick game s, start game s].
var _auras: Array = []


func cast(pos: Vector2) -> bool:
	var best: Spot = null  # Spot nearest the tap.
	for s: Spot in game.spots:
		if s.position.distance_to(pos) <= float(row["pick_radius"]) and (best == null or s.position.distance_to(pos) < best.position.distance_to(pos)):
			best = s
	if best == null:
		return false
	_auras.append([best.position, game.time + float(row["duration"]), game.time, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	var tick := float(row["tick"])  # Pulse spacing (s).
	var rot := float(CharacterModifiers.innate("wither_rot", 0.0)) + float(row["rot_dps"])  # Creeping Rot per s.
	for i in range(_auras.size() - 1, -1, -1):
		var a: Array = _auras[i]
		if game.time >= float(a[1]):
			_auras.remove_at(i)
			continue
		if game.time < float(a[2]):
			continue
		a[2] = float(a[2]) + tick
		for e: TdEnemy in game.foes_near(a[0], float(row["radius"])):
			TdCombat.shred_enemy(game, e, float(row["shred"]), tick * 1.5)
			TdCombat.add_dot(game, e, float(row["dps"]), tick, id)
			if rot > 0.0:
				TdCombat.add_dot(game, e, rot, tick, "creeping_rot")
			e.vis_field_until = game.time + TdVfxData.FIELD_STATUS_TIME  # Its rot mark (drawn only).
			e.vis_field_look = "plague"
			game.stats["withered"] = int(game.stats.get("withered", 0)) + 1


func draw(ci: CanvasItem) -> void:
	var r := float(row["radius"])  # Aura radius (px).
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var ring := TdArt.texture("range_ring")  # The aura's real edge.
	for a: Array in _auras:
		var left := clampf((float(a[1]) - game.time) / 0.6, 0.0, 1.0)  # Fades out at the end.
		var prog := fmod((game.time - float(a[3])) / TdVfxData.KIT_WITHER_PERIOD, 1.0)  # Strip loop 0..1.
		SpriteBank.draw_anim(ci, "wither_aura", a[0], r * 2.0, prog, TdVfxData.KIT_WITHER_A * left, Color.WHITE)
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(Vector2(a[0]) - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, 0.8 * left))


func busy() -> bool:
	return not _auras.is_empty()
