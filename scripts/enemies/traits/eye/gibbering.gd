## The Gibbering Mass (Necropathy's GibberingKit): killed, it SPLITS into
## `count` masses of kind `into` where it fell, `gap` px apart across the road,
## as extras of the current wave (WaveDirector.spawn_extra; the lesser mass
## splits again, the least does not). A mass that leaks does not split. Args:
## into (kind id), count, gap (px).
extends EnemyTrait


func on_death(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var n := int(a["count"])  # Masses.
	for i in n:
		var lane := e.follower.lane + (float(i) - float(n - 1) * 0.5) * float(a["gap"])  # Across the road.
		game.waves.spawn_extra(String(a["into"]), e.follower.road.id, maxf(e.follower.dist - float(i) * 6.0, 0.0), lane)
	game.fx.spawn("ink_burst", e.position, e.radius * 4.0, 0.45, Color(0.7, 0.5, 0.9))
	EnemyTrait.note(game, "eye_splits", float(n))
