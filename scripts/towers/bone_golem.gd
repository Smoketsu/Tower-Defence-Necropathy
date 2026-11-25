## Bone Golem kit (GDD §4.2; Necropathy's Bone Golem): a heavy blocker unlike
## the Abomination. It holds fewer (`hold`) but every `slam_every`-th strike
## slams everything it holds for `slam_mult` x damage and staggers them
## (`stagger_time` s, TdCombat.stagger_enemy). Bulwark: below `plant_frac` of
## its HP it plants itself and ignores `plant_cut` of every hit
## (BlockBody.damage_cut, read by TdCombat.damage_body). Ossuary Hunger: an
## enemy that dies while it holds it restores `hunger_heal` HP to that body.
## Evolved into the Ossuary Titan (EvolutionData "ossuary_titan"): holds more,
## slams every other strike, feeds harder.
## Tower.vars: "strikes" (count), "slams" (count), "fed" (HP restored), "hunger" (its enemy_killed Callable).
extends "res://scripts/towers/blocker.gd"


func setup(t: Tower) -> void:
	super(t)
	var cb := _on_kill.bind(t)  # Ossuary Hunger listener (one per Golem).
	t.vars["hunger"] = cb
	t.game.enemy_killed.connect(cb)


func on_removed(t: Tower) -> void:
	if t.vars.has("hunger") and t.game.enemy_killed.is_connected(t.vars["hunger"]):
		t.game.enemy_killed.disconnect(t.vars["hunger"])
	super(t)


## TdGame.enemy_killed: a held enemy died: the body that held it feeds.
func _on_kill(e: TdEnemy, _tower: Tower, t: Tower) -> void:
	if t.block == null or e.holder == null or not t.block.bodies.has(e.holder) or e.holder.hp >= e.holder.max_hp:
		return  # Only a hurt body feeds (as the Mender heals only the hurt).
	var fed := TdCombat.heal_body(t.game, e.holder, float(t.stats["hunger_heal"]))  # HP restored.
	t.vars["fed"] = float(t.vars.get("fed", 0.0)) + fed
	if fed > 0.0:
		t.game.vfx.heal(t, e.holder)


func step(t: Tower, dt: float) -> void:
	for b: BlockBody in t.block.bodies:
		b.damage_cut = float(t.stats["plant_cut"]) if b.alive and b.hp < b.max_hp * float(t.stats["plant_frac"]) else 0.0
	super(t, dt)


func strike(t: Tower, b: BlockBody) -> float:
	t.vars["strikes"] = int(t.vars.get("strikes", 0)) + 1
	if int(t.vars["strikes"]) % int(t.stats["slam_every"]) != 0:
		return super(t, b)
	var dealt := 0.0  # Damage dealt.
	for e: TdEnemy in b.held.duplicate():
		dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * float(t.stats["slam_mult"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
		if e.alive:
			TdCombat.stagger_enemy(t.game, e, float(t.stats["stagger_time"]))
	t.vars["slams"] = int(t.vars.get("slams", 0)) + 1
	if t.game.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -6), TdVfxData.KIT_SLAM_D * k, 0.45, Color.WHITE, "golem_slam")
		t.game.vfx.add(TdVfx.Kind.CRACK, b.pos, 1.2 * k, TdVfxData.CRACK_TIME, Color.WHITE)
		t.game.vfx.shake(TdVfxData.SMASH_SHAKE * k)
	return dealt


## Blocker HP bars, plus a set-stone glow under a planted body (drawn only).
func draw_overlay(t: Tower) -> void:
	if t.game.vfx.on:
		for b: BlockBody in t.block.bodies:
			if b.alive and b.damage_cut > 0.0:
				var d := 70.0  # Glow size (px).
				t.draw_texture_rect(TdVfx._soft(), Rect2(b.pos - t.position - Vector2(d, d * 0.5) * 0.5, Vector2(d, d * 0.5)), false, Color(TdVfxData.KIT_PLANT_TINT, 0.45))
	super(t)
