## Projectile behaviour (Archer, Mage, Frost Wraith, Catapult and any plot
## tower that shoots): every `interval` s it picks a target by its mode and
## fires one shot (TdProjectiles) with its stats; from level 3 the volley
## hook adds its burst. Hits, splash, slows and freezes resolve in
## TdProjectiles through TdCombat.
extends TowerBehavior


func step(t: Tower, _dt: float) -> void:
	if t.game.time < t.next_fire:
		return
	var target := t.pick_target()  # Enemy to shoot, or null.
	if target == null:
		return
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.face(target.position)
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	t.game.sound_fire(t.tower_id)
	t.game.projectiles.fire(t, target, float(t.stats["damage"]), String(t.stats["projectile"]), Color.WHITE, false)
	volley(t, target)
