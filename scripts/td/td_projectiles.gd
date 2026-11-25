## TdProjectiles: the pool of tower shots in flight, simulated on the game
## clock and drawn by this one node with textures (SpriteBank.draw_flat), no
## node per shot. A shot homes on its target; if the target dies (or is
## recycled: generation check) it flies on to the last aim point. On arrival
## it resolves through TdCombat: single target (+ `pierce` extra enemies next
## to it) or splash, then the tower's slow / freeze, then the tower
## behaviour's impact() hook (class specials). Lobbed shots (fire_at: the
## Catapult's boulders) fly a fixed arc to a ground point over a landing
## telegraph instead of homing. Ground fields (add_field: burning bone
## shards, plague) tick damage over time on whatever stands in them.
class_name TdProjectiles
extends Node2D

## One shot in flight (pooled).
class Shot:
	## True while flying (false = free in the pool).
	var active: bool = false
	## Map px now.
	var pos: Vector2 = Vector2.ZERO
	## Target enemy and its generation when fired.
	var target: TdEnemy = null
	## See target.
	var target_gen: int = 0
	## Last known target position (map px).
	var aim: Vector2 = Vector2.ZERO
	## Speed (px/s).
	var speed: float = 300.0
	## Damage on hit.
	var damage: float = 0.0
	## Tower that fired it (stats are copied at fire time; the tower may be sold).
	var tower: Tower = null
	## Copied tower stats used on impact (splash, slow, freeze, pierce, armour_pierce, source).
	var splash: float = 0.0
	## See splash.
	var slow: float = 1.0
	## See splash.
	var slow_time: float = 0.0
	## True when this hit freezes (every Nth shot of a freeze_every tower).
	var freeze_time: float = 0.0
	## See splash.
	var pierce: int = 0
	## See splash.
	var armour_pierce: float = 0.0
	## Stats key of its damage (tower class).
	var source: String = ""
	## Sprite key (projectile or volley mask) and its tint.
	var sprite: String = ""
	## See sprite.
	var tint: Color = Color.WHITE
	## True for a Lv3+ volley shot (never freezes; impact hooks may skip specials).
	var is_volley: bool = false
	## Lobbed shots: true = flies a fixed arc to `aim` (no homing).
	var lob: bool = false
	## Lobbed shots: launch px, launch game s and flight time s.
	var from: Vector2 = Vector2.ZERO
	## See from.
	var t0: float = 0.0
	## See from.
	var flight: float = 1.0
	## Drawn size multiplier (volley boulders are smaller; visual only).
	var size: float = 1.0

## One ground field (pooled): ticks damage on enemies inside it.
class Field:
	## True while burning (false = free in the pool).
	var active: bool = false
	## Map px of its centre and its radius (px).
	var pos: Vector2 = Vector2.ZERO
	## See pos.
	var radius: float = 30.0
	## Game s it ends and of its next tick; s between ticks.
	var until: float = 0.0
	## See until.
	var next_tick: float = 0.0
	## See until.
	var tick: float = 0.5
	## Damage per tick to each enemy inside (damage over time: no armour).
	var damage: float = 0.0
	## Stats key and the tower credited (may be null: a spell).
	var source: String = ""
	## See source.
	var tower: Tower = null
	## Look: "flame" (aoe/flame_N) or "plague" (aoe/puff_plague_N), and its start game s.
	var look: String = "flame"
	## See look.
	var t0: float = 0.0

## The run.
var game: TdGame = null
## Every shot ever made (active and free).
var _shots: Array[Shot] = []
## Every ground field ever made (active and free).
var _fields: Array[Field] = []
## Cached textures (a draw command keeps only the RID): telegraph and field puffs.
var _tex: Dictionary = {}


func _ready() -> void:
	z_index = 5


