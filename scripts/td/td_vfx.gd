## TdVfx: the combat-effects layer (DECISIONS V1-V8): muzzle flashes, impact
## bursts and splash rings, sword slashes and smashes, enemy blows and shield
## sparks, sound rings, Mender soul-threads, death bursts, the boss death
## sequence, soul wisps flying to the soul counter, ground cracks, the screen
## shake and the gate's leak flash. Gameplay code only TELLS it that something
## happened (an event it already resolved); it reads the run, never writes
## to it, and uses its own RNG (never game.rng), so a run plays out
## identically with or without it. Everything is off headless (nothing is
## seen; the autotest stays lean). Numbers in TdVfxData; drawn with textures
## only (strips, masks, discs), no polygons. The Effects setting's Reduced
## level keeps the big shots, slashes and impacts but drops trails, wisps,
## breathing and the other ambient extras, with a smaller cap.
class_name TdVfx
extends Node2D

## Effect kinds.
enum Kind { ANIM, SLASH, RING, THREAD, WISP, CRACK, FLASH }

## One live effect.
class Fx:
	## Kind (Kind).
	var kind: int = 0
	## Effect strip id (ANIM: effects/<id>).
	var id: String = ""
	## Map px where it plays (THREAD / WISP: its start).
	var pos: Vector2 = Vector2.ZERO
	## THREAD: map px of its far end.
	var to: Vector2 = Vector2.ZERO
	## Diameter (px; RING: end radius; THREAD: thickness; WISP / FLASH: radius).
	var size: float = 0.0
	## RING: start radius (px).
	var size0: float = 0.0
	## Game s it starts (may be in the future: a delayed effect) and its length (s).
	var t0: float = 0.0
	## See t0.
	var dur: float = 0.3
	## Colour multiplier.
	var tint: Color = Color.WHITE
	## Rotation (radians; SLASH: its swing direction).
	var ang: float = 0.0
	## SLASH: true mirrors the crescent (alternate swings).
	var flip: bool = false
	## True: drawn on the ground layer (under the units).
	var ground: bool = false

## The run.
var game: TdGame = null
## False headless: every call returns at once.
var on: bool = true
## Live effects, oldest first.
var _live: Array[Fx] = []
## Ground layer (under the units: cracks, dust rings).
var _ground: UnitLayer = null
## Visual-only random source (shake jitter, slash mirroring); never game.rng.
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
## Current shake strength (px; decays).
var _shake: float = 0.0
## Game s the gate's leak flash started (-INF = none).
var _leak_at: float = -INF
## Wisps in flight now.
var _wisps: int = 0


func _ready() -> void:
	on = DisplayServer.get_name() != "headless"
	z_index = 6
	_rng.seed = 7  # Fixed: visuals only.
	_ground = UnitLayer.new()
	_ground.z_as_relative = false
	_ground.z_index = -2
	_ground.draw_fn = func(ci: CanvasItem) -> void: _draw_list(ci, true)
	add_child(_ground)


## True on the Reduced effects level (trails and ambient extras off).
static func reduced() -> bool:
	return Settings.effects == "reduced"


## True when motion effects (shake, lunges, breathing) may play.
static func motion() -> bool:
	return not Settings.reduce_motion


## Adds an effect (see Fx); `delay` s before it starts. Returns it (null when off).
func add(kind: int, pos: Vector2, size: float, dur: float, tint: Color, id: String = "", delay: float = 0.0) -> Fx:
	if not on:
		return null
	var cap := TdVfxData.CAP_REDUCED if reduced() else TdVfxData.CAP  # Live effects allowed.
	while _live.size() >= cap:
		if _live[0].kind == Kind.WISP:
			_wisps -= 1
		_live.pop_front()
	var f := Fx.new()  # The new effect.
	f.kind = kind
	f.pos = pos
	f.size = size
	f.dur = maxf(dur, 0.01)
	f.tint = tint
	f.id = id
	f.t0 = game.time + delay
	f.ground = kind == Kind.CRACK
	_live.append(f)
	return f


## Shakes the map by up to `px` (off under Reduce motion).
func shake(px: float) -> void:
	if on and motion():
		_shake = minf(maxf(_shake, px), TdVfxData.SHAKE_MAX)


## Lunge offset (0..1 of its reach) at `f` (0..1 through the lunge): quickly
## out over TdVfxData.LUNGE_OUT, then a slower step back.
static func lunge_curve(f: float) -> float:
	var o := TdVfxData.LUNGE_OUT  # Fraction going out.
	return sin(f / o * PI * 0.5) if f < o else cos((f - o) / (1.0 - o) * PI * 0.5)


