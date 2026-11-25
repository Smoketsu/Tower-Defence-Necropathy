## Captain Cornelius Vandermere at his wheel, road version (the Maelstrom's
## boss, the Black Tide's finale; Necropathy BossVandermere).
##   DEAD MEN'S OATH — while the Oath holds he takes `oath_taken` of every hit.
##     Every enemy killed while he is on the map (his crew's souls, claimed by
##     the necromancer) chips it `oath_chip`; empty, it BREAKS: he takes
##     `vulnerable_taken` for `vulnerable_time` s, then the Oath refills and he
##     calls his crew at once. A spectral ring pulses round him while it holds.
##   THE CREW — every `crew_every` s (the first after `crew_first`) he stands
##     `crew_cast` s calling (pose 1) and his drowned crew (`crew`) boards at
##     the start of road `crew_road` (missing: the first entrance).
##   HIS LANTERN VOLLEY — every `volley_every` s, `volley_count` spectral shots
##     (game.hostile.fire(), arcing) at the nearest towers within
##     `volley_range` px, each disabling `volley_disable` s.
##   THE MAELSTROM — below `maelstrom_hp`, every `kraken_every` s a kraken arm
##     strikes the tower nearest him (a telegraphed shell, cause "grabbed").
## Args in his row. vars: "oath" (0..1), "broken_until", "next_crew",
## "call_at", "next_volley", "next_kraken", "kills_seen", "maelstrom",
## "pose_until", "next_pulse" (game s / counts).
extends EnemyTrait

## The crew boarding shared with the Ghost Bosun.
const GhostBosun = preload("res://scripts/enemies/traits/corsair/ghost_bosun.gd")
## The nearest-tower search shared with the Voodoo Navigator.
const SeaMark = preload("res://scripts/enemies/traits/corsair/sea_mark.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["oath"] = 1.0
	e.vars["broken_until"] = 0.0
	e.vars["next_crew"] = game.time + float(a["crew_first"])
	e.vars["next_volley"] = game.time + float(a["volley_every"]) * 0.5
	e.vars["next_kraken"] = 0.0
	e.vars["kills_seen"] = _kills(game)
	e.vars["maelstrom"] = false
	e.vars["pose_until"] = 0.0
	e.vars["next_pulse"] = 0.0


## Every enemy killed this run so far.
static func _kills(game: TdGame) -> int:
	var n := 0  # Total.
	for k: String in game.stats["kills"]:
		n += int(game.stats["kills"][k])
	return n


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var kills := _kills(game)  # Kills so far.
	var broken := game.time < float(e.vars["broken_until"])  # The Oath is broken now.
	if not broken and float(e.vars["broken_until"]) > 0.0:
		e.vars["broken_until"] = 0.0
		e.vars["oath"] = 1.0
		e.vars["next_crew"] = game.time
		game.banner("Vandermere renews Dead Men's Oath!")
	if not broken:
		e.vars["oath"] = float(e.vars["oath"]) - float(kills - int(e.vars["kills_seen"])) * float(a["oath_chip"])
		if float(e.vars["oath"]) <= 0.0:
			e.vars["broken_until"] = game.time + float(a["vulnerable_time"])
			game.banner("Dead Men's Oath breaks! Vandermere is vulnerable")
			EnemyTrait.note(game, "vandermere_oath_breaks")
			game.fx.spawn("frost_shatter", e.position, 160.0, 0.6, Acts.data("corsair")["LOOK"]["oath_tint"])
	e.vars["kills_seen"] = kills
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and not e.vars.has("call_at"):
		e.pose = 0
		e.body.queue_redraw()
	if game.vfx.on and not broken and game.time >= float(e.vars["next_pulse"]):
		var lk: Dictionary = Acts.data("corsair")["LOOK"]  # Looks.
		e.vars["next_pulse"] = game.time + float(lk["oath_pulse"])
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(lk["oath_ring"]) + float(lk["oath_ring_grow"]) * float(e.vars["oath"]), float(lk["oath_pulse"]) * 0.9, lk["oath_tint"])
		if ring != null:
			ring.size0 = float(lk["oath_ring_from"])
	if not bool(e.vars["maelstrom"]) and e.hp < e.max_hp * float(a["maelstrom_hp"]):
		e.vars["maelstrom"] = true
		game.banner("The Maelstrom roars: kraken arms rise from the deep!")
		EnemyTrait.note(game, "vandermere_maelstrom")
	if e.vars.has("call_at"):
		if game.time >= float(e.vars["call_at"]):
			e.vars.erase("call_at")
			e.speed = float(e.row["speed"])
			var road := String(a["crew_road"]) if game.roads.has(String(a["crew_road"])) else game.first_entrance()  # Where his crew boards.
			GhostBosun.board(game, road, a["crew"], float(a["crew_gap"]))
			EnemyTrait.note(game, "vandermere_crews")
		return
	if game.time >= float(e.vars["next_crew"]):
		e.vars["next_crew"] = game.time + float(a["crew_every"])
		e.vars["call_at"] = game.time + float(a["crew_cast"])
		e.speed = 0.0
		e.pose = 1
		e.body.queue_redraw()
		game.banner("Vandermere calls his drowned crew!")
		return
	if game.time >= float(e.vars["next_volley"]):
		e.vars["next_volley"] = game.time + float(a["volley_every"])
		_volley(e, game, a)
	if bool(e.vars["maelstrom"]) and game.time >= float(e.vars["next_kraken"]):
		var t := SeaMark.nearest_tower(game, e.position, INF)  # The struck tower.
		if t != null:
			e.vars["next_kraken"] = game.time + float(a["kraken_every"])
			game.hostile.shell(t.position, float(a["kraken_radius"]), float(a["kraken_telegraph"]), float(a["kraken_disable"]), "grabbed", float(a["kraken_body_damage"]))
			EnemyTrait.note(game, "vandermere_kraken")


## His lantern volley at the nearest towers.
func _volley(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ts: Array[Tower] = []  # Towers in range.
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= float(a["volley_range"]):
			ts.append(t)
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	for i in mini(int(a["volley_count"]), ts.size()):
		game.hostile.fire(e.position + Vector2(0, -30), ts[i], {"disable": float(a["volley_disable"]), "cause": "shot", "speed": float(a["volley_speed"]), "arc": true, "look": "spectral"})
	if not ts.is_empty():
		EnemyTrait.note(game, "vandermere_volleys")
		e.pose = 1
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		e.body.queue_redraw()


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]  # His numbers.
	return amount * (float(a["vulnerable_taken"]) if game.time < float(e.vars.get("broken_until", 0.0)) else float(a["oath_taken"]))
