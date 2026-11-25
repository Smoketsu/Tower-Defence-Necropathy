## Night Swarm (Act III, Castle Sanguis' spell; Necropathy NightSwarm: "a cloud
## of spectral bats circles and darts at enemies"): `bats` spectral bats (+ the
## Dhampir's innate "swarm_bats") circle the tap `orbit` px out
## (`orbit_speed` rad/s) for `duration` s. Each bat, every `bite_every` s
## (staggered round the swarm), bites the enemy nearest the spot within `aim`
## px for `damage` (the n-th bat takes the n-th nearest, so the swarm spreads);
## its dart shows for `dart_time` s. Row: SpellData "night_swarm".
extends TdSpell

## Live swarms: {"pos": map px, "until": game s, "next": [game s per bat],
## "dart": [[from px, to px, game s] per bat]}.
var _swarms: Array = []


func cast(pos: Vector2) -> bool:
	var n := int(row["bats"]) + int(CharacterModifiers.innate("swarm_bats", 0))  # Bats in the swarm.
	var next: Array = []  # Each bat's first bite, staggered.
	var dart: Array = []  # No dart yet.
	for i in n:
		next.append(game.time + float(row["bite_every"]) * float(i) / float(n))
		dart.append([pos, pos, -INF])
	_swarms.append({"pos": pos, "until": game.time + float(row["duration"]), "next": next, "dart": dart})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


## Map px of bat `i` of `n` circling `pos` now.
func _bat_pos(pos: Vector2, i: int, n: int) -> Vector2:
	var a := game.time * float(row["orbit_speed"]) + TAU * float(i) / float(n)  # Its angle.
	return pos + Vector2(cos(a), sin(a) * 0.6) * float(row["orbit"])


func step(_dt: float) -> void:
	for k in range(_swarms.size() - 1, -1, -1):
		var s: Dictionary = _swarms[k]
		if game.time >= float(s["until"]):
			_swarms.remove_at(k)
			continue
		var foes: Array[TdEnemy] = []  # Nearest first, found once per step when needed.
		var n := (s["next"] as Array).size()  # Bats.
		for i in n:
			if game.time < float(s["next"][i]):
				continue
			if foes.is_empty():
				foes = game.foes_near(s["pos"], float(row["aim"]))
				if foes.is_empty():
					break
				foes.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return x.position.distance_squared_to(s["pos"]) < y.position.distance_squared_to(s["pos"]))
			var e: TdEnemy = foes[i % foes.size()]  # Its prey.
			s["next"][i] = game.time + float(row["bite_every"])
			s["dart"][i] = [_bat_pos(s["pos"], i, n), e.position, game.time]
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": s["pos"]})
			game.stats["swarm_bites"] = int(game.stats.get("swarm_bites", 0)) + 1


func draw(ci: CanvasItem) -> void:
	var streak := TdArt.texture("vfx_streak")  # Dart mask.
	for s: Dictionary in _swarms:
		var n := (s["next"] as Array).size()  # Bats.
		for i in n:
			var p := _bat_pos(s["pos"], i, n)  # Its place on the circle.
			var d: Array = s["dart"][i]
			var f := (game.time - float(d[2])) / float(row["dart_time"])  # 0..1 through its dart.
			if f >= 0.0 and f < 1.0:
				var to: Vector2 = d[1]
				p = p.lerp(to, sin(f * PI))  # Out to its prey and back.
				if streak != null:
					var v := p - Vector2(d[0])  # Dart so far.
					TdVfx.draw_streak(ci, streak, p, v.angle(), v.length(), TdVfxData.COURT_DART_W, TdVfxData.COURT_BAT_TINT)
			SpriteBank.draw_flat(ci, "court/vampire_bat", p, 0.0, TdVfxData.COURT_BAT_TINT, TdVfxData.COURT_BAT_SCALE)


func busy() -> bool:
	return not _swarms.is_empty()