## The shot look of tower class `id` (TdVfxData.SHOTS row or the default).
static func look(id: String) -> Dictionary:
	return TdVfxData.SHOTS.get(id, TdVfxData.SHOT_DEFAULT)


## Size multiplier of tower `t`'s effects (evolved towers are louder).
static func loud(t: Tower) -> float:
	return TdVfxData.EVOLVED_MULT if t != null and is_instance_valid(t) and t.evolution != "" else 1.0


## Tower `t` fired a shot (main shots only flash the muzzle).
func muzzle(t: Tower, is_volley: bool) -> void:
	if not on or is_volley:
		return
	var lk := look(t.tower_id)  # Its shot look.
	var d := float(lk["muzzle"]) * loud(t)  # Flash diameter (px).
	if d > 0.0:
		add(Kind.ANIM, t.position + Vector2(0, -TdVfxData.MUZZLE_LIFT), d, TdVfxData.MUZZLE_TIME, lk["tint"], "volley_flash")


## Shot `s` landed: its impact burst, splash ring, and for boulders the dust,
## the crack and the shake.
func impact(s: TdProjectiles.Shot) -> void:
	if not on:
		return
	var lk := look(s.source)  # Its tower's shot look.
	var k := loud(s.tower)  # Evolved: louder.
	var tint: Color = s.tint if s.is_volley else lk["tint"]  # Volleys keep their own colour.
	if s.is_volley:
		add(Kind.ANIM, s.pos, TdVfxData.VOLLEY_IMPACT_D * k * (1.6 if s.lob else 1.0), TdVfxData.IMPACT_TIME, tint, "volley_hit")
		if s.lob:
			add(Kind.ANIM, s.pos, s.splash * 1.2, TdVfxData.IMPACT_TIME, Color.WHITE, "bone_wall_burst")
		return
	var d := float(lk["impact_d"]) if float(lk["impact_d"]) > 0.0 else s.splash * 2.0  # Burst diameter (px).
	if String(lk["impact"]) != "" and d > 0.0:
		add(Kind.ANIM, s.pos, d * k, TdVfxData.IMPACT_TIME, Color.WHITE if String(lk["impact"]) != "volley_hit" else tint, String(lk["impact"]))
	if bool(lk["ring"]) and s.splash > 0.0:
		var r := add(Kind.RING, s.pos, s.splash * TdVfxData.RING_TO * k, TdVfxData.RING_TIME, tint if not s.lob else TdVfxData.DUST_TINT)
		if r != null:
			r.size0 = s.splash * TdVfxData.RING_FROM
			r.ground = s.lob
	if s.lob:
		add(Kind.CRACK, s.pos, 1.0 + 0.4 * (k - 1.0), TdVfxData.CRACK_TIME, Color.WHITE)
		shake(TdVfxData.LOB_SHAKE * k)


## Blocker body `b` of tower `t` struck enemy `e` (a sword slash, or the
## Abomination's overhead smash): the lunge, the slash or smash and the
## enemy's nudge (drawn offsets only).
func melee(t: Tower, b: BlockBody, e: TdEnemy) -> void:
	if not on:
		return
	var dir := (e.position - b.pos).normalized() if e.position != b.pos else Vector2(t.facing, 0.0)  # Body -> enemy.
	b.vis_strike_at = game.time
	b.vis_dir = dir
	var k := loud(t)  # Evolved: louder.
	if t.tower_id == "abomination":
		var at := game.time  # The fists land now (the body heaved up over the wind-up: abomination.gd).
		var ring := add(Kind.RING, b.pos + dir * 10.0, TdVfxData.SMASH_RING_D * 0.5 * k, 0.35, TdVfxData.DUST_TINT)
		if ring != null:
			ring.size0 = 10.0
			ring.ground = true
		add(Kind.CRACK, b.pos + dir * 12.0, 1.2 * k, TdVfxData.CRACK_TIME, Color.WHITE, "", at - game.time)
		add(Kind.ANIM, b.pos + dir * 12.0, TdVfxData.SMASH_RING_D * 0.8 * k, 0.35, Color.WHITE, "bone_wall_burst", at - game.time)
		for o: TdEnemy in b.held:
			_nudge(o, (o.position - b.pos).normalized(), at)
		if k > 1.0 or t.level >= 3:
			shake(TdVfxData.SMASH_SHAKE * k)
		return
	var f := add(Kind.SLASH, e.position - dir * 4.0, TdVfxData.SLASH_D * k, TdVfxData.SLASH_TIME,
			TdVfxData.SLASH_TINT_EVOLVED if k > 1.0 else TdVfxData.SLASH_TINT, "", TdVfxData.LUNGE_TIME * TdVfxData.LUNGE_OUT * 0.5)
	if f != null:
		f.ang = dir.angle()
		f.flip = _rng.randf() < 0.5
	_nudge(e, dir, game.time + TdVfxData.LUNGE_TIME * TdVfxData.LUNGE_OUT)


