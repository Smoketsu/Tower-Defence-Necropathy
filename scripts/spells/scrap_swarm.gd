## Scrap Swarm (Act XII spell, Deus Ex Machina's reward; Necropathy's Scrap
## Swarm: "drones of bone and scrap orbit beyond your ring and shoot foes
## before they reach your army"): `drones` scrap drones (+ the Rust Prophet's
## innate "swarm_drones") circle the tap `orbit` px out for `duration` s; each
## fires a bolt every `fire_every` s at the nearest foe within `range` px of it
## for `damage` (TdCombat). Nothing near the tap: no cast. Row: SpellData
## "scrap_swarm". Game stat "swarm_bolts".
extends TdSpell

## Swarms: {at: map px, start: game s, n: drones, next: Array[float] (game s each fires next)}.
var _swarms: Array[Dictionary] = []
## Bolts drawn: [from px, to px, game s].
var _bolts: Array = []


func cast(pos: Vector2) -> bool:
	if game.foes_near(pos, float(row["range"]) + float(row["orbit"])).is_empty():
		return false
	var n := int(row["drones"]) + int(CharacterModifiers.innate("swarm_drones", 0.0))  # Drones.
	var nx: Array[float] = []  # Each drone's next shot.
	for i in n:
		nx.append(game.time + float(row["fire_every"]) * float(i) / float(n))
	_swarms.append({"at": pos, "start": game.time, "n": n, "next": nx})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


## Map px of drone `i` of swarm `s` now.
func _drone_pos(s: Dictionary, i: int) -> Vector2:
	var ang := (game.time - float(s["start"])) * float(row["orbit_speed"]) + TAU * float(i) / float(s["n"])  # Its place on the orbit.
	return Vector2(s["at"]) + Vector2.from_angle(ang) * float(row["orbit"])


func step(_dt: float) -> void:
	for si in range(_swarms.size() - 1, -1, -1):
		var s: Dictionary = _swarms[si]
		if game.time > float(s["start"]) + float(row["duration"]):
			_swarms.remove_at(si)
			continue
		var nx: Array = s["next"]
		for i in int(s["n"]):
			if game.time < float(nx[i]):
				continue
			var p := _drone_pos(s, i)  # The drone.
			var best: TdEnemy = null  # Nearest foe.
			for e: TdEnemy in game.foes_near(p, float(row["range"])):
				if best == null or e.position.distance_squared_to(p) < best.position.distance_squared_to(p):
					best = e
			if best == null:
				continue
			nx[i] = game.time + float(row["fire_every"])
			TdCombat.damage_enemy(game, best, float(row["damage"]), {"source": id, "origin": p})
			game.stats["swarm_bolts"] = int(game.stats.get("swarm_bolts", 0)) + 1
			_bolts.append([p, best.position, game.time])
	for i in range(_bolts.size() - 1, -1, -1):
		if game.time > float(_bolts[i][2]) + 0.2:
			_bolts.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	for s: Dictionary in _swarms:
		for i in int(s["n"]):
			var f := int(game.time * 12.0) % 2  # Rotor frame (drawn only).
			SpriteBank.draw_flat_frame(ci, "projectiles/scrap_drone", 2, f, _drone_pos(s, i), 0.0)
	var streak := TdArt.texture("vfx_streak")  # Bolt trail mask.
	if streak == null:
		return
	for b: Array in _bolts:
		var from: Vector2 = b[0]
		var to: Vector2 = b[1]
		var k := clampf((game.time - float(b[2])) / 0.2, 0.0, 1.0)  # Flight share.
		var at := from.lerp(to, k)  # Bolt head.
		TdVfx.draw_streak(ci, streak, at, (to - from).angle(), minf(40.0, from.distance_to(at)), 6.0, Color(lk["swarm_tint"], 1.0 - k * 0.5))


func busy() -> bool:
	return not _swarms.is_empty() or not _bolts.is_empty()
