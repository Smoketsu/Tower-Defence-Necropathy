## Iron Revenant kit (Act XII's second unlockable summon; Necropathy's Iron
## Revenant: "one of the Empire's war walkers, reanimated, its plating bound
## with bone and soul fire; it holds a post and lays down suppressive fire that
## slows what it hits"): a heavy blocker (blocker.gd: its one body holds `hold`
## and strikes what it holds) whose cannon also fires over the post while its
## body stands: every `gun_interval` s (scaled like its strikes by level and
## buffs) it shoots `shells` shells, the first at its target by mode within
## `range` px and each other at another enemy in range, each `gun_mult` x its
## damage, slowing (`slow` / `slow_time`, TdProjectiles) and splashing
## (`splash`, 0 = none). Its body is a wall of steel: Empire shots aimed past
## the post stop on it like on any blocker (the Line of Fire's answer).
## Evolved into the Deus Revenant (EvolutionData "deus_revenant"): missiles
## (`projectile` deus_missile) that splash, and more of them.
## Under Pinned Down (SynergyData "pin_time") every foe a shell hits is
## marked pinned (TdCombat.pin_enemy) for the archers.
## Tower.vars: "salvos" (bursts fired, the kit summary's counter).
extends "res://scripts/towers/blocker.gd"


func step(t: Tower, dt: float) -> void:
	super(t, dt)
	var g := t.game  # The run.
	if g.time < t.next_fire or not t.block.bodies.any(func(b: BlockBody) -> bool: return b.alive):
		return
	var target := t.pick_target()  # Its gun's target.
	if target == null:
		return
	t.next_fire = g.time + float(t.stats["gun_interval"]) * float(t.stats["interval"]) / float(t.row["interval"])
	var others := g.foes_near(t.position, float(t.stats["range"]))  # Other shells' targets.
	others.erase(target)
	for i in range(others.size() - 1, -1, -1):
		if not t.can_hit(others[i]):
			others.remove_at(i)
	for i in int(t.stats["shells"]):
		var e: TdEnemy = target if i == 0 or others.is_empty() else others[(i - 1) % others.size()]
		g.projectiles.fire(t, e, float(t.stats["damage"]) * float(t.stats["gun_mult"]), String(t.stats["projectile"]), Color.WHITE, false)
	t.vars["salvos"] = int(t.vars.get("salvos", 0)) + 1
	g.sound_fire(t.tower_id)


func impact(t: Tower, _shot: TdProjectiles.Shot, victims: Array[TdEnemy]) -> void:
	var pin := float(Synergies.value(t, "pin_time", 0.0))  # Pinned Down mark (s; 0 = pair not active).
	if pin > 0.0:
		for e: TdEnemy in victims:
			if e.alive:
				TdCombat.pin_enemy(t.game, e, pin)
