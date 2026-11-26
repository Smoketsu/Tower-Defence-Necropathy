## towers_check: a headless self-check of the tower kit specials that a
## normal autotest run rarely reaches (Bone Colossus taunt and shrapnel,
## Winter Revenant shatter, Keening Lady silence, Gravebow curse, Shatterfall),
## and the gw2-kit later towers, spells, ultimates, statuses and unlocks (_kit_checks),
## and the Black Tide's tower, spells, Broadsides and kinds (_tide_checks, w2b-tide).
## and Act III's Blood Spawn, its spells and the Blood Moon (_court_checks, w2b-court).
## and Act V (_shogun_checks): the Bound Oni smash, the Oni Lord quake, the act
## spells and the Sun's Course (night visibility, douse / relight, ambush, Kage, the Shogun);
## Act X (_host_checks): the Bound Ophan roll and Throne of Bones, Turning Wheel, the act
## spells, the Hallowed Light (weakening, shade, Grace), Judgment, the Ophan, the Throne's rims.
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
	_tide_checks()
	_court_checks()
	_city_checks()
	_shogun_checks()
	_host_checks()
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


## w2b-tide: the Powder Wraith's burst and knockback (Magazine Lord, Boarding
## Party), the three act spells, the Broadsides (a shell, a barrel blast spiking
## its cannon), a Powder Runner's blast and Dead Men's Oath.
func _tide_checks() -> void:
	var loadout: Array[String] = ["chain_shot", "cannonade", "anchor_drop"]
	var game := TdGame.new()
	game.setup("cutter", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	var ab := _maxed(game, "post:3", "abomination")
	var pw := _maxed(game, "plot:4", "powder_wraith")
	_check("tide magazine lord", pw.evolution == "magazine_lord" and float(pw.stats["second_burst"]) > 0.0)
	_check("tide boarding party", pw.synergies.any(func(p: Array) -> bool: return p[0] == "boarding_party") and ab != null)
	for x: float in [620.0, 640.0, 660.0, 760.0, 780.0]:
		_enemy_at(game, "tide_boarding_bruiser", Vector2(x, 480)).hp = 5000.0
	_run(game, 3.0)
	_check("tide wraith burst", int(pw.vars.get("bursts", 0)) > 0)
	_check("tide knockback", float(game.stats.get("events", {}).get("knocked_back", 0.0)) > 0.0)
	for p: Vector2 in [Vector2(420, 260), Vector2(420, 280), Vector2(420, 300)]:
		_enemy_at(game, "tide_boarding_bruiser", p)
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	var cast := 0  # Act spells cast.
	for i in [1, 2, 0]:  # Cannonade lands before the chain-shot knocks its marks away.
		if game.cast_spell(i, Vector2(420, 280)):
			cast += 1
		_run(game, 1.0)
	_run(game, 2.0)
	_check("tide spells cast", cast == 3)
	for id: String in loadout:
		_check("tide " + id + " hits", float(game.stats["damage"].get(id, 0.0)) > 0.0)
	var rule: MapRule = game.act_rule
	var slot: Dictionary = rule.slots[0]
	rule._run_out(slot)
	slot["next"] = game.time
	_run(game, 2.0)
	_check("tide broadside", int(rule.counts["broadsides"]) > 0 and int(game.hostile.counts["shells"]) > 0)
	TdCombat.kill_enemy(game, slot["k"], null)
	_check("tide keg spikes", int(rule.counts["blasts"]) == 1 and int(rule.counts["spiked"]) == 1 and game.time < float(slot["spiked"]))
	var war := _maxed(game, "post:0", "warrior")
	var road: Road = game.roads["main"]
	game.spawn_at("tide_powder_runner", "main", 1, road.project(war.block.bodies[0].pos) - 40.0, 0.0).hp = 5000.0  # Outlives the Warrior's blows.
	_run(game, 3.0)
	_check("tide powder runner", float(game.stats["events"].get("powder_blasts", 0.0)) > 0.0)
	var v := _enemy_at(game, "vandermere", Vector2(1100, 180))
	var dealt := TdCombat.damage_enemy(game, v, 100.0, {"source": "check", "dot": true})
	_check("tide oath", dealt < 50.0)

## w2b-court: the Blood Spawn drinks, the Nosferatu spills, the Red Waltz pairs,
## the three Court spells cast, the Blood Moon feeds and shields, a werewolf
## turns under it, a mist noble is hidden, and the Court's locks open.
func _court_checks() -> void:
	var loadout: Array[String] = ["moonfang", "witch_circle", "night_swarm"]
	var game := TdGame.new()
	game.setup("ravensmoor", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	for c: TdEnemy in game.enemies.duplicate():  # No coffins in the way.
		game.remove_enemy(c, false)
	var bs := _maxed(game, "post:3", "blood_spawn")
	_check("nosferatu", bs.evolution == "nosferatu" and float(bs.stats["spill_share"]) > 0.0)
	var war := _maxed(game, "post:4", "warrior")
	var e := _enemy_at(game, "blood_knight", bs.block.bodies[0].pos)
	e.hp = e.max_hp
	game.tick(1.0 / 60.0)
	var b: BlockBody = bs.block.bodies[0]
	b.held.append(e)
	b.hp = b.max_hp - 1.0  # Nearly full: most of the drink spills.
	var mate: BlockBody = bs.block.bodies[1]  # Its wounded post-mate takes the spill.
	mate.hp = mate.max_hp * 0.2
	var w0: float = mate.hp  # Its HP before the spill.
	bs.behavior.strike(bs, b)
	_check("blood spawn drinks", float(bs.vars.get("fed", 0.0)) > 0.0)
	_check("nosferatu spills", float(bs.vars.get("spilled", 0.0)) > 0.0 and mate.hp > w0)
	b.held.erase(e)
	var ban := _maxed(game, "plot:12", "banshee")
	Synergies.evaluate(game.towers)
	_check("red waltz", bs.synergies.any(func(p: Array) -> bool: return p[0] == "red_waltz") or ban.position.distance_to(bs.position) > 220.0)
	# The spells.
	var cast := 0  # Spells cast.
	game.tick(1.0 / 60.0)
	for i in loadout.size():
		if game.cast_spell(i, e.position):
			cast += 1
		else:
			_check("cast " + loadout[i], false)
	_check("court spells cast", cast == 3)
	_run(game, 3.0)
	_check("moonfang bites", int(game.stats.get("moonfang_bites", 0)) > 0)
	_check("night swarm bites", int(game.stats.get("swarm_bites", 0)) > 0)
	# The Blood Moon: rise, shield, feed, turn, mist.
	var moon: MapRule = game.act_rule
	_check("moon down", not bool(moon.call("moon_up")))
	var wolf := _enemy_at(game, "werewolf", Vector2(600, 140))
	var thrall := _enemy_at(game, "blood_thrall", Vector2(620, 140))
	thrall.hp = thrall.max_hp * 0.5
	moon.call("force_moon", game.time + 10.0)
	_run(game, 0.1)
	_check("moon up", bool(moon.call("moon_up")) and int(moon.counts["moons"]) == 1 and int(moon.counts["bats"]) > 0)
	_check("moon shields", game.time < thrall.ward_until)
	_check("werewolf turns", bool(wolf.vars.get("beast", false)) and String(wolf.row["sprite"]) == "court/werewolf_beast")
	var hp0 := thrall.hp  # Before a kill beside it.
	var victim := _enemy_at(game, "blood_thrall", Vector2(610, 140))
	game.tick(1.0 / 60.0)
	TdCombat.kill_enemy(game, victim, null)
	_check("bloodfeast", thrall.hp > hp0 and int(moon.counts["feeds"]) > 0)
	var noble := _enemy_at(game, "vampire_noble", Vector2(640, 380))
	TdCombat.damage_enemy(game, noble, noble.max_hp * 0.95, {"source": "check", "dot": true})  # Through the moon's blood shield.
	_check("noble mists", game.time < float(noble.vars["mist_until"]) and not game.can_target(war, noble))
	# Unlocks: the Court's finale opens the Blood Spawn.
	_check("blood spawn locked", not Unlocks.met({"map": "castle_sanguis"}))
	(Meta.data["maps"]["cleared"] as Array).append("castle_sanguis")
	_check("blood spawn unlock", Unlocks.tower_open("blood_spawn") and Unlocks.met(TowerData.TOWERS["blood_spawn"]["unlock"]))
	(Meta.data["maps"]["cleared"] as Array).erase("castle_sanguis")

## w2b-city (Act IV): the Fallen Hero's slam (shred, stagger), Black Paragon's
## stun, a vehicle crashing through a light post and held by a heavy one, a
## Super's weakness, and the three act spells.
func _city_checks() -> void:
	var loadout: Array[String] = ["hearse_run", "bone_mines", "heros_fist"]
	var game := TdGame.new()
	game.setup("skid_row", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	# Fallen Hero (evolved: Black Paragon) beside foes: slams, shreds, stuns.
	var hero := _maxed(game, "plot:4", "fallen_hero")
	_check("black paragon evolved", hero.evolution == "black_paragon")
	var foes: Array[TdEnemy] = []
	for i in 3:
		foes.append(_enemy_at(game, "riot_cop", hero.position + Vector2(60 + i * 12, 0)))
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	var shredded := false  # Some foe had its armour shredded.
	for i in roundi(6.0 * float(TdRulesData.TICK_RATE)):
		game.tick(1.0 / float(TdRulesData.TICK_RATE))
		for e: TdEnemy in foes:
			shredded = shredded or (e.alive and TdCombat.shred_of(game, e) > 0.0)
	_check("hero slams", int(hero.vars.get("slams", 0)) > 0)
	_check("hero shreds", shredded)
	game.sell(game.spot_by_id("plot:4"))
	# A squad car crashes through a level-1 Warrior post, and is held by a level-5 Abomination.
	var post := game.spot_by_id("post:1")
	game.build(post, "warrior")
	var car := game.spawn_at("squad_car", post.tower.block.road_id, 1, maxf(post.tower.block.dist - 60.0, 0.0), 0.0)
	var crashed := false  # The car ran the post over.
	for i in roundi(4.0 * float(TdRulesData.TICK_RATE)):
		game.tick(1.0 / float(TdRulesData.TICK_RATE))
		crashed = crashed or float(game.stats.get("events", {}).get("vehicle_crashes", 0.0)) > 0.0
	_check("vehicle crashes light post", crashed and car.follower.dist > post.tower.block.dist)
	game.remove_enemy(car, false)
	game.sell(post)
	var heavy := _maxed(game, "post:1", "abomination")
	var car2 := game.spawn_at("squad_car", heavy.block.road_id, 1, maxf(heavy.block.dist - 60.0, 0.0), 0.0)
	for i in roundi(2.0 * float(TdRulesData.TICK_RATE)):
		game.tick(1.0 / float(TdRulesData.TICK_RATE))
	_check("vehicle held by heavy post", float(game.stats.get("events", {}).get("vehicle_held", 0.0)) > 0.0)
	if car2.alive:
		game.remove_enemy(car2, false)
	# A Super's weakness: Atlas takes double once shredded.
	var atlas := _enemy_at(game, "atlas", Vector2(620, 560))
	var plain := TdCombat.damage_enemy(game, atlas, 100.0, {"source": "check", "dot": true})
	TdCombat.shred_enemy(game, atlas, 1.0, 2.0)
	var weak := TdCombat.damage_enemy(game, atlas, 100.0, {"source": "check", "dot": true})
	_check("super weakness", is_equal_approx(weak, plain * 2.0))
	game.remove_enemy(atlas, false)
	# The act spells.
	for p: Vector2 in [Vector2(500, 560), Vector2(520, 560), Vector2(540, 560)]:
		_enemy_at(game, "city_tank", p)
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	var cast := 0  # Spells cast.
	for i in loadout.size():
		if game.cast_spell(i, Vector2(560, 560)):
			cast += 1
	_run(game, 2.0)
	_check("act iv spells cast", cast == 3)
	_check("hearse ran over", int(game.stats.get("hearse_hits", 0)) > 0)
	_check("fist struck", int(game.stats.get("fists", 0)) > 0)
	game.queue_free()
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


## Act X (w2c-host): the Bound Ophan and its evolution, the act spells, the
## Hallowed Light's weakening / shade / Grace, Judgment, the Ophan and the Throne.
func _host_checks() -> void:
	var loadout: Array[String] = ["flaming_sword", "wheel_of_eyes", "revelation"]
	var game := TdGame.new()
	game.setup("silver_stair", DifficultyData.DEFAULT_ID, 1, loadout)
	add_child(game)
	game.economy.earn(50000, "test_bonus")
	var light: MapRule = game.act_rule
	_check("hallowed light loaded", light != null and light.has_method("send_judges"))
	# The Bound Ophan rolls back along the road through a pack and staggers it.
	var oph := game.spot_by_id("plot:5")
	game.build(oph, "bound_ophan")
	var pack: Array[TdEnemy] = []  # Foes in its reach.
	for i in 4:
		var e := _enemy_at(game, "host_virtue", Vector2(520.0 - float(i) * 30.0, 480))
		e.max_hp = 1.0e6
		e.hp = e.max_hp
		pack.append(e)
	_run(game, 4.0)
	_check("ophan rolls", int(oph.tower.vars.get("rolls", 0)) > 0)
	_check("ophan roll hits the pack", pack.filter(func(e: TdEnemy) -> bool: return e.hp < e.max_hp).size() >= 2)
	_check("ophan roll staggers", pack.any(func(e: TdEnemy) -> bool: return e.staggered_until > 0.0))
	var throne := _maxed(game, "plot:9", "bound_ophan")
	_check("throne of bones set", throne.evolution == "throne_of_bones" and int(throne.stats["chain_slams"]) == 1 and float(throne.stats["dive_stun"]) > 0.0)
	var wd := _maxed(game, "plot:6", "warder")
	_check("turning wheel active", throne.synergies.any(func(p: Array) -> bool: return p[0] == "turning_wheel") or wd.synergies.any(func(p: Array) -> bool: return p[0] == "turning_wheel"))
	# The act spells.
	var foe := pack[0]
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	var hp := foe.hp  # Before the spells.
	_check("cast flaming_sword", game.cast_spell(0, foe.position))
	_check("cast wheel_of_eyes", game.cast_spell(1, foe.position))
	_check("cast revelation", game.cast_spell(2, foe.position))
	_check("revelation freezes and weakens", foe.freeze_until > game.time and foe.weaken_until > game.time)
	_run(game, 2.0)
	_check("sword and wheel strike", int(game.stats.get("sword_sweeps", 0)) > 0 and int(game.stats.get("wheel_hits", 0)) > 0 and foe.hp < hp)
	for e: TdEnemy in pack:
		game.remove_enemy(e, false)
	# The Hallowed Light: a still shaft weakens a tower out of the shade, not one in it; angels in it are graced.
	light.call("on_wave_start", 1)
	var arch := game.spot_by_id("plot:0")
	game.build(arch, "archer")
	var dmg := float(arch.tower.stats["damage"])  # Before the light.
	light.call("add_shaft", arch.position, Vector2.RIGHT, 80.0, 10.0)
	var angel := _enemy_at(game, "host_virtue", Vector2(180, 640))
	angel.hp = angel.max_hp * 0.5
	_run(game, 2.5)
	_check("light weakens", float(arch.tower.stats["damage"]) < dmg)
	_check("grace heals and hastes", angel.hp > angel.max_hp * 0.5 and angel.haste_until > game.time)
	var cloud: Array = (light.call("clouds") as Array)[0]
	_check("cloud shades", bool(light.call("shaded", cloud[0])))
	# Judgment: fallen bodies are sins; a boss's arrival sends Judges.
	for i in 25:
		light.call("on_body_fallen", BlockBody.new(), null)
	_check("sins counted", int(light.get("sins")) == 25)
	game.spawn_at("host_seraiel", "main", 1, 0.0, 0.0)
	_run(game, 8.0)
	_check("judges sent", int(light.get("counts")["judges_sent"]) == 2)
	# The Ophan rolls free of a post unless staggered; the Throne's rims turn blows aside.
	var op := game.spawn_at("host_ophan", "main", 1, 100.0, 0.0)
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	_check("ophan unholdable", op.unholdable_until > game.time)
	TdCombat.stagger_enemy(game, op, 2.0)
	game.tick(1.0 / float(TdRulesData.TICK_RATE))
	_check("staggered ophan holdable", op.unholdable_until <= game.time)
	var th := game.spawn_at("host_throne", "main", 1, 0.0, 0.0)
	_check("throne rims", TdCombat.damage_enemy(game, th, 1000.0, {"source": "check", "dot": true}) < 400.0)
	th.vars["core_until"] = game.time + 5.0
	_check("throne core", is_equal_approx(TdCombat.damage_enemy(game, th, 1000.0, {"source": "check", "dot": true}), 1000.0))
