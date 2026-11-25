## towers_check: a headless self-check of the tower kit specials that a
## normal autotest run rarely reaches (Bone Colossus taunt and shrapnel,
## Winter Revenant shatter, Keening Lady silence, Gravebow curse, Shatterfall),
## and the gw2-kit later towers, spells, ultimates, statuses and unlocks (_kit_checks),
## and Act V (_shogun_checks): the Bound Oni smash, the Oni Lord quake, the act
## spells and the Sun's Course (night visibility, douse / relight, ambush, Kage, the Shogun).
## Run: godot --headless tools/towers_check.tscn   (prints PASS / FAIL, exit 0 / 1)
extends Node

## Failed check names.
var _fails: Array[String] = []


func _ready() -> void:
	var game := TdGame.new()
	game.setup("graveyard", DifficultyData.DEFAULT_ID, 1)
	add_child(game)
	game.economy.earn(20000, "test_bonus")
	_fresh_bodies(game)
	# Bone Colossus at post:1 beside a Warrior at post:2 (197 px apart).
	var col := _maxed(game, "post:1", "abomination")
	var war := _maxed(game, "post:2", "warrior")
	game.tick(1.0 / 60.0)
	_check("colossus taunt", war.block.bodies.any(func(o: BlockBody) -> bool: return o.taunt_by == col.block.bodies[0]))
	game.spawn_enemy("footman", game.first_entrance(), 1)
	var e: TdEnemy = game.enemies[0]
	e.position = col.block.bodies[0].pos
	game.tick(1.0 / 60.0)
	TdCombat.damage_body(game, col.block.bodies[0], INF)
	game.tick(1.0 / 60.0)
	_check("colossus shrapnel", int(game.stats.get("shrapnel", 0)) == 1)
	# Winter Revenant: a frozen enemy killed by anything shatters onto its neighbours.
	var rev := _maxed(game, "plot:5", "frost_wraith")
	_check("revenant evolved", rev.evolution == "winter_revenant")
	game.spawn_enemy("recruit", game.first_entrance(), 1)
	game.spawn_enemy("recruit", game.first_entrance(), 1)
	var a: TdEnemy = game.enemies[game.enemies.size() - 2]
	var b: TdEnemy = game.enemies[game.enemies.size() - 1]
	game.tick(1.0 / 60.0)
	TdCombat.freeze_enemy(game, a, 2.0)
	var hp_b := b.hp  # Neighbour HP before the shatter.
	TdCombat.kill_enemy(game, a, null)
	_check("revenant shatter", int(game.stats.get("shatters", 0)) == 1 and b.hp < hp_b)
	# Silence, curse and Shatterfall on one enemy.
	TdCombat.silence_enemy(game, b, 1.0)
	_check("silence query", not EnemyTrait.can_heal(b, game))
	var cat := _maxed(game, "plot:10", "corpse_catapult")
	_check("shatterfall active", cat.synergies.any(func(p: Array) -> bool: return p[0] == "shatterfall"))
	b.hp = b.max_hp
	var plain := TdCombat.damage_enemy(game, b, 10.0, {"tower": cat, "dot": true})  # Not frozen.
	TdCombat.freeze_enemy(game, b, 2.0)
	TdCombat.curse_enemy(game, b, 1.15, 2.0)
	var boosted := TdCombat.damage_enemy(game, b, 10.0, {"tower": cat, "dot": true})  # Frozen and cursed.
	_check("shatterfall + curse", is_equal_approx(boosted, plain * 1.6 * 1.15))
	_kit_checks()
	_shogun_checks()
	print("TOWERS CHECK %s %s" % ["PASS" if _fails.is_empty() else "FAIL", ",".join(_fails)])
	get_tree().quit(0 if _fails.is_empty() else 1)


