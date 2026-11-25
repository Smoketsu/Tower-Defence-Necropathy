## TdProjectiles: the pool of tower shots in flight, simulated on the game
## clock and drawn by this one node with textures (SpriteBank.draw_flat), no
## node per shot. A shot homes on its target; if the target dies (or is
## recycled: generation check) it flies on to the last aim point. On arrival
## it resolves through TdCombat: single target (+ `pierce` extra enemies next
## to it) or splash, then the tower's slow / freeze.
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

## The run.
var game: TdGame = null
## Every shot ever made (active and free).
var _shots: Array[Shot] = []


func _ready() -> void:
	z_index = 5


## Fires a shot from tower `t` at `target` for `damage`, drawn as `sprite`
## tinted `tint`. `is_volley` shots never freeze (volleys are cosmetic bursts
## that still deal their damage).
func fire(t: Tower, target: TdEnemy, damage: float, sprite: String, tint: Color, is_volley: bool) -> void:
	var s: Shot = null  # A free shot.
	for x: Shot in _shots:
		if not x.active:
			s = x
			break
	if s == null:
		s = Shot.new()
		_shots.append(s)
	s.active = true
	s.pos = t.position + Vector2(0, -18)
	s.target = target
	s.target_gen = target.generation
	s.aim = target.position
	s.speed = float(t.stats.get("projectile_speed", 400.0))
	s.damage = damage
	s.tower = t
	s.splash = float(t.stats.get("splash", 0.0))
	s.slow = float(t.stats.get("slow", 1.0))
	s.slow_time = float(t.stats.get("slow_time", 0.0))
	var fe := int(t.stats.get("freeze_every", 0))  # Freeze cadence.
	s.freeze_time = float(t.stats.get("freeze_time", 0.0)) if fe > 0 and not is_volley and t.shots % fe == 0 else 0.0
	s.pierce = int(t.stats.get("pierce", 0))
	s.armour_pierce = float(t.stats.get("armour_pierce", 0.0))
	s.source = t.tower_id
	s.sprite = sprite
	s.tint = tint


## Moves every shot one fixed step and resolves arrivals.
func step(dt: float) -> void:
	for s: Shot in _shots:
		if not s.active:
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
	if s.splash > 0.0:
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


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	for s: Shot in _shots:
		if s.active:
			var ang := (s.aim - s.pos).angle()  # Flight direction (art points right).
			if not SpriteBank.draw_flat(self, s.sprite, s.pos, ang, s.tint):
				SpriteBank.draw_disc(self, s.pos, 3.0, s.tint)
