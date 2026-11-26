## TdGame: one map run, the root of the map scene. It owns the fixed-step
## game clock (TdRulesData.TICK_RATE ticks per game second, `speed` ticks per
## physics frame, none while paused), the seeded RNG, the map objects
## (roads, spots, blocks), the pooled enemies, the towers, the shots and
## effects, lives, the economy (SoulEconomy), the waves (WaveDirector) and
## the spells (SpellCaster), and exposes the player actions (build, upgrade,
## evolve, sell, target, call, cast, speed, pause) used by the HUD and the
## autotest alike. Deterministic per seed: no wall clock, no instance ids.
##
## Node tree: world (Node2D, the 1280 x 720 map scaled to fit and centred)
## -> map view, gate layer, spots, units (y-sorted towers and enemies),
## shots, effects, spell layer, overlay; plus the HUD (TdHud, a CanvasLayer).
class_name TdGame
extends Node

## Emitted when lives, wave or anything shown in the top bar changes.
signal changed
## Emitted to show a banner line (HUD banner queue).
signal banner_requested(text: String)
## Emitted when wave `n` (1-based) starts.
signal wave_started(n: int)
## Emitted once when the map ends (`won` = the last wave is dead).
signal ended(won: bool)
## Emitted when an enemy is killed (before it returns to the pool: its
## position, road and statuses are still readable); `tower` may be null.
signal enemy_killed(e: TdEnemy, tower: Tower)
## Emitted when an enemy was placed on a road (after its trait's on_spawn).
signal enemy_spawned(e: TdEnemy)
## Emitted when a blocker / Bone Wall body falls; `by` = the enemy whose blow felled it, or null.
signal body_fallen(b: BlockBody, by: TdEnemy)
## Emitted after every fixed step (the autotest bot acts here).
signal ticked
## Emitted when the player asks to replay this map (pause Restart, results Again).
signal restart_requested
## Emitted when the player asks to go back to the title (pause / results Menu).
signal menu_requested

## Map id (MapRegistry) and its data.
var map_id: String = ""
## See map_id.
var map: Dictionary = {}
## Difficulty id (DifficultyData).
var difficulty: String = DifficultyData.DEFAULT_ID
## Seed of `rng`.
var run_seed: int = 1
## The run's only random source (lane offsets; traits may use it).
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
## Game time (s) since the map started (fixed steps only).
var time: float = 0.0
## Fixed steps run so far.
var ticks: int = 0
## Ticks per physics frame (TdRulesData.SPEEDS value; the autotest uses its --speed).
var speed: int = 1
## True while paused (no ticks).
var paused: bool = false
## True once the map ended.
var over: bool = false
## True when it ended in a win.
var won: bool = false
## Gate lives now and at the start.
var lives: int = 20
## See lives.
var start_lives: int = 20
## Road id -> Road.
var roads: Dictionary = {}
## Remaining length (px) after each road's end down to the gate, road id -> px.
var _tail: Dictionary = {}
## Every spot (plots first, then posts).
var spots: Array[Spot] = []
## Every tower.
var towers: Array[Tower] = []
## Every live road block (blocker posts, Bone Walls).
var blocks: Array[RoadBlock] = []
## Live enemies, in spawn order.
var enemies: Array[TdEnemy] = []
## Pooled enemies not on the road.
var _pool: Array[TdEnemy] = []
## Spatial hash of the live enemies, rebuilt every step.
var _hash: SpatialHash = SpatialHash.new(64.0)
## Scratch array for hash queries.
var _scratch: Array = []
## Souls (the one soul path).
var economy: SoulEconomy = null
## Waves.
var waves: WaveDirector = null
## Spells and the ultimate meter.
var caster: SpellCaster = null
## Game time (s) the Dread Rally buff ends (0 = none).
var rally_until: float = 0.0
## True while the Rally buff is applied to tower stats.
var _rally_on: bool = false
## Free-upgrade credits from miniboss chests (GDD §3).
var free_upgrades: int = 0
## Run statistics for the summary: damage (source -> dmg), kills / leaks
## (kind -> n), body_damage, bodies_lost, stuck (n), chests (n).
var stats: Dictionary = {"damage": {}, "kills": {}, "leaks": {}, "body_damage": 0.0, "bodies_lost": 0, "stuck": 0, "chests": 0}
## The spot whose menu is open (null = none).
var selected: Spot = null
## Spell slot armed for targeting (-1 = none).
var armed: int = -1
## Map rule instance (MapRule subclass) or null.
var rule: MapRule = null
## The act's rule (MAP "act_rule", default ActData "rule"; a MapRule subclass) or null.
var act_rule: MapRule = null
## The live rules, map rule first then act rule (hooks wired in setup()).
var rules: Array[MapRule] = []
## Hostile shots and telegraphed shelling (HostileFire; the one path for enemy fire at towers / blockers).
var hostile: HostileFire = null
## True once the optional Reckoning endless mode was started on a cleared map (GDD §6.2).
var reckoning: bool = false
## Reckoning waves reached (0 = not started; the menu stores the best per map).
var reckoning_wave: int = 0
## Lives kept when the map was cleared (the skull rating once a Reckoning ran).
var lives_at_clear: int = 0
## Extra HP multiplier on enemies spawned now (the Reckoning's escalation; 1 = none).
var extra_hp_mult: float = 1.0

