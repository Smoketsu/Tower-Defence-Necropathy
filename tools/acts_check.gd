## acts_check: a headless self-check of the act framework (ActData / Acts /
## MapRegistry lookups, the unlock chain and Soul Ash step, the merged enemy
## and build-order tables, and every act hook on the test act's map: hostile
## shots stopped by a blocker, the tower disable path, flyers never held and
## skipped by ground-only towers, a fallen body raised hostile, an off-road
## exit, visibility through the rule hook; the shared kit's towers and Risen
## under those rules).
## Run: godot --headless tools/acts_check.tscn -- --autotest   (prints PASS / FAIL, exit 0 / 1)
extends Node

## Failed check names.
var _fails: Array[String] = []


func _ready() -> void:
	# Registry and order.
	_check("act I maps", Acts.maps_of("covenant") == ["graveyard", "crimson_march", "sanctum"])
	_check("order", Acts.map_order().slice(0, 3) == ["graveyard", "crimson_march", "sanctum"])
	_check("prev map", Acts.prev_map("crimson_march") == "graveyard" and Acts.prev_map("graveyard") == "")
	_check("ash step", Meta.map_index("sanctum") == 2 and Meta.map_index("graveyard") == 0)
	_check("hidden act open", Acts.prev_map("test_grounds") == "" and Acts.next_map("sanctum") != "test_grounds")  # wave 2b: later acts follow Act I
	_check("numerals", Acts.numeral("covenant") == "I" and Acts.numeral("wild") == "XV" and Acts.numeral("test") == "T")
	_check("coming soon", Acts.maps_of("corsair").is_empty() or MapRegistry.has("cutter"))
	_check("act defaults", String(MapRegistry.get_map("test_grounds")["act_rule"]) == "test/proving" and String(MapRegistry.get_map("graveyard")["act"]) == "covenant")
	_check("merged kinds", Acts.kinds().has("recruit") and Acts.kinds().has("test_bat") and Acts.act_of_kind("test_bat") == "test" and Acts.act_of_kind("recruit") == "covenant")
	_check("merged orders", Acts.orders().has("graveyard_default") and Acts.orders().has("test_default"))
	_check("music", Sfx.run_mode_for("graveyard") == Sfx.MUSIC_RUN)
	_check("mood", not Acts.mood_for(MapRegistry.get_map("test_grounds")).is_empty())
	# Hooks on the test map.
	var game := TdGame.new()
	game.setup("test_grounds", DifficultyData.DEFAULT_ID, 1)
	add_child(game)
	game.economy.earn(20000, "test_bonus")
	_check("act rule loaded", game.act_rule != null and game.rules.size() == 1)
	game.build(game.spot_by_id("post:0"), "warrior")
	game.build(game.spot_by_id("plot:0"), "archer")
	var war := game.spot_by_id("post:0").tower  # Blocker at (650, 200).
	var arc := game.spot_by_id("plot:0").tower  # Archer at (560, 120).
	game.tick(1.0 / 60.0)
	# A straight shot from beyond the post at the archer is stopped by the warrior's body.
	var body: BlockBody = war.block.bodies[0]
	var hp := body.hp  # Before the shot.
	var behind := body.pos + (body.pos - arc.position).normalized() * 60.0  # Beyond the body, in line with the archer.
	game.hostile.fire(behind, arc, {"damage": 5.0, "disable": 2.0})
	for i in 60:
		game.tick(1.0 / 60.0)
	_check("shot blocked", body.hp < hp and game.time >= arc.disabled_until and int(game.hostile.counts["blocked"]) == 1)
	# An arcing shot flies over and disables the archer; it then does not fire.
	game.hostile.fire(behind, arc, {"disable": 5.0, "arc": true})
	for i in 60:
		game.tick(1.0 / 60.0)
	_check("arc disables", game.time < arc.disabled_until and arc.disabled_cause == "shot")
	game.spawn_enemy("recruit", "main", 1)
	var e: TdEnemy = game.enemies.back()
	e.follower.dist = 560.0
	e.position = e.follower.position()
	var shots := arc.shots  # Shots fired so far.
	for i in 30:
		game.tick(1.0 / 60.0)
	_check("disabled holds fire", arc.shots == shots)
	TdCombat.kill_enemy(game, e, null)
	# Flyers: never held; skipped by a ground-only tower.
	var fly := game.spawn_at("test_bat", "main", 1, 600.0, 0.0)
	_check("flyer not held", war.block.free_body(fly) == null)
	arc.disabled_until = 0.0
	arc.stats["ground_only"] = true
	_check("ground only", arc.pick_target() != fly)
	arc.stats["ground_only"] = false
	_check("air ok", arc.pick_target() == fly)
	# Kit towers under the framework (wave 2a integration): the ground-only Rogue /
	# Hounds never take the flyer, the Gargoyle takes it first; a disabled kit tower
	# does nothing; hostile shots stop on a Golem body and on a temporary Risen.
	game.build(game.spot_by_id("plot:3"), "rogue")
	game.build(game.spot_by_id("plot:1"), "bone_hound")
	game.build(game.spot_by_id("plot:2"), "gargoyle")
	var rog := game.spot_by_id("plot:3").tower  # (420, 300).
	var hnd := game.spot_by_id("plot:1").tower  # (800, 290).
	var gar := game.spot_by_id("plot:2").tower  # (900, 120).
	fly.follower.dist = 560.0
	fly.position = fly.follower.position()
	var fly2 := game.spawn_at("test_bat", "main", 1, 850.0, 0.0)  # Near the hounds and the gargoyle.
	game.tick(1.0 / 60.0)  # The spatial hash is rebuilt each tick.
	_check("kit ground only", rog.behavior.call("_pick", rog) == null and hnd.behavior.call("_pick", hnd) == null)
	_check("kit air first", gar.behavior.call("_pick", gar) == fly2)
	var swoops := int(gar.vars.get("swoops", 0))  # Before.
	var gshots := gar.shots  # Before.
	TdCombat.disable_tower(game, gar, 3.0, "shot")
	for i in 60:
		game.tick(1.0 / 60.0)
	_check("kit disabled", int(gar.vars.get("swoops", 0)) == swoops and gar.shots == gshots)
	TdCombat.kill_enemy(game, fly, null)
	TdCombat.kill_enemy(game, fly2, null)
	game.build(game.spot_by_id("post:1"), "bone_golem")
	var gol: BlockBody = game.spot_by_id("post:1").tower.block.bodies[0]  # At (1000, 400).
	var ghp := gol.hp  # Before.
	game.hostile.fire(gol.pos + Vector2(-60, 0), gol, {"damage": 7.0})
	for i in 60:
		game.tick(1.0 / 60.0)
	_check("golem takes shots", gol.alive and gol.hp <= ghp - 7.0)
	var tb := TempBlockers.new(game)  # Risen as a spell raises them.
	var rb := tb.raise("main", 300.0, 1, 50.0, 1, 1.0, 1.0, 10.0, "check")
	var rbody: BlockBody = rb.bodies[0]
	game.hostile.fire(rbody.pos + Vector2(-40, 0), arc, {"damage": 9.0})
	for i in 30:
		game.tick(1.0 / 60.0)
	_check("risen blocks shots", rbody.hp < 50.0)
	_check("no risen off road", tb.raise("trail", 100.0, 1, 50.0, 1, 1.0, 1.0, 10.0, "check") == null)
	# Claims: a body felled by a claimer's blow rises as a thrall.
	var cl := game.spawn_at("test_claimer", "main", 1, 640.0, 0.0)
	game.tick(1.0 / 60.0)  # Into the spatial hash (the claim looks it up there).
	var before := game.enemies.size()  # Live enemies.
	TdCombat.damage_body(game, body, INF, cl)
	_check("thrall raised", game.enemies.size() == before + 1 and game.enemies.back().kind == "test_thrall")
	# Off-road exit: a crosser at its trail's end leaves with no lives lost.
	var herd := game.spawn_at("test_herd", "trail", 1, game.roads["trail"].length - 1.0, 0.0)
	var lives := game.lives  # Before.
	for i in 10:
		game.tick(1.0 / 60.0)
	_check("off-road exit", not herd.alive and game.lives == lives and not game.nearest_road(Vector2(600, 100), 30.0) == game.roads["trail"])
	# Shelling disables every tower in the radius after the telegraph.
	game.hostile.shell(arc.position, 40.0, 0.5, 3.0)
	for i in 40:
		game.tick(1.0 / 60.0)
	_check("shell", game.time < arc.disabled_until and arc.disabled_cause == "shelled")
	print("ACTS CHECK %s %s" % ["PASS" if _fails.is_empty() else "FAIL", ",".join(_fails)])
	get_tree().quit(0 if _fails.is_empty() else 1)


## Records check `name` as failed unless `ok`.
func _check(name: String, ok: bool) -> void:
	if not ok:
		_fails.append(name)
