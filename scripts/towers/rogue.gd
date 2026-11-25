## Grave Rogue kit (GDD §4.2 "leaves its plot to dash at elites"): every
## `interval` s it picks a victim on the road in range (an elite, miniboss or
## boss first, `elite_bonus`; never a flyer), dashes out over `dash_time` s,
## strikes it for `damage` and a bleed (`bleed_dps` for `bleed_time` s, damage
## over time), lingers `linger` s and runs back as long as the dash took. It
## cannot dash again until it is home. From level 3 each dash also throws its
## volley of daggers. Evolved into the Shadow Reaper (EvolutionData
## "shadow_reaper"): faster dashes, `chain_dashes` more enemies within
## `chain_radius` px of the victim struck in the same dash, heavier bleeds, and
## a dash that kills refunds `kill_reset` of its cooldown.
## Tower.vars: "phase" (0 home, 1 out, 2 by the victim, 3 back), "t0" (game s
## the phase began), "at" (map px it struck), "dashes" (count).
extends TowerBehavior


func step(t: Tower, _dt: float) -> void:
	var g := t.game  # The run.
	var phase := int(t.vars.get("phase", 0))  # Where it is.
	var dt_out := float(t.stats["dash_time"])  # One-way trip (s).
	if phase != 0 and g.vfx.on:
		t.layers[0].queue_redraw()  # It moves every frame while away (drawn only).
	match phase:
		1:
			if g.time - float(t.vars["t0"]) >= dt_out:
				_strike(t)
				t.vars["phase"] = 2
				t.vars["t0"] = g.time
			return
		2:
			if g.time - float(t.vars["t0"]) >= float(t.stats["linger"]):
				t.vars["phase"] = 3
				t.vars["t0"] = g.time
			return
		3:
			if g.time - float(t.vars["t0"]) >= dt_out:
				t.vars["phase"] = 0
			return
	if g.time < t.next_fire:
		return
	var v := _pick(t)  # Victim, or null.
	if v == null:
		return
	t.vars["phase"] = 1
	t.vars["t0"] = g.time
	t.vars["victim"] = v
	t.vars["victim_gen"] = v.generation
	t.vars["at"] = v.position
	t.vars["dashes"] = int(t.vars.get("dashes", 0)) + 1
	t.next_fire = g.time + float(t.stats["interval"])
	t.shots += 1
	t.face(v.position)
	t.squash_until = g.time + TowerData.FIRE_SQUASH_TIME
	g.sound_fire(t.tower_id)
	volley(t, v)


## The victim in range: the elite / miniboss / boss nearest the gate when one is
## there, else the tower's own targeting pick (never a flyer: row "ground_only").
func _pick(t: Tower) -> TdEnemy:
	var best: TdEnemy = null  # Best elite so far.
	for e: TdEnemy in t.game.foes_near(t.position, float(t.stats["range"])):
		if String(e.row["rank"]) == "fodder" or bool(e.row.get("flying", false)):
			continue
		if best == null or t.game.progress(e) + float(t.stats["elite_bonus"]) > t.game.progress(best) + float(t.stats["elite_bonus"]):
			best = e
	if best != null:
		return best
	var e := t.pick_target()  # The targeting mode's pick.
	return null if e == null or bool(e.row.get("flying", false)) else e


