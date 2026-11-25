## CityTactics: the Last Line bosses' shared moves (Act IV; preloaded by
## don_marrow.gd, harrow.gd and paragon.gd, no class_name): a squad called in
## behind a boss on its road, a telegraphed line of strikes down the road
## ahead of it, and the boss's phase banner + pose. Every strike goes through
## game.hostile.shell(), every spawn through WaveDirector.spawn_extra(). No
## numbers of its own: callers pass their row's args. Static, no state.
extends RefCounted


## Spawns one of each kind in `kinds` behind boss `e` on its road, `gap` px
## apart, alternating sides (counted in the boss's wave); returns how many.
static func squad(game: TdGame, e: TdEnemy, kinds: Array, gap: float) -> int:
	var n := 0  # Spawned.
	for k: Variant in kinds:
		var d := maxf(e.follower.dist - gap * float(n + 1), 0.0)  # Behind it (px).
		game.waves.spawn_extra(String(k), e.follower.road.id, d, e.follower.lane + float(n % 2 * 2 - 1) * gap * 0.4)
		n += 1
	return n


## A telegraphed line of `marks` strikes along the road ahead of boss `e`
## over `reach` px (the first one `reach` / marks ahead), each `radius` px,
## landing `delay` s from now plus `step` s per mark: towers inside disabled
## `disable` s, bodies inside take `damage` (game.hostile.shell).
static func road_line(game: TdGame, e: TdEnemy, reach: float, marks: int, radius: float, delay: float, step: float, disable: float, damage: float) -> void:
	var r: Road = e.follower.road  # Its road.
	for i in marks:
		var d := minf(e.follower.dist + reach * float(i + 1) / float(marks), r.length)  # Along the road (px).
		game.hostile.shell(r.point_at(d), radius, delay + step * float(i), disable, "shelled", damage)


## Shows boss `e`'s pose `p` and banner `text` ("" = none).
static func phase(game: TdGame, e: TdEnemy, p: int, text: String) -> void:
	e.pose = p
	e.body.queue_redraw()
	if text != "":
		game.banner(text)
