## HostileFire (`game.hostile`): the ONE path for enemy fire at the
## necromancer's side (GDD §7.3 Line of Fire, Broadsides). fire() sends a shot
## at a tower or a blocker body; a straight shot is stopped by the first living
## blocker / Bone Wall body on its path (that body takes the hit), an arcing
## shot flies over them. A shot reaching a tower disables it through
## TdCombat.disable_tower(); one reaching a body damages it through
## TdCombat.damage_body(). shell() is a telegraphed strike on a spot of the
## map: after its delay it disables every tower and damages every body in its
## radius. Also draws the disabled-tower look. Simulation on game.time only
## (no RNG); drawing is off headless. Numbers and looks in HostileData.
class_name HostileFire
extends Node2D

## One hostile shot (pooled).
class Shot:
	## True while flying.
	var active: bool = false
	## Map px where it was fired, where it is, and where it lands.
	var from: Vector2 = Vector2.ZERO
	## See from.
	var pos: Vector2 = Vector2.ZERO
	## See from.
	var to: Vector2 = Vector2.ZERO
	## Speed (px/s).
	var speed: float = 300.0
	## Damage to the body it hits (blocked, or its target body).
	var damage: float = 0.0
	## Seconds a tower it reaches is disabled.
	var disable: float = 0.0
	## Disable cause (HostileData.CAUSE_TINT key).
	var cause: String = "shot"
	## Target tower (null = a body target or none).
	var tower: Tower = null
	## Target body (null = a tower target).
	var body: BlockBody = null
	## True: arcs over blockers (never stopped).
	var arc: bool = false
	## Look id (HostileData.LOOKS key).
	var look: String = "arrow"

## The run.
var game: TdGame = null
## Shot pool (active and free).
var _shots: Array[Shot] = []
## Pending shells: [map px, radius px, land game s, disable s, cause, body damage, start game s].
var _shells: Array = []
## Run counts for the summary: fired, blocked, hit_tower, hit_body, shells.
var counts: Dictionary = {"fired": 0, "blocked": 0, "hit_tower": 0, "hit_body": 0, "shells": 0}


func _ready() -> void:
	z_index = 5  # Over the units, under the effects.
	set_process(DisplayServer.get_name() != "headless")


## Fires a shot from map px `from` at `target` (a Tower or a BlockBody). `args`
## keys (all optional): speed (px/s), damage (to a body), disable (s, to a
## tower), cause (HostileData.CAUSE_TINT key), arc (true: flies over
## blockers), look (HostileData.LOOKS key). Returns false when the pool is full.
func fire(from: Vector2, target: Object, args: Dictionary) -> bool:
	var s: Shot = null  # A free shot.
	for x: Shot in _shots:
		if not x.active:
			s = x
			break
	if s == null:
		if _shots.size() >= HostileData.SHOT_CAP:
			return false
		s = Shot.new()
		_shots.append(s)
	s.active = true
	s.from = from
	s.pos = from
	s.tower = target as Tower
	s.body = target as BlockBody
	s.to = s.tower.position if s.tower != null else (s.body.pos if s.body != null else from)
	s.speed = float(args.get("speed", HostileData.SHOT_SPEED))
	s.damage = float(args.get("damage", 0.0))
	s.disable = float(args.get("disable", 0.0))
	s.cause = String(args.get("cause", "shot"))
	s.arc = bool(args.get("arc", false))
	s.look = String(args.get("look", "arrow"))
	counts["fired"] = int(counts["fired"]) + 1
	return true


## Telegraphs a strike at map px `pos` of radius `radius` px landing `delay` s
## from now: every tower inside is disabled `disable` s (`cause`), every
## blocker body inside takes `damage`.
func shell(pos: Vector2, radius: float, delay: float, disable: float, cause: String = "shelled", damage: float = 0.0) -> void:
	_shells.append([pos, radius, game.time + delay, disable, cause, damage, game.time])


## Fixed step: moves the shots (blocking, landing) and lands due shells.
func step(dt: float) -> void:
	for s: Shot in _shots:
		if s.active:
			_move(s, dt)
	for i in range(_shells.size() - 1, -1, -1):
		var sh: Array = _shells[i]
		if game.time < float(sh[2]):
			continue
		_shells.remove_at(i)
		_land_shell(sh)


## Moves shot `s` one step: blocked by a body on its path, or lands at its end.
func _move(s: Shot, dt: float) -> void:
	var step := s.speed * dt  # Px this step.
	var left := s.pos.distance_to(s.to)  # Px to its end.
	var nxt := s.to if step >= left else s.pos + (s.to - s.pos) / left * step  # Where it gets to.
	if not s.arc:
		var hit := _blocker_on(s.pos, nxt, s.body)  # First body in its way.
		if hit != null:
			counts["blocked"] = int(counts["blocked"]) + 1
			s.active = false
			TdCombat.damage_body(game, hit, s.damage)
			_impact(s, hit.pos)
			return
	s.pos = nxt
	if step < left:
		return
	s.active = false
	if s.tower != null and is_instance_valid(s.tower) and game.towers.has(s.tower):
		counts["hit_tower"] = int(counts["hit_tower"]) + 1
		TdCombat.disable_tower(game, s.tower, s.disable, s.cause)
	elif s.body != null and s.body.alive:
		counts["hit_body"] = int(counts["hit_body"]) + 1
		TdCombat.damage_body(game, s.body, s.damage)
	_impact(s, s.to)