## Nodes.
var world: Node2D = null
## See world.
var map_view: MapView = null
## See world.
var units: Node2D = null
## See world.
var projectiles: TdProjectiles = null
## See world.
var fx: TdFx = null
## See world: the combat-effects layer (visual only).
var vfx: TdVfx = null
## The world node's fitted position (px; the screen shake draws around it).
var world_origin: Vector2 = Vector2.ZERO
## See world.
var spell_layer: UnitLayer = null
## See world.
var overlay: UnitLayer = null
## See world.
var gate_layer: UnitLayer = null
## The HUD (null until _ready()).
var hud: TdHud = null


## Configures the run before it enters the tree.
func setup(p_map_id: String, p_difficulty: String, p_seed: int, loadout: Array[String] = SpellData.DEFAULT_LOADOUT) -> void:
	map_id = p_map_id if MapRegistry.has(p_map_id) else MapRegistry.DEFAULT_ID
	map = MapRegistry.get_map(map_id)
	difficulty = p_difficulty if DifficultyData.LEVELS.has(p_difficulty) else DifficultyData.DEFAULT_ID
	run_seed = p_seed
	rng.seed = p_seed
	roads = MapLoader.build_roads(map)
	MapLoader.validate(map, roads)
	for id: String in roads:
		_tail[id] = _tail_of(id)
	start_lives = MetaModifiers.start_lives(int(map["lives"]) if int(map["lives"]) > 0 else TdRulesData.START_LIVES)
	lives = start_lives
	economy = SoulEconomy.new(CharacterModifiers.start_souls(MetaModifiers.start_souls(int(map["souls"]) if int(map["souls"]) > 0 else EconomyData.START_SOULS)))
	economy.changed.connect(func() -> void: changed.emit())
	waves = WaveDirector.new(self, map["waves"])
	caster = SpellCaster.new(self, loadout)
	if String(map["rule"]) != "":
		rule = _load_rule(String(map["rule"]))
	if String(map.get("act_rule", "")) != "":
		act_rule = _load_rule(String(map["act_rule"]))
	for r: MapRule in [rule, act_rule]:
		if r != null:
			rules.append(r)
			wave_started.connect(r.on_wave_start)
			enemy_spawned.connect(r.on_spawn)
			enemy_killed.connect(r.on_kill)
			body_fallen.connect(r.on_body_fallen)
	hostile = HostileFire.new()
	hostile.game = self


## The rule scripts/maps/rules/<id>.gd (a MapRule) bound to this run.
func _load_rule(id: String) -> MapRule:
	var r := (load("res://scripts/maps/rules/%s.gd" % id) as GDScript).new() as MapRule  # The rule.
	r.game = self
	return r


## Remaining px from the end of road `id` to the gate.
func _tail_of(id: String) -> float:
	var r: Road = roads[id]
	if r.next_id == "" or not roads.has(r.next_id):
		return 0.0
	var n: Road = roads[r.next_id]
	return n.length - r.next_at + _tail_of(n.id)


