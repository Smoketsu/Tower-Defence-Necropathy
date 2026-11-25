## Hex Circle (Act III, the Witchwood's spell, id "witch_circle"; Necropathy:
## "a crimson circle that drains every enemy inside"): a circle of `radius` px
## (+ the Hedge Witch's innate "circle_radius" share) at the tap for `duration`
## s. Every `tick` s every enemy inside takes `drain` (damage over time), and
## `heal_share` of what it drained is split among the living blocker bodies
## inside (TdCombat.heal_body). Row: SpellData "witch_circle".
extends TdSpell

## Live circles: [map px, radius px, end game s, next tick game s].
var _circles: Array = []


func cast(pos: Vector2) -> bool:
	var r := float(row["radius"]) * (1.0 + float(CharacterModifiers.innate("circle_radius", 0.0)))  # Its radius.
	_circles.append([pos, r, game.time + float(row["duration"]), game.time + float(row["tick"])])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_circles.size() - 1, -1, -1):
		var c: Array = _circles[i]
		if game.time >= float(c[2]):
			_circles.remove_at(i)
			continue
		if game.time < float(c[3]):
			continue
		c[3] = float(c[3]) + float(row["tick"])
		var drained := 0.0  # Damage done this tick.
		for e: TdEnemy in game.foes_near(c[0], float(c[1])):
			drained += TdCombat.damage_enemy(game, e, float(row["drain"]), {"source": id, "dot": true})
		var bodies := game.bodies_near(c[0], float(c[1]))  # Blockers inside.
		if drained <= 0.0 or bodies.is_empty():
			continue
		var healed := 0.0  # HP restored.
		for b: BlockBody in bodies:
			healed += TdCombat.heal_body(game, b, drained * float(row["heal_share"]) / float(bodies.size()))
		game.stats["hex_healed"] = float(game.stats.get("hex_healed", 0.0)) + healed


func draw(ci: CanvasItem) -> void:
	var tex := MapView.grid_texture(CovenantField.ZONE_TEX)  # Disc art.
	if tex == null:
		return
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for c: Array in _circles:
		var r := float(c[1])  # Radius (px).
		var pulse := 0.75 + 0.25 * cos((float(c[3]) - game.time) / TdVfxData.COURT_CIRCLE_PERIOD * TAU)  # Brightest on each tick.
		ci.draw_texture_rect(tex, Rect2(c[0] - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(tint, TdVfxData.COURT_CIRCLE_A * pulse))


func busy() -> bool:
	return not _circles.is_empty()