## The first living blocker / Bone Wall body within HostileData.BLOCK_RADIUS of
## segment a -> b (closest to a), other than `skip`; null when none.
func _blocker_on(a: Vector2, b: Vector2, skip: BlockBody) -> BlockBody:
	var best: BlockBody = null  # Nearest body in the way.
	var best_d := INF  # Its distance from a.
	for blk: RoadBlock in game.blocks:
		if game.time >= blk.until:
			continue
		for body: BlockBody in blk.bodies:
			if not body.alive or body == skip:
				continue
			var q := Geometry2D.get_closest_point_to_segment(body.pos, a, b)  # Nearest point of the path.
			if q.distance_to(body.pos) <= HostileData.BLOCK_RADIUS and a.distance_to(q) < best_d:
				best_d = a.distance_to(q)
				best = body
	return best


## Lands shell `sh` (see _shells).
func _land_shell(sh: Array) -> void:
	var p: Vector2 = sh[0]
	var r := float(sh[1])  # Radius (px).
	counts["shells"] = int(counts["shells"]) + 1
	for t: Tower in game.towers.duplicate():
		if t.position.distance_to(p) <= r:
			TdCombat.disable_tower(game, t, float(sh[3]), String(sh[4]))
	if float(sh[5]) > 0.0:
		for b: BlockBody in game.bodies_near(p, r):
			TdCombat.damage_body(game, b, float(sh[5]))
	if game.vfx.on:
		var lk: Dictionary = HostileData.LOOKS["shell"]
		game.vfx.add(TdVfx.Kind.ANIM, p, r * 2.0, TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "corpse_explosion")
		var ring := game.vfx.add(TdVfx.Kind.RING, p, r, TdVfxData.RING_TIME, lk["tint"])
		if ring != null:
			ring.size0 = r * 0.3
		game.vfx.add(TdVfx.Kind.CRACK, p, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.shake(HostileData.SHELL_SHAKE)


## Shot `s` hit at `at`: its impact burst (drawn only).
func _impact(s: Shot, at: Vector2) -> void:
	if not game.vfx.on:
		return
	var lk: Dictionary = HostileData.LOOKS.get(s.look, HostileData.LOOKS["arrow"])
	game.vfx.add(TdVfx.Kind.ANIM, at + Vector2(0, -10), float(lk["impact"]), TdVfxData.IMPACT_TIME, lk["tint"], "volley_hit")


## Tower `t` was just disabled: a burst in its cause's colour (drawn only).
func disabled(t: Tower) -> void:
	if not game.vfx.on:
		return
	var tint: Color = HostileData.CAUSE_TINT.get(t.disabled_cause, HostileData.CAUSE_TINT["shelled"])
	game.vfx.add(TdVfx.Kind.ANIM, t.position + Vector2(0, -16), HostileData.DISABLED_BURST, TdVfxData.IMPACT_TIME, tint, "volley_hit")


func _process(_delta: float) -> void:
	queue_redraw()


## Draws the shells' closing telegraphs, the shots (sprite + trail) and the
## disabled towers' pulsing rings. Textures only.
func _draw() -> void:
	if game == null:
		return
	var tg := SpriteBank.texture("telegraphs/target")  # Telegraph circle.
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	for sh: Array in _shells:
		var p := clampf((game.time - float(sh[6])) / maxf(float(sh[2]) - float(sh[6]), 0.01), 0.0, 1.0)  # 0..1 to landing.
		var r := float(sh[1]) * (1.25 - 0.25 * p)  # Closing in (px).
		if tg != null:
			draw_texture_rect(tg, Rect2(Vector2(sh[0]) - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(HostileData.TELEGRAPH_TINT, 0.35 + 0.5 * p))
	var streak := TdArt.texture("vfx_streak")  # Trail mask.
	for s: Shot in _shots:
		if not s.active:
			continue
		var lk: Dictionary = HostileData.LOOKS.get(s.look, HostileData.LOOKS["arrow"])
		var ang := (s.to - s.from).angle()  # Flight direction.
		var at := s.pos  # Drawn position.
		if s.arc:
			var tot := maxf(s.from.distance_to(s.to), 1.0)  # Flight length (px).
			at += Vector2(0, -sin(s.from.distance_to(s.pos) / tot * PI) * tot * HostileData.ARC_LIFT)
		if streak != null and float(lk["trail"]) > 0.0 and not TdVfx.reduced():
			TdVfx.draw_streak(self, streak, at, ang, minf(float(lk["trail"]), s.from.distance_to(s.pos)), HostileData.TRAIL_W, lk["tint"])
		SpriteBank.draw_flat(self, String(lk["sprite"]), at, ang, Color.WHITE, float(lk["scale"]))
	if ring == null:
		return
	var d := HostileData.DISABLED_RING  # Ring diameter (px).
	for t: Tower in game.towers:
		if game.time >= t.disabled_until:
			continue
		var pulse := 0.6 + 0.4 * sin(game.time * TAU / HostileData.DISABLED_PULSE)  # 0.2..1.
		var tint: Color = HostileData.CAUSE_TINT.get(t.disabled_cause, HostileData.CAUSE_TINT["shelled"])
		var k := d * (0.9 + 0.1 * pulse)  # Pulsing size (px).
		draw_texture_rect(ring, Rect2(t.position + Vector2(-k * 0.5, -k * 0.3), Vector2(k, k * 0.6)), false, Color(tint, 0.5 + 0.5 * pulse))
