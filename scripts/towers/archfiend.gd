## Archfiend kit (Act IX's finale summon class, opened by the Morning Star;
## Necropathy's Archfiend, "a winged heavy demon"): a heavy blocker
## (blocker.gd) whose every strike sets what it hits burning (`burn_dps` per s
## for `burn_time` s, TdCombat.add_dot, source "archfiend_burn"); every
## `breath_every`-th strike it breathes hellfire: every foe within
## `breath_radius` px of the body (the held ones too) takes `breath_mult` x its
## damage and starts burning. Evolved into the Prince of Hell (EvolutionData
## "prince_of_hell": holds more, breathes every other strike, wider, hotter).
## Tower.vars: "strikes" (count), "breaths" (the kit summary's counter).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var first: TdEnemy = b.held[0]  # Struck now (super hits it).
	var dealt := super(t, b)
	_burn(t, first)
	t.vars["strikes"] = int(t.vars.get("strikes", 0)) + 1
	if int(t.vars["strikes"]) % int(t.stats["breath_every"]) != 0:
		return dealt
	var r := float(t.stats["breath_radius"])  # Px.
	for e: TdEnemy in t.game.foes_near(b.pos, r):
		dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * float(t.stats["breath_mult"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
		_burn(t, e)
	t.vars["breaths"] = int(t.vars.get("breaths", 0)) + 1
	if t.game.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -6), r * 2.0, 0.45, Color(1.0, 0.6, 0.3), "corpse_explosion")
		var ring := t.game.vfx.add(TdVfx.Kind.RING, b.pos, r, TdVfxData.RING_TIME, Color(1.0, 0.5, 0.2, 0.9))
		if ring != null:
			ring.size0 = r * 0.3
		t.game.vfx.shake(TdVfxData.SMASH_SHAKE * 0.5 * k)
	return dealt


## Sets `e` burning (its DoT and the drawn burning mark).
func _burn(t: Tower, e: TdEnemy) -> void:
	if not e.alive:
		return
	TdCombat.add_dot(t.game, e, float(t.stats["burn_dps"]), float(t.stats["burn_time"]), "archfiend_burn")
	e.vis_field_until = t.game.time + float(t.stats["burn_time"])
	e.vis_field_look = "flame"