func _ready() -> void:
	world = Node2D.new()
	add_child(world)
	map_view = MapView.new()
	map_view.map = map
	map_view.roads = roads
	world.add_child(map_view)
	var spot_layer := Node2D.new()  # Spot bases, under the units.
	spot_layer.z_index = -5
	world.add_child(spot_layer)
	spots = MapLoader.build_spots(map, roads, spot_layer)
	gate_layer = _layer(-4, _draw_gate)
	var necro := _layer(-3, func(ci: CanvasItem) -> void: SpriteBank.draw(ci, TdArtData.NECROMANCER, Vector2.ZERO, false))  # The necromancer beside the gate.
	necro.position = necromancer_pos()
	necro.scale = Vector2(-1, 1)  # Faces the road (the art faces right).
	var mood := MapMood.new()  # Props, glows, fog, light pools (visual only).
	mood.game = self
	world.add_child(mood)
	add_child(MapMood.vignette())
	units = Node2D.new()
	units.y_sort_enabled = true
	world.add_child(units)
	projectiles = TdProjectiles.new()
	projectiles.game = self
	world.add_child(projectiles)
	fx = TdFx.new()
	fx.game = self
	world.add_child(fx)
	vfx = TdVfx.new()
	vfx.game = self
	world.add_child(vfx)
	world.add_child(hostile)
	spell_layer = _layer(7, caster.draw)
	overlay = _layer(8, _draw_overlay)
	hud = TdHud.new()
	hud.game = self
	add_child(hud)
	for r: MapRule in rules:
		r.setup()
	Sfx.prepare_pack("td")  # The five Gravewatch sounds (TdSoundData.SOUNDS).
	get_viewport().size_changed.connect(_fit)
	_fit()


## A UnitLayer drawing callback `fn` at z `z` under the world.
func _layer(z: int, fn: Callable) -> UnitLayer:
	var l := UnitLayer.new()  # The layer.
	l.z_index = z
	l.draw_fn = fn
	world.add_child(l)
	return l


## Px of the screen's top covered by the HUD's top bar (set by TdHud; visual).
var top_inset: float = 0.0


## Sets the HUD's top-bar height (px) and refits the map.
func set_top_inset(px: float) -> void:
	top_inset = px
	_fit()


## Scales and centres the 1280 x 720 map in the visible viewport. On screens
## wider than the map (phones in landscape) it fits below the top bar, so the
## top row of spots is not hidden under it.
func _fit() -> void:
	var vp := get_viewport().get_visible_rect().size  # Visible layout size.
	var top := top_inset if vp.x / vp.y > MapView.SIZE.x / MapView.SIZE.y + 0.05 else 0.0  # Reserved strip (px).
	var k := minf(vp.x / MapView.SIZE.x, (vp.y - top) / MapView.SIZE.y)  # Fit scale.
	world.scale = Vector2(k, k)
	world_origin = ((vp - Vector2(0.0, top) - MapView.SIZE * k) * 0.5 + Vector2(0.0, top)).round()
	world.position = world_origin


func _physics_process(_delta: float) -> void:
	if over or paused:
		return
	for i in speed:
		tick(1.0 / float(TdRulesData.TICK_RATE))
		if over:
			break


func _process(_delta: float) -> void:
	spell_layer.queue_redraw()
	if armed >= 0 or selected != null:
		overlay.queue_redraw()


## One fixed step of the whole simulation.
func tick(dt: float) -> void:
	time += dt
	ticks += 1
	waves.step()
	caster.step(dt)
	for r: MapRule in rules:
		r.step(dt)
	if _rally_on and time >= rally_until:
		_rally_on = false
		for t: Tower in towers:
			t.recompute()
	for i in range(blocks.size() - 1, -1, -1):
		if time >= blocks[i].until:
			blocks[i].release_all()
	_hash.clear()
	for e: TdEnemy in enemies:
		_hash.insert(e, e.position)
	for e: TdEnemy in enemies.duplicate():
		if e.alive:
			e.step(dt)
			if e.alive and e.holder == null and time >= e.freeze_until and time - e.last_moved > TdRulesData.STUCK_TIME \
					and not e.vars.has("stuck"):
				e.vars["stuck"] = true
				stats["stuck"] = int(stats["stuck"]) + 1
	for t: Tower in towers:
		t.step(dt)
	projectiles.step(dt)
	hostile.step(dt)
	if lives <= 0:
		_end(false)
	elif waves.all_spawned() and enemies.is_empty():
		_end(true)
	ticked.emit()


