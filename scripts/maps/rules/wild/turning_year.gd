## The Turning Year: Act XV's act rule (GDD §7.3 names no gimmick for this act:
## DECISIONS T15; Necropathy's SeasonCycle and Thickets, docs/year/). Numbers in
## Acts.data("wild")["RULE"] (its "maps" row for this map). The season turns
## every `per` waves (season `start` on wave 1; a map's `hold` keeps one season all
## run; bosses and minibosses force one for a while through set_override()),
## and each season changes ONE thing, announced by a banner:
##   Spring — `thickets` towers' spots sprout a thicket (a telegraph of `sprout`
##            s), then it CHOKES the spot: its tower is disabled (the one stop
##            path, TdCombat.disable_tower, cause "choked") until a tap burns
##            the thicket for `burn_cost` souls (YearLayer's input, or the
##            bot's autotest_tap()). Thickets outlast Spring. plant() is the
##            one way to sprout one (the Gardener, the Stag King's Crown).
##   Summer — every enemy spawned is `summer_speed` x faster
##            (TdCombat.empower_enemy, from on_spawn()).
##   Autumn — every `sprout_every`-th fodder kill rises once as a `sprout_kind`
##            where it fell (spawned on the next step, never inside a kill).
##   Winter — every tower attacks at `winter_rate` x its speed
##            (TdCombat.chill_tower, the one attack-speed chill).
## The Green Mother's Last Claim borrows the Underworld's claim through
## on_body_fallen() while `claim_until` runs (claim_kind rises from the body).
## The look: YearLayer (edge bands in the season's colour, drifting leaves or
## snow, sprouts and thickets on their spots, frost under chilled towers) and
## YearDial (the HUD wheel of the year), both null headless.
extends MapRule

## Season ids (RULE "names" order).
enum { SPRING, SUMMER, AUTUMN, WINTER }

## This map's RULE "maps" row.
var cfg: Dictionary = {}
## Wave now (1-based; 0 before the first).
var wave: int = 0
## Season now (SPRING..WINTER; -1 before the first wave).
var season: int = -1
## Season forced by set_override() (-1 = none) and the game s it ends.
var override: int = -1
## See override.
var override_until: float = 0.0
## Thickets: {spot: Spot, at: game s it chokes (sprout before), grown_at: game s
## it grew (the bot's delay)}.
var thickets: Array[Dictionary] = []
## Game s of the next choke application.
var next_choke: float = 0.0
## Game s of the next winter check.
var next_check: float = 0.0
## Fodder kills counted in Autumn (every sprout_every-th sprouts).
var fallen: int = 0
## Sprouts waiting to rise: [road id, px along it, lane px].
var sprout_queue: Array = []
## The Green Mother's borrowed claim: blocker bodies falling before this game s
## rise as `claim_kind` (the Underworld's claim, TdGame.spawn_from_body()).
var claim_until: float = 0.0
## See claim_until.
var claim_kind: String = ""
## Counters for the summary.
var counts: Dictionary = {"turns": 0, "planted": 0, "choked_s": 0.0, "burned": 0, "sprouted": 0, "summer_spawns": 0, "chilled_s": 0.0, "overrides": 0, "claimed": 0}
## The drawing layer and the HUD dial (null headless).
var layer: Node2D = null
## See layer.
var dial: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("wild")["RULE"]


## The Turning Year of this run, or null on another act's map (kinds and bosses ask).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("plant") else null


func setup() -> void:
	cfg = r()["maps"].get(game.map_id, r()["maps"]["greenwood"])
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/wild/year_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	dial = (load("res://scripts/maps/rules/wild/year_dial.gd") as GDScript).new() as Control
	dial.set("rule", self)
	game.hud.root.add_child(dial)


func on_wave_start(n: int) -> void:
	wave = n
	_update_season()


## The season the clock gives now (override, hold, else by wave).
func season_now() -> int:
	if override >= 0 and game.time < override_until:
		return override
	if int(cfg["hold"]) >= 0:
		return int(cfg["hold"])
	return (int(cfg["start"]) + maxi(wave - 1, 0) / int(cfg["per"])) % 4


## Forces season `s` until game s `until` (bosses, minibosses), then the clock takes over.
func set_override(s: int, until: float) -> void:
	override = s
	override_until = until
	counts["overrides"] = int(counts["overrides"]) + 1
	_update_season()


## Enters a new season when the clock says so (banner, Spring's thickets, Winter's thaw).
func _update_season() -> void:
	if wave <= 0:
		return
	var s := season_now()  # Season due.
	if s == season:
		return
	var was := season  # Season leaving.
	season = s
	counts["turns"] = int(counts["turns"]) + 1
	game.banner("%s: %s" % [String(r()["names"][s]), String(r()["rules"][s])])
	Sfx.play("season_turn")
	if s == SPRING:
		_spring()
	if was == WINTER:
		for t: Tower in game.towers:
			TdCombat.chill_tower(game, t, 1.0)
	if s == WINTER:
		next_check = 0.0
	if dial != null:
		dial.queue_redraw()


