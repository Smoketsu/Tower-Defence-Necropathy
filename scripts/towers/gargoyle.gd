## Crypt Gargoyle kit (GDD §4.2 "patrols a circle, the answer to flyers"): it
## circles its plot in the air (`patrol_r` px at `patrol_speed` rad/s; drawn
## only, targeting is from the plot). Every `interval` s it swoops on a target
## in range (a flyer first, `air_bonus`): after `dive_time` s it lands, dealing
## `damage` to every enemy within `splash` px (x `air_mult` on flyers), marks
## them swooped for `swoop_mark` s (TdCombat.swoop_enemy: Death from Above and
## the Wild Hunt read it), then flies back. From level 3 each landing throws its
## volley of feather shards. Evolved into the Cathedral Horror
## (EvolutionData "cathedral_horror"): a wider landing that freezes what it hits
## for `dive_stun` s, then `stone_time` s as stone before it flies back.
## Tower.vars: "phase" (0 circling, 1 diving, 2 perched, 3 returning), "t0",
## "at" (landing px), "from" (map offset it dived from), "swoops" (count).
extends TowerBehavior


func step(t: Tower, _dt: float) -> void:
	var g := t.game  # The run.
	if g.vfx.on:
		t.layers[0].queue_redraw()  # Always in motion (drawn only).
		t.queue_redraw()  # Its dive trail (draw_overlay).
	var phase := int(t.vars.get("phase", 0))  # What it does.
	var dive := float(t.stats["dive_time"])  # One-way flight (s).
	match phase:
		1:
			if g.time - float(t.vars["t0"]) >= dive:
				_land(t)
				t.vars["phase"] = 2
				t.vars["t0"] = g.time
			return
		2:
			if g.time - float(t.vars["t0"]) >= maxf(float(t.stats["stone_time"]), 0.2):
				t.vars["phase"] = 3
				t.vars["t0"] = g.time
			return
		3:
			if g.time - float(t.vars["t0"]) >= dive:
				t.vars["phase"] = 0
			return
	if g.time < t.next_fire:
		return
	var target := _pick(t)  # What it swoops on, or null.
	if target == null:
		return
	t.vars["from"] = circle(t, g.time)
	t.vars["phase"] = 1
	t.vars["t0"] = g.time
	t.vars["target"] = target
	t.vars["target_gen"] = target.generation
	t.vars["at"] = target.position
	t.vars["swoops"] = int(t.vars.get("swoops", 0)) + 1
	t.next_fire = g.time + float(t.stats["interval"])
	t.shots += 1
	t.face(target.position)
	g.sound_fire(t.tower_id)


## A flyer in range when there is one (the nearest to the gate), else the
## tower's own targeting pick.
func _pick(t: Tower) -> TdEnemy:
	var best: TdEnemy = null  # Best flyer.
	for e: TdEnemy in t.game.foes_near(t.position, float(t.stats["range"])):
		if bool(e.row.get("flying", false)) and (best == null or t.game.progress(e) > t.game.progress(best)):
			best = e
	return best if best != null else t.pick_target()


## The landing: area damage, the swoop mark, the stun, the volley.
func _land(t: Tower) -> void:
	var g := t.game  # The run.
	var tg: TdEnemy = t.vars.get("target", null)
	if TdEnemy.valid(tg, int(t.vars.get("target_gen", -1))):
		t.vars["at"] = tg.position  # It tracks its prey down.
	t.vars.erase("target")
	var at: Vector2 = t.vars["at"]
	var r := float(t.stats["splash"])  # Landing radius (px).
	var first: TdEnemy = null  # Someone hit (the volley's target).
	for e: TdEnemy in g.foes_near(at, r):
		var dmg := float(t.stats["damage"]) * (float(t.stats["air_mult"]) if bool(e.row.get("flying", false)) else 1.0)  # Flyers take more.
		TdCombat.damage_enemy(g, e, dmg, {"source": t.tower_id, "tower": t, "origin": at})
		if e.alive:
			TdCombat.swoop_enemy(g, e, float(t.stats["swoop_mark"]))
			if float(t.stats["dive_stun"]) > 0.0:
				TdCombat.freeze_enemy(g, e, float(t.stats["dive_stun"]))
			first = e if first == null else first
	if g.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		g.vfx.add(TdVfx.Kind.ANIM, at, r * 2.4 * k, 0.5, Color.WHITE, "seraph_dive")
		var ring := g.vfx.add(TdVfx.Kind.RING, at, r * TdVfxData.RING_TO, TdVfxData.RING_TIME * 1.3, TdVfxData.KIT_SWOOP_TINT)
		if ring != null:
			ring.size0 = r * TdVfxData.RING_FROM
		g.vfx.add(TdVfx.Kind.CRACK, at, 0.8 * k, TdVfxData.CRACK_TIME, Color.WHITE)
		g.vfx.shake(1.5 * k)
	if first != null:
		volley(t, first)


