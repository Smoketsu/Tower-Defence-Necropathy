## Crimson Witch (the Witchwood's covens; Necropathy WitchHexes): every `every`
## s (twice as often near a living hex stone within `stone_range` px) she draws
## a hex circle of `circle_r` px on the nearest tower within `range` px: every
## tower in it deals `mult` x damage for `time` s (CourtKit.hex ->
## TdCombat.suppress_tower). Under the Blood Moon or near a hex stone she also
## heals every Court foe within `heal_radius` px by `heal` (not while silenced:
## EnemyTrait.can_heal). Args: range, every, circle_r, mult, time, heal,
## heal_radius, stone_range. vars: "next_cast" (game s).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_cast"] = game.time + float(e.row["args"]["every"]) * 0.5


## True when a living hex stone stands within `r` px of `e`.
static func stone_near(e: TdEnemy, game: TdGame, r: float) -> bool:
	for o: TdEnemy in game.enemies_near(e.position, r):
		if o.kind == "hex_stone":
			return true
	return false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_cast"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	var t := CourtKit.nearest_tower(game, e.position, float(a["range"]))  # Her mark.
	if t == null:
		return
	var stone := stone_near(e, game, float(a.get("stone_range", 0.0)))  # Powered by a hex stone.
	e.vars["next_cast"] = game.time + float(a["every"]) * (0.5 if stone else 1.0)
	CourtKit.hex(game, t, float(a["circle_r"]), float(a["mult"]), float(a["time"]))
	e.vis_strike_at = game.time
	e.vis_strike_dir = (t.position - e.position).normalized()
	if (stone or CourtKit.moon_up(game)) and a.has("heal") and EnemyTrait.can_heal(e, game):
		for o: TdEnemy in game.foes_near(e.position, float(a["heal_radius"])):
			if o != e and o.hp < o.max_hp:
				TdCombat.heal_enemy(game, o, float(a["heal"]))
		game.fx.spawn("level_up", e.position, 70.0, 0.5, Color(1.0, 0.35, 0.4))
		EnemyTrait.note(game, "coven_heals")
