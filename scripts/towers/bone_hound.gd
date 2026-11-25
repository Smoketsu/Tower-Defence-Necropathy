## Bone Hounds kit (GDD §4.2 "a pack that chases leaks down the road"): a pack
## of `bodies` hounds (LEVELS; `pack` before) lives in the kennel on its plot.
## The pack picks one prey within `range` px of the kennel, the enemy nearest
## the gate (never a flyer; elites first by `elite_bonus`), and the hounds run
## to it at `hound_speed` px/s; each hound beside it bites for `damage` every
## `interval` s, +`pack_bonus` per other hound biting the same prey (max
## `pack_max`, Necropathy's Pack Hunt). With no prey they run home. From level
## 3, every `volley.every` bites the kennel howls its volley. Hound positions
## are simulation state (Tower.vars), moved in fixed steps. Evolved into the
## Hellhound (EvolutionData "hellhound"): faster hounds whose bites burn
## (`burn_dps` for `burn_time` s, damage over time).
## Tower.vars: "hounds" — Array of [map px, next bite game s, last bite game s];
## "prey" / "prey_gen" — the pack's prey and its saved generation; "bites" (count).
extends TowerBehavior


func setup(t: Tower) -> void:
	on_recompute(t)


func on_recompute(t: Tower) -> void:
	var n := int(t.stats.get("bodies", t.stats["pack"]))  # Hounds now.
	if not t.vars.has("hounds"):
		t.vars["hounds"] = []
	var hs: Array = t.vars["hounds"]
	while hs.size() < n:
		hs.append([_home(t, hs.size()), 0.0, -INF])
	t.ensure_layers(n)


## Map px of hound `i`'s place in the kennel.
func _home(t: Tower, i: int) -> Vector2:
	return t.position + Vector2((float(i % 3) - 1.0) * 12.0, float(i / 3) * 8.0 - 2.0)


func step(t: Tower, dt: float) -> void:
	var g := t.game  # The run.
	var prey: TdEnemy = t.vars.get("prey", null)
	var r := float(t.stats["range"])  # Leash (px from the kennel).
	if not TdEnemy.valid(prey, int(t.vars.get("prey_gen", -1))) or prey.position.distance_squared_to(t.position) > r * r:
		prey = _pick(t)
		t.vars["prey"] = prey
		t.vars["prey_gen"] = prey.generation if prey != null else -1
	var hs: Array = t.vars["hounds"]
	var speed := float(t.stats["hound_speed"]) * dt  # Px a hound runs this step.
	var reach := (prey.radius if prey != null else 0.0) + 14.0  # Biting distance (px).
	var biting := 0  # Hounds beside the prey now (Pack Hunt).
	if prey != null:
		for h: Array in hs:
			biting += 1 if Vector2(h[0]).distance_to(prey.position) <= reach else 0
		t.face(prey.position)
	for i in hs.size():
		var h: Array = hs[i]
		var p: Vector2 = h[0]
		var goal := _home(t, i)  # Where it runs.
		if prey != null:
			var ang := TAU * float(i) / float(hs.size())  # Its side of the prey.
			goal = prey.position + Vector2(cos(ang), sin(ang) * 0.5) * (reach - 4.0)
		var to := goal - p  # Remaining run.
		h[0] = goal if to.length() <= speed else p + to.normalized() * speed
		if prey != null and prey.alive and Vector2(h[0]).distance_to(prey.position) <= reach and g.time >= float(h[1]):
			_bite(t, h, prey, biting)
	if g.vfx.on:
		for l: UnitLayer in t.layers:
			l.queue_redraw()  # Running every frame (drawn only).


## The prey: the enemy nearest the gate within the leash (elites first; no flyers).
func _pick(t: Tower) -> TdEnemy:
	var best: TdEnemy = null  # Best so far.
	var best_s := -INF  # Its score.
	for e: TdEnemy in t.game.foes_near(t.position, float(t.stats["range"])):
		if bool(e.row.get("flying", false)):
			continue
		var s := t.game.progress(e) + (float(t.stats["elite_bonus"]) if String(e.row["rank"]) != "fodder" else 0.0)  # Score.
		if s > best_s:
			best_s = s
			best = e
	return best


## Hound `h` bites `e` with `biting` packmates beside it.
func _bite(t: Tower, h: Array, e: TdEnemy, biting: int) -> void:
	var g := t.game  # The run.
	h[1] = g.time + float(t.stats["interval"])
	h[2] = g.time
	var bonus := minf(float(t.stats["pack_bonus"]) * float(maxi(biting - 1, 0)), float(t.stats["pack_max"]))  # Pack Hunt.
	var p: Vector2 = h[0]
	TdCombat.damage_enemy(g, e, float(t.stats["damage"]) * (1.0 + bonus), {"source": t.tower_id, "tower": t, "origin": p})
	if e.alive and float(t.stats["burn_dps"]) > 0.0:
		TdCombat.add_dot(g, e, float(t.stats["burn_dps"]), float(t.stats["burn_time"]), "hellhound_burn")
	t.shots += 1
	t.vars["bites"] = int(t.vars.get("bites", 0)) + 1
	g.sound_fire(t.tower_id)
	if g.vfx.on:
		var hell := float(t.stats["burn_dps"]) > 0.0  # Hellhound fire.
		var tint := TdVfxData.KIT_HELL_TINT if hell else TdVfxData.KIT_BITE_TINT  # Its colour.
		var f := g.vfx.add(TdVfx.Kind.SLASH, e.position - (e.position - p).normalized() * 4.0, TdVfxData.KIT_BITE_D * TdVfx.loud(t), TdVfxData.SLASH_TIME * 0.8, tint, "evolved")
		if f != null:
			f.ang = (e.position - p).angle()
			f.flip = (t.shots % 2) == 0
		g.vfx.add(TdVfx.Kind.ANIM, e.position + Vector2(0, -8), 40.0, 0.3, tint, "volley_hit")
	if e.alive:
		volley(t, e)


## Map offset of hound `i` from the kennel now (drawn only).
func _offset(t: Tower, i: int) -> Vector2:
	var hs: Array = t.vars.get("hounds", [])
	return Vector2(hs[i][0]) - t.position if i < hs.size() else Vector2.ZERO


func draw_body(t: Tower, ci: CanvasItem, index: int) -> void:
	var hs: Array = t.vars.get("hounds", [])
	if index >= hs.size() or index >= t.layers.size():
		return
	var l := t.layers[index]  # This hound's layer (mirrored by node scale).
	var o := _offset(t, index)  # Map offset from the kennel.
	var local := Vector2((o.x - l.position.x) * t.facing, o.y - l.position.y)  # In the layer's space.
	var hell := float(t.stats["burn_dps"]) > 0.0  # Hellhound.
	var away := o.length() > 20.0  # Out of the kennel, running.
	if away and hell and t.game.vfx.on and not TdVfx.reduced():  # A fire trail behind it.
		SpriteBank.draw_disc(ci, local + Vector2(-8.0, -4.0), 6.0, Color(TdVfxData.KIT_HELL_TINT, 0.5))
	var bit := t.game.time - float(hs[index][2]) < 0.12  # Just bit (flash).
	var tint := Color(1.6, 1.4, 1.2) if t.game.vfx.on and bit else Color.WHITE
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), local.round(), false, tint):
		ci.draw_rect(Rect2(local + Vector2(-8, -12), Vector2(16, 12)), Color(0.9, 0.85, 0.7))
