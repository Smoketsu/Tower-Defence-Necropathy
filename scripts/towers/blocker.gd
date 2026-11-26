## Blocker behaviour (Skeleton Warrior, Corpse Abomination): the tower's
## bodies stand across the road at its post (one RoadBlock registered with
## the run) and hold enemies; each living body strikes what it holds every
## `interval` s (strike(): all of them when `hits_all_held`). From level 3,
## every `volley.every` strikes the post throws its volley at enemies within
## `volley.reach`. A fallen body returns at full HP after `respawn` s, free
## (GDD §4.3). Level ups change the body count and HP through
## Tower.recompute() -> on_recompute(). Class kits (warrior.gd,
## abomination.gd) extend this and override strike() / step().
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
		b.max_hp = float(t.stats["body_hp"])  # Before the share below reads it (DECISIONS K15).
		b.hp = b.max_hp
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
		if t.game.time < b.charm_until:
			_charmed_strike(t, b)  # Tempted (w2c-inferno): it fights its own post.
			continue
		if b.held.is_empty() or t.game.time < b.next_attack:
			continue
		b.next_attack = t.game.time + float(t.stats["interval"])
		t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
		t.game.sound_fire(t.tower_id)
		t.shots += 1
		var first: TdEnemy = b.held[0]  # Its main target (the volley falls back on it).
		strike(t, b)
		t.game.vfx.melee(t, b, first)
		volley(t, first)


## Charmed body `b` (TdCombat.charm_body) strikes another living body of its
## own post on its cadence, at `charm_mult` x its blow; alone, it just stands.
func _charmed_strike(t: Tower, b: BlockBody) -> void:
	if t.game.time < b.next_attack:
		return
	for o: BlockBody in t.block.bodies:
		if o != b and o.alive:
			b.next_attack = t.game.time + float(t.stats["interval"])
			b.vis_strike_at = t.game.time
			b.vis_dir = (o.pos - b.pos).normalized()
			TdCombat.damage_body(t.game, o, float(t.stats["damage"]) * b.charm_mult)
			EnemyTrait.note(t.game, "charmed_blows")
			return


## One strike of body `b` on what it holds: the first held enemy, or all of
## them when `hits_all_held` (a stomp). Returns the damage dealt.
func strike(t: Tower, b: BlockBody) -> float:
	var targets: Array[TdEnemy] = [b.held[0]]  # Hit this time.
	if bool(t.stats["hits_all_held"]):
		targets.assign(b.held)
	var dealt := 0.0  # Damage dealt.
	for e: TdEnemy in targets:
		dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
	return dealt


func on_removed(t: Tower) -> void:
	t.block.release_all()
	t.game.remove_block(t.block)


func draw_body(t: Tower, ci: CanvasItem, i: int) -> void:
	if i >= t.block.bodies.size():
		return
	var b: BlockBody = t.block.bodies[i]
	var key := String(t.stats["sprite"])  # Body sprite.
	if not b.alive:
		if t.game.vfx.on:  # A bone pile where it fell (drawn only).
			SpriteBank.draw_flat(ci, TdVfxData.BONE_PILE, Vector2(0, SpriteBank.drawn_height(key) * 0.3), 0.0, Color(0.9, 0.88, 0.8), TdVfxData.BONE_PILE_SCALE)
		return
	var o := body_offset(t, b)  # Drawn lunge / flinch / smash offset (px, layer space).
	var rise := (t.game.time - b.vis_rise_at) / TdVfxData.RISE_TIME  # 0..1 climbing out of the bone pile.
	if t.game.vfx.on and rise >= 0.0 and rise < 1.0:
		SpriteBank.draw_flat(ci, TdVfxData.BONE_PILE, Vector2(0, SpriteBank.drawn_height(key) * 0.3), 0.0, Color(0.9, 0.88, 0.8, 1.0 - rise), TdVfxData.BONE_PILE_SCALE)
		if SpriteBank.draw_rising(ci, key, o, rise, false):
			return
	var tint := TdVfxData.STATUS_TINT["charmed"] if t.game.time < b.charm_until else Color.WHITE  # Charmed: pink (w2c-inferno).
	if not SpriteBank.draw(ci, key, o, t.game.time < b.flash_until, tint):
		ci.draw_rect(Rect2(-8, -16, 16, 24), Color(0.8, 0.8, 0.7))


## Drawn offset (px, in the mirrored body layer's space) of body `b`: its
## lunge toward what it strikes and its flinch from a blow (drawn only; the
## Abomination adds its smash wind-up).
func body_offset(t: Tower, b: BlockBody) -> Vector2:
	if not t.game.vfx.on or not TdVfx.motion():
		return Vector2.ZERO
	var off := Vector2.ZERO  # Map-space offset (px).
	var lf := (t.game.time - b.vis_strike_at) / TdVfxData.LUNGE_TIME  # 0..1 through its lunge.
	if lf >= 0.0 and lf < 1.0:
		off += b.vis_dir * TdVfxData.LUNGE_PX * TdVfx.lunge_curve(lf)
	var ff := (t.game.time - b.vis_flinch_at) / TdVfxData.NUDGE_TIME  # 0..1 through its flinch.
	if ff >= 0.0 and ff < 1.0:
		off += b.vis_flinch_dir * TdVfxData.FLINCH_PX * sin(ff * PI)
	return Vector2(off.x * signf(t.layers[0].scale.x), off.y).round()


func draw_overlay(t: Tower) -> void:
	var lift := SpriteBank.overlay_height(String(t.stats["sprite"]), TdVfxData.UNIT_SCALE_TOWER) * 0.5 + 6.0  # Bar height above the body origin, at the drawn size.
	for b: BlockBody in t.block.bodies:
		if b.alive and b.hp < b.max_hp:
			var o := b.pos - t.position + Vector2(-10, -lift)  # Bar corner (px).
			t.draw_rect(Rect2(o, Vector2(20, 3)), Color(0, 0, 0, 0.7))
			t.draw_rect(Rect2(o, Vector2(20 * b.hp / b.max_hp, 3)), Color(0.3, 0.9, 0.5))
