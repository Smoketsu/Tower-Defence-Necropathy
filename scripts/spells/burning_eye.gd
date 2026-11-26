## Burning Eye (Act VII spell, Sekhmet's reward; Necropathy's Burning Eye: "a
## solar eye fires a beam that sweeps an arc"): a solar eye opens over the tap
## for `duration` s. Its beam (`range` px long, x the Lion-Priestess's innate
## "eye_reach"; `width` px wide) starts on the nearest foe and sweeps at
## `turn` rad/s; every `tick` s every foe the beam crosses takes `damage`
## (TdCombat). Nothing blocks a beam. Row: SpellData "burning_eye".
extends TdSpell

## Live eyes: [map px, end game s, next tick game s, beam angle (rad), turn direction].
var _eyes: Array = []


## Beam reach (px) with the innate.
func _reach() -> float:
	return float(row["range"]) * float(CharacterModifiers.innate("eye_reach", 1.0))


func cast(pos: Vector2) -> bool:
	var best: TdEnemy = null  # Nearest foe in reach: the beam starts on it.
	for e: TdEnemy in game.foes_near(pos, _reach()):
		if best == null or e.position.distance_squared_to(pos) < best.position.distance_squared_to(pos):
			best = e
	var ang := (best.position - pos).angle() if best != null else 0.0
	_eyes.append([pos, game.time + float(row["duration"]), game.time, ang, 1.0 if _eyes.size() % 2 == 0 else -1.0])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(dt: float) -> void:
	for i in range(_eyes.size() - 1, -1, -1):
		var s: Array = _eyes[i]
		if game.time >= float(s[1]):
			_eyes.remove_at(i)
			continue
		s[3] = float(s[3]) + float(s[4]) * float(row["turn"]) * dt
		if game.time < float(s[2]):
			continue
		s[2] = game.time + float(row["tick"])
		var o: Vector2 = s[0]
		var dir := Vector2.from_angle(float(s[3]))  # Beam direction.
		var hw := float(row["width"]) * 0.5  # Half width (px).
		for e: TdEnemy in game.foes_near(o, _reach()):
			var rel := e.position - o
			var along := rel.dot(dir)  # Px along the beam.
			if along >= 0.0 and absf(rel.cross(dir)) <= hw + e.radius:
				TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": o})
		game.stats["eye_beams"] = int(game.stats.get("eye_beams", 0)) + 1


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var lk: Dictionary = Acts.data("dynasty")["LOOK"]
	var reach := _reach()
	for s: Array in _eyes:
		var o: Vector2 = s[0]
		var left := clampf((float(s[1]) - game.time) / 0.4, 0.0, 1.0)  # Fades at the end.
		var tip := o + Vector2.from_angle(float(s[3])) * reach
		TdVfx.draw_streak(ci, TdVfx._soft(), tip, float(s[3]), reach, float(row["width"]) * 1.6, Color(tint, 0.9 * left))
		var d := float(lk["eye_d"])  # Eye glow (px).
		ci.draw_texture_rect(TdVfx._soft(), Rect2(o - Vector2(d, d), Vector2(d, d) * 2.0), false, Color(tint, 0.6 * left))
		SpriteBank.draw_disc(ci, o, d * 0.45, Color(1.0, 0.95, 0.8, left))  # The eye's white.
		SpriteBank.draw_disc(ci, o + Vector2.from_angle(float(s[3])) * d * 0.15, d * 0.22, Color(lk["eye_pupil"], left))  # Its pupil, looking down the beam.


func busy() -> bool:
	return not _eyes.is_empty()
