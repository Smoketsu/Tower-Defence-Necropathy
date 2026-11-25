## Structures: helpers shared by the Act I map rules for raising map
## structures (TdEnemyData rows with "structure": true) beside a road. A
## structure is an enemy that never moves: it stands on the nearest road at
## the projected distance, offset sideways to the authored point.
class_name Structures
extends RefCounted


## Raises structure kind `kind` at map px `pos` (on the nearest road's side) and returns it.
static func raise(game: TdGame, kind: String, pos: Vector2) -> TdEnemy:
	var road: Road = game.nearest_road(pos, INF)  # The road it stands beside.
	var d := road.project(pos)  # Distance along it.
	var dir := road.dir_at(d)  # Road direction there.
	var lane := (pos - road.point_at(d)).dot(Vector2(dir.y, -dir.x))  # Sideways offset (px).
	var e := game.spawn_at(kind, road.id, 0, d, lane)
	game.fx.spawn("summon_rise", e.position, 80.0, 0.5)
	return e
