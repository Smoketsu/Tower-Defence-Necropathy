## Shieldbearer (GDD §6.1 "Takes less damage from the front"): a hit whose
## origin lies ahead of it along its walking direction (a tower's spot when
## a tower dealt it, else the hit's origin) takes `front_mult` of its damage.
## Damage over time, hits with no origin and the sources in `ignore` (the
## Catapult's arcing boulders) go around the shield.
## Args: front_mult (0..1), ignore (Array of hit sources).
extends EnemyTrait


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, hit: Dictionary) -> float:
	if bool(hit.get("dot", false)):
		return amount
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	if (a["ignore"] as Array).has(String(hit.get("source", ""))):
		return amount
	return amount * float(a["front_mult"]) if from_front(e, hit) else amount


## True when hit `hit` came from ahead of `e` (the side its shield faces).
static func from_front(e: TdEnemy, hit: Dictionary) -> bool:
	var tower: Tower = hit.get("tower", null)  # Dealer, if a tower.
	var origin: Variant = tower.position if tower != null and is_instance_valid(tower) else hit.get("origin", null)  # Where it came from.
	if origin == null:
		return false
	return (Vector2(origin) - e.position).dot(e.follower.direction()) > 0.0
