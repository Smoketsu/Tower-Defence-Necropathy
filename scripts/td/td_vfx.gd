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
enum Kind { ANIM, SLASH, RING, THREAD, WISP, CRACK, FLASH, NUMBER, STREAK }

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
	## True: drawn on the additive glow layer (grey masks, rings, threads, wisps, flashes).
	var glow: bool = false
	## Damage number text (Kind.NUMBER).
	var text: String = ""

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
## Additive glow layer over the effects (see Fx.glow).
var _add: UnitLayer = null
## Damage numbers alive now (pooled in _live; capped by TdVfxData.NUMBERS_MAX).
var _numbers: int = 0
## The shared additive material (additive()).
static var _additive: CanvasItemMaterial = null
## The shared soft glow disc (_soft()).
static var _soft_tex: GradientTexture2D = null


func _ready() -> void:
	on = DisplayServer.get_name() != "headless"
	z_index = 6
	_rng.seed = 7  # Fixed: visuals only.
	_ground = UnitLayer.new()
	_ground.z_as_relative = false
	_ground.z_index = -2
	_ground.draw_fn = func(ci: CanvasItem) -> void: _draw_list(ci, 0)
	add_child(_ground)
	_add = UnitLayer.new()
	_add.material = additive()
	_add.draw_fn = func(ci: CanvasItem) -> void: _draw_list(ci, 2)
	add_child(_add)


## The shared additive-blend material (glows read on the dark grass and the grey road alike).
static func additive() -> CanvasItemMaterial:
	if _additive == null:
		_additive = CanvasItemMaterial.new()
		_additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	return _additive


## Draws a trail on `ci` (meant for an additive layer): streak mask `tex`
## stretched `len` px behind `pos` along angle `ang`, `w` px wide, in `col`,
## with a white core over its front part; `col.a` fades both.
static func draw_streak(ci: CanvasItem, tex: Texture2D, pos: Vector2, ang: float, len: float, w: float, col: Color) -> void:
	ci.draw_set_transform(pos, ang, Vector2.ONE)
	ci.draw_texture_rect(tex, Rect2(-len, -w * 0.5, len, w), false, Color(col, col.a * TdVfxData.TRAIL_ALPHA))
	var cl := len * TdVfxData.TRAIL_CORE_LEN  # Core length (px).
	var cw := w * TdVfxData.TRAIL_CORE_W  # Core width (px).
	ci.draw_texture_rect(tex, Rect2(-cl, -cw * 0.5, cl, cw), false, Color(1, 1, 1, col.a * TdVfxData.TRAIL_CORE_A))
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## True on the Reduced effects level (trails and ambient extras off).
static func reduced() -> bool:
	return Settings.reduced_effects()


## True when motion effects (shake, lunges, breathing) may play.
static func motion() -> bool:
	return not Settings.reduce_motion and not GameState.autotest_reduce_motion


## Adds an effect (see Fx); `delay` s before it starts. Returns it (null when off).
func add(kind: int, pos: Vector2, size: float, dur: float, tint: Color, id: String = "", delay: float = 0.0) -> Fx:
	if not on:
		return null
	var cap := TdVfxData.CAP_REDUCED if reduced() else TdVfxData.CAP  # Live effects allowed.
	while _live.size() >= cap:
		if _live[0].kind == Kind.WISP:
			_wisps -= 1
		elif _live[0].kind == Kind.NUMBER:
			_numbers -= 1
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
	f.glow = kind in [Kind.RING, Kind.THREAD, Kind.WISP, Kind.FLASH, Kind.STREAK] or (kind == Kind.ANIM and TdVfxData.MASK_STRIPS.has(id))
	_live.append(f)
	return f


## Shakes the map by up to `px` (off under Reduce motion).
func shake(px: float) -> void:
	if on and motion() and Settings.screen_shake:
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
	if not s.lob and not reduced() and s.from != s.pos:  # The trail lingers where it landed.
		var tl := minf((TdVfxData.VOLLEY_TRAIL if s.is_volley else float(lk["trail"])) * k, s.from.distance_to(s.pos))  # Length (px).
		var st := add(Kind.STREAK, s.pos, (TdVfxData.VOLLEY_TRAIL_W if s.is_volley else float(lk["trail_w"])) * k, TdVfxData.TRAIL_LINGER, tint)
		if st != null:
			st.ang = (s.pos - s.from).angle()
			st.size0 = tl
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
		f.id = "evolved" if k > 1.0 else ""
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
			Color(1.0, 0.78, 0.72) if not boss else Color.WHITE, "vael_cleave" if boss else "enemy", 0.04)
	if f != null:
		f.ang = dir.angle()
		f.flip = _rng.randf() < 0.5
		if not boss:
			f.id = "enemy"
			f.tint = Color(1.0, 0.78, 0.72)
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