## The dash lands: the victim (if still alive, else whoever stands nearest the
## strike point) and up to `chain_dashes` more are struck and bled.
func _strike(t: Tower) -> void:
	var g := t.game  # The run.
	var at: Vector2 = t.vars["at"]
	var v: TdEnemy = t.vars.get("victim", null)
	if TdEnemy.valid(v, int(t.vars.get("victim_gen", -1))):
		at = v.position
		t.vars["at"] = at
	else:
		v = null
		var near := g.foes_near(at, float(t.stats.get("chain_radius", 0.0)) + 40.0)  # Someone else where it landed.
		v = near[0] if not near.is_empty() else null
	t.vars.erase("victim")
	if v == null:
		return
	var hits: Array[TdEnemy] = [v]  # Struck this dash.
	for e: TdEnemy in g.foes_near(v.position, float(t.stats["chain_radius"])):
		if hits.size() > int(t.stats["chain_dashes"]):
			break
		if e != v and not bool(e.row.get("flying", false)):
			hits.append(e)
	var killed := false  # A dash kill (Shadow Reaper's reset).
	var prev := at  # Chain trail start.
	for e: TdEnemy in hits:
		var p := e.position  # Where it is struck.
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": prev, "armour_pierce": float(t.stats["armour_pierce"])})
		if e.alive:
			TdCombat.add_dot(g, e, float(t.stats["bleed_dps"]), float(t.stats["bleed_time"]), "rogue_bleed")
		else:
			killed = true
		_slash(t, prev, p)
		prev = p
	if killed and float(t.stats["kill_reset"]) > 0.0:
		t.next_fire -= float(t.stats["interval"]) * float(t.stats["kill_reset"])
		g.stats["rogue_resets"] = int(g.stats.get("rogue_resets", 0)) + 1


## The dash's look from `a` to `b`: a blood-red streak and a slash (drawn only).
func _slash(t: Tower, a: Vector2, b: Vector2) -> void:
	if not t.game.vfx.on:
		return
	var k := TdVfx.loud(t)  # Evolved: louder.
	var st := t.game.vfx.add(TdVfx.Kind.STREAK, b, TdVfxData.KIT_DASH_W * k, TdVfxData.TRAIL_LINGER * 1.6, TdVfxData.KIT_DASH_TINT)
	if st != null:
		st.ang = (b - a).angle()
		st.size0 = maxf(a.distance_to(b), 30.0)
	var f := t.game.vfx.add(TdVfx.Kind.SLASH, b, TdVfxData.KIT_DASH_SLASH_D * k, TdVfxData.SLASH_TIME, TdVfxData.KIT_DASH_TINT, "evolved")
	if f != null:
		f.ang = (b - a).angle()
	t.game.vfx.add(TdVfx.Kind.ANIM, b + Vector2(0, -10), 60.0 * k, TdVfxData.IMPACT_TIME, TdVfxData.KIT_DASH_TINT, "volley_hit")


## Map offset (px) of the rogue from its plot now (out on a dash, by its victim, or home).
func offset(t: Tower) -> Vector2:
	var phase := int(t.vars.get("phase", 0))  # Where it is.
	if phase == 0 or not t.vars.has("at"):
		return Vector2.ZERO
	var far: Vector2 = Vector2(t.vars["at"]) - t.position + Vector2(-10.0 * t.facing, 0)  # Beside the victim.
	var f := clampf((t.game.time - float(t.vars["t0"])) / float(t.stats["dash_time"]), 0.0, 1.0)  # 0..1 of the trip.
	match phase:
		1: return far * f
		2: return far
		3: return far * (1.0 - f)
	return Vector2.ZERO


func draw_body(t: Tower, ci: CanvasItem, _index: int) -> void:
	var o := offset(t)  # Map offset from the plot.
	var away := int(t.vars.get("phase", 0)) != 0  # Out on the road.
	if away and t.game.vfx.on:  # The empty grave stays marked by a faint shadow.
		SpriteBank.draw_disc(ci, Vector2(0, -TowerData.BODY_LIFT + 2), TdVfxData.KIT_SHADOW_R, Color(0, 0, 0, TdVfxData.KIT_SHADOW_A * 0.5))
	var local := Vector2(o.x * t.facing, o.y - TowerData.BODY_LIFT)  # In the mirrored layer's space.
	var tint := Color(1.6, 1.4, 1.4) if t.game.vfx.on and (t.firing_flash() or int(t.vars.get("phase", 0)) == 1) else Color.WHITE
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), local.round(), false, tint):
		ci.draw_rect(Rect2(local + Vector2(-10, -26), Vector2(20, 30)), Color(0.8, 0.4, 0.4))
