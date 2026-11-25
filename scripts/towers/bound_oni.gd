## Bound Oni kit (Act V's unlockable summon class; Necropathy's Bound Oni: "bound
## oni brutes with kanabō, a heavy blocker with a stun smash"): a heavy blocker
## (blocker.gd) whose every strike hits all it holds (`hits_all_held`); every
## `smash_every`-th strike is the kanabō SMASH: everything it holds is stunned
## `stun_time` s (TdCombat.freeze_enemy, by rank). Evolved into the Oni Lord
## (EvolutionData "oni_lord", keys in its "set"): smashes more often and each
## smash also shakes the ground: every enemy within `quake_radius` px takes
## `quake_mult` x its damage and is stunned too (0 = no quake).
## Tower.vars: "strikes" (count), "slams" (smashes, the kit summary's counter).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var held := b.held.duplicate()  # Struck this time (deaths shrink b.held).
	var dealt := super(t, b)  # The blow on all it holds.
	t.vars["strikes"] = int(t.vars.get("strikes", 0)) + 1
	if int(t.vars["strikes"]) % int(t.stats["smash_every"]) != 0:
		return dealt
	var stun := float(t.stats["stun_time"])  # Stun (s, before the rank multiplier).
	for e: TdEnemy in held:
		if e.alive:
			TdCombat.freeze_enemy(t.game, e, stun)
	var qr := float(t.stats.get("quake_radius", 0.0))  # Oni Lord quake reach (px).
	if qr > 0.0:
		for e: TdEnemy in t.game.foes_near(b.pos, qr):
			if held.has(e):
				continue
			dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * float(t.stats["quake_mult"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
			if e.alive:
				TdCombat.freeze_enemy(t.game, e, stun)
	t.vars["slams"] = int(t.vars.get("slams", 0)) + 1
	if t.game.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		var d := maxf(qr * 2.0, TdVfxData.KIT_SLAM_D) * k  # Burst: the real quake radius when it has one.
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -6), d, 0.45, Color(1.0, 0.75, 0.6), "golem_slam")
		t.game.vfx.add(TdVfx.Kind.CRACK, b.pos, 1.2 * k, TdVfxData.CRACK_TIME, Color.WHITE)
		if qr > 0.0:
			var ring := t.game.vfx.add(TdVfx.Kind.RING, b.pos, qr, TdVfxData.RING_TIME, Color(1.0, 0.55, 0.35, 0.9))
			if ring != null:
				ring.size0 = qr * 0.3
		t.game.vfx.shake(TdVfxData.SMASH_SHAKE * k)
	return dealt
