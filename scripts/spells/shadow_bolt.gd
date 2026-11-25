## Shadow Bolt (GDD §5): an aimed single-target shot, the finisher for leaks.
## Targets the enemy nearest the tap within `pick_radius` px and flies from
## the necromancer at the gate at `speed` px/s; on arrival it deals `damage`
## through TdCombat. Row: SpellData "shadow_bolt".
extends TdSpell

## Bolts in flight: [map px, target TdEnemy, its generation, aim px].
var _bolts: Array = []


func cast(pos: Vector2) -> bool:
	var best: TdEnemy = null  # Nearest enemy to the tap.
	var best_d := INF  # Its squared distance.
	for e: TdEnemy in game.enemies_near(pos, float(row["pick_radius"])):
		var d := e.position.distance_squared_to(pos)  # Squared distance to the tap.
		if d < best_d:
			best_d = d
			best = e
	if best == null:
		return false
	_bolts.append([game.necromancer_pos(), best, best.generation, best.position])
	return true


func step(dt: float) -> void:
	for i in range(_bolts.size() - 1, -1, -1):
		var b: Array = _bolts[i]
		var e: TdEnemy = b[1]
		if TdEnemy.valid(e, int(b[2])):
			b[3] = e.position
		var to: Vector2 = b[3] - b[0]  # Remaining flight.
		var move := float(row["speed"]) * dt  # Px this step.
		if to.length() > move:
			b[0] = b[0] + to.normalized() * move
			continue
		_bolts.remove_at(i)
		if TdEnemy.valid(e, int(b[2])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": b[0]})
		game.fx.spawn("bolt_impact", b[3], 64.0, 0.3, Color(0.8, 0.6, 1.0))


func draw(ci: CanvasItem) -> void:
	for b: Array in _bolts:
		SpriteBank.draw_flat(ci, String(row["projectile"]), b[0], (b[3] - b[0]).angle())


func busy() -> bool:
	return not _bolts.is_empty()
