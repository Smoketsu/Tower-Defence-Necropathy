## Root and Rot (Act XV spell, the Green Mother's reward; Necropathy's Root and
## Rot, "roots hold the foes and the rot takes them"): roots burst from the
## earth round the tap: every foe within `radius` px that walks (not a flyer,
## not a structure) is held `root` s (TdCombat.freeze_enemy, rank multipliers
## apply) and every foe there rots: `rot_dps` (x the Gravegardener's innate
## "rot_mult") damage per s for `rot_time` s (TdCombat.add_dot). Nobody there:
## no cast. Row: SpellData "root_and_rot".
extends TdSpell

## Bursts drawn: [map px, game s cast].
var _bursts: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Who the roots reach.
	if foes.is_empty():
		return false
	var dps := float(row["rot_dps"]) * float(CharacterModifiers.innate("rot_mult", 1.0))  # Rot per s.
	for e: TdEnemy in foes:
		if not bool(e.row.get("flying", false)) and not bool(e.row.get("structure", false)):
			TdCombat.freeze_enemy(game, e, float(row["root"]))
		TdCombat.add_dot(game, e, dps, float(row["rot_time"]), id)
	game.stats["rotted"] = int(game.stats.get("rotted", 0)) + foes.size()
	_bursts.append([pos, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_bursts.size() - 1, -1, -1):
		if game.time > float(_bursts[i][1]) + 0.8:
			_bursts.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var r := float(row["radius"])
	var ring := TdArt.texture("range_ring")  # Its real reach.
	for b: Array in _bursts:
		var k := 1.0 - clampf((game.time - float(b[1])) / 0.8, 0.0, 1.0)  # Fades.
		var p: Vector2 = b[0]
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(r, r * 0.7), Vector2(r, r * 0.7) * 2.0), false, Color(0.35, 0.25, 0.1, 0.5 * k))
		SpriteBank.draw_anim(ci, "wild_bury", p, r * 2.0, 1.0 - k, k, tint)
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(p - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, k))


func busy() -> bool:
	return not _bursts.is_empty()
