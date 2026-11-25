## The Broadsides (the Black Tide's act rule, GDD §7.3 "deck cannons shell
## plots on a telegraph"; MAP "act_rule": "corsair/broadsides"). Numbers in
## the act data file's RULE, cannon places in BROADSIDES[map id], looks in LOOK.
##   cannons — at the waves listed for the map the pirates run out a deck cannon
##             at the rail (kind tide_deck_cannon, a structure beside the road:
##             towers shoot it when nothing else is in range) with powder
##             barrels lashed beside it (tide_powder_keg, an ordinary target). Every `every` s
##             (x `crew_mult` while any Gunnery Mate lives: she mans the guns) a
##             standing cannon shells one plot tower within `reach` px (round
##             robin, nearest first): a telegraphed strike of `radius` px through
##             game.hostile.shell() that disables what it hits `disable` s.
##   counter — shoot the barrels: their blast deals `keg_damage` to every enemy
##             within `keg_radius` px, `keg_cannon_damage` to every cannon there
##             and spikes those cannons for `keg_spike` s. Fresh barrels are
##             lashed `keg_restock` s later while their cannon stands. A sunk
##             cannon stays sunk. Killing the Gunnery Mates slows the guns.
##   look    — the sea band and rail along the bottom edge (static layer), a
##             closing amber fuse ring over each cannon counting down to its
##             next broadside (grey when spiked), a muzzle flash and a streak to
##             the shelled plot, the barrels' blast; banners when a cannon is run
##             out, sunk or spiked. Drawn only, never read by the simulation.
extends MapRule

## Per cannon slot: {"row": its BROADSIDES row, "c": cannon TdEnemy or null, "cg":
## its generation, "k": barrels TdEnemy or null, "kg": their generation,
## "next": game s of its next broadside, "spiked": game s it is spiked until,
## "restock": game s fresh barrels are due (INF = none due), "aim": round-robin
## index, "raised": bool}.
var slots: Array[Dictionary] = []
## Counters for the summary.
var counts: Dictionary = {"cannons": 0, "sunk": 0, "broadsides": 0, "crewed": 0, "blasts": 0, "spiked": 0, "kegs": 0, "keg_kills": 0}
## The static sea band and rail.
var _sea: UnitLayer = null
## The fuse rings over the cannons (redrawn while any cannon stands).
var _fuses: UnitLayer = null


## RULE numbers.
func _r() -> Dictionary:
	return Acts.data("corsair")["RULE"]


## LOOK numbers.
func _lk() -> Dictionary:
	return Acts.data("corsair")["LOOK"]


func setup() -> void:
	for row: Dictionary in Acts.data("corsair")["BROADSIDES"].get(game.map_id, []):
		slots.append({"row": row, "c": null, "cg": 0, "k": null, "kg": 0, "next": INF, "spiked": 0.0, "restock": INF, "aim": 0, "raised": false})
	if DisplayServer.get_name() == "headless":
		return
	_sea = UnitLayer.new()
	_sea.z_index = -9  # Over the deck floor, under the spots and units.
	_sea.draw_fn = _draw_sea
	game.world.add_child(_sea)
	_fuses = UnitLayer.new()
	_fuses.z_index = 6  # Over the units, beside the hostile shots.
	_fuses.draw_fn = _draw_fuses
	game.world.add_child(_fuses)


func step(_dt: float) -> void:
	var r := _r()  # Numbers.
	var crew := _crewed()  # A Gunnery Mate mans the guns.
	for s: Dictionary in slots:
		if not bool(s["raised"]):
			if game.waves.current + 1 >= int(s["row"]["wave"]):
				_run_out(s)
			continue
		if not TdEnemy.valid(s["c"], int(s["cg"])):
			continue
		if not TdEnemy.valid(s["k"], int(s["kg"])) and game.time >= float(s["restock"]):
			_lash_kegs(s)
		if game.time < float(s["next"]) or game.time < float(s["spiked"]):
			continue
		s["next"] = game.time + float(r["every"]) * (float(r["crew_mult"]) if crew else 1.0)
		_fire(s, crew)
	if _fuses != null and game.vfx.on:
		_fuses.queue_redraw()
	_finish()


## Runs out the cannon of slot `s` (and its barrels).
func _run_out(s: Dictionary) -> void:
	s["raised"] = true
	var c := Structures.raise(game, String(_r()["cannon_kind"]), s["row"]["pos"])
	s["c"] = c
	s["cg"] = c.generation
	s["next"] = game.time + float(_r()["first_delay"])
	_lash_kegs(s)
	counts["cannons"] = int(counts["cannons"]) + 1
	game.banner("The pirates run out a deck cannon: shoot its powder barrels!")


## When every wave has spawned and only structures and powder barrels remain,
## clears them so the map can end (MapRule.finish_structures() with the barrels,
## which are not structures so that towers and splash hit them like any foe).
func _finish() -> void:
	if not game.waves.all_spawned() or game.enemies.is_empty():
		return
	var keg := String(_r()["keg_kind"])  # The barrels' kind.
	for e: TdEnemy in game.enemies:
		if e.kind != keg and not bool(e.row.get("structure", false)):
			return
	for e: TdEnemy in game.enemies.duplicate():
		game.remove_enemy(e, false)


## Lashes fresh powder barrels beside the cannon of slot `s`.
func _lash_kegs(s: Dictionary) -> void:
	var k := Structures.raise(game, String(_r()["keg_kind"]), s["row"]["keg"])
	s["k"] = k
	s["kg"] = k.generation
	s["restock"] = INF
	counts["kegs"] = int(counts["kegs"]) + 1


