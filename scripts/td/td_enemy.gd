## TdEnemy: one pooled Covenant unit on the road. It walks by PathFollower,
## stops when a RoadBlock body takes it, attacks that body, and carries its
## statuses (slow, freeze, weaken, haste, damage over time). Its kind's
## EnemyTrait (if any) gets the hooks on_spawn / step / incoming_damage /
## on_death. All damage, statuses and death go through TdCombat; this script
## only moves, attacks its holder and draws. Pooled by TdGame: stored
## references must compare `generation` (bumped on every reuse).
class_name TdEnemy
extends Node2D

## The run (set once at creation).
var game: TdGame = null
## Reuse counter: a stored reference is valid only while its saved value matches.
var generation: int = 0
## True while on the road (false = in the pool).
var alive: bool = false
## TdEnemyData id.
var kind: String = ""
## Its TdEnemyData row (shared, read only).
var row: Dictionary = {}
## Its trait (shared instance per kind), or null.
var traits: EnemyTrait = null
## Current HP (0 .. max_hp).
var hp: float = 1.0
## Max HP after difficulty scaling.
var max_hp: float = 1.0
## Flat armour (px-free damage points removed per hit; a trait may change it).
var armour: float = 0.0
## Base speed (px/s).
var speed: float = 0.0
## Body radius (px).
var radius: float = 10.0
## Movement along the roads.
var follower: PathFollower = PathFollower.new()
## The body holding it, or null while it walks.
var holder: BlockBody = null
## Game time (s) of its next attack on its holder.
var next_attack: float = 0.0
## Speed multiplier of the current slow (0..1) and its end (game s).
var slow_mult: float = 1.0
## See slow_mult.
var slow_until: float = 0.0
## Game time (s) until which it is frozen (no movement, no attacks).
var freeze_until: float = 0.0
## Multiplier (0..1) on the damage it deals while weakened, and the end (game s).
var weaken_mult: float = 1.0
## See weaken_mult.
var weaken_until: float = 0.0
## Speed multiplier (>= 1) of the current haste (banner, charge) and its end (game s).
var haste_mult: float = 1.0
## See haste_mult.
var haste_until: float = 0.0
## Game time (s) until which no block can hold it (a boss charge).
var unholdable_until: float = 0.0
## Damage over time entries: [damage per second, end game s, source id].
var dots: Array = []
## Trait-owned state (keys documented in each trait).
var vars: Dictionary = {}
## Wave number (1-based) it belongs to (no-leak bonus bookkeeping).
var wave: int = 0
## Game time (s) until which it draws a hit flash (visual only).
var flash_until: float = 0.0
## Px walked (drives the walk frame; visual only).
var walked: float = 0.0
## Last distance (px) along its road and the game time it last moved (stuck check).
var last_dist: float = 0.0
## See last_dist.
var last_moved: float = 0.0
## Its body layer (sprite, walk strip, facing by scale.x).
var body: UnitLayer = null
## Pose shown by a boss sprite (BossPoseData: 0 walk, 1 windup, 3 strike); set by its trait.
var pose: int = 0


func _ready() -> void:
	body = UnitLayer.new()
	body.draw_fn = _draw_body
	add_child(body)


## Puts the pooled enemy on road `road` at distance `d` as kind `p_kind`.
func activate(p_kind: String, road: Road, d: float, lane: float, hp_mult: float, p_wave: int) -> void:
	generation += 1
	alive = true
	visible = true
	kind = p_kind
	row = TdEnemyData.KINDS[p_kind]
	max_hp = float(row["hp"]) * hp_mult
	hp = max_hp
	armour = float(row["armour"])
	speed = float(row["speed"])
	radius = float(row["radius"])
	follower.setup(game.roads, road, d, lane)
	holder = null
	slow_mult = 1.0
	slow_until = 0.0
	freeze_until = 0.0
	weaken_mult = 1.0
	weaken_until = 0.0
	haste_mult = 1.0
	haste_until = 0.0
	unholdable_until = 0.0
	dots.clear()
	vars.clear()
	wave = p_wave
	walked = 0.0
	last_dist = d
	last_moved = game.time
	next_attack = 0.0
	pose = 0
	position = follower.position()
	body.walk_frame = -1
	body.scale = Vector2.ONE
	traits = EnemyTrait.for_kind(String(row["trait"]))
	if traits != null:
		traits.on_spawn(self, game)
	queue_redraw()
	body.queue_redraw()


## Speed (px/s) right now with slows and hastes (0 while frozen).
func current_speed() -> float:
	if game.time < freeze_until:
		return 0.0
	var s := speed  # Base speed.
	if game.time < slow_until:
		s *= maxf(slow_mult, TdRulesData.SLOW_FLOOR)
	if game.time < haste_until:
		s *= haste_mult
	return s