## Spring comes: `thickets` towers' spots (seeded pick among the built ones) sprout.
func _spring() -> void:
	var cands: Array[Spot] = []  # Built spots without a thicket.
	for t: Tower in game.towers:
		if thicket_at(t.spot) < 0:
			cands.append(t.spot)
	for i in mini(int(cfg["thickets"]), cands.size()):
		var k := game.rng.randi_range(0, cands.size() - 1)  # Seeded pick.
		plant(cands[k], float(r()["sprout"]))
		cands.remove_at(k)


## Index of the thicket on spot `s` (-1 = none).
func thicket_at(s: Spot) -> int:
	for i in thickets.size():
		if thickets[i]["spot"] == s:
			return i
	return -1


## Sprouts a thicket on spot `s`, choking it after `sprout` s (the one way a
## thicket grows; nothing when one is there already). Returns true when planted.
func plant(s: Spot, sprout: float) -> bool:
	if s == null or thicket_at(s) >= 0:
		return false
	thickets.append({"spot": s, "at": game.time + sprout, "grown_at": game.time + sprout})
	counts["planted"] = int(counts["planted"]) + 1
	game.fx.spawn("summon_rise", s.position, 60.0, 0.5, Acts.data("wild")["LOOK"]["warn_tint"])
	Sfx.play("thicket_grow")
	return true


## Burns the thicket on spot index `i` of `thickets` for `burn_cost` souls (a tap). Returns true when burned.
func burn(i: int) -> bool:
	if i < 0 or i >= thickets.size():
		return false
	if not game.economy.spend(int(r()["burn_cost"])):
		game.sound("denied")
		return false
	var s: Spot = thickets[i]["spot"]
	thickets.remove_at(i)
	counts["burned"] = int(counts["burned"]) + 1
	game.fx.spawn("wild_thicket_burn", s.position + Vector2(0, -10), 72.0, 0.6, Color.WHITE)
	Sfx.play("thicket_burn")
	return true  # The choke lapses within one choke_tick (each re-application is that short).


func on_spawn(e: TdEnemy) -> void:
	if season == SUMMER and not bool(e.row.get("structure", false)):
		TdCombat.empower_enemy(game, e, 1.0, float(r()["summer_speed"]))
		counts["summer_spawns"] = int(counts["summer_spawns"]) + 1


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	if season != AUTUMN or String(e.row["rank"]) != "fodder" or e.kind == String(r()["sprout_kind"]) or bool(e.row.get("flying", false)):
		return
	fallen += 1
	if fallen % int(r()["sprout_every"]) == 0:
		sprout_queue.append([e.follower.road.id, e.follower.dist, e.follower.lane])


func on_body_fallen(b: BlockBody, _by: TdEnemy) -> void:
	if game.time < claim_until and claim_kind != "" and not b.temporary:
		game.spawn_from_body(claim_kind, b)
		counts["claimed"] = int(counts["claimed"]) + 1


func step(dt: float) -> void:
	_update_season()
	# Autumn's sprouts rise.
	for q: Array in sprout_queue:
		var e := game.waves.spawn_extra(String(r()["sprout_kind"]), String(q[0]), float(q[1]), float(q[2]))
		if e != null:
			game.fx.spawn("summon_rise", e.position, 48.0, 0.4, Color(1.0, 0.75, 0.4))
			counts["sprouted"] = int(counts["sprouted"]) + 1
	sprout_queue.clear()
	# Thickets choke their towers.
	if game.time >= next_choke:
		next_choke = game.time + float(r()["choke_tick"])
		for th: Dictionary in thickets:
			var t: Tower = (th["spot"] as Spot).tower
			if t != null and game.time >= float(th["at"]):
				TdCombat.disable_tower(game, t, float(r()["choke_tick"]) + 0.1, "choked")
	for th: Dictionary in thickets:
		if (th["spot"] as Spot).tower != null and game.time >= float(th["at"]):
			counts["choked_s"] = float(counts["choked_s"]) + dt
	# Winter chills every tower.
	if season == WINTER and game.time >= next_check:
		next_check = game.time + float(r()["check_every"])
		for t: Tower in game.towers:
			TdCombat.chill_tower(game, t, float(r()["winter_rate"]))
	if season == WINTER:
		counts["chilled_s"] = float(counts["chilled_s"]) + dt * float(game.towers.size())


## The autotest bot's tap policy (TdAutotest calls it each tick): burns a grown
## thicket `bot_delay` s after it grew, when it has `bot_reserve` souls to spare.
func autotest_tap() -> void:
	if game.economy.souls < int(r()["bot_reserve"]):
		return
	for i in thickets.size():
		var s: Spot = thickets[i]["spot"]
		if s.tower != null and game.time >= float(thickets[i]["grown_at"]) + float(r()["bot_delay"]):
			burn(i)
			return


func summary() -> String:
	return "season:%s turns:%d planted:%d burned:%d thickets_left:%d choked_s:%d summer_spawns:%d sprouted:%d chilled_tower_s:%d overrides:%d claimed:%d" % [
		String(r()["names"][maxi(season, 0)]), int(counts["turns"]), int(counts["planted"]), int(counts["burned"]), thickets.size(),
		int(counts["choked_s"]), int(counts["summer_spawns"]), int(counts["sprouted"]), int(counts["chilled_s"]), int(counts["overrides"]), int(counts["claimed"])]
