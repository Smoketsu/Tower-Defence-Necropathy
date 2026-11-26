## Spawn of the Deep kit (Act XI's unlockable summon class; Necropathy's
## DeepSpawnBehavior "grasp": "tentacled spawn of the deep that seize foes and
## hold them fast"): a heavy blocker (blocker.gd) with a GRASP: every
## `grasp_every` s, while a body stands, a tentacle seizes the
## `grasp_targets` strongest foes (most HP; every pick through t.can_hit(),
## flyers included: it drags them down) within `grasp_range` px of the post
## that are not seized already, and holds each frozen `grasp_time` s
## (TdCombat.freeze_enemy, rank multipliers apply), squeezing it for
## `grasp_mult` x its damage every `grasp_tick` s (TdCombat.damage_enemy,
## credited to the tower). A frozen foe is what Salt of the Deep's mages burn
## harder. Evolved into the Leviathan (EvolutionData "leviathan", keys in its
## "set"): two foes at once, and each grasp's tentacles sweep the ground round
## the body: every foe within `sweep_radius` px takes `sweep_mult` x its damage
## and is thrown `sweep_knock` px back (TdCombat.knock_enemy). A disabled
## tower makes no step, so no grasp and no squeeze.
## Tower.vars: "next_grasp" (game s), "held" (Array of [TdEnemy, generation,
## end game s, next squeeze game s]), "grasps" (count), "slams" (the kit
## summary's counter: grasps).
extends "res://scripts/towers/blocker.gd"


func step(t: Tower, dt: float) -> void:
	super(t, dt)
	var g := t.game  # The run.
	var held: Array = t.vars.get("held", [])  # Seized foes.
	for i in range(held.size() - 1, -1, -1):
		var h: Array = held[i]
		var e: TdEnemy = h[0]
		if not TdEnemy.valid(e, int(h[1])) or g.time >= float(h[2]):
			held.remove_at(i)
			continue
		if g.time >= float(h[3]):
			h[3] = float(h[3]) + float(t.stats["grasp_tick"])
			TdCombat.damage_enemy(g, e, float(t.stats["damage"]) * float(t.stats["grasp_mult"]), {"source": t.tower_id, "tower": t, "origin": t.position})
	t.vars["held"] = held
	if g.time < float(t.vars.get("next_grasp", 0.0)) or not t.block.bodies.any(func(b: BlockBody) -> bool: return b.alive):
		return
	var picks := _strongest(t, held)  # Foes to seize.
	if picks.is_empty():
		return
	t.vars["next_grasp"] = g.time + float(t.stats["grasp_every"])
	t.vars["grasps"] = int(t.vars.get("grasps", 0)) + 1
	t.vars["slams"] = int(t.vars["grasps"])
	var from := t.block.bodies[0].pos  # Where the tentacles rise.
	for e: TdEnemy in picks:
		TdCombat.freeze_enemy(g, e, float(t.stats["grasp_time"]))
		held.append([e, e.generation, g.time + float(t.stats["grasp_time"]), g.time])
		if g.vfx.on:
			var lk: Dictionary = Acts.data("eye")["LOOK"]
			var f := g.vfx.add(TdVfx.Kind.STREAK, e.position, float(lk["tentacle_w"]) * TdVfx.loud(t), 0.45, lk["tentacle_tint"])
			if f != null:
				f.ang = (e.position - from).angle()
				f.size0 = maxf(from.distance_to(e.position), 12.0)
			g.vfx.add(TdVfx.Kind.ANIM, e.position, 56.0 * TdVfx.loud(t), 0.5, lk["tentacle_tint"], "drowned_tendrils")
	var sr := float(t.stats["sweep_radius"])  # Leviathan sweep (0 = none).
	if sr > 0.0:
		for e: TdEnemy in g.foes_near(from, sr):
			if t.can_hit(e):
				TdCombat.damage_enemy(g, e, float(t.stats["damage"]) * float(t.stats["sweep_mult"]), {"source": t.tower_id, "tower": t, "origin": from})
				TdCombat.knock_enemy(g, e, float(t.stats["sweep_knock"]))
		if g.vfx.on:
			var ring := g.vfx.add(TdVfx.Kind.RING, from, sr, TdVfxData.RING_TIME, TdVfxData.SHOTS["spawn_of_the_deep"]["tint"])
			if ring != null:
				ring.size0 = sr * TdVfxData.RING_FROM
			g.vfx.add(TdVfx.Kind.ANIM, from, sr * 2.0, 0.45, TdVfxData.SHOTS["spawn_of_the_deep"]["tint"], "tide_splash")
			g.vfx.shake(1.2)
	g.sound_fire(t.tower_id)


## The `grasp_targets` strongest foes in reach not seized already (most HP first; ties keep the hash order).
func _strongest(t: Tower, held: Array) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []  # Candidates.
	for e: TdEnemy in t.game.foes_near(t.block.bodies[0].pos, float(t.stats["grasp_range"])):
		if t.can_hit(e) and not held.any(func(h: Array) -> bool: return h[0] == e and int(h[1]) == e.generation):
			out.append(e)
	out.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	return out.slice(0, int(t.stats["grasp_targets"]))
