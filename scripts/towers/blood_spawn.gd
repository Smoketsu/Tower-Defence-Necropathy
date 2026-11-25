## Blood Spawn kit (Act III's summon, GDD §4.2 / §7.3; Necropathy's Blood Spawn
## and its BLOODTHIRST): fast vampire brawlers on a road post (blocker.gd). Each
## strike heals the striking body `drink_share` of the damage it dealt
## (TdCombat.heal_body). Evolved into the Nosferatu (EvolutionData "nosferatu"):
## they drink deeper, and `spill_share` of the drink the body cannot hold goes
## to the most wounded other blocker body within `spill_radius` px (any post).
## A disabled tower makes no strike (blocker step), so it drinks nothing.
## Tower.vars: "fed" (HP restored to its bodies), "spilled" (HP given on).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var dealt := super(t, b)  # The normal strike on its first held enemy.
	var drink := dealt * float(t.stats["drink_share"])  # HP it drinks.
	if drink <= 0.0:
		return dealt
	var fed := TdCombat.heal_body(t.game, b, drink)  # HP restored to the striker.
	t.vars["fed"] = float(t.vars.get("fed", 0.0)) + fed
	if t.game.vfx.on and fed > 0.0:
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -12), TdVfxData.COURT_DRINK_D * TdVfx.loud(t), 0.35, TdVfxData.COURT_DRINK_TINT, "volley_hit")
	var spill := (drink - fed) * float(t.stats["spill_share"])  # Overflow given on (Nosferatu).
	if spill > 0.0:
		var best: BlockBody = null  # Most wounded other body near it.
		for o: BlockBody in t.game.bodies_near(b.pos, float(t.stats["spill_radius"])):
			if o != b and o.hp < o.max_hp and (best == null or o.hp / o.max_hp < best.hp / best.max_hp):
				best = o
		if best != null:
			var given := TdCombat.heal_body(t.game, best, spill)  # HP it received.
			t.vars["spilled"] = float(t.vars.get("spilled", 0.0)) + given
			if t.game.vfx.on and given > 0.0:
				var f := t.game.vfx.add(TdVfx.Kind.THREAD, b.pos + Vector2(0, -12), TdVfxData.THREAD_W, TdVfxData.THREAD_TIME, TdVfxData.COURT_DRINK_TINT)
				if f != null:
					f.to = best.pos + Vector2(0, -12)
	return dealt
