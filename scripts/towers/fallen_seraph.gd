## Fallen Seraph kit (gw2-kit; Necropathy's Seraphine-unlocked class): every
## `interval` s it throws `feathers` black feathers, the first at its target by
## mode and each other at a different enemy in range (flyers included); from
## level 3 the volley adds its burst. Evolved into the Seraph of Ruin
## (EvolutionData "seraph_of_ruin"): five piercing feathers, and every
## `ruin_every`-th shot it falls on the strongest enemy in range, `ruin_mult` x
## damage to every enemy within `ruin_radius` px (effects/seraph_dive).
## Tower.vars: "ruins" — dives made.
extends "res://scripts/towers/projectile.gd"


func step(t: Tower, _dt: float) -> void:
	var g := t.game  # The run.
	if g.time < t.next_fire:
		return
	var target := t.pick_target()  # First feather's target.
	if target == null:
		return
	t.next_fire = g.time + float(t.stats["interval"])
	t.shots += 1
	t.face(target.position)
	t.squash_until = g.time + TowerData.FIRE_SQUASH_TIME
	g.sound_fire(t.tower_id)
	var others := g.foes_near(t.position, float(t.stats["range"]))  # Other feathers' targets.
	others.erase(target)
	for i in range(others.size() - 1, -1, -1):
		if not t.can_hit(others[i]):
			others.remove_at(i)  # Flyers / hidden foes it may not strike.
	var n := int(t.stats["feathers"])  # Feathers this shot.
	for i in n:
		var e: TdEnemy = target if i == 0 or others.is_empty() else others[(i - 1) % others.size()]
		g.projectiles.fire(t, e, float(t.stats["damage"]), String(t.stats["projectile"]), Color.WHITE, false)
	var every := int(t.stats["ruin_every"])  # Ruin cadence (0 = not evolved).
	if every > 0 and t.shots % every == 0:
		_ruin(t)
	volley(t, target)


## The Seraph of Ruin's fall on the strongest enemy in range.
func _ruin(t: Tower) -> void:
	var g := t.game  # The run.
	var best: TdEnemy = null  # Strongest.
	for e: TdEnemy in g.foes_near(t.position, float(t.stats["range"])):
		if t.can_hit(e) and (best == null or e.hp > best.hp):
			best = e
	if best == null:
		return
	var at := best.position  # Where it falls.
	var r := float(t.stats["ruin_radius"])  # Blast radius (px).
	for e: TdEnemy in g.foes_near(at, r):
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]) * float(t.stats["ruin_mult"]), {"source": "seraph_ruin", "tower": t, "origin": at})
	t.vars["ruins"] = int(t.vars.get("ruins", 0)) + 1
	if g.vfx.on:
		g.vfx.add(TdVfx.Kind.ANIM, at, r * 2.6, 0.55, Color.WHITE, "seraph_dive")
		var ring := g.vfx.add(TdVfx.Kind.RING, at, r * TdVfxData.RING_TO, TdVfxData.RING_TIME * 1.4, TdVfxData.KIT_RUIN_TINT)
		if ring != null:
			ring.size0 = r * TdVfxData.RING_FROM
		var f := g.vfx.add(TdVfx.Kind.THREAD, t.position + Vector2(0, -30), 16.0, 0.35, TdVfxData.KIT_RUIN_TINT)
		if f != null:
			f.to = at
		g.vfx.shake(3.0)
