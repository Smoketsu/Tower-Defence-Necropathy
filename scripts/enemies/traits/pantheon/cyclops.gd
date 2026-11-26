## Cyclops and Polyphemus (Act VIII; Necropathy's CyclopsKit / PolyphemusKit:
## "throws boulders with a landing circle; flat armour"): every `throw_every`
## s (first after `throw_first`; x `rage_mult` once its HP is below `rage_hp`)
## it hurls `boulders` boulders at the towers nearest it within `throw_range`
## px (not already disabled): each a telegraphed landing circle
## (game.hostile.shell: `radius` px, landing after `delay` s; towers inside
## are disabled `disable` s, blocker bodies take `body_damage`). Flat armour is
## its row's. Args: throw_first, throw_every (s), throw_range (px), boulders,
## radius (px), delay, disable (s), body_damage, rage_hp (0..1, 0 = never),
## rage_mult (x interval). vars: "next_throw" (game s), "raged" (bool).
## Counted as event "boulders".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_throw"] = game.time + float(e.row["args"]["throw_first"])
	e.vars["raged"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if not bool(e.vars["raged"]) and e.hp < e.max_hp * float(a["rage_hp"]):
		e.vars["raged"] = true
		game.banner("%s roars in rage: the boulders come faster!" % String(e.row["name"]))
		EnemyTrait.note(game, "cyclops_rage")
	if game.time < float(e.vars["next_throw"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var ts: Array[Tower] = []  # Towers in reach, not disabled.
	var r := float(a["throw_range"])  # Reach (px).
	for t: Tower in game.towers:
		if game.time >= t.disabled_until and t.position.distance_squared_to(e.position) <= r * r:
			ts.append(t)
	if ts.is_empty():
		return
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	e.vars["next_throw"] = game.time + float(a["throw_every"]) * (float(a["rage_mult"]) if bool(e.vars["raged"]) else 1.0)
	for t: Tower in ts.slice(0, int(a["boulders"])):
		game.hostile.shell(t.position, float(a["radius"]), float(a["delay"]), float(a["disable"]), "shelled", float(a["body_damage"]))
		EnemyTrait.note(game, "boulders")
	e.vis_strike_at = game.time  # The throw's lunge (drawn only).
	e.vis_strike_dir = (ts[0].position - e.position).normalized()
