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
## Flash / frozen look the body was last drawn with (redraw when it changes; visual).
var _look: int = 0
## Damage-taken multiplier (>= 1) from tower hits while cursed (Gravebow), and its end (game s).
var curse_mult: float = 1.0
## See curse_mult.
var curse_until: float = 0.0
## Game time (s) until which it is silenced: it cannot heal or revive others
## (Keening Lady / Banshee; healer traits ask EnemyTrait.can_heal()).
var silenced_until: float = 0.0
## Game time (s) until which it is staggered by a stomp (no attacks; Killing Field reads it).
var staggered_until: float = 0.0
## Pose shown by a boss sprite (BossPoseData: 0 walk, 1 windup, 3 strike); set by its trait.
var pose: int = 0
## Multiplier (0..1) on the damage it takes while warded (Sun Paladin aura, Holy Ward
## Generators; TdCombat.ward_enemy, the strongest ward wins) and the ward's end (game s).
var ward_mult: float = 1.0
## See ward_mult.
var ward_until: float = 0.0

## --- Drawing only (TdVfx; never read by the simulation) ---
## Game s it was last nudged back by a blow, and the push direction (unit vector).
var vis_nudge_at: float = -INF
## See vis_nudge_at.
var vis_nudge_dir: Vector2 = Vector2.ZERO
## Game s it last struck its holder, and the lunge direction (unit vector).
var vis_strike_at: float = -INF
## See vis_strike_at.
var vis_strike_dir: Vector2 = Vector2.ZERO
## Game s it last took a direct hit (the hit squash).
var vis_hit_at: float = -INF
## Game s a ground field (burning shards / plague) last ticked on it, and that field's look.
var vis_field_until: float = -INF
## See vis_field_until ("flame" or "plague").
var vis_field_look: String = ""


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
	row = Acts.kinds()[p_kind]
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
	curse_mult = 1.0
	curse_until = 0.0
	silenced_until = 0.0
	staggered_until = 0.0
	ward_mult = 1.0
	ward_until = 0.0
	vis_nudge_at = -INF
	vis_strike_at = -INF
	vis_hit_at = -INF
	vis_field_until = -INF
	body.position = Vector2.ZERO
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
	if game.time < float(vars.get("k_charm_until", 0.0)):
		TdCombat.charm_step(game, self)  # Charmed (w2c-inferno): it stands and fights for the necromancer.
		last_moved = game.time
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
		if follower.road.exit:
			EnemyTrait.note(game, "crossed")  # An off-road crosser left the map: no lives lost.
			game.remove_enemy(self, false)
		else:
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
	var target := holder  # The body it hits: its holder, or a taunting Bone Colossus body.
	if holder.taunt_by != null and holder.taunt_by.alive and game.time < holder.taunt_until:
		target = holder.taunt_by
	TdCombat.damage_body(game, target, float(row["damage"]) * damage_mult() * TdRulesData.BLOCKER_HIT_MULT * float(TdRulesData.BLOCKER_HIT_RANK.get(row["rank"], 1.0)), self)
	game.vfx.enemy_blow(self, target)
	if traits != null and alive:
		traits.on_attack(self, game, target)


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


## Statuses shown on it now (TdVfxData.STATUS_ORDER names; drawn only).
func statuses() -> Array[String]:
	var out: Array[String] = []  # In priority order.
	var t := game.time  # Now (game s).
	for st: String in TdVfxData.STATUS_ORDER:
		var yes := false  # True when st is on.
		match st:
			"frozen": yes = t < freeze_until
			"burning": yes = t < vis_field_until and vis_field_look == "flame"
			"rot": yes = t < vis_field_until and vis_field_look == "plague"
			"cursed": yes = t < curse_until
			"weakened": yes = t < weaken_until and weaken_mult < 1.0
			"slowed": yes = t < slow_until and slow_mult < 1.0
			"charmed": yes = t < float(vars.get("k_charm_until", 0.0))
		if yes:
			out.append(st)
	return out


## Statuses on it now as bits in TdVfxData.STATUS_ORDER order (no allocation:
## checked every frame by _process()).
func _status_mask() -> int:
	var t := game.time  # Now (game s).
	var m := 0  # Bits.
	if t < freeze_until:
		m |= 1
	if t < vis_field_until:
		m |= 2 if vis_field_look == "flame" else 4
	if t < curse_until:
		m |= 8
	if t < weaken_until and weaken_mult < 1.0:
		m |= 16
	if t < slow_until and slow_mult < 1.0:
		m |= 32
	if t < float(vars.get("k_charm_until", 0.0)):
		m |= 64  # Charmed (w2c-inferno).
	return m


## True while a boss shows its strike pose after a blow (drawn only).
func _striking() -> bool:
	return game.time - vis_strike_at < TdVfxData.BOSS_POSE_TIME and String(row["rank"]) == "boss"


