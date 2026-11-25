## The Blood Moon, the Sanguine Court's act rule (ActData "court"; GDD §7.3
## "Blood Moon"; Necropathy's BloodMoon + Bloodfeast + Night Wings). Every
## RULE.every waves from wave RULE.first the moon rises for RULE.duration s
## (bosses keep it up through force_moon()). While it is up:
##   Bloodfeast  — a kill heals the feed_max nearest Court foes within feed_radius px by
##                 kill_heal; a blocker body that falls heals every Court foe
##                 within body_radius px by body_heal (a red thread to each
##                 feeder); healing past full banks as a blood shield.
##   Blood shield — TdCombat.ward_enemy(shield_ward): every Court foe on the
##                 road at the rise and spawned while it is up is shielded;
##                 a banked shield lasts shield_time s (a red ring under it).
##   Night Wings — at the rise a flight of `bats` bats crosses over every
##                 entrance road (flyers: blockers never hold them, ground-only
##                 towers never hit them).
##   and the kinds read moon_up(): werewolves turn, sleeping coffins open,
##   witches heal.
## Also: blood pools (add_pool(): the Bloated Thrall's burst, Isolde's bombs)
## heal the Court standing in them, moon or not; a foe in mist (vars
## "mist_until": the Vampire Noble, Carmilla) or hidden (vars "hidden_until":
## Isolde among her sisters) cannot be targeted (can_target()).
## Look: red sky edge bands and a blood moon disc fading in and out (textures,
## no full-screen overlay, no screen-reading shader), shield rings, a HUD cue
## ("Blood Moon in N waves" / "BLOOD MOON 0:32") and banners. Numbers in the
## act data file's RULE / LOOK.
extends MapRule

## Game s until which the moon is up (0 = down).
var moon_until: float = 0.0
## True when the moon was up at the last step (rise / set detection).
var _was_up: bool = false
## Current wave number (1-based; 0 before the first).
var wave: int = 0
## Live blood pools: [map px, radius px, end game s, HP per s].
var pools: Array = []
## Counters for the summary.
var counts: Dictionary = {"moons": 0, "feeds": 0, "fed_hp": 0, "shields": 0, "bats": 0, "pools": 0, "pool_hp": 0, "hidden": 0}
## Sky layer (red bands, under the HUD) and its additive moon disc; null headless.
var _sky: Node2D = null
## Shield ring layer (on the floor, under the units); null headless.
var _rings: Node2D = null
## HUD cue label; null headless.
var _cue: Label = null
## Sky strength 0..1 now (drawn only; eased toward the moon state on game time).
var _sky_a: float = 0.0
## Cached edge-band gradient (top -> transparent; per run, so nothing outlives it).
var _band_tex: GradientTexture2D = null


## The RULE numbers.
func _r() -> Dictionary:
	return Acts.data("court")["RULE"]


## The LOOK numbers.
static func look() -> Dictionary:
	return Acts.data("court")["LOOK"]


## True while the Blood Moon is up.
func moon_up() -> bool:
	return game.time < moon_until


## Keeps the moon up until at least game s `until` (bosses: Vargr's Moon-Eater, Isolde's Red Moon).
func force_moon(until: float) -> void:
	moon_until = maxf(moon_until, until)


## True when `e` belongs to the Court and is not a structure (it feeds, shields).
static func court(e: TdEnemy) -> bool:
	return Acts.act_of_kind(e.kind) == "court" and not bool(e.row.get("structure", false))


## Opens a blood pool of `radius` px at `pos` for `life` s, healing the Court
## inside `heal` HP per s (drawn as a red zone).
func add_pool(pos: Vector2, radius: float, life: float, heal: float) -> void:
	pools.append([pos, radius, game.time + life, heal])
	counts["pools"] = int(counts["pools"]) + 1
	if game.vfx.on:
		CovenantField.of(game).add_zone(pos, radius, game.time + life, look()["pool_tint"])


## The wave number of the next Blood Moon at or after wave `n` (0 = none left).
func next_moon_wave(n: int) -> int:
	var first := int(_r()["first"])  # First moon wave.
	var every := int(_r()["every"])  # Waves between moons.
	var total := (game.map["waves"] as Array).size()  # Waves on the map.
	var w := first if n <= first else first + ceili(float(n - first) / float(every)) * every  # Candidate.
	return w if w <= total else 0


func setup() -> void:
	if not game.vfx.on:
		return
	_rings = Node2D.new()
	_rings.z_index = -1
	_rings.draw.connect(_draw_rings)
	game.world.add_child(_rings)
	_sky = Node2D.new()
	_sky.z_index = 6  # Over the units and effects, under the spells' layer and the HUD.
	_sky.draw.connect(_draw_sky)
	game.world.add_child(_sky)
	var disc := Node2D.new()  # The moon's additive glow.
	disc.material = TdVfx.additive()
	disc.draw.connect(_draw_moon.bind(disc))
	_sky.add_child(disc)
	_cue = UiTheme.tier_label("", UiTheme.Tier.BODY)
	_cue.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cue.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	game.hud.root.add_child(_cue)