## Ends the map once.
func _end(p_won: bool) -> void:
	if over:
		return
	over = true
	won = p_won or reckoning  # A Reckoning only ends when the gate falls; the map stays cleared.
	if p_won and not reckoning:
		lives_at_clear = lives
	ended.emit(won)


## Starts the Reckoning endless mode on a cleared map (GDD §6.2): the run
## resumes and escalating waves come until the gate falls (`ended` again,
## `reckoning_wave` = waves reached). False when the map was not cleared.
func start_reckoning() -> bool:
	if not over or not won or reckoning:
		return false
	reckoning = true
	over = false
	waves.start_reckoning()
	changed.emit()
	return true


# ------------------------------------------------------------------ enemies

## Spawns kind `kind` at the start of road `road_id` for wave `w` (1-based).
func spawn_enemy(kind: String, road_id: String, w: int) -> TdEnemy:
	var lane := rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD)  # Lateral offset.
	return spawn_at(kind, road_id, w, 0.0, lane)


## Spawns kind `kind` on road `road_id` at distance `dist` px and lateral
## offset `lane` px for wave `w` (0 = no wave: structures); returns it.
func spawn_at(kind: String, road_id: String, w: int, dist: float, lane: float) -> TdEnemy:
	var e: TdEnemy = _pool.pop_back() if not _pool.is_empty() else null  # A pooled enemy.
	if e == null:
		e = TdEnemy.new()
		e.game = self
		units.add_child(e)
	e.activate(kind, roads[road_id], dist, lane, DifficultyModifiers.hp_mult(difficulty) * extra_hp_mult, w)
	enemies.append(e)
	enemy_spawned.emit(e)
	if String(e.row["rank"]) == "boss" or String(e.row["rank"]) == "miniboss":
		sound("boss")
	return e


## True when tower `t` may target enemy `e` (every rule's can_target(): visibility limits).
func can_target(t: Tower, e: TdEnemy) -> bool:
	if time < float(e.vars.get("k_charm_until", 0.0)):
		return false  # A charmed enemy fights for the necromancer (TdCombat.charm_enemy, w2c-inferno).
	for r: MapRule in rules:
		if not r.can_target(t, e):
			return false
	return true


## Spawns kind `kind` where blocker body `b` stood, just past its block, as an
## extra of the latest wave (claims: a fallen blocker rises hostile); returns it.
func spawn_from_body(kind: String, b: BlockBody) -> TdEnemy:
	var r: Road = roads[b.block.road_id]  # The block's road.
	var d := minf(b.block.dist + float(Acts.kinds()[kind]["radius"]) + TdRulesData.HOLD_GAP + 1.0, r.length)  # Just past the block.
	var dir := r.dir_at(d)  # Road direction there.
	var e := waves.spawn_extra(kind, r.id, d, (b.pos - r.point_at(b.block.dist)).dot(Vector2(dir.y, -dir.x)))
	fx.spawn("summon_rise", b.pos, 72.0, 0.45)  # It climbs out where the body fell.
	return e


## Takes `e` off the road into the pool (`leaked` = it reached the gate).
func remove_enemy(e: TdEnemy, leaked: bool) -> void:
	e.alive = false
	e.visible = false
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	enemies.erase(e)
	_pool.append(e)
	waves.enemy_gone(e.wave, leaked)


## Live enemies within `r` px of map px `pos` (spawn order within a hash cell).
func enemies_near(pos: Vector2, r: float) -> Array[TdEnemy]:
	_hash.query(pos, r, _scratch)
	var out: Array[TdEnemy] = []  # Alive ones only (deaths this step stay in the hash).
	for e: TdEnemy in _scratch:
		if e.alive:
			out.append(e)
	return out


