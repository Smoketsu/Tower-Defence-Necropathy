## Aura behaviour (Banshee, Grave Mender): every `interval` s it pulses on
## everything in range: enemies (affects "enemies": wail damage, slow,
## weaken) or blocker bodies (affects "blockers": heal). From level 3 the
## pulse is drawn with its class's effect strip (the aura's volley look).
extends TowerBehavior


func step(t: Tower, _dt: float) -> void:
	if t.game.time < t.next_fire:
		return
	var r := float(t.stats["range"])  # Pulse radius (px).
	if String(t.stats["affects"]) == "blockers":
		var hurt := false  # True when any body in range needs healing.
		for b: BlockBody in t.game.bodies_near(t.position, r):
			if b.hp < b.max_hp:
				hurt = true
				TdCombat.heal_body(t.game, b, float(t.stats["heal"]))
		if not hurt:
			return
	else:
		var targets := t.game.enemies_near(t.position, r)  # Enemies in the pulse.
		if targets.is_empty():
			return
		for e: TdEnemy in targets:
			TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t})
			if e.alive:
				TdCombat.slow_enemy(t.game, e, float(t.stats["slow"]), float(t.stats["slow_time"]))
				TdCombat.weaken_enemy(t.game, e, float(t.stats["weaken"]), float(t.stats["weaken_time"]))
	t.game.sound_fire(t.tower_id)
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	t.game.fx.spawn("frost_nova" if t.level >= 3 else "volley_hit", t.position, r * 2.0, 0.5,
			Color(0.7, 1.0, 0.8, 0.5) if String(t.stats["affects"]) == "blockers" else Color(0.8, 0.7, 1.0, 0.5))