## Multiplier on the damage it deals right now (weaken).
func damage_mult() -> float:
	return weaken_mult if game.time < weaken_until else 1.0


## True when the stored reference (`e`, saved generation `gen`) still points at
## the same living enemy.
static func valid(e: TdEnemy, gen: int) -> bool:
	return e != null and e.alive and e.generation == gen


## One fixed step: damage over time, the trait, then walk or fight.
func step(dt: float) -> void:
	for i in range(dots.size() - 1, -1, -1):
		var dot: Array = dots[i]  # [dps, until, source].
		if game.time >= float(dot[1]):
			dots.remove_at(i)
			continue
		TdCombat.damage_enemy(game, self, float(dot[0]) * dt, {"source": String(dot[2]), "dot": true})
		if not alive:
			return
	if traits != null:
		traits.step(self, game, dt)
		if not alive:
			return
	if holder != null:
		_fight()
		last_moved = game.time
		return
	var move := current_speed() * dt  # Px to walk this step.
	if move <= 0.0:
		last_moved = game.time
		return
	var block := game.block_ahead(self, move)  # A block it walks into, with a free body.
	if block != null:
		var b := block.free_body(self)  # The body that takes it.
		var stop := block.dist - radius - TdRulesData.HOLD_GAP  # Where it stands, just before the block.
		if stop > follower.dist:
			follower.advance(stop - follower.dist)
		holder = b
		b.held.append(self)
		var r: Road = game.roads[block.road_id]  # The block's road.
		var dir := r.dir_at(block.dist)  # Road direction at the block.
		var n := b.held.size()  # Its slot number (1-based).
		# Stand in line with the body, extra holds fanned out to alternate sides.
		follower.lane = (b.pos - r.point_at(block.dist)).dot(Vector2(dir.y, -dir.x)) \
				+ float((n - 1) % 2 * 2 - 1) * float(n / 2) * 7.0
		next_attack = game.time + float(row["attack_interval"]) * 0.5
	elif follower.advance(move):
		TdCombat.leak(game, self)
		return
	walked += move
	if follower.dist != last_dist:
		last_dist = follower.dist
		last_moved = game.time
	_place()


## Attacks the holding body on its own cadence (no attacks while frozen).
func _fight() -> void:
	if game.time < freeze_until or game.time < next_attack:
		return
	next_attack = game.time + float(row["attack_interval"])
	TdCombat.damage_body(game, holder, float(row["damage"]) * damage_mult())


## Moves the node to the follower and updates facing and walk frame (visual).
func _place() -> void:
	position = follower.position()
	var dx := follower.direction().x  # Horizontal part of the walking direction.
	if absf(dx) > 0.2:
		body.scale.x = -1.0 if dx < 0.0 else 1.0
	var n := body.walk_count  # Frames in its walk strip (known after the first draw).
	if n > 1:
		var f := int(walked / TdRulesData.WALK_PX_PER_FRAME) % n  # Walk frame from the distance walked.
		if f != body.walk_frame:
			body.walk_frame = f
			body.queue_redraw()


## Draws the HP bar and freeze tint on the node (not on the mirrored body).
func _draw() -> void:
	if hp < max_hp:
		var h := SpriteBank.drawn_height(String(row["sprite"]))  # Sprite height (px).
		var w := clampf(radius * 2.2, 18.0, 60.0)  # Bar width (px).
		var top := Vector2(-w * 0.5, -h * 0.5 - 8.0)  # Bar corner (px).
		draw_rect(Rect2(top, Vector2(w, 3.0)), Color(0.1, 0.0, 0.0, 0.8))
		draw_rect(Rect2(top, Vector2(w * hp / max_hp, 3.0)), Color(0.85, 0.15, 0.2))


## Body layer callback: the sprite (walk strip when it has one, boss pose).
func _draw_body(ci: CanvasItem) -> void:
	var key := String(row.get("sprite", ""))  # Sprite key.
	var flash := game != null and game.time < flash_until  # Hit flash.
	var tint := Color(0.6, 0.85, 1.3) if game != null and game.time < freeze_until else Color.WHITE  # Frozen look.
	if row.get("rank", "") == "boss":
		if not SpriteBank.draw_pose(ci, key, pose, Vector2.ZERO, flash, tint):
			ci.draw_rect(Rect2(-radius, -radius, radius * 2.0, radius * 2.0), Color(0.9, 0.8, 0.3))
		return
	if not SpriteBank.draw(ci, key, Vector2.ZERO, flash, tint):
		ci.draw_rect(Rect2(-radius, -radius, radius * 2.0, radius * 2.0), Color(0.8, 0.2, 0.2))
