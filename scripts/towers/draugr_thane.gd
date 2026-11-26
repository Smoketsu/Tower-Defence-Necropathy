## Draugr Thane kit (Act VI's unlockable summon class; Necropathy's
## DraugrThaneBehavior, "a heavy undead jarl, a blocker whose frost-axe slows
## what it hits"): a heavy blocker (blocker.gd) whose every axe blow chills the
## foe it strikes (`chill_mult` of its speed for `chill_time` s,
## TdCombat.slow_enemy); every `cleave_every`-th blow is the FROST CLEAVE: every
## foe within `cleave_radius` px of the body takes `cleave_mult` x its damage
## and is chilled too. Evolved into the Barrow King (EvolutionData
## "barrow_king", keys in its "set"): a wider cleave that also freezes what it
## strikes for `cleave_freeze` s (TdCombat.freeze_enemy, by rank; 0 = none).
## Tower.vars: "strikes" (count), "slams" (cleaves, the kit summary's counter).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var first := b.held[0]  # The foe its axe strikes.
	var dealt := super(t, b)  # The blow.
	if first.alive:
		TdCombat.slow_enemy(t.game, first, float(t.stats["chill_mult"]), float(t.stats["chill_time"]))
	t.vars["strikes"] = int(t.vars.get("strikes", 0)) + 1
	if int(t.vars["strikes"]) % int(t.stats["cleave_every"]) != 0:
		return dealt
	var r := float(t.stats["cleave_radius"])  # Cleave reach (px).
	var frz := float(t.stats.get("cleave_freeze", 0.0))  # Barrow King freeze (s).
	for e: TdEnemy in t.game.foes_near(b.pos, r):
		if e != first:
			dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * float(t.stats["cleave_mult"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
		if e.alive:
			TdCombat.slow_enemy(t.game, e, float(t.stats["chill_mult"]), float(t.stats["chill_time"]))
			if frz > 0.0:
				TdCombat.freeze_enemy(t.game, e, frz)
	t.vars["slams"] = int(t.vars.get("slams", 0)) + 1
	if t.game.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -6), r * 2.0 * k, 0.45, Color(0.7, 0.9, 1.0), "frost_nova")
		var ring := t.game.vfx.add(TdVfx.Kind.RING, b.pos, r, TdVfxData.RING_TIME, Color(0.6, 0.85, 1.0, 0.9))
		if ring != null:
			ring.size0 = r * 0.3
		t.game.vfx.shake(TdVfxData.SMASH_SHAKE * k)
	return dealt
