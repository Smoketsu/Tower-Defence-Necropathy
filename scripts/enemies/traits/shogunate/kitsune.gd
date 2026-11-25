## Kitsune (Necropathy's KitsuneKit, fox-fire illusions): every `every` s
## (first after `first`) she conjures `count` illusions of herself (kind
## `kind`, a fox_fire row) beside her on the road, `gap` px apart, keeping at
## most `max`; towers waste shots on them. They fade when she dies.
## Args: first, every (s), count, kind, gap (px), max. vars: "next",
## "decoys" ([[TdEnemy, generation], ...]).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["decoys"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next"] = game.time + float(a["every"])
	var live: Array = (e.vars["decoys"] as Array).filter(func(p: Array) -> bool: return TdEnemy.valid(p[0], int(p[1])))
	for i in int(a["count"]):
		if live.size() >= int(a["max"]):
			break
		var side := float(i % 2 * 2 - 1)  # Alternate ahead / behind.
		var d := maxf(e.follower.dist + side * float(a["gap"]) * float(i / 2 + 1), 0.0)  # Px along her road.
		var c := game.waves.spawn_extra(String(a["kind"]), e.follower.road.id, d, e.follower.lane - side * 8.0)
		live.append([c, c.generation])
		game.fx.spawn("level_up", c.position, 50.0, 0.5, Acts.data("shogunate")["LOOK"]["fox_tint"])
	e.vars["decoys"] = live
	EnemyTrait.note(game, "kitsune_conjures")


func on_death(e: TdEnemy, game: TdGame) -> void:
	for p: Array in e.vars.get("decoys", []):
		if TdEnemy.valid(p[0], int(p[1])):
			var c: TdEnemy = p[0]
			game.fx.spawn("level_up", c.position, 50.0, 0.5, Acts.data("shogunate")["LOOK"]["fox_tint"])
			game.remove_enemy(c, false)