## True while any Gunnery Mate lives.
func _crewed() -> bool:
	var kind := String(_r()["crew_kind"])  # The crew's kind.
	for e: TdEnemy in game.enemies:
		if e.kind == kind:
			return true
	return false


## Cannon of slot `s` fires a broadside at a plot tower in reach (round robin, nearest first).
func _fire(s: Dictionary, crew: bool) -> void:
	var r := _r()  # Numbers.
	var c: TdEnemy = s["c"]
	var ts: Array[Tower] = []  # Plot towers in reach.
	for t: Tower in game.towers:
		if t.spot.kind == "plot" and t.position.distance_to(c.position) <= float(r["reach"]):
			ts.append(t)
	if ts.is_empty():
		return
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(c.position) < y.position.distance_squared_to(c.position))
	var t: Tower = ts[int(s["aim"]) % ts.size()]  # Its target.
	s["aim"] = int(s["aim"]) + 1
	game.hostile.shell(t.position, float(r["radius"]), float(r["delay"]), float(r["disable"]), "shelled")
	counts["broadsides"] = int(counts["broadsides"]) + 1
	if crew:
		counts["crewed"] = int(counts["crewed"]) + 1
	Sfx.play("cannon_fire")
	if game.vfx.on:
		var lk := _lk()  # Looks.
		game.vfx.add(TdVfx.Kind.ANIM, c.position + Vector2(0, -10), float(lk["muzzle_d"]), TdVfxData.IMPACT_TIME, lk["amber"], "volley_flash")
		var f := game.vfx.add(TdVfx.Kind.THREAD, c.position + Vector2(0, -10), float(lk["trail_w"]), float(r["delay"]), lk["fuse_tint"])
		if f != null:
			f.to = t.position
		game.vfx.shake(1.5)


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	var r := _r()  # Numbers.
	if e.kind == String(r["cannon_kind"]):
		counts["sunk"] = int(counts["sunk"]) + 1
		game.banner("A deck cannon is sunk")
		return
	if e.kind != String(r["keg_kind"]):
		return
	var at := e.position  # The blast.
	var rad := float(r["keg_radius"])  # Its radius (px).
	counts["blasts"] = int(counts["blasts"]) + 1
	for s: Dictionary in slots:
		if s["k"] == e and int(s["kg"]) == e.generation:
			s["restock"] = game.time + float(r["keg_restock"])
	for o: TdEnemy in game.enemies_near(at, rad):
		if o == e or not o.alive:
			continue
		if o.kind == String(r["cannon_kind"]):
			for s: Dictionary in slots:
				if s["c"] == o and int(s["cg"]) == o.generation:
					s["spiked"] = game.time + float(r["keg_spike"])
					counts["spiked"] = int(counts["spiked"]) + 1
			TdCombat.damage_enemy(game, o, float(r["keg_cannon_damage"]), {"source": "powder_keg", "origin": at})
		elif not bool(o.row.get("structure", false)):
			TdCombat.damage_enemy(game, o, float(r["keg_damage"]), {"source": "powder_keg", "origin": at})
			if not o.alive:
				counts["keg_kills"] = int(counts["keg_kills"]) + 1
	Sfx.play("powder_blast")
	if game.vfx.on:
		var lk := _lk()  # Looks.
		game.vfx.add(TdVfx.Kind.ANIM, at, float(lk["keg_d"]), TdVfxData.IMPACT_TIME * 1.6, lk["blast_tint"], "corpse_explosion")
		var ring := game.vfx.add(TdVfx.Kind.RING, at, rad, TdVfxData.RING_TIME, lk["amber"])
		if ring != null:
			ring.size0 = rad * 0.3
		game.vfx.shake(float(lk["shake"]))


## The sea band and the rail along the bottom edge (static).
func _draw_sea(ci: CanvasItem) -> void:
	var lk := _lk()  # Looks.
	var h := float(lk["sea_h"])  # Band height (px).
	var tex := MapView.grid_texture("tiles/corsair_water", true)  # Tiled sea.
	var band := Rect2(-40.0, 720.0 - h, 1360.0, h + 40.0)  # The sea under the rail.
	SpriteBank.apply_sharp(ci)
	if tex != null:
		ci.draw_texture_rect(tex, band, true, lk["sea_tint"])
	else:
		ci.draw_rect(band, Color(0.1, 0.2, 0.38))
	ci.draw_rect(Rect2(-40.0, 720.0 - h - float(lk["rail_w"]), 1360.0, float(lk["rail_w"])), lk["rail_tint"])


## A closing fuse ring over every standing cannon (grey while spiked).
func _draw_fuses(ci: CanvasItem) -> void:
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	if ring == null:
		return
	var lk := _lk()  # Looks.
	var every := float(_r()["every"])  # Full fuse (s).
	for s: Dictionary in slots:
		if not TdEnemy.valid(s["c"], int(s["cg"])):
			continue
		var c: TdEnemy = s["c"]
		var spiked := game.time < float(s["spiked"])  # Spiked by a blast.
		var left := clampf((float(s["next"]) - game.time) / every, 0.0, 1.0)  # 1 = just fired, 0 = due.
		var d := float(lk["fuse_d"]) * (1.0 + 0.8 * left)  # Closing ring (px).
		var col: Color = lk["spiked_tint"] if spiked else lk["fuse_tint"]
		col.a = 0.45 if spiked else 0.35 + 0.65 * (1.0 - left)
		ci.draw_texture_rect(ring, Rect2(c.position + Vector2(-d * 0.5, -d * 0.35), Vector2(d, d * 0.7)), false, col)


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = []  # k:v entries.
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)