## As enemies_near() without structures (ward generators, crystals: row key
## "structure"): what area effects, freezes, volleys and pack aims consider
## (the one structure rule, DECISIONS I2).
func foes_near(pos: Vector2, r: float) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []  # Living, marching enemies only.
	for e: TdEnemy in enemies_near(pos, r):
		if not bool(e.row.get("structure", false)):
			out.append(e)
	return out


## Progress of `e` toward the gate (higher = closer; "first" targeting).
func progress(e: TdEnemy) -> float:
	return -(e.follower.road.length - e.follower.dist + float(_tail[e.follower.road.id]))


## The block `e` walks into within `move` px ahead on its road that has a
## body free to take it, the nearest one; null when none.
func block_ahead(e: TdEnemy, move: float) -> RoadBlock:
	if time < e.unholdable_until:
		return null
	var best: RoadBlock = null  # Nearest matching block.
	var d := e.follower.dist  # Where it is.
	for b: RoadBlock in blocks:
		if b.road_id != e.follower.road.id or b.dist < d or time >= b.until:
			continue
		if d + move < b.dist - e.radius - TdRulesData.HOLD_GAP:
			continue
		if (best == null or b.dist < best.dist) and b.free_body(e) != null:
			best = b
	return best


## Registers road block `b` (a blocker post or a wall).
func add_block(b: RoadBlock) -> void:
	blocks.append(b)


## Removes road block `b` (and breaks its body <-> block reference cycle).
func remove_block(b: RoadBlock) -> void:
	blocks.erase(b)
	b.bodies.clear()


## Breaks the RefCounted cycles (block <-> bodies) when the run is freed.
func _exit_tree() -> void:
	for b: RoadBlock in blocks:
		b.release_all()
		b.bodies.clear()


## Living blocker bodies within `r` px of `pos` (Mender heals).
func bodies_near(pos: Vector2, r: float) -> Array[BlockBody]:
	var out: Array[BlockBody] = []  # Matching bodies.
	for blk: RoadBlock in blocks:
		for b: BlockBody in blk.bodies:
			if b.alive and b.pos.distance_squared_to(pos) <= r * r:
				out.append(b)
	return out


## The road nearest map px `pos` if within `max_d` px, else null.
func nearest_road(pos: Vector2, max_d: float) -> Road:
	var best: Road = null  # Nearest road.
	var best_d := max_d  # Its distance.
	for r: Road in roads.values():
		if r.off_road:
			continue  # Trails are not roads (spells, walls).
		var d := r.distance_to(pos)  # Distance to this road.
		if d <= best_d:
			best_d = d
			best = r
	return best


## Id of the first entrance road (wave groups without a road spawn there).
func first_entrance() -> String:
	for r: Road in roads.values():
		if r.entrance:
			return r.id
	return String(roads.keys()[0])


# ------------------------------------------------------------------ lives, chest, rally

## Loses `n` lives (the gate art follows).
func lose_lives(n: int) -> void:
	lives = maxi(lives - n, 0)
	gate_layer.queue_redraw()
	vfx.leak()
	sound("life_lost")
	changed.emit()


## A miniboss died at `pos`: its chest grants free upgrades (GDD §3).
func grant_chest(pos: Vector2) -> void:
	free_upgrades += TdRulesData.CHEST_FREE_UPGRADES
	stats["chests"] = int(stats["chests"]) + 1
	fx.spawn("chest_open", pos, 128.0, 0.8)
	sound("chest")
	banner("Chest! Your next upgrade is free")
	changed.emit()


## Starts the Dread Rally buff for `duration` s.
func start_rally(duration: float) -> void:
	rally_until = time + duration
	_rally_on = true
	for t: Tower in towers:
		t.recompute()


## Map px of the necromancer (beside the gate; Shadow Bolt's origin).
func necromancer_pos() -> Vector2:
	return Vector2(map["gate"]) + TdArtData.NECROMANCER_OFFSET