## Moves the body layer by its drawn offsets (nudge, lunge), squashes it on a
## hit, and redraws the body / the node when its look (flash, statuses, boss
## strike pose) changes. Visual only.
func _process(_delta: float) -> void:
	if not alive:
		return
	var look := (1 if game.time < flash_until else 0) + (2 if _striking() else 0)  # Current look.
	look += _status_mask() << 3
	if look != _look:
		var icons := (look >> 3) != (_look >> 3)  # The status icons changed.
		_look = look
		body.queue_redraw()
		if icons:
			queue_redraw()
	if not game.vfx.on:
		return
	var off := Vector2.ZERO  # Drawn offset of the body (px).
	if TdVfx.motion():
		var nf := (game.time - vis_nudge_at) / TdVfxData.NUDGE_TIME  # 0..1 through the nudge.
		if nf >= 0.0 and nf < 1.0:
			off += vis_nudge_dir * TdVfxData.NUDGE_PX * sin(nf * PI)
		var lf := (game.time - vis_strike_at) / TdVfxData.LUNGE_TIME  # 0..1 through its lunge.
		if lf >= 0.0 and lf < 1.0:
			var px := TdVfxData.BOSS_LUNGE_PX if String(row["rank"]) == "boss" else TdVfxData.ENEMY_LUNGE_PX  # Lunge reach.
			off += vis_strike_dir * px * TdVfx.lunge_curve(lf)
	if bool(row["flying"]):
		off.y -= HostileData.FLY_LIFT  # Flyers hang above the road; their shadow stays on it (_draw).
	body.position = off.round()
	var sq := 0.0  # Squash amount now.
	var hf := (game.time - vis_hit_at) / TdVfxData.HIT_SQUASH_TIME  # 0..1 through the hit squash.
	if hf >= 0.0 and hf < 1.0:
		sq = TdVfxData.HIT_SQUASH * (1.0 - hf)
	var sx := -1.0 if body.scale.x < 0.0 else 1.0  # Facing.
	body.scale = Vector2(sx * (1.0 + sq), 1.0 - sq)


## Draws the HP bar and the status icons on the node (not on the mirrored body).
func _draw() -> void:
	var h := SpriteBank.drawn_height(String(row["sprite"]))  # Sprite height (px).
	if bool(row.get("flying", false)) and game != null and game.vfx.on:
		var sh := HostileData.FLY_SHADOW  # Its ground shadow (px).
		draw_texture_rect(SpriteBank.disc(), Rect2(Vector2(-sh.x * 0.5, h * 0.3 - sh.y * 0.5), sh), false, Color(0, 0, 0, HostileData.FLY_SHADOW_A))
		h += HostileData.FLY_LIFT * 2.0  # HP bar and icons above the lifted body.
	if hp < max_hp:
		var w := clampf(radius * 2.2, 18.0, 60.0)  # Bar width (px).
		var top := Vector2(-w * 0.5, -h * 0.5 - 8.0)  # Bar corner (px).
		draw_rect(Rect2(top, Vector2(w, 3.0)), Color(0.1, 0.0, 0.0, 0.8))
		draw_rect(Rect2(top, Vector2(w * hp / max_hp, 3.0)), Color(0.85, 0.15, 0.2))
	if game == null or not game.vfx.on:
		return
	var tex := TdArt.texture("vfx_status")  # Icon strip.
	var sts := statuses()  # Statuses on it.
	if tex == null or sts.is_empty():
		return
	SpriteBank.apply_sharp(self)
	var n := mini(sts.size(), TdVfxData.STATUS_ICONS_MAX)  # Icons shown.
	var px := float(TdVfxData.STATUS_ICON_PX)  # Icon art size (texels).
	var sz := px * TdVfxData.STATUS_ICON_SCALE  # Drawn size (px).
	var x0 := -float(n) * (sz + 1.0) * 0.5  # Row start (px).
	for k in n:
		var src := Rect2(px * float(TdVfxData.STATUS_ICON[sts[k]]), 0.0, px, px)  # Icon in the strip.
		draw_texture_rect_region(tex, Rect2(Vector2(x0 + float(k) * (sz + 1.0), -h * 0.5 - 10.0 - sz), Vector2(sz, sz)), src)


## Body layer callback: the sprite (walk strip when it has one, boss pose),
## tinted by its first status (TdVfxData.STATUS_TINT).
func _draw_body(ci: CanvasItem) -> void:
	var key := String(vars.get("sprite", row.get("sprite", "")))  # Sprite key (vars "sprite": a form change, w2c-dynasty's Ammit).
	var flash := game != null and game.time < flash_until  # Hit flash.
	var tint: Color = row.get("tint", Color.WHITE)  # Status look (an optional row tint: the Black Tide's ghost crew).
	tint *= vars.get("tint", Color.WHITE) as Color  # One enemy's tint (w2c-dynasty: a reborn body's gold, a hunter in the sand).
	if game != null:
		var sts := statuses()  # Statuses on it.
		if not sts.is_empty():
			tint *= TdVfxData.STATUS_TINT[sts[0]]
	tint.a *= float(vars.get("vis_alpha", 1.0))  # A trait's fade (drawn only: Hrimgar sunk in his barrow, Act VI).
	if row.get("rank", "") == "boss":
		var p := 3 if pose == 0 and game != null and _striking() else pose  # A blow shows the strike pose.
		if not SpriteBank.draw_pose(ci, key, p, Vector2.ZERO, flash, tint):
			ci.draw_rect(Rect2(-radius, -radius, radius * 2.0, radius * 2.0), Color(0.9, 0.8, 0.3))
		return
	if not SpriteBank.draw(ci, key, Vector2.ZERO, flash, tint):
		ci.draw_rect(Rect2(-radius, -radius, radius * 2.0, radius * 2.0), Color(0.8, 0.2, 0.2))