## Fires a shot from tower `t` at `target` for `damage`, drawn as `sprite`
## tinted `tint`. `is_volley` shots never freeze (volleys are cosmetic bursts
## that still deal their damage).
func fire(t: Tower, target: TdEnemy, damage: float, sprite: String, tint: Color, is_volley: bool) -> void:
	var s := _take(t, damage, sprite, tint, is_volley)  # A free shot, filled from the tower.
	s.target = target
	s.target_gen = target.generation
	s.aim = target.position
	var fe := int(t.stats.get("freeze_every", 0))  # Freeze cadence.
	s.freeze_time = float(t.stats.get("freeze_time", 0.0)) if fe > 0 and not is_volley and t.shots % fe == 0 else 0.0


## Lobs a shot from tower `t` onto ground point `point`, landing after
## `flight` s (a landing telegraph shows meanwhile). `size` scales its sprite.
func fire_at(t: Tower, point: Vector2, flight: float, damage: float, sprite: String, tint: Color, is_volley: bool, size: float = 1.0) -> void:
	var s := _take(t, damage, sprite, tint, is_volley)  # A free shot, filled from the tower.
	s.target = null
	s.aim = point
	s.lob = true
	s.from = s.pos
	s.t0 = game.time
	s.flight = maxf(flight, 0.05)
	s.size = size
	s.freeze_time = 0.0


## A free pooled shot set up with tower `t`'s impact stats.
func _take(t: Tower, damage: float, sprite: String, tint: Color, is_volley: bool) -> Shot:
	var s: Shot = null  # A free shot.
	for x: Shot in _shots:
		if not x.active:
			s = x
			break
	if s == null:
		s = Shot.new()
		_shots.append(s)
	s.active = true
	s.lob = false
	s.size = 1.0
	s.is_volley = is_volley
	s.pos = t.position + Vector2(0, -18)
	s.speed = float(t.stats.get("projectile_speed", 400.0))
	s.damage = damage
	s.tower = t
	s.splash = float(t.stats.get("splash", 0.0))
	s.slow = float(t.stats.get("slow", 1.0))
	s.slow_time = float(t.stats.get("slow_time", 0.0))
	s.pierce = int(t.stats.get("pierce", 0))
	s.armour_pierce = float(t.stats.get("armour_pierce", 0.0))
	s.source = t.tower_id
	s.sprite = sprite
	s.tint = tint
	return s


## Lays a ground field at `pos` (`radius` px) for `life` s that deals `damage`
## (damage over time) every `tick` s to each enemy inside, credited to `tower`
## (may be null) under stats key `source`. `look`: "flame" or "plague".
func add_field(pos: Vector2, radius: float, life: float, tick: float, damage: float, source: String, tower: Tower, look: String) -> void:
	var f: Field = null  # A free field.
	for x: Field in _fields:
		if not x.active:
			f = x
			break
	if f == null:
		f = Field.new()
		_fields.append(f)
	f.active = true
	f.pos = pos
	f.radius = radius
	f.until = game.time + life
	f.tick = tick
	f.next_tick = game.time + tick
	f.damage = damage
	f.source = source
	f.tower = tower
	f.look = look
	f.t0 = game.time


## Moves every shot one fixed step and resolves arrivals.
func step(dt: float) -> void:
	for f: Field in _fields:
		if not f.active:
			continue
		if game.time >= f.until:
			f.active = false
			continue
		if game.time >= f.next_tick:
			f.next_tick += f.tick
			var hit := {"source": f.source, "tower": f.tower if is_instance_valid(f.tower) else null, "dot": true}  # TdCombat hit info.
			for e: TdEnemy in game.enemies_near(f.pos, f.radius):
				TdCombat.damage_enemy(game, e, f.damage, hit)
	for s: Shot in _shots:
		if not s.active:
			continue
		if s.lob:
			if game.time - s.t0 >= s.flight:
				s.pos = s.aim
				_impact(s)
			else:
				s.pos = s.from.lerp(s.aim, (game.time - s.t0) / s.flight)
			continue
		if TdEnemy.valid(s.target, s.target_gen):
			s.aim = s.target.position
		var to := s.aim - s.pos  # Remaining flight.
		var move := s.speed * dt  # Px this step.
		if to.length() <= move:
			s.pos = s.aim
			_impact(s)
		else:
			s.pos += to.normalized() * move