## Plays the Sfx sound of Gravewatch event `event` (TdSoundData.EVENTS).
func sound(event: String) -> void:
	Sfx.play(String(TdSoundData.EVENTS.get(event, "")))


## Plays the shot / pulse / hit sound of tower class `tower_id` (TdSoundData.FIRE).
func sound_fire(tower_id: String) -> void:
	Sfx.play(String(TdSoundData.FIRE.get(tower_id, "")))


## Shows banner `text`.
func banner(text: String) -> void:
	banner_requested.emit(text)


## Skull rating (GDD §3): 0 on a loss, else 1-3 by lives kept.
func skulls() -> int:
	if not won:
		return 0
	var f := float(lives_at_clear if reckoning else lives) / float(start_lives)  # Lives kept.
	return 3 if f >= TdRulesData.SKULL_THRESHOLDS[0] else (2 if f >= TdRulesData.SKULL_THRESHOLDS[1] else 1)


# ------------------------------------------------------------------ player actions

## The spot with build-order id `id` ("plot:N" / "post:N"), or null.
func spot_by_id(id: String) -> Spot:
	for s: Spot in spots:
		if s.spot_id() == id:
			return s
	return null


## Cost of a paid action: 0 while a chest credit is held (the credit is used).
func _pay(cost: int) -> bool:
	if free_upgrades > 0:
		free_upgrades -= 1
		changed.emit()
		return true
	return economy.spend(cost)


## Raises tower `id` on empty spot `s`; returns true when built.
func build(s: Spot, id: String) -> bool:
	var row: Dictionary = TowerData.TOWERS[id]
	if s.tower != null or String(row["spot"]) != s.kind or not economy.spend(int(row["cost"])):
		return false
	var t := Tower.new()  # The new tower.
	t.setup(self, s, id)
	t.spent = int(row["cost"])
	towers.append(t)
	units.add_child(t)
	s.set_tower(t)
	Synergies.evaluate(towers)
	fx.spawn("summon_rise", s.position, 80.0, 0.4)
	sound("place")
	changed.emit()
	return true


## Upgrades the tower on `s` one level; true when done.
func upgrade(s: Spot) -> bool:
	var t := s.tower  # The tower.
	if t == null or t.level >= 5:
		return false
	var cost := t.upgrade_cost()  # Souls asked.
	var free := free_upgrades > 0  # Paid by a chest credit.
	if not _pay(cost):
		return false
	t.spent += 0 if free else cost
	t.level += 1
	t.recompute()
	Synergies.evaluate(towers)
	fx.spawn("level_up", s.position, 96.0, 0.5)
	sound("upgrade")
	changed.emit()
	return true


## Evolves the tower on `s` (tier 6) when its hidden recipe is met.
func evolve(s: Spot) -> bool:
	var t := s.tower  # The tower.
	if t == null or not t.can_evolve():
		return false
	var cost := t.evolve_cost()  # Souls asked.
	var free := free_upgrades > 0  # Paid by a chest credit.
	if not _pay(cost):
		return false
	t.spent += 0 if free else cost
	t.evolution = String(t.row["evolution"])
	t.recompute()
	Synergies.evaluate(towers)
	fx.spawn("evolution", s.position, 128.0, 0.7)
	sound("evolve")
	banner("%s evolved: %s" % [String(t.row["name"]), String(EvolutionData.EVOLUTIONS[t.evolution]["name"])])
	changed.emit()
	return true


## Sells the tower on `s` for its refund.
func sell(s: Spot) -> bool:
	var t := s.tower  # The tower.
	if t == null:
		return false
	economy.earn(t.sell_value(), "refund")
	sound("sell")
	t.behavior.on_removed(t)
	towers.erase(t)
	s.set_tower(null)
	t.queue_free()
	Synergies.evaluate(towers)
	changed.emit()
	return true


## Cycles (or sets, with `mode`) the targeting mode of the tower on `s`.
func set_target(s: Spot, mode: String = "") -> void:
	var t := s.tower  # The tower.
	if t == null:
		return
	if mode == "":
		var i := TowerData.TARGET_MODES.find(t.target_mode)  # Current mode index.
		mode = TowerData.TARGET_MODES[(i + 1) % TowerData.TARGET_MODES.size()]
	t.target_mode = mode
	changed.emit()


