## Plague Cloud (GDD §5 "Rot over a stretch of road; damage over time"): a
## cloud `length` px long laid along the road nearest the tap (within
## `max_snap` px), centred on the tap's road point, for `duration` s. It is
## `puffs` ground fields (TdProjectiles.add_field, look "plague") of
## `radius` px spread along that stretch; each deals `rot` damage over time
## every `tick` s to every enemy inside (an enemy under two puffs rots twice).
## Row: SpellData "plague_cloud".
extends TdSpell


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var mid := road.project(pos)  # Cloud centre along the road (px).
	var n := int(row["puffs"])  # Puffs along the stretch.
	for i in n:
		var d := clampf(mid + (float(i) / float(maxi(n - 1, 1)) - 0.5) * float(row["length"]), 0.0, road.length)  # This puff's distance.
		game.projectiles.add_field(road.point_at(d), float(row["radius"]), float(row["duration"]), float(row["tick"]),
				float(row["rot"]), id, null, "plague")
	game.fx.spawn("spore_cloud", road.point_at(mid), float(row["length"]), 0.6)
	return true
