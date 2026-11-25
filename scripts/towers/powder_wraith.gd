## Powder Wraith kit (the Black Tide's act tower, unlocked by Captain
## Vandermere; Necropathy PowderWraithBehavior "keg_burst": "a skeleton
## carrying a lit keg that walks into a pack and bursts, then reforms"): every
## `interval` s (its reform time) it picks the densest pack on the road in range
## (the enemy with the most foes within `splash` px; never a flyer: row
## "ground_only"), marches at it with the fuse lit at `march_speed` px/s
## (homing on its victim) and bursts: `damage` to every enemy within `splash`
## px (armour_pierce), a stagger of `stagger_time` s and a knockback of `knock`
## px down the road (TdCombat.knock_enemy: never bosses, minibosses, structures
## or flyers). Then it is spent and reforms on its plot when the cooldown ends.
## From level 3 each burst throws a ring of burning shrapnel (its volley row:
## `count` extra hits of `damage` x the burst's damage on the nearest foes within
## `reach` px of the burst). Evolved into the Magazine Lord (EvolutionData
## "magazine_lord"): a wider keg and a second burst at the next pack within
## `second_burst` px of the first.
## Tower.vars: "phase" (0 home, 1 marching, 2 spent), "pos" (map px of the
## wraith while it marches), "victim" / "victim_gen", "bursts" (count).
extends TowerBehavior


func step(t: Tower, dt: float) -> void:
	var g := t.game  # The run.
	var phase := int(t.vars.get("phase", 0))  # Where it is.
	if phase == 1:
		_march(t, dt)
		if g.vfx.on:
			t.layers[0].queue_redraw()  # It moves every frame while out (drawn only).
		return
	if g.time < t.next_fire:
		return
	if phase == 2:
		t.vars["phase"] = 0  # Reformed on its plot.
		g.fx.spawn("summon_rise", t.position, 70.0, 0.45)
		t.layers[0].queue_redraw()
	var v := _densest(t, t.position, float(t.stats["range"]), null)  # Its victim.
	if v == null:
		return
	t.vars["phase"] = 1
	t.vars["pos"] = t.position
	t.vars["victim"] = v
	t.vars["victim_gen"] = v.generation
	t.vars["aim"] = v.position
	t.shots += 1
	t.face(v.position)
	g.sound_fire(t.tower_id)


## The enemy within `r` px of `at` with the most foes within `splash` px (ties:
## nearest the gate), never `skip`, only ones this tower may strike; null when none.
func _densest(t: Tower, at: Vector2, r: float, skip: TdEnemy) -> TdEnemy:
	var g := t.game  # The run.
	var best: TdEnemy = null  # Best so far.
	var best_s := -INF  # Its score.
	for e: TdEnemy in g.foes_near(at, r):
		if e == skip or not t.can_hit(e):
			continue
		var s := float(g.foes_near(e.position, float(t.stats["splash"])).size()) * 100000.0 + g.progress(e)  # Pack size first.
		if s > best_s:
			best_s = s
			best = e
	return best


## One march step toward its victim (homing); bursts on arrival.
func _march(t: Tower, dt: float) -> void:
	var v: TdEnemy = t.vars.get("victim", null)
	if TdEnemy.valid(v, int(t.vars.get("victim_gen", -1))):
		t.vars["aim"] = v.position
	var p: Vector2 = t.vars["pos"]
	var to: Vector2 = Vector2(t.vars["aim"]) - p  # Remaining march.
	var move := float(t.stats["march_speed"]) * dt  # Px this step.
	if to.length() > move:
		t.vars["pos"] = p + to.normalized() * move
		t.face(Vector2(t.vars["aim"]))
		return
	var at: Vector2 = t.vars["aim"]
	_burst(t, at)
	var second := float(t.stats["second_burst"])  # Magazine Lord's chain (0 = none).
	if second > 0.0:
		var n := _densest(t, at, second, null)  # The next pack.
		if n != null and n.position.distance_to(at) > float(t.stats["splash"]) * 0.5:
			_burst(t, n.position)
			_streak(t, at, n.position)
	t.vars.erase("victim")
	t.vars["phase"] = 2
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME


