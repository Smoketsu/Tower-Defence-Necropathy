## Ushabti Sentinel kit (Act VII's unlockable summon class; Necropathy's
## Ushabti Sentinel: "a stone servant that answers for its master; it
## reassembles once on a lethal blow"): a blocker (blocker.gd) whose bodies,
## felled, REASSEMBLE: `reassembles` times per life each body climbs back
## after `reassemble_delay` s at `reassemble_frac` of its HP, and the sand of
## its rising staggers every foe within `reassemble_radius` px for
## `stagger_time` s (TdCombat.stagger_enemy). Once its reassemblies are spent a
## felled body waits for its normal respawn, which restores them. Evolved into
## the Eternal Guard (EvolutionData "eternal_guard", keys in its "set"): more
## reassemblies at full HP, a longer stagger, holds more.
## Tower.vars: "left" (reassemblies left per body), "partial" (true while a body
## is reassembling), "was_dead" (per body, last step), "reassembled" (count).
extends "res://scripts/towers/blocker.gd"


func step(t: Tower, dt: float) -> void:
	var n := t.block.bodies.size()  # Bodies now (levels add some).
	var left: Array = t.vars.get("left", [])
	var partial: Array = t.vars.get("partial", [])
	var was_dead: Array = t.vars.get("was_dead", [])
	while left.size() < n:
		left.append(int(t.stats["reassembles"]))
		partial.append(false)
		was_dead.append(false)
	for i in n:
		var b: BlockBody = t.block.bodies[i]
		was_dead[i] = not b.alive
		if not b.alive and not bool(partial[i]) and int(left[i]) > 0 and b.respawn_at > t.game.time + float(t.stats["reassemble_delay"]):
			b.respawn_at = t.game.time + float(t.stats["reassemble_delay"])  # The pieces gather.
			partial[i] = true
			left[i] = int(left[i]) - 1
	super(t, dt)
	for i in n:
		var b: BlockBody = t.block.bodies[i]
		if not bool(was_dead[i]) or not b.alive:
			continue
		if bool(partial[i]):
			partial[i] = false
			b.hp = b.max_hp * float(t.stats["reassemble_frac"])
			_rise(t, b)
		else:
			left[i] = int(t.stats["reassembles"])  # A full respawn restores them.
	t.vars["left"] = left
	t.vars["partial"] = partial
	t.vars["was_dead"] = was_dead


## A body stood up from its pieces: the sand staggers the foes around it.
func _rise(t: Tower, b: BlockBody) -> void:
	t.vars["reassembled"] = int(t.vars.get("reassembled", 0)) + 1
	for e: TdEnemy in t.game.foes_near(b.pos, float(t.stats["reassemble_radius"])):
		TdCombat.stagger_enemy(t.game, e, float(t.stats["stagger_time"]))
	if t.game.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		var r := float(t.stats["reassemble_radius"])
		t.game.vfx.add(TdVfx.Kind.ANIM, b.pos, r * 2.0 * k, 0.5, Acts.data("dynasty")["LOOK"]["sand"], "spore_cloud")
		var ring := t.game.vfx.add(TdVfx.Kind.RING, b.pos, r, TdVfxData.RING_TIME, Acts.data("dynasty")["LOOK"]["gold"])
		if ring != null:
			ring.size0 = r * 0.3
