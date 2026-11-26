## Gungnir (Act VI spell, Odin's reward; Necropathy's Gungnir, "a spear thrown
## at the strongest enemy that pierces everything in its line"): from the
## necromancer (the gate, TdGame.necromancer_pos()) a spear of soul-light flies
## `length` px at once through the foe with the most HP within `aim` px of the
## tap (one more spear at the next strongest for each of `spears` beyond the
## first, + the Berserker's `gungnir_spears`) and strikes EVERY foe whose body
## lies within `width` px of its line for `damage` (TdCombat; no shield or body
## stops it). No foe in reach: nothing (no cooldown). Row: SpellData "gungnir".
extends TdSpell

## Spear lines showing: [from map px, to map px, game s thrown].
var _lines: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["aim"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return x.hp > y.hp)
	var n := mini(roundi(float(row["spears"])) + int(CharacterModifiers.innate("gungnir_spears", 0)), foes.size())  # Spears this cast.
	var from := game.necromancer_pos()  # Thrown from the gate.
	for k in n:
		var dir := (foes[k].position - from).normalized()  # Its line.
		var to := from + dir * float(row["length"])
		var hits := 0  # Foes struck by this spear.
		for e: TdEnemy in game.enemies.duplicate():
			if not e.alive or bool(e.row.get("structure", false)):
				continue  # The one structure rule: area hits pass structures.
			var q := Geometry2D.get_closest_point_to_segment(e.position, from, to)  # Nearest point of the line.
			if q.distance_to(e.position) <= float(row["width"]) + e.radius:
				TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": from})
				hits += 1
		game.stats["gungnir_hits"] = int(game.stats.get("gungnir_hits", 0)) + hits
		_lines.append([from, to, game.time])
		if game.vfx.on:
			var lk: Dictionary = Acts.data("norse")["LOOK"]
			var f := game.vfx.add(TdVfx.Kind.STREAK, (from + to) * 0.5, float(lk["spear_w"]) * 1.4, 0.35, lk["spear_tint"])
			if f != null:
				f.ang = dir.angle()
				f.size0 = float(row["length"])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_lines.size() - 1, -1, -1):
		if game.time - float(_lines[i][2]) > float(Acts.data("norse")["LOOK"]["spear_show"]):
			_lines.remove_at(i)


func draw(ci: CanvasItem) -> void:
	for l: Array in _lines:
		var left := 1.0 - (game.time - float(l[2])) / float(Acts.data("norse")["LOOK"]["spear_show"])  # Fades.
		SpriteBank.draw_flat(ci, "projectiles/bone_spear", Vector2(l[0]).lerp(l[1], clampf(1.0 - left, 0.0, 1.0)), (Vector2(l[1]) - Vector2(l[0])).angle(), Color(0.8, 0.95, 1.0, left), 2.4)


func busy() -> bool:
	return not _lines.is_empty()