## Enemy `e` is nudged back along `dir` from game s `at` (drawn only).
func _nudge(e: TdEnemy, dir: Vector2, at: float) -> void:
	e.vis_nudge_at = at
	e.vis_nudge_dir = dir


## Held enemy `e` hit blocker body `b`: its lunge, a red slash, the body's flinch
## and shield sparks; a boss swings its strike pose with a big cleave.
func enemy_blow(e: TdEnemy, b: BlockBody) -> void:
	if not on:
		return
	var dir := (b.pos - e.position).normalized() if b.pos != e.position else Vector2.RIGHT  # Enemy -> body.
	e.vis_strike_at = game.time
	e.vis_strike_dir = dir
	b.vis_flinch_at = game.time + 0.05
	b.vis_flinch_dir = dir
	var boss := String(e.row["rank"]) == "boss"  # Bosses swing big.
	var f := add(Kind.SLASH if not boss else Kind.ANIM, b.pos - dir * (4.0 if not boss else 10.0),
			TdVfxData.BOSS_SLASH_D if boss else TdVfxData.ENEMY_SLASH_D, TdVfxData.SLASH_TIME * (1.4 if boss else 1.0),
			TdVfxData.ENEMY_SLASH_TINT if not boss else Color.WHITE, "vael_cleave" if boss else "", 0.04)
	if f != null:
		f.ang = dir.angle()
		f.flip = _rng.randf() < 0.5
	add(Kind.ANIM, b.pos + Vector2(0, -10) - dir * 6.0, TdVfxData.SPARK_D, 0.25, TdVfxData.SPARK_TINT, "volley_hit", 0.05)
	if boss:
		shake(TdVfxData.BOSS_SHAKE)


## A Banshee wail of radius `r` px from tower `t`: sound rings rolling out.
func wail(t: Tower, r: float) -> void:
	if not on:
		return
	var n := 1 if reduced() else TdVfxData.WAIL_RINGS  # Rings this wail.
	for i in n:
		var f := add(Kind.RING, t.position + Vector2(0, -12), r * loud(t), TdVfxData.WAIL_RING_LIFE, TdVfxData.WAIL_TINT, "", float(i) * TdVfxData.WAIL_RING_GAP)
		if f != null:
			f.size0 = 14.0


## Mender `t` healed blocker body `b`: a soul-thread and a sparkle.
func heal(t: Tower, b: BlockBody) -> void:
	if not on:
		return
	var f := add(Kind.THREAD, t.position + Vector2(0, -20), TdVfxData.THREAD_W * loud(t), TdVfxData.THREAD_TIME, TdVfxData.THREAD_TINT)
	if f != null:
		f.to = b.pos + Vector2(0, -12)
	add(Kind.ANIM, b.pos + Vector2(0, -12), TdVfxData.HEAL_SPARKLE_D, 0.4, TdVfxData.THREAD_TINT, "volley_hit", 0.12)


func _process(delta: float) -> void:
	if not on:
		return
	for i in range(_live.size() - 1, -1, -1):
		var f := _live[i]
		if game.time - f.t0 >= f.dur:
			if f.kind == Kind.WISP:
				_wisps -= 1
			_live.remove_at(i)
	var off := Vector2.ZERO  # Shake offset (px) this frame.
	if _shake > 0.0:
		off = Vector2(_rng.randf_range(-1, 1), _rng.randf_range(-1, 1)) * _shake
		_shake = maxf(_shake - TdVfxData.SHAKE_DECAY * delta, 0.0) if not game.paused else _shake
	game.world.position = game.world_origin + off.round()
	var lf := (game.time - _leak_at) / TdVfxData.LEAK_FLASH_TIME  # 0..1 through the leak flash.
	game.gate_layer.modulate = TdVfxData.LEAK_TINT.lerp(Color.WHITE, clampf(lf, 0.0, 1.0)) if lf < 1.0 else Color.WHITE
	queue_redraw()
	_ground.queue_redraw()


func _draw() -> void:
	_draw_list(self, false)


