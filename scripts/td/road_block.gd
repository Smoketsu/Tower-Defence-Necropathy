## RoadBlock: something standing on a road that stops enemies there: a
## blocker tower's bodies on its road post, or a Bone Wall. Enemies ask
## free_body() as they walk into it (TdEnemy) and are then held by that body
## until it dies, the block ends or they die. One path for holding.
class_name RoadBlock
extends RefCounted

## Road the block stands on (Road.id).
var road_id: String = ""
## Distance (px) along that road.
var dist: float = 0.0
## The bodies that hold enemies (BlockBody), side by side across the road.
var bodies: Array[BlockBody] = []
## Game time (s) at which the block ends by itself (INF = never; a Bone Wall's expiry).
var until: float = INF
## True: holds enemies whose row has ignores_walls (blockers hold bosses; walls do not).
var holds_bosses: bool = true
## Extra enemies each body holds (Flesh Rampart synergy; set by the owner tower).
var hold_bonus: int = 0


## The living body with a free hold slot for enemy `e`, or null (full, all
## dead, flying enemy, or a boss at a wall).
func free_body(e: TdEnemy) -> BlockBody:
	if bool(e.row["flying"]) or (bool(e.row["ignores_walls"]) and not holds_bosses):
		return null
	for b: BlockBody in bodies:
		if b.alive and b.held.size() < b.capacity + hold_bonus:
			return b
	return null


## Lets go of every enemy held by any body (the block ends or is sold).
func release_all() -> void:
	for b: BlockBody in bodies:
		b.release_all()
