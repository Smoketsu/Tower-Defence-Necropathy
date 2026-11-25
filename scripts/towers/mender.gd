## Grave Mender kit (GDD §4.1 "heals blockers in range"): every `interval` s
## it restores `heal` HP to every hurt blocker body within range (through
## TdCombat.heal_body()); it keeps its healing record in Tower.vars "healed"
## (the Profane Bishop recipe). Evolved into the Profane Bishop (EvolutionData
## "profane_bishop", keys in its "set"): each pulse also burns every enemy in
## range for `burn` damage and hurries every fallen body in range back
## `revive_haste` s sooner.
## Tower.vars: "healed" — HP restored so far.
extends "res://scripts/towers/aura.gd"


func step(t: Tower, _dt: float) -> void:
	if t.game.time < t.next_fire:
		return
	var r := float(t.stats["range"])  # Pulse radius (px).
	var haste := float(t.stats.get("revive_haste", 0.0))  # Bishop: respawn hurry (s; 0 = none).
	var burn := float(t.stats.get("burn", 0.0))  # Bishop: burn damage (0 = none).
	var acted := false  # True when the pulse did anything.
	for blk: RoadBlock in t.game.blocks:
		for b: BlockBody in blk.bodies:
			if b.temporary or b.pos.distance_squared_to(t.position) > r * r:
				continue
			if b.alive and b.hp < b.max_hp:
				t.vars["healed"] = float(t.vars.get("healed", 0.0)) + TdCombat.heal_body(t.game, b, float(t.stats["heal"]))
				t.game.vfx.heal(t, b)
				acted = true
			elif not b.alive and haste > 0.0:
				b.respawn_at -= haste
				acted = true
	if burn > 0.0:
		for e: TdEnemy in t.game.enemies_near(t.position, r):
			TdCombat.damage_enemy(t.game, e, burn, {"source": "bishop_burn", "tower": t})
			acted = true
	if not acted:
		return
	t.game.sound_fire(t.tower_id)
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	t.game.fx.spawn("frost_nova" if t.level >= 3 else "volley_hit", t.position, r * 2.0, 0.5,
			Color(0.9, 0.5, 1.0, 0.5) if burn > 0.0 else Color(0.7, 1.0, 0.8, 0.5))