## Calls the next wave (Call button).
func call_wave() -> void:
	if waves.can_call():
		sound("wave_call")
	waves.call_next()
	changed.emit()


## Casts spell slot `i` at map px `pos`; true when cast.
func cast_spell(i: int, pos: Vector2) -> bool:
	return caster.cast(i, pos)


## Steps the game speed through TdRulesData.SPEEDS.
func cycle_speed() -> void:
	var i := TdRulesData.SPEEDS.find(speed)  # Current index.
	speed = TdRulesData.SPEEDS[(i + 1) % TdRulesData.SPEEDS.size()]
	changed.emit()


## Pauses / resumes.
func set_paused(on: bool) -> void:
	paused = on
	changed.emit()


# ------------------------------------------------------------------ input and drawing

## A tap or click at map px `pos` (HUD controls get theirs first): casts the
## armed spell, else opens the menu of the spot under it, else closes it.
func tap(pos: Vector2) -> void:
	if over:
		return
	if armed >= 0:
		cast_spell(armed, pos)
		armed = -1
		overlay.queue_redraw()
		changed.emit()
		return
	var best: Spot = null  # Spot under the tap.
	for s: Spot in spots:
		if s.position.distance_to(pos) <= TdRulesData.SPOT_PICK and (best == null or s.position.distance_to(pos) < best.position.distance_to(pos)):
			best = s
	selected = best if best != selected else null
	overlay.queue_redraw()
	changed.emit()


func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton  # Touch arrives as emulated mouse clicks.
	if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		tap(world.get_global_transform_with_canvas().affine_inverse() * mb.position)
		get_viewport().set_input_as_handled()


## Gate layer: the gate art by lives left.
func _draw_gate(ci: CanvasItem) -> void:
	var f := float(lives) / float(maxi(start_lives, 1))  # Lives fraction.
	var role := "gate_intact" if f > TdArtData.GATE_DAMAGED_FRAC else ("gate_damaged" if f > TdArtData.GATE_BROKEN_FRAC else "gate_broken")  # Art role.
	if not TdArt.draw(ci, role, map["gate"]):
		ci.draw_rect(Rect2(Vector2(map["gate"]) - Vector2(40, 50), Vector2(80, 100)), Color(0.4, 0.4, 0.5))


## Overlay: the selected tower's range ring with links to its synergy
## partners, and the armed spell's aim hint at the pointer.
func _draw_overlay(ci: CanvasItem) -> void:
	if selected != null and selected.tower != null:
		var t := selected.tower  # The selected tower.
		var ring := TdArt.texture("range_ring")  # Grey ring mask.
		var r := float(t.stats["range"])  # Range (px).
		if ring != null and t.block == null:
			SpriteBank.apply_sharp(ci)
			var rc := TdMoodData.RANGE_TINT  # Ring colour.
			ci.draw_texture_rect(SpriteBank.disc(), Rect2(t.position - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(rc, TdMoodData.RANGE_FILL_A))
			ci.draw_texture_rect(ring, Rect2(t.position - Vector2(r, r), Vector2(r, r) * 2.0), false, rc)
		var link := TdArt.texture("synergy_link", true)  # Grey link mask.
		for pair: Array in t.synergies:
			var o: Tower = pair[1]
			if link != null:
				var d := o.position - t.position  # Link vector.
				ci.draw_set_transform(t.position, d.angle(), Vector2.ONE)
				ci.draw_texture_rect(link, Rect2(Vector2(0, -4), Vector2(d.length(), 8)), true, Color(1.0, 0.85, 0.4))
				ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if armed >= 0:
		var p := world.get_local_mouse_position()  # Pointer in map px.
		var ring2 := TdArt.texture("range_ring")
		if ring2 != null:
			ci.draw_texture_rect(ring2, Rect2(p - Vector2(40, 40), Vector2(80, 80)), false, Color(0.8, 0.6, 1.0, 0.8))