func on_wave_start(n: int) -> void:
	wave = n
	if n == next_moon_wave(n):
		force_moon(game.time + float(_r()["duration"]))


func on_spawn(e: TdEnemy) -> void:
	if moon_up() and court(e):
		TdCombat.ward_enemy(game, e, float(_r()["shield_ward"]), moon_until - game.time)
		e.vars["shield_until"] = moon_until


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	for o: TdEnemy in game.foes_near(e.position, 90.0):
		if o != e and o.traits != null and o.traits.has_method("offer_meal"):
			o.traits.call("offer_meal", o, game)  # A ghoul stops to eat (moon or not).
	if moon_up():
		_feed(e.position, float(_r()["feed_radius"]), float(_r()["kill_heal"]), e)


func on_body_fallen(b: BlockBody, _by: TdEnemy) -> void:
	if moon_up():
		_feed(b.pos, float(_r()["body_radius"]), float(_r()["body_heal"]), null)


## Bloodfeast: the `feed_max` Court foes nearest `pos` within `r` px (not `skip`) heal `amount`;
## past full it banks a blood shield.
func _feed(pos: Vector2, r: float, amount: float, skip: TdEnemy) -> void:
	var near: Array[TdEnemy] = []  # Court foes in reach, nearest first.
	for o: TdEnemy in game.foes_near(pos, r):
		if o != skip and court(o):
			near.append(o)
	near.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return x.position.distance_squared_to(pos) < y.position.distance_squared_to(pos))
	for o: TdEnemy in near.slice(0, int(_r()["feed_max"])):
		var room := o.max_hp - o.hp  # HP it can still take.
		TdCombat.heal_enemy(game, o, amount)
		counts["feeds"] = int(counts["feeds"]) + 1
		counts["fed_hp"] = int(counts["fed_hp"]) + roundi(minf(room, amount))
		if amount > room:
			shield(o, float(_r()["shield_time"]))
		if game.vfx.on:
			var f := game.vfx.add(TdVfx.Kind.THREAD, pos + Vector2(0, -8), float(look()["feed_w"]), 0.4, look()["feed_tint"])
			if f != null:
				f.to = o.position + Vector2(0, -10)


## Puts a blood shield on `e` for `time` s (the one shield path of the act).
func shield(e: TdEnemy, time: float) -> void:
	TdCombat.ward_enemy(game, e, float(_r()["shield_ward"]), time)
	e.vars["shield_until"] = maxf(float(e.vars.get("shield_until", 0.0)), game.time + time)
	counts["shields"] = int(counts["shields"]) + 1


func can_target(_t: Tower, e: TdEnemy) -> bool:
	if game.time < float(e.vars.get("mist_until", 0.0)) or game.time < float(e.vars.get("hidden_until", 0.0)):
		counts["hidden"] = int(counts["hidden"]) + 1
		return false
	return true


func step(dt: float) -> void:
	var up := moon_up()  # Moon state now.
	if up and not _was_up:
		_rise()
	elif _was_up and not up:
		game.banner("The Blood Moon sets")
	_was_up = up
	for i in range(pools.size() - 1, -1, -1):
		var p: Array = pools[i]
		if game.time >= float(p[2]):
			pools.remove_at(i)
			continue
		for o: TdEnemy in game.foes_near(p[0], float(p[1])):
			if court(o) and o.hp < o.max_hp:
				var h := minf(float(p[3]) * dt, o.max_hp - o.hp)  # HP healed this step.
				TdCombat.heal_enemy(game, o, h)
				counts["pool_hp"] = float(counts["pool_hp"]) + h
	if _sky != null:
		_step_look(dt)


## The moon rises: banner, every Court foe shielded, a bat flight over every entrance.
func _rise() -> void:
	counts["moons"] = int(counts["moons"]) + 1
	game.banner("The Blood Moon rises: the Court feeds")
	game.sound("boss")
	for e: TdEnemy in game.enemies:
		if e.alive and court(e):
			TdCombat.ward_enemy(game, e, float(_r()["shield_ward"]), moon_until - game.time)
			e.vars["shield_until"] = moon_until
	var kind := String(_r()["bat_kind"])  # The flight's kind.
	var gap := float(Acts.kinds()[kind]["radius"]) * 2.0 * float(_r()["bat_spacing"]) * 4.0  # Px between bats.
	for id: String in game.roads:
		var road: Road = game.roads[id]
		if not road.entrance:
			continue
		for i in int(_r()["bats"]):
			game.waves.spawn_extra(kind, id, -gap * float(i), float(i % 3 - 1) * 10.0)
			counts["bats"] = int(counts["bats"]) + 1


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = []  # k:v entries.
	for k: Variant in keys:
		parts.append("%s:%d" % [k, roundi(float(counts[k]))])
	return ",".join(parts)


