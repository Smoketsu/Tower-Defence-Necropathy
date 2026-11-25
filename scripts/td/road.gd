## Road: one road of a map, a polyline enemies walk along by distance
## travelled (PathFollower). Built by MapLoader from a map's `roads` row.
## Pure geometry, no state that changes during a run.
class_name Road
extends RefCounted

## Road id (the map's `roads` key).
var id: String = ""
## Polyline points in map px, from the start (entrance or join) to the end.
var points: PackedVector2Array = PackedVector2Array()
## Distance (px) along the road at each point; cum[0] = 0, cum[-1] = length.
var cum: PackedFloat32Array = PackedFloat32Array()
## Total length (px).
var length: float = 0.0
## Road this one joins at its end ("" = it ends at the gate).
var next_id: String = ""
## Distance (px) along `next_id` where this road joins it.
var next_at: float = 0.0
## True when enemies may spawn at its start (an entrance arch is drawn there).
var entrance: bool = false
## True for an off-road route (herds, riders crossing the map; map road key "off_road"):
## not drawn as a road, no post snaps to it, no spell targets it, nothing holds on it.
var off_road: bool = false
## True when an enemy reaching its end leaves the map without costing lives
## (map road key "exit"; a crossing herd) instead of reaching the gate.
var exit: bool = false


func _init(p_id: String, row: Dictionary) -> void:
	id = p_id
	for p: Vector2 in row["points"]:
		points.append(p)
	next_id = String(row.get("next", ""))
	next_at = float(row.get("next_at", 0.0))
	entrance = bool(row.get("entrance", false))
	off_road = bool(row.get("off_road", false))
	exit = bool(row.get("exit", false))
	cum.append(0.0)
	for i in range(1, points.size()):
		length += points[i - 1].distance_to(points[i])
		cum.append(length)


## Index of the segment holding distance `d` (0 .. points.size() - 2).
func _segment(d: float) -> int:
	for i in range(1, points.size()):
		if d <= cum[i]:
			return i - 1
	return points.size() - 2


## Map px at distance `d` (clamped to the road).
func point_at(d: float) -> Vector2:
	var i := _segment(d)  # Segment index.
	var seg := cum[i + 1] - cum[i]  # Segment length (px).
	var t := clampf((d - cum[i]) / seg, 0.0, 1.0) if seg > 0.0 else 0.0  # Fraction along it.
	return points[i].lerp(points[i + 1], t)


## Unit walking direction at distance `d`.
func dir_at(d: float) -> Vector2:
	var i := _segment(d)  # Segment index.
	return (points[i + 1] - points[i]).normalized()


## Distance along the road of the road point closest to map px `p`.
func project(p: Vector2) -> float:
	var best := INF  # Closest squared distance found.
	var best_d := 0.0  # Its distance along the road.
	for i in range(points.size() - 1):
		var a := points[i]  # Segment start.
		var ab := points[i + 1] - a  # Segment vector.
		var t := clampf((p - a).dot(ab) / maxf(ab.length_squared(), 0.0001), 0.0, 1.0)  # Fraction along it.
		var q := a + ab * t  # Closest point on this segment.
		var d2 := p.distance_squared_to(q)  # Squared distance to it.
		if d2 < best:
			best = d2
			best_d = cum[i] + ab.length() * t
	return best_d


## Shortest distance (px) from map px `p` to the road.
func distance_to(p: Vector2) -> float:
	return p.distance_to(point_at(project(p)))