## Enemy `e` died: its burst by rank, a soul wisp to the soul counter, and the
## boss death sequence (staggered bursts, a white flash, the shake).
func death(e: TdEnemy) -> void:
	if not on:
		return
	var rank := String(e.row["rank"])  # fodder / elite / miniboss / boss.
	var d := float(TdVfxData.DEATH_D.get(rank, 70.0))  # Burst diameter (px).
	if rank == "boss":
		for i in TdVfxData.BOSS_BURSTS:
			var off := Vector2(_rng.randf_range(-40, 40), _rng.randf_range(-50, 20)) if i > 0 else Vector2.ZERO  # Around the body.
			add(Kind.ANIM, e.position + off, d * (0.6 if i < TdVfxData.BOSS_BURSTS - 1 else 1.2), 0.6, Color.WHITE, "boss_death", float(i) * TdVfxData.BOSS_BURST_GAP)
		add(Kind.FLASH, e.position, TdVfxData.BOSS_FLASH_R, TdVfxData.BOSS_FLASH_TIME, Color(1, 1, 1, 0.9), "", float(TdVfxData.BOSS_BURSTS - 1) * TdVfxData.BOSS_BURST_GAP)
		shake(TdVfxData.BOSS_DEATH_SHAKE)
	else:
		add(Kind.ANIM, e.position, d, TdVfxData.DEATH_TIME, Color.WHITE, "enemy_death")
		if rank != "fodder":
			add(Kind.ANIM, e.position, d * 0.9, TdVfxData.DEATH_TIME, TdVfxData.ELITE_TINT, "volley_hit")
			var r := add(Kind.RING, e.position, d * 0.6, 0.4, TdVfxData.ELITE_TINT)
			if r != null:
				r.size0 = 8.0
			if rank == "miniboss":
				shake(TdVfxData.BOSS_SHAKE)
	if not reduced() and _wisps < TdVfxData.WISP_CAP:
		_wisps += 1
		add(Kind.WISP, e.position + Vector2(0, -10), TdVfxData.WISP_R * (1.0 if rank == "fodder" else 1.6), TdVfxData.WISP_TIME, TdVfxData.WISP_TINT, "", 0.1)


## Spell `id` was cast at map px `pos`: a flash at the necromancer, then the
## spell's burst, ring and shake at its target (TdVfxData.SPELLS).
func cast(id: String, pos: Vector2) -> void:
	if not on or not TdVfxData.SPELLS.has(id):
		return
	var row: Dictionary = TdVfxData.SPELLS[id]
	var tint: Color = row["tint"]
	add(Kind.ANIM, game.necromancer_pos() + Vector2(0, -24), float(row["flash"]), TdVfxData.CAST_TIME, tint, "volley_flash")
	var at := game.necromancer_pos() if id == "dread_rally" else pos  # Where it lands.
	if String(row["strip"]) != "":
		add(Kind.ANIM, at, float(row["strip_d"]), TdVfxData.CAST_TIME * 1.4, tint if TdVfxData.MASK_STRIPS.has(String(row["strip"])) else Color.WHITE, String(row["strip"]), 0.05)
	if float(row["ring"]) > 0.0:
		var r := add(Kind.RING, at, float(row["ring"]), TdVfxData.CAST_TIME, tint, "", 0.05)
		if r != null:
			r.size0 = 12.0
	shake(float(row["shake"]))


## A Shadow Bolt hit at `pos`: a big violet burst and ring.
func bolt_hit(pos: Vector2) -> void:
	if not on:
		return
	var tint: Color = TdVfxData.SPELLS["shadow_bolt"]["tint"]
	add(Kind.ANIM, pos, TdVfxData.BOLT_IMPACT_D, TdVfxData.IMPACT_TIME, Color.WHITE, "bolt_impact")
	add(Kind.ANIM, pos, TdVfxData.BOLT_IMPACT_D * 0.8, TdVfxData.IMPACT_TIME, tint, "volley_hit")
	var r := add(Kind.RING, pos, TdVfxData.BOLT_IMPACT_D * 0.5, TdVfxData.RING_TIME, tint)
	if r != null:
		r.size0 = 10.0


## Enemy `e` took `dmg` (a direct hit): a floating number, when Settings >
## Damage numbers is on (capped; the oldest goes first).
func number(e: TdEnemy, dmg: float) -> void:
	if not on or dmg < TdVfxData.NUMBER_MIN or not (Settings.damage_numbers or GameState.autotest_numbers):
		return
	if _numbers >= TdVfxData.NUMBERS_MAX:
		for i in _live.size():
			if _live[i].kind == Kind.NUMBER:
				_live.remove_at(i)
				_numbers -= 1
				break
	var f := add(Kind.NUMBER, e.position + Vector2(_rng.randf_range(-8, 8), -SpriteBank.drawn_height(String(e.row["sprite"])) * 0.5 - 14.0),
			0.0, TdVfxData.NUMBER_TIME, TdVfxData.NUMBER_BIG_TINT if dmg >= TdVfxData.NUMBER_BIG else TdVfxData.NUMBER_TINT)
	if f != null:
		f.text = str(roundi(dmg))
		_numbers += 1


## An enemy reached the gate: the gate flashes red and the lives counter shakes.
func leak() -> void:
	if not on:
		return
	_leak_at = game.time
	if game.hud != null:
		game.hud.shake_lives()