# ------------------------------------------------------------------ look (drawn only)

## Eases the sky, redraws the layers and updates the HUD cue (visual only).
func _step_look(dt: float) -> void:
	var want := 1.0 if moon_up() else 0.0  # Target sky strength.
	var a := move_toward(_sky_a, want, dt / float(look()["fade"]))  # Eased strength.
	if a != _sky_a or want > 0.0:
		_sky_a = a
		_sky.queue_redraw()
		_sky.get_child(0).queue_redraw()
	_rings.queue_redraw()
	var lk := look()
	_cue.position = Vector2(game.hud.root.size.x, game.top_inset) + lk["cue_pos"]
	if moon_up():
		var left := ceili(moon_until - game.time)  # s left.
		_cue.text = "BLOOD MOON %d:%02d" % [left / 60, left % 60]
		_cue.add_theme_color_override("font_color", lk["cue_up"])
	else:
		var nw := next_moon_wave(wave + 1)  # Next moon wave.
		_cue.visible = nw > 0
		var ahead := nw - wave  # Waves to go.
		_cue.text = "Blood Moon next wave" if ahead <= 1 else "Blood Moon in %d waves" % ahead
		_cue.add_theme_color_override("font_color", lk["cue_near"] if ahead <= int(_r()["warn_waves"]) else lk["cue_ahead"])


## The cached vertical edge gradient (opaque at 0, clear at 1).
func _band() -> GradientTexture2D:
	if _band_tex == null:
		var g := Gradient.new()
		g.set_color(0, Color.WHITE)
		g.set_color(1, Color(1, 1, 1, 0))
		_band_tex = GradientTexture2D.new()
		_band_tex.gradient = g
		_band_tex.fill_from = Vector2(0.5, 0.0)
		_band_tex.fill_to = Vector2(0.5, 1.0)
		_band_tex.width = 8
		_band_tex.height = 64
	return _band_tex


## Red sky edge bands (four textured rects; nothing over the middle of the map).
func _draw_sky() -> void:
	if _sky_a <= 0.0:
		return
	var lk := look()
	var c: Color = lk["band"]
	c.a *= _sky_a
	var sz := Vector2(1280, 720)  # Map size (px).
	var dh := sz.y * float(lk["band_depth"])  # Band depth (px).
	var tex := _band()
	_sky.draw_texture_rect(tex, Rect2(0, 0, sz.x, dh), false, c)
	_sky.draw_set_transform(Vector2(0, sz.y), PI, Vector2(-1, 1))
	_sky.draw_texture_rect(tex, Rect2(0, 0, sz.x, dh), false, c)
	_sky.draw_set_transform(Vector2(0, 0), -PI * 0.5, Vector2(-1, 1))
	_sky.draw_texture_rect(tex, Rect2(0, 0, sz.y, dh), false, c)
	_sky.draw_set_transform(Vector2(sz.x, 0), PI * 0.5, Vector2.ONE)
	_sky.draw_texture_rect(tex, Rect2(0, 0, sz.y, dh), false, c)
	_sky.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## The blood moon disc, glowing additively (strength follows the sky).
func _draw_moon(ci: Node2D) -> void:
	if _sky_a <= 0.0:
		return
	var lk := look()
	var d := float(lk["moon_d"]) * (1.0 + 0.04 * sin(game.time * 1.5))  # Breathing glow (px).
	var c: Color = lk["moon_tint"]
	c.a *= _sky_a
	var p: Vector2 = lk["moon_pos"]
	ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(d, d) * 0.5, Vector2(d, d)), false, c)
	ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(d, d) * 0.2, Vector2(d, d) * 0.4), false, Color(1.0, 0.75, 0.7, _sky_a))


## A red ring under every blood-shielded Court foe.
func _draw_rings() -> void:
	var lk := look()
	var tex := MapView.grid_texture(CovenantField.ZONE_TEX)  # Disc art.
	if tex == null:
		return
	for e: TdEnemy in game.enemies:
		if e.alive and game.time < float(e.vars.get("shield_until", 0.0)) and game.time < e.ward_until:
			var d := e.radius * float(lk["shield_scale"])  # Ring diameter (px).
			_rings.draw_texture_rect(tex, Rect2(e.position - Vector2(d, d * 0.6) * 0.5, Vector2(d, d * 0.6)), false, lk["shield_tint"])
