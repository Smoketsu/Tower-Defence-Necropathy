## Crypt Warder kit (GDD §4.2 "barriers on blockers"): every `interval` s it
## raises a bone barrier of `barrier` HP (x the "hp" multiplier) on every
## living blocker body in range for `barrier_time` s (TdCombat.barrier_body:
## refreshed, never stacked; damage_body spends it first). It only wards when
## some body in range is missing HP or barrier. From level 3 each ward also
## throws its volley (ward darts) at enemies held near it. Its record
## "warded" (barrier HP given) is kept in Tower.vars. Evolved into the Bone
## Aegis (EvolutionData "bone_aegis"): longer barriers, and each ward stings
## every enemy held by a warded body for `thorns` x the barrier.
## Tower.vars: "warded" — barrier HP given so far.
extends "res://scripts/towers/aura.gd"


func step(t: Tower, _dt: float) -> void:
	if t.game.vfx.on:
		t.queue_redraw()  # The barrier shells fade as they are spent (draw_overlay).
	if t.game.time < t.next_fire:
		return
	var r := float(t.stats["range"])  # Ward radius (px).
	var amt := float(t.stats["barrier"])  # Barrier per body.
	var bodies := t.game.bodies_near(t.position, r)  # Living bodies in range.
	var need := false  # Some body would gain from a ward.
	for b: BlockBody in bodies:
		if b.hp < b.max_hp or b.barrier < amt * 0.5 or t.game.time >= b.barrier_until or not b.held.is_empty():
			need = true
			break
	if not need:
		return
	var thorns := float(t.stats.get("thorns", 0.0))  # Bone Aegis sting fraction (0 = none).
	var target: TdEnemy = null  # A held enemy (the volley's fallback target).
	for b: BlockBody in bodies:
		t.vars["warded"] = float(t.vars.get("warded", 0.0)) + TdCombat.barrier_body(t.game, b, amt, float(t.stats["barrier_time"]))
		if t.game.vfx.on:
			var f := t.game.vfx.add(TdVfx.Kind.THREAD, t.position + Vector2(0, -22), TdVfxData.KIT_WARD_THREAD_W * TdVfx.loud(t), TdVfxData.KIT_WARD_THREAD_T, TdVfxData.KIT_BARRIER_TINT)
			if f != null:
				f.to = b.pos + Vector2(0, -12)
			t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -12), TdVfxData.KIT_BARRIER_D * 1.3, 0.4, TdVfxData.KIT_BARRIER_TINT, "volley_flash", 0.1)
		for e: TdEnemy in b.held.duplicate():
			target = e
			if thorns > 0.0:
				TdCombat.damage_enemy(t.game, e, amt * thorns, {"source": "aegis_thorns", "tower": t, "origin": b.pos})
	t.game.sound_fire(t.tower_id)
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	if t.game.vfx.on:
		var ring := t.game.vfx.add(TdVfx.Kind.RING, t.position, r * TdVfx.loud(t), 0.45, TdVfxData.KIT_BARRIER_TINT)
		if ring != null:
			ring.size0 = 14.0
	if target == null:
		var near := t.game.foes_near(t.position, float(t.stats["volley"]["reach"]))  # Darts need someone to hit.
		target = near[0] if not near.is_empty() else null
	if target != null and target.alive:
		volley(t, target)


func draw_body(t: Tower, ci: CanvasItem, _index: int) -> void:
	var ev_tint: Color = EvolutionData.EVOLUTIONS[t.evolution].get("tint", Color.WHITE) if t.evolution != "" else Color.WHITE  # Bone Aegis gold.
	var tint := ev_tint * (Color(1.6, 1.6, 1.5) if t.game.vfx.on and t.firing_flash() else Color.WHITE)
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), Vector2(0, -TowerData.BODY_LIFT), false, tint):
		ci.draw_rect(Rect2(-10, -26, 20, 30), Color(0.5, 0.8, 0.9))


## The barrier shells over every warded body in range (drawn only).
func draw_overlay(t: Tower) -> void:
	if not t.game.vfx.on:
		return
	SpriteBank.apply_sharp(t)
	for b: BlockBody in t.game.bodies_near(t.position, float(t.stats["range"])):
		if b.barrier > 0.0 and t.game.time < b.barrier_until:
			var a := clampf(b.barrier / maxf(float(t.stats["barrier"]), 1.0), 0.3, 1.0)  # Stronger = brighter.
			var d := TdVfxData.KIT_BARRIER_D  # Shell size (px).
			t.draw_texture_rect(TdVfx._soft(), Rect2(b.pos - t.position - Vector2(d, d) * 0.5 + Vector2(0, -12), Vector2(d, d)), false,
					Color(TdVfxData.KIT_BARRIER_TINT, TdVfxData.KIT_BARRIER_TINT.a * a))
