## Corpse Abomination kit (GDD §4.1): the heavy blocker of blocker.gd that
## holds 4 and stomps every held enemy at once; each stomp staggers them for
## `stagger_time` s (no attacks; Killing Field boulders aim at staggered
## packs) through TdCombat.stagger_enemy(). Evolved into the Bone Colossus
## (EvolutionData "bone_colossus", keys in its "set"): it taunts, taking the
## hits meant for any other blocker body within `taunt_radius` px
## (BlockBody.taunt_by, read by TdEnemy), and when it falls it bursts into
## bone shrapnel: `shrapnel_mult` x its stomp damage to every enemy within
## `shrapnel_radius` px.
## Tower.vars: "up" — Array[bool], each body's alive state last step (shrapnel on its fall).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var held := b.held.duplicate()  # Stomped this time (deaths shrink b.held).
	var dealt := super(t, b)  # The stomp itself.
	for e: TdEnemy in held:
		if e.alive:
			TdCombat.stagger_enemy(t.game, e, float(t.stats["stagger_time"]))
	t.game.fx.spawn("frost_nova", b.pos, 70.0, 0.3, Color(0.9, 0.75, 0.6, 0.6))
	return dealt


func step(t: Tower, dt: float) -> void:
	super(t, dt)
	var taunt := float(t.stats.get("taunt_radius", 0.0))  # Colossus taunt reach (0 = none).
	if taunt <= 0.0:
		return
	var up: Array = t.vars.get("up", [])  # Bodies alive last step.
	for i in t.block.bodies.size():
		var b: BlockBody = t.block.bodies[i]
		if i < up.size() and bool(up[i]) and not b.alive:
			_shrapnel(t, b)
		if b.alive:
			for blk: RoadBlock in t.game.blocks:
				if blk == t.block:
					continue
				for o: BlockBody in blk.bodies:
					if not o.temporary and o.pos.distance_squared_to(b.pos) <= taunt * taunt:
						o.taunt_by = b
						o.taunt_until = t.game.time + 0.25
	t.vars["up"] = t.block.bodies.map(func(x: BlockBody) -> bool: return x.alive)


## Bone shrapnel from fallen Colossus body `b`.
func _shrapnel(t: Tower, b: BlockBody) -> void:
	var dmg := float(t.stats["damage"]) * float(t.stats["shrapnel_mult"])  # Damage to each enemy.
	for e: TdEnemy in t.game.enemies_near(b.pos, float(t.stats["shrapnel_radius"])):
		TdCombat.damage_enemy(t.game, e, dmg, {"source": "colossus_shrapnel", "tower": t, "origin": b.pos})
	t.game.fx.spawn("bone_wall_burst", b.pos, float(t.stats["shrapnel_radius"]) * 2.0, 0.5)
	t.game.stats["shrapnel"] = int(t.game.stats.get("shrapnel", 0)) + 1