func _process(delta: float) -> void:
	if not on:
		return
	for i in range(_live.size() - 1, -1, -1):
		var f := _live[i]
		if game.time - f.t0 >= f.dur:
			if f.kind == Kind.WISP:
				_wisps -= 1
			elif f.kind == Kind.NUMBER:
				_numbers -= 1
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
	_add.queue_redraw()


func _draw() -> void:
	_draw_list(self, 1)


## Draws every started effect of list `layer` on `ci`: 0 the ground layer,
## 1 this node (normal blend), 2 the additive glow layer.
func _draw_list(ci: CanvasItem, layer: int) -> void:
	if game == null:
		return
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	var ground := layer == 0  # Drawing the ground list.
	for f: Fx in _live:
		if game.time < f.t0 or f.ground != ground:
			continue
		if f.kind == Kind.SLASH and not ground:
			_draw_slash(ci, f, clampf((game.time - f.t0) / f.dur, 0.0, 1.0), layer == 2)
			continue
		if not ground and f.glow != (layer == 2):
			continue
		var p := clampf((game.time - f.t0) / f.dur, 0.0, 1.0)  # 0..1 through it.
		match f.kind:
			Kind.ANIM:
				SpriteBank.draw_anim(ci, f.id, f.pos, f.size, p, 1.0, f.tint)
			Kind.NUMBER:
				_draw_number(ci, f, p)
			Kind.STREAK:
				var tex := TdArt.texture("vfx_streak")
				if tex != null:
					draw_streak(ci, tex, f.pos, f.ang, f.size0 * (1.0 - p * 0.5), f.size * (1.0 - p * 0.6), Color(f.tint, 1.0 - p))
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


## The soft glow disc texture: white at the centre fading smoothly to clear
## at the rim (a radial GradientTexture2D, made once and cached).
static func _soft() -> Texture2D:
	if _soft_tex == null:
		var g := Gradient.new()  # Centre -> rim.
		g.offsets = PackedFloat32Array([0.0, 0.35, 1.0])
		g.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0.55), Color(1, 1, 1, 0)])
		var t := GradientTexture2D.new()  # Radial.
		t.gradient = g
		t.fill = GradientTexture2D.FILL_RADIAL
		t.fill_from = Vector2(0.5, 0.5)
		t.fill_to = Vector2(1.0, 0.5)
		t.width = 64
		t.height = 64
		_soft_tex = t
	return _soft_tex


## A sword crescent (td/vfx_slash strip) swinging along f.ang: it sweeps in,
## holds fully drawn, then fades (TdVfxData.SLASH_SWEEP / SLASH_HOLD). The
## coloured rim is the additive pass (`edge`), the white-gold core the normal one.
func _draw_slash(ci: CanvasItem, f: Fx, p: float, edge: bool) -> void:
	var tex := TdArt.texture("vfx_slash")  # 6 frames of 48 x 48.
	if tex == null:
		return
	var fh := tex.get_size().y  # Frame size (texels).
	var frames := int(tex.get_size().x / fh)  # Frame count (6: 3 sweep, 3 fade).
	var sw := TdVfxData.SLASH_SWEEP  # Sweep share.
	var hold := sw + TdVfxData.SLASH_HOLD  # End of the hold.
	var fr := 0  # Frame now.
	if p < sw:
		fr = mini(int(p / sw * 3.0), 2)
	elif p < hold:
		fr = 2
	else:
		fr = mini(3 + int((p - hold) / maxf(1.0 - hold, 0.01) * float(frames - 3)), frames - 1)
	var s := f.size * (TdVfxData.SLASH_EDGE_SCALE if edge else 1.0)  # Drawn size (px).
	var col: Color = f.tint  # Core colour.
	if edge:
		col = TdVfxData.SLASH_EDGE_EVOLVED if f.id == "evolved" else (TdVfxData.SLASH_EDGE if f.id == "" else f.tint)
	ci.draw_set_transform(f.pos, f.ang, Vector2(1.0, -1.0 if f.flip else 1.0))
	ci.draw_texture_rect_region(tex, Rect2(-s * 0.5, -s * 0.5, s, s), Rect2(fh * float(fr), 0.0, fh, fh), col)
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## A floating damage number (f.text) rising and fading.
func _draw_number(ci: CanvasItem, f: Fx, p: float) -> void:
	var font := UiTheme.font_for(TdVfxData.NUMBER_FONT)  # Jersey 10.
	var pos := f.pos + Vector2(0, -TdVfxData.NUMBER_RISE * p)  # Rising (px).
	var w := font.get_string_size(f.text, HORIZONTAL_ALIGNMENT_LEFT, -1, TdVfxData.NUMBER_FONT).x  # Text width (px).
	var a := 1.0 - p * p  # Fades late.
	ci.draw_string_outline(font, pos - Vector2(w * 0.5, 0), f.text, HORIZONTAL_ALIGNMENT_LEFT, -1, TdVfxData.NUMBER_FONT, 4, Color(0, 0, 0, 0.8 * a))
	ci.draw_string(font, pos - Vector2(w * 0.5, 0), f.text, HORIZONTAL_ALIGNMENT_LEFT, -1, TdVfxData.NUMBER_FONT, Color(f.tint, a))


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
