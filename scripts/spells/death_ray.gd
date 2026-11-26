## Death Ray (Act XII spell, Kestrel's reward; Necropathy's Death Ray: "a soul
## laser sweeps a full circle around you, cutting everything in its line; each
## kill on the beam sparks lightning to one nearby enemy"): a beam `length` px
## long turns one full circle round the tap in `sweep_time` s, striking every
## foe it crosses once for `damage`; a foe it kills sparks lightning to the
## nearest other foe within `spark_range` px for `spark` x the beam's damage
## (the Lightning Abbess's innate "ray_sparks" sparks to more foes). Row:
## SpellData "death_ray". Game stats "ray_hits", "ray_sparks".
extends TdSpell

## Beams turning: {at: map px, start: game s, hit: Array[TdEnemy] (struck this sweep), gens: Array[int]}.
var _beams: Array[Dictionary] = []
## Sparks drawn: [from px, to px, game s].
var _sparks: Array = []


func cast(pos: Vector2) -> bool:
	if game.foes_near(pos, float(row["length"])).is_empty():
		return false
	_beams.append({"at": pos, "start": game.time, "hit": [], "gens": []})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	var len := float(row["length"])  # Beam length (px).
	var sweep := float(row["sweep_time"])  # S per circle.
	for i in range(_beams.size() - 1, -1, -1):
		var b: Dictionary = _beams[i]
		var p := clampf((game.time - float(b["start"])) / sweep, 0.0, 1.0)  # Share of the circle turned.
		var ang := p * TAU  # Beam angle now.
		var at: Vector2 = b["at"]
		for e: TdEnemy in game.foes_near(at, len):
			if (b["hit"] as Array).has(e):
				continue
			var a := wrapf((e.position - at).angle(), 0.0, TAU)  # Its angle round the tap.
			if a > ang:
				continue  # The beam has not reached it yet.
			b["hit"].append(e)
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
			game.stats["ray_hits"] = int(game.stats.get("ray_hits", 0)) + 1
			if not e.alive:
				_spark(e.position)
		if p >= 1.0:
			_beams.remove_at(i)
	for i in range(_sparks.size() - 1, -1, -1):
		if game.time > float(_sparks[i][2]) + 0.3:
			_sparks.remove_at(i)


## A kill at `from` sparks lightning to the nearest other foes (1 + the Abbess's extra).
func _spark(from: Vector2) -> void:
	var n := 1 + int(CharacterModifiers.innate("ray_sparks", 0.0))  # Foes it jumps to.
	var foes := game.foes_near(from, float(row["spark_range"]))  # Candidates.
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.position.distance_squared_to(from) < b.position.distance_squared_to(from))
	for e: TdEnemy in foes.slice(0, n):
		TdCombat.damage_enemy(game, e, float(row["damage"]) * float(row["spark"]), {"source": id, "origin": from})
		game.stats["ray_sparks"] = int(game.stats.get("ray_sparks", 0)) + 1
		_sparks.append([from, e.position, game.time])


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var streak := TdArt.texture("vfx_streak")  # Beam mask.
	if streak == null:
		return
	var len := float(row["length"])  # Px.
	for b: Dictionary in _beams:
		var p := clampf((game.time - float(b["start"])) / float(row["sweep_time"]), 0.0, 1.0)  # Turned share.
		var at: Vector2 = b["at"]
		for k in 4:  # The beam and its fading afterglow.
			var ang := p * TAU - float(k) * 0.12
			TdVfx.draw_streak(ci, streak, at + Vector2.from_angle(ang) * len, ang, len, float(lk["ray_w"]) * (1.0 - float(k) * 0.2), Color(lk["ray_tint"], 1.0 - float(k) * 0.25))
	for s: Array in _sparks:
		var from: Vector2 = s[0]
		var to: Vector2 = s[1]
		var k := 1.0 - clampf((game.time - float(s[2])) / 0.3, 0.0, 1.0)  # Fades.
		TdVfx.draw_streak(ci, streak, to, (to - from).angle(), from.distance_to(to), 6.0, Color(lk["spark_tint"], k))


func busy() -> bool:
	return not _beams.is_empty() or not _sparks.is_empty()
