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
## dead, flying enemy, or a boss at a wall). A miniboss
## (TdRulesData.BUMPING_RANKS) at a full post gets a body holding a lesser
## enemy instead: make_room() then pushes that one on (DECISIONS Y3).
func free_body(e: TdEnemy) -> BlockBody:
	if bool(e.row["flying"]) or (bool(e.row["ignores_walls"]) and not holds_bosses):
		return null
	var bump: BlockBody = null  # A full body holding a lesser enemy (bumping ranks only).
	var big := TdRulesData.BUMPING_RANKS.has(String(e.row["rank"]))  # It may push a lesser enemy out.
	for b: BlockBody in bodies:
		if b.alive and e.game.time >= b.charm_until:  # A charmed body holds nobody (w2c-inferno).
			if b.held.size() < b.capacity + hold_bonus:
				return b
			if big and bump == null and _lesser(b) != null:
				bump = b
	return bump


## Frees a hold slot on body `b` (from free_body) for its new enemy: the
## latest-held lesser enemy is let go and walks on past the post.
func make_room(b: BlockBody) -> void:
	if b.held.size() < b.capacity + hold_bonus:
		return
	var out := _lesser(b)  # The enemy pushed out.
	b.held.erase(out)
	out.holder = null
	out.unholdable_until = out.game.time + TdRulesData.BUMP_FREE_TIME  # It clears this post instead of being caught again.
	EnemyTrait.note(out.game, "bumped")


## The latest-held enemy of body `b` whose rank does not bump, or null.
func _lesser(b: BlockBody) -> TdEnemy:
	for i in range(b.held.size() - 1, -1, -1):
		if not TdRulesData.BUMPING_RANKS.has(String(b.held[i].row["rank"])):
			return b.held[i]
	return null


## Lets go of every enemy held by any body (the block ends or is sold).
func release_all() -> void:
	for b: BlockBody in bodies:
		b.release_all()