## Every blocker class: a fresh body has exactly its body_hp, and a level up
## (more bodies) keeps every body at its stat (DECISIONS K15, W-rows). Sells them after.
func _fresh_bodies(game: TdGame) -> void:
	for id: String in TowerData.ORDER:
		if String(TowerData.TOWERS[id]["spot"]) != "post" or not TowerData.TOWERS[id].has("body_hp"):
			continue
		var s := game.spot_by_id("post:0")  # A free post.
		game.build(s, id)
		var t := s.tower  # The blocker.
		var ok := t.block.bodies.all(func(b: BlockBody) -> bool: return is_equal_approx(b.hp, float(t.stats["body_hp"])) and is_equal_approx(b.max_hp, float(t.stats["body_hp"])))
		while t.level < 5:
			game.upgrade(s)
		ok = ok and t.block.bodies.all(func(b: BlockBody) -> bool: return is_equal_approx(b.hp, float(t.stats["body_hp"])) and is_equal_approx(b.max_hp, float(t.stats["body_hp"])))
		_check("fresh body hp " + id, ok)
		game.sell(s)


## Builds `id` on spot `spot`, raises it to level 5 and evolves it.
func _maxed(game: TdGame, spot: String, id: String) -> Tower:
	var s := game.spot_by_id(spot)  # The spot.
	game.build(s, id)
	for i in 4:
		game.upgrade(s)
	s.tower.evolution = String(s.tower.row["evolution"])  # Forced: the check is about the kit, not the recipe.
	s.tower.recompute()
	Synergies.evaluate(game.towers)
	return s.tower


## Records check `name` as failed unless `ok`.
func _check(name: String, ok: bool) -> void:
	if not ok:
		_fails.append(name)


## Spawns `kind` on the road point nearest map px `p` (frozen in place for the check).
func _enemy_at(game: TdGame, kind: String, p: Vector2) -> TdEnemy:
	var road := game.nearest_road(p, 600.0)  # Nearest road.
	var e := game.spawn_at(kind, road.id, 1, road.project(p), 0.0)  # The enemy.
	TdCombat.freeze_enemy(game, e, 30.0)
	return e


## Runs `game` for `s` game seconds.
func _run(game: TdGame, s: float) -> void:
	for i in roundi(s * float(TdRulesData.TICK_RATE)):
		game.tick(1.0 / float(TdRulesData.TICK_RATE))


