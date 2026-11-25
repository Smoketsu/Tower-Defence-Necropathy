## Bone Wall (GDD §5): blocks the road for `duration` s at the road point
## nearest the tap (within `max_snap` px). It is a RoadBlock with one body of
## unlimited HP and capacity; bosses and minibosses walk through
## (holds_bosses false + their ignores_walls). Drawn as `segments` rising
## bone-wall segments (structures/bone_wall_segment). Row: SpellData "bone_wall".
extends TdSpell

## Live walls: [RoadBlock, start game s].
var _walls: Array = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var blk := RoadBlock.new()  # The wall.
	blk.road_id = road.id
	blk.dist = road.project(pos)
	blk.until = game.time + float(row["duration"])
	blk.holds_bosses = false
	var b := BlockBody.new()  # Its one unbreakable body.
	b.block = blk
	b.hp = INF
	b.max_hp = INF
	b.capacity = 999
	b.pos = road.point_at(blk.dist)
	blk.bodies.append(b)
	game.add_block(blk)
	_walls.append([blk, game.time])
	game.fx.spawn("bone_wall_rise", b.pos, 96.0, 0.4)
	return true


func step(_dt: float) -> void:
	for i in range(_walls.size() - 1, -1, -1):
		var blk: RoadBlock = _walls[i][0]
		if game.time >= blk.until:
			blk.release_all()
			game.fx.spawn("bone_wall_burst", blk.bodies[0].pos, 96.0, 0.4)
			game.remove_block(blk)
			_walls.remove_at(i)


func draw(ci: CanvasItem) -> void:
	for w: Array in _walls:
		var blk: RoadBlock = w[0]
		var road: Road = game.roads[blk.road_id]
		var dir := road.dir_at(blk.dist)  # Road direction at the wall.
		var nrm := Vector2(dir.y, -dir.x)  # Across the road.
		var n := int(row["segments"])  # Segments across the road.
		var rise := clampf((game.time - float(w[1])) / 0.3, 0.0, 1.0)  # Grows out of the ground.
		for k in n:
			var p := blk.bodies[0].pos + nrm * (float(k) - float(n - 1) * 0.5) * (TdArtData.ROAD_WIDTH / float(n))  # Segment px.
			if not SpriteBank.draw_rising(ci, "structures/bone_wall_segment", p, rise, k % 2 == 1):
				ci.draw_rect(Rect2(p - Vector2(6, 12), Vector2(12, 16)), Color(0.9, 0.88, 0.8))


func busy() -> bool:
	return not _walls.is_empty()