## Draws every started effect of the ground (`ground` true) or the upper list on `ci`.
func _draw_list(ci: CanvasItem, ground: bool) -> void:
	if game == null:
		return
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	for f: Fx in _live:
		if f.ground != ground or game.time < f.t0:
			continue
		var p := clampf((game.time - f.t0) / f.dur, 0.0, 1.0)  # 0..1 through it.
		match f.kind:
			Kind.ANIM:
				SpriteBank.draw_anim(ci, f.id, f.pos, f.size, p, 1.0, f.tint)
			Kind.SLASH:
				_draw_slash(ci, f, p)
			Kind.RING:
				if ring != null:
					var r := lerpf(f.size0, f.size, 1.0 - (1.0 - p) * (1.0 - p))  # Eased out (px).
					var c := Color(f.tint, f.tint.a * (1.0 - p))
					ci.draw_texture_rect(ring, Rect2(f.pos - Vector2(r, r), Vector2(r, r) * 2.0), false, c)
					if f.size > 40.0:
						var r2 := r * 0.92  # A second ring: the band reads thicker.
						ci.draw_texture_rect(ring, Rect2(f.pos - Vector2(r2, r2), Vector2(r2, r2) * 2.0), false, Color(c, c.a * 0.6))
			Kind.THREAD:
				_draw_thread(ci, f, p)
			Kind.WISP:
				_draw_wisp(ci, f, p)
			Kind.CRACK:
				var tex := TdArt.texture("vfx_crack")
				if tex != null:
					var sz := tex.get_size() * 2.0 * f.size  # Drawn size (px).
					ci.draw_texture_rect(tex, Rect2(f.pos - sz * 0.5, sz), false, Color(1, 1, 1, 1.0 - p * p))
			Kind.FLASH:
				var r := f.size * (0.4 + 0.6 * p)  # Growing white flash (px).
				ci.draw_texture_rect(_soft(), Rect2(f.pos - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(f.tint, f.tint.a * (1.0 - p)))


## The soft glow disc texture (holy/soft_disc; the hard disc without art).
static func _soft() -> Texture2D:
	var t := SpriteBank.texture("holy/soft_disc")  # Soft white disc.
	return t if t != null else SpriteBank.disc()


## A sword crescent (td/vfx_slash strip) swinging along f.ang.
func _draw_slash(ci: CanvasItem, f: Fx, p: float) -> void:
	var tex := TdArt.texture("vfx_slash")  # 6 frames of 48 x 48.
	if tex == null:
		return
	var fh := tex.get_size().y  # Frame size (texels).
	var frames := int(tex.get_size().x / fh)  # Frame count.
	var fr := mini(int(p * float(frames)), frames - 1)  # Frame now.
	ci.draw_set_transform(f.pos, f.ang, Vector2(1.0, -1.0 if f.flip else 1.0))
	var s := f.size  # Drawn size (px).
	ci.draw_texture_rect_region(tex, Rect2(-s * 0.5, -s * 0.5, s, s), Rect2(fh * float(fr), 0.0, fh, fh), f.tint)
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## A Mender soul-thread from f.pos to f.to with a mote running along it.
func _draw_thread(ci: CanvasItem, f: Fx, p: float) -> void:
	var link := TdArt.texture("synergy_link", true)  # Grey link mask.
	var d := f.to - f.pos  # Thread vector.
	var a := 1.0 - p * p  # Fade.
	if link != null:
		ci.draw_set_transform(f.pos, d.angle(), Vector2.ONE)
		ci.draw_texture_rect(link, Rect2(Vector2(0, -f.size * 0.5), Vector2(d.length(), f.size)), true, Color(f.tint, f.tint.a * a))
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var m := f.pos + d * minf(p * 1.6, 1.0)  # The running mote.
	ci.draw_texture_rect(_soft(), Rect2(m - Vector2(9, 9), Vector2(18, 18)), false, Color(f.tint, a))


## A soul wisp flying in an arc from f.pos to the HUD's soul counter.
func _draw_wisp(ci: CanvasItem, f: Fx, p: float) -> void:
	var target := f.pos + Vector2(0, -200)  # Fallback: straight up.
	if game.hud != null:
		target = game.world.get_global_transform_with_canvas().affine_inverse() * game.hud.souls_screen_pos()
	var q := p * p  # Accelerates toward the counter.
	var pos := f.pos.lerp(target, q) + Vector2(0, -TdVfxData.WISP_ARC * sin(q * PI))  # Point on the arc.
	var r := f.size * (1.0 - 0.4 * p)  # Shrinks as it arrives (px).
	ci.draw_texture_rect(_soft(), Rect2(pos - Vector2(r, r) * 2.0, Vector2(r, r) * 4.0), false, Color(f.tint, 0.45))
	ci.draw_texture_rect(_soft(), Rect2(pos - Vector2(r, r) * 0.6, Vector2(r, r) * 1.2), false, Color(1, 1, 1, 0.95))