## A keg bursts at `at`: damage, stagger and knockback on every foe in the blast, then the Lv3 shrapnel.
func _burst(t: Tower, at: Vector2) -> void:
	var g := t.game  # The run.
	var r := float(t.stats["splash"])  # Blast radius (px).
	var hit: Array[TdEnemy] = []  # Struck by the blast.
	for e: TdEnemy in g.foes_near(at, r):
		if t.can_hit(e):
			hit.append(e)
	for e: TdEnemy in hit:
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": at, "armour_pierce": float(t.stats["armour_pierce"])})
		if e.alive:
			TdCombat.stagger_enemy(g, e, float(t.stats["stagger_time"]))
			TdCombat.knock_enemy(g, e, float(t.stats["knock"]))
	t.vars["bursts"] = int(t.vars.get("bursts", 0)) + 1
	_shrapnel(t, at)
	Sfx.play("powder_blast")
	if g.vfx.on:
		var lk: Dictionary = TdVfx.look(t.tower_id)  # Its SHOTS row.
		var k := TdVfx.loud(t)  # Evolved: louder.
		g.vfx.add(TdVfx.Kind.ANIM, at, r * 2.4 * k, TdVfxData.IMPACT_TIME * 1.5, lk["tint"], "corpse_explosion")
		var ring := g.vfx.add(TdVfx.Kind.RING, at, r * TdVfxData.RING_TO, TdVfxData.RING_TIME, lk["tint"])  # The REAL radius.
		if ring != null:
			ring.size0 = r * TdVfxData.RING_FROM
		g.vfx.add(TdVfx.Kind.CRACK, at, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
		g.vfx.shake(2.0 * k)


## The Lv3+ ring of burning shrapnel off a burst at `at` (its volley row).
func _shrapnel(t: Tower, at: Vector2) -> void:
	var v: Dictionary = t.stats.get("volley", {})  # The class's volley row.
	if v.is_empty() or t.level < 3:
		return
	var g := t.game  # The run.
	var near := g.foes_near(at, float(v["reach"]))  # Candidates.
	near.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.position.distance_squared_to(at) < b.position.distance_squared_to(at))
	var n := 0  # Shards thrown.
	for e: TdEnemy in near:
		if n >= int(v["count"]):
			break
		if not t.can_hit(e):
			continue
		n += 1
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]) * float(v["damage"]), {"source": t.tower_id, "tower": t, "origin": at})
		_streak(t, at, e.position)
	if n > 0:
		g.fx.spawn("volley_flash", at + Vector2(0, -16), TdVfxData.TIDE_SHRAPNEL_FLASH, 0.25, v["tint"])


## A shard / chain streak from `a` to `b` in the class colour (drawn only).
func _streak(t: Tower, a: Vector2, b: Vector2) -> void:
	if not t.game.vfx.on:
		return
	var lk: Dictionary = TdVfx.look(t.tower_id)  # Its SHOTS row.
	var st := t.game.vfx.add(TdVfx.Kind.STREAK, b, float(lk["trail_w"]), TdVfxData.TRAIL_LINGER * 1.4, lk["tint"])
	if st != null:
		st.ang = (b - a).angle()
		st.size0 = maxf(a.distance_to(b), 24.0)
	t.game.vfx.add(TdVfx.Kind.ANIM, b + Vector2(0, -10), float(lk["impact_d"]), TdVfxData.IMPACT_TIME, lk["tint"], "volley_hit")


## No default volley: the shrapnel comes off each burst (_shrapnel).
func volley(_t: Tower, _target: TdEnemy) -> void:
	pass


func draw_body(t: Tower, ci: CanvasItem, _index: int) -> void:
	var phase := int(t.vars.get("phase", 0))  # Where it is.
	if phase != 0 and t.game.vfx.on:  # The empty plot stays marked by a faint shadow.
		SpriteBank.draw_disc(ci, Vector2(0, -TowerData.BODY_LIFT + 2), TdVfxData.KIT_SHADOW_R, Color(0, 0, 0, TdVfxData.KIT_SHADOW_A * 0.5))
	if phase == 2:
		return  # Spent: it reforms when the cooldown ends.
	var o: Vector2 = (Vector2(t.vars["pos"]) - t.position) if phase == 1 else Vector2.ZERO  # Map offset from the plot.
	var local := Vector2(o.x * t.facing, o.y - TowerData.BODY_LIFT)  # In the mirrored layer's space.
	var lit := phase == 1 and t.game.vfx.on and int(t.game.time * TdVfxData.TIDE_FUSE_HZ) % 2 == 0  # The fuse flickers while it marches.
	var tint := TdVfxData.TIDE_FUSE_TINT if lit or t.firing_flash() else Color.WHITE
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), local.round(), false, tint):
		ci.draw_rect(Rect2(local + Vector2(-10, -26), Vector2(20, 30)), Color(0.9, 0.6, 0.3))