## gw2-kit: every later tower's special, the statuses, recipes, spells, ultimates, unlocks.
func _kit_checks() -> void:
	Meta.load_save()  # A fresh save (--autotest keeps it off user://).
	var loadout: Array[String] = ["death_mark", "soul_chains", "wither", "raise_dead"]
	SpellCaster.ultimate_id = "grave_tide"
	var game := TdGame.new()
	game.setup("graveyard", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	# Warder (Bone Aegis) beside a Warrior: barrier, then a hit is absorbed.
	var war := _maxed(game, "post:1", "warrior")
	var wd := _maxed(game, "plot:4", "warder")
	_check("shieldwall active", wd.synergies.any(func(p: Array) -> bool: return p[0] == "shieldwall"))
	_run(game, 0.1)
	var b: BlockBody = war.block.bodies[0]
	_check("warder barrier", b.barrier > 0.0)
	var hp0 := b.hp  # Before a small hit.
	TdCombat.damage_body(game, b, 5.0)
	_check("barrier absorbs", b.hp == hp0)
	# Statuses.
	var e := _enemy_at(game, "footman", Vector2(620, 340))
	e.armour = 6.0
	var plain := TdCombat.damage_enemy(game, e, 10.0, {"source": "check"})
	TdCombat.shred_enemy(game, e, 5.0, 2.0)
	var shred := TdCombat.damage_enemy(game, e, 10.0, {"source": "check"})
	_check("wither shred", shred > plain)
	TdCombat.swoop_enemy(game, e, 2.0)
	_check("swooped status", Synergies.has_status(e, "swooped", game))
	# Profane Bishop: "any" recipe met by the Warder beside the Mender.
	var mend := game.spot_by_id("plot:3")
	game.build(mend, "mender")
	for i in 4:
		game.upgrade(mend)
	_check("bishop via warder", mend.tower.can_evolve())
	# Rogue, Gargoyle, Hounds, Seraph, Golem: their specials fire.
	var rg := _maxed(game, "plot:5", "rogue")
	var gg := _maxed(game, "plot:6", "gargoyle")
	var hd := _maxed(game, "plot:9", "bone_hound")
	var sr := _maxed(game, "plot:8", "fallen_seraph")
	var gl := _maxed(game, "post:2", "bone_golem")
	for i in 3:  # Fresh foes beside every tower, three times over.
		for t: Tower in [rg, gg, hd, sr]:
			_enemy_at(game, "templar", t.position)
		_run(game, 4.0)
	_check("rogue dash", int(rg.vars.get("dashes", 0)) > 0)
	_check("gargoyle swoop", int(gg.vars.get("swoops", 0)) > 0)
	_check("hound bites", int(hd.vars.get("bites", 0)) > 0)
	_check("seraph ruin", int(sr.vars.get("ruins", 0)) > 0)
	var gb: BlockBody = gl.block.bodies[0]
	gb.hp = gb.max_hp * 0.3
	_run(game, 0.05)
	_check("golem plants", gb.damage_cut > 0.0)
	# Spells and the Grave Tide.
	for p: Vector2 in [Vector2(620, 340), Vector2(640, 345), Vector2(660, 350)]:
		_enemy_at(game, "templar", p)
	game.tick(1.0 / float(TdRulesData.TICK_RATE))  # Into the spatial hash.
	var cast := 0  # Spells cast.
	for i in loadout.size():
		var at := Vector2(620, 340) if loadout[i] != "wither" else Vector2(620, 250)  # Wither needs a spot.
		var near := game.foes_near(at, 200.0)
		if game.cast_spell(i, near[0].position if not near.is_empty() and loadout[i] != "wither" else at):
			cast += 1
		else:
			_check("cast " + loadout[i], false)
	_check("later spells cast", cast == 4)
	var blocks := game.blocks.size()  # Raise Dead added one.
	game.caster.meter = float(SpellData.ULTIMATE["meter_max"])
	_check("grave tide cast", game.caster.cast_ultimate() and game.caster.ultimate.id == "grave_tide")
	_run(game, 12.0)
	_check("raise dead crumbles", game.blocks.size() < blocks + 4)
	SpellCaster.ultimate_id = "dread_rally"
	# Unlocks: a fresh save opens the Graveyard's towers once it is cleared.
	_check("unlock locked", not Unlocks.met({"map": "graveyard"}))
	(Meta.data["maps"]["cleared"] as Array).append("graveyard")
	var opened := Unlocks.refresh()
	_check("unlock refresh", opened.has("Crypt Warder") and opened.has("Grave Rogue") and opened.has("Death Mark"))
	(Meta.data["maps"]["cleared"] as Array).erase("graveyard")


## Act V (w2b-shogun): the Bound Oni and Oni Lord, the three act spells, and the
## Sun's Course on the Burning Province (visibility, lanterns, ambush, bosses).
func _shogun_checks() -> void:
	var loadout: Array[String] = ["hundred_shadows", "banner_of_the_dead", "black_sun"]
	var game := TdGame.new()
	game.setup("province", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	var sun: MapRule = game.act_rule
	_check("sun course loaded", sun != null and sun.has_method("douse_near"))
	# Bound Oni: the third strike smashes: what it holds is stunned.
	var oni := game.spot_by_id("post:2")
	game.build(oni, "bound_oni")
	var held: Array[TdEnemy] = []  # Enemies walked into the oni.
	for i in 3:
		var e := game.spawn_at("samurai", "main", 1, oni.road_dist - 60.0 - float(i) * 6.0, 0.0)
		e.max_hp = 1.0e6
		e.hp = e.max_hp
		held.append(e)
	_run(game, 6.0)
	_check("oni holds three", oni.tower.block.bodies[0].held.size() == 3)
	_check("oni smash stuns", int(oni.tower.vars.get("slams", 0)) > 0 and held.any(func(e: TdEnemy) -> bool: return e.freeze_until > 0.0))
	var lord := _maxed(game, "post:4", "bound_oni")
	_check("oni lord quake set", lord.evolution == "oni_lord" and float(lord.stats["quake_radius"]) > 0.0)
	var arch := _maxed(game, "plot:5", "archer")
	_check("iron and bone active", arch.synergies.any(func(p: Array) -> bool: return p[0] == "iron_and_bone"))
	for e: TdEnemy in held:
		game.remove_enemy(e, false)
	# The act spells.
	var foe := _enemy_at(game, "ashigaru", Vector2(700, 440))
	foe.max_hp = 1.0e6
	foe.hp = foe.max_hp
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	var rate := float(arch.stats["interval"])  # Before the banner.
	_check("cast hundred_shadows", game.cast_spell(0, foe.position))
	_check("cast banner", game.cast_spell(1, arch.position))
	_check("banner rallies", float(arch.stats["interval"]) < rate)
	_check("cast black_sun", game.cast_spell(2, foe.position))
	_run(game, 3.0)
	_check("shadow strikes", int(game.stats.get("shadow_strikes", 0)) > 0)
	_check("black sun beams", int(game.stats.get("black_sun_beams", 0)) > 0)
	_run(game, 10.0)
	_check("banner ends", is_equal_approx(float(arch.stats["interval"]), rate))
	# The Sun's Course: night hides foes outside lantern light; douse and relight.
	sun.call("on_wave_start", 15)
	_check("night falls", int(sun.get("phase")) == 2 and int(sun.call("lit_count")) == (sun.get("lanterns") as Array).size())
	var lan: Dictionary = (sun.get("lanterns") as Array)[0]
	var lit_foe := _enemy_at(game, "ashigaru", Vector2(lan["pos"]))
	var dark_foe := _enemy_at(game, "ashigaru", Vector2(1150, 240))
	_check("lit foe seen", game.can_target(arch, lit_foe))
	_check("dark foe hidden", bool(sun.call("in_light", dark_foe.position)) or not game.can_target(arch, dark_foe))
	_check("douse", int(sun.call("douse_near", lan["pos"], 10.0)) == 1 and not bool(lan["lit"]))
	var souls := game.economy.souls  # Before the relight.
	_check("relight costs souls", bool(sun.call("relight", 0)) and game.economy.souls < souls and bool(lan["lit"]))
	# From the Shadows: a ninja appears at an ambush point.
	var nj := game.spawn_enemy("ninja", "main", 1)
	_check("ninja ambush", nj.follower.dist > 100.0)
	# Kage: hidden in the dark while a shadow stands, true in the light.
	var kage := game.spawn_at("kage", "main", 1, 1000.0, 0.0)
	_run(game, 6.0)
	sun.call("douse_near", kage.position, 400.0)
	sun.call("douse_near", kage.position, 400.0)
	var hp := kage.hp  # Before a hit.
	var dealt := TdCombat.damage_enemy(game, kage, 100.0, {"source": "check", "dot": true})
	_check("kage hidden", bool(sun.call("in_light", kage.position)) or dealt < 100.0 or hp <= 0.0)
	sun.call("set_override", 0)
	_check("kage in daylight", is_equal_approx(TdCombat.damage_enemy(game, kage, 100.0, {"source": "check", "dot": true}), 100.0))
	sun.call("set_override", -1)
	# The Shogun: guarded while his regiments march.
	var sg := game.spawn_at("shogun", "main", 1, 0.0, 0.0)
	_check("shogun guarded", TdCombat.damage_enemy(game, sg, 1000.0, {"source": "check", "dot": true}) < 200.0)
