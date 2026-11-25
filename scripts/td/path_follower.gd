## PathFollower: moves one enemy along the roads by distance travelled. It
## knows only roads and distances; blocking (RoadBlock) and speed are decided
## by TdEnemy before it calls advance(). At the end of a road with a `next`
## road it carries the overflow onto that road at its join point (merging
## roads); at the end of the last road it reports the gate.
class_name PathFollower
extends RefCounted

## Every road of the map, id -> Road (shared, read only).
var roads: Dictionary = {}
## Road currently walked.
var road: Road = null
## Distance (px) travelled along `road`.
var dist: float = 0.0
## Lateral offset (px) from the road centre line, + = to the walker's left.
var lane: float = 0.0


## Starts on road `r` at distance `d` with lateral offset `p_lane`.
func setup(all_roads: Dictionary, r: Road, d: float, p_lane: float) -> void:
	roads = all_roads
	road = r
	dist = d
	lane = p_lane


## Map px of the walker (road point plus the lateral offset).
func position() -> Vector2:
	var dir := road.dir_at(dist)  # Walking direction here.
	return road.point_at(dist) + Vector2(dir.y, -dir.x) * lane


## Unit walking direction at the walker.
func direction() -> Vector2:
	return road.dir_at(dist)


## Moves `step` px forward. Returns true when the walker reached the gate
## (the end of a road with no `next`); it then stays at that end.
func advance(step: float) -> bool:
	dist += step
	while dist >= road.length:
		if road.next_id == "" or not roads.has(road.next_id):
			dist = road.length
			return true
		var over := dist - road.length  # Distance carried onto the next road.
		var nxt: Road = roads[road.next_id]  # The road joined.
		dist = road.next_at + over
		road = nxt
	return false
