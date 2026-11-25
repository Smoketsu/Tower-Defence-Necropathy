## The Ghost Bosun (the Maelstrom's miniboss; Necropathy GhostBosunKit "whose
## whistle summons a spectral longboat"): every `every` s (the first after
## `first`) he stops with the whistle at his lips for `windup` s, then a
## spectral longboat's crew boards at the start of road `road` (missing: the
## first entrance): `crew` drowned deckhands and `gunners` drowned gunners,
## `gap` px apart, as extras of the current wave (WaveDirector.spawn_extra()).
## Args in his row. vars: "next" (game s of the next whistle), "call_at" (game s
## the crew boards; absent = not whistling).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.vars.has("call_at"):
		if game.time < float(e.vars["call_at"]):
			return
		e.vars.erase("call_at")
		e.speed = float(e.row["speed"])
		var road := String(a["road"]) if game.roads.has(String(a["road"])) else game.first_entrance()  # Where the boat comes alongside.
		board(game, road, [{"kind": "tide_ghost_deckhand", "count": int(a["crew"])}, {"kind": "tide_ghost_gunner", "count": int(a["gunners"])}], float(a["gap"]))
		game.banner("The Ghost Bosun's longboat comes alongside!")
		EnemyTrait.note(game, "ghost_bosun_boats")
		return
	if game.time < float(e.vars["next"]):
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["call_at"] = game.time + float(a["windup"])
	e.speed = 0.0  # He stands to whistle.
	e.vis_strike_at = game.time
	e.vis_strike_dir = Vector2.UP


## A boat's crew boards at the start of road `road`: each {kind, count} group,
## `gap` px apart, lanes from the run's RNG (shared with the bosses' calls).
static func board(game: TdGame, road: String, crew: Array, gap: float) -> void:
	var k := 0  # Boarders so far.
	for g: Dictionary in crew:
		for i in int(g["count"]):
			game.waves.spawn_extra(String(g["kind"]), road, -float(k) * gap, game.rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD))
			k += 1
	game.fx.spawn("tide_splash", game.roads[road].point_at(0.0), float(Acts.data("corsair")["LOOK"]["splash_d"]), 0.6)