## Resolves shot `s` at its position.
func _impact(s: Shot) -> void:
	s.active = false
	var hit := {"source": s.source, "tower": s.tower if is_instance_valid(s.tower) else null,
		"armour_pierce": s.armour_pierce, "origin": s.pos}  # TdCombat hit info.
	var victims: Array[TdEnemy] = []  # Enemies hit.
	if s.lob:
		victims = game.enemies_near(s.pos, s.splash)
	elif s.splash > 0.0:
		victims = game.enemies_near(s.pos, s.splash)
		game.fx.spawn("bolt_impact", s.pos, s.splash * 2.0, 0.3, s.tint)
	elif TdEnemy.valid(s.target, s.target_gen):
		victims.append(s.target)
		if s.pierce > 0:
			for e: TdEnemy in game.enemies_near(s.pos, TdRulesData.PIERCE_REACH):
				if e != s.target and victims.size() <= s.pierce:
					victims.append(e)
	for e: TdEnemy in victims:
		TdCombat.damage_enemy(game, e, s.damage, hit)
		if not e.alive:
			continue
		if s.slow < 1.0:
			TdCombat.slow_enemy(game, e, s.slow, s.slow_time)
		if s.freeze_time > 0.0:
			TdCombat.freeze_enemy(game, e, s.freeze_time)
	if is_instance_valid(s.tower) and game.towers.has(s.tower):  # Not sold since it fired.
		s.tower.behavior.impact(s.tower, s, victims)


func _process(_delta: float) -> void:
	queue_redraw()


## Cached texture `key` (SpriteBank key), or null.
func _texture(key: String) -> Texture2D:
	if not _tex.has(key):
		_tex[key] = SpriteBank.texture(key)
	return _tex[key]


func _draw() -> void:
	for f: Field in _fields:
		if f.active:
			var age := game.time - f.t0  # Field age (s).
			var tex := _texture("aoe/%s_%d" % ["flame" if f.look == "flame" else "puff_plague", int(age * 6.0) % 3])  # Flickering puff.
			var fade := clampf((f.until - game.time) / 0.4, 0.0, 1.0)  # Fades out at the end.
			if tex != null:
				var sz := Vector2(2.0, 2.0 * float(tex.get_height()) / float(tex.get_width())) * f.radius  # Drawn size, aspect kept (px).
				draw_texture_rect(tex, Rect2(f.pos - sz * 0.5, sz), false, Color(1, 1, 1, 0.75 * fade))
	var tg := _texture("telegraphs/target")  # Landing telegraph of lobbed shots.
	for s: Shot in _shots:
		if not s.active:
			continue
		if s.lob:
			var p := (game.time - s.t0) / s.flight  # 0..1 through the flight.
			if tg != null:
				var r := s.splash * (1.0 - 0.3 * p)  # Telegraph radius closing in (px).
				draw_texture_rect(tg, Rect2(s.aim - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(1.0, 0.45, 0.3, 0.35 + 0.4 * p))
			var lift := Vector2(0, -sin(p * PI) * s.from.distance_to(s.aim) * 0.35)  # Height of the arc (px).
			if not SpriteBank.draw_flat(self, s.sprite, s.pos + lift, p * TAU, s.tint, s.size * (1.0 + 0.4 * sin(p * PI))):
				SpriteBank.draw_disc(self, s.pos + lift, 4.0, s.tint)
			continue
		var ang := (s.aim - s.pos).angle()  # Flight direction (art points right).
		if not SpriteBank.draw_flat(self, s.sprite, s.pos, ang, s.tint):
			SpriteBank.draw_disc(self, s.pos, 3.0, s.tint)
