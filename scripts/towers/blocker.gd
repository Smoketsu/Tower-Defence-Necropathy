## Blocker behaviour (Skeleton Warrior, Corpse Abomination): the tower's
## bodies stand across the road at its post (one RoadBlock registered with
## the run) and hold enemies; each living body hits what it holds every
## `interval` s (all of them when `hits_all_held`). A fallen body returns at
## full HP after `respawn` s, free (GDD §4.3). Level ups change the body
## count and HP through Tower.recompute() -> on_recompute().
extends TowerBehavior


func setup(t: Tower) -> void:
	t.block = RoadBlock.new()
	t.block.road_id = t.spot.road_id
	t.block.dist = t.spot.road_dist
	t.game.add_block(t.block)
	on_recompute(t)


func on_recompute(t: Tower) -> void:
	if t.block == null:
		return
	var want := int(t.stats["bodies"])  # Bodies this level.
	while t.block.bodies.size() < want:
		var b := BlockBody.new()  # A new body, at full HP.
		b.block = t.block
		b.hp = float(t.stats["body_hp"])
		t.block.bodies.append(b)
	var road: Road = t.game.roads[t.block.road_id]  # The post's road.
	var dir := road.dir_at(t.block.dist)  # Road direction at the post.
	var nrm := Vector2(dir.y, -dir.x)  # Across the road.
	var n := t.block.bodies.size()  # Bodies standing side by side.
	for i in n:
		var b: BlockBody = t.block.bodies[i]
		var frac := b.hp / b.max_hp if b.max_hp > 0.0 else 1.0  # Keeps its health share.
		b.max_hp = float(t.stats["body_hp"])
		b.hp = b.max_hp * frac
		b.capacity = int(t.stats["hold"])
		b.respawn_time = float(t.stats["respawn"])
		b.pos = road.point_at(t.block.dist) + nrm * (float(i) - float(n - 1) * 0.5) * TowerData.BODY_SPACING
	t.block.hold_bonus = int(t.stats["hold_bonus"])
	t.ensure_layers(n)
	for i in t.layers.size():
		t.layers[i].position = t.block.bodies[i].pos - t.position if i < n else Vector2.ZERO
	t.facing = -1.0 if dir.x > 0.0 else 1.0  # Bodies face the oncoming column.


func step(t: Tower, _dt: float) -> void:
	for b: BlockBody in t.block.bodies:
		if not b.alive:
			if t.game.time >= b.respawn_at:
				TdCombat.revive_body(t.game, b)
			continue
		if b.held.is_empty() or t.game.time < b.next_attack:
			continue
		b.next_attack = t.game.time + float(t.stats["interval"])
		t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
		t.game.sound_fire(t.tower_id)
		var targets: Array[TdEnemy] = [b.held[0]]  # Hit this time: the first held, or all of them (a stomp).
		if bool(t.stats["hits_all_held"]):
			targets.assign(b.held)
		for e: TdEnemy in targets:
			TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": b.pos})


func on_removed(t: Tower) -> void:
	t.block.release_all()
	t.game.remove_block(t.block)


func draw_body(t: Tower, ci: CanvasItem, i: int) -> void:
	if i >= t.block.bodies.size() or not t.block.bodies[i].alive:
		return
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), Vector2.ZERO, t.game.time < t.block.bodies[i].flash_until):
		ci.draw_rect(Rect2(-8, -16, 16, 24), Color(0.8, 0.8, 0.7))


func draw_overlay(t: Tower) -> void:
	var lift := SpriteBank.drawn_height(String(t.stats["sprite"])) * 0.5 + 6.0  # Bar height above the feet line.
	for b: BlockBody in t.block.bodies:
		if b.alive and b.hp < b.max_hp:
			var o := b.pos - t.position + Vector2(-10, -lift)  # Bar corner (px).
			t.draw_rect(Rect2(o, Vector2(20, 3)), Color(0, 0, 0, 0.7))
			t.draw_rect(Rect2(o, Vector2(20 * b.hp / b.max_hp, 3)), Color(0.3, 0.9, 0.5))