## Map offset (px) from its plot of its patrol circle at game s `time` (in the air).
func circle(t: Tower, time: float) -> Vector2:
	var a := time * float(t.stats["patrol_speed"]) + t.position.x * 0.01  # Angle (radians; offset per plot).
	var r := float(t.stats["patrol_r"])  # Radius (px).
	return Vector2(cos(a) * r, sin(a) * r * 0.5 - TdVfxData.KIT_FLY_LIFT)


## Map offset (px) of the gargoyle now and whether it is on the ground.
func offset(t: Tower) -> Vector2:
	var phase := int(t.vars.get("phase", 0))  # What it does.
	if phase == 0:
		return circle(t, t.game.time)
	var land: Vector2 = Vector2(t.vars["at"]) - t.position  # The landing point.
	var f := clampf((t.game.time - float(t.vars["t0"])) / float(t.stats["dive_time"]), 0.0, 1.0)  # 0..1 of the flight.
	match phase:
		1: return Vector2(t.vars["from"]).lerp(land, f * f)  # Accelerating dive.
		2: return land
		3: return land.lerp(circle(t, t.game.time), f)
	return Vector2.ZERO


func draw_body(t: Tower, ci: CanvasItem, _index: int) -> void:
	var o := offset(t)  # Map offset from the plot.
	var phase := int(t.vars.get("phase", 0))
	var ground := o + Vector2(0, TdVfxData.KIT_FLY_LIFT) if phase == 0 else o  # The shadow's spot.
	if phase == 3:
		ground = o + Vector2(0, TdVfxData.KIT_FLY_LIFT * clampf((t.game.time - float(t.vars["t0"])) / float(t.stats["dive_time"]), 0.0, 1.0))
	if t.game.vfx.on:
		SpriteBank.draw_disc(ci, Vector2(ground.x * t.facing, ground.y - TowerData.BODY_LIFT + 2), TdVfxData.KIT_SHADOW_R, Color(0, 0, 0, TdVfxData.KIT_SHADOW_A))
	var key := String(t.stats["sprite"])  # Its sprite.
	if phase == 2 and float(t.stats["stone_time"]) > 0.0 and SpriteBank.has(key + "_stone"):
		key += "_stone"  # The Cathedral Horror's stone form.
	var local := Vector2(o.x * t.facing, o.y - TowerData.BODY_LIFT)  # In the mirrored layer's space.
	var tint := Color(1.5, 1.4, 1.7) if t.game.vfx.on and (t.firing_flash() or phase == 1) else Color.WHITE
	if not SpriteBank.draw(ci, key, local.round(), false, tint):
		ci.draw_rect(Rect2(local + Vector2(-12, -26), Vector2(24, 30)), Color(0.6, 0.6, 0.7))


## The dive trail while it swoops (drawn only, on the tower node).
func draw_overlay(t: Tower) -> void:
	if not t.game.vfx.on or int(t.vars.get("phase", 0)) != 1:
		return
	var o := offset(t)  # Where it is.
	var from: Vector2 = t.vars["from"]
	var streak := TdArt.texture("vfx_streak")  # Trail mask.
	if streak != null and not TdVfx.reduced():
		var d := o - from  # Flight so far.
		t.material = TdVfx.additive()
		TdVfx.draw_streak(t, streak, o + Vector2(0, -16), d.angle(), minf(d.length(), 90.0), TdVfxData.KIT_SWOOP_W, TdVfxData.KIT_SWOOP_TINT)
