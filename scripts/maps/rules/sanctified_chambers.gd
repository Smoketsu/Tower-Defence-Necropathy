## Sanctified chambers (GDD §7.2, the Sanctum's rule): towers whose spot lies
## inside a chamber (Act1RuleData.CHAMBERS rect) deal CHAMBER_DAMAGE_MULT
## damage until all of that chamber's ward crystals (TdEnemyData
## "ward_crystal", structures beside the road) are broken; then every tower
## recomputes at full strength. Draws the chamber floors (static, redrawn
## only when a chamber breaks). Leftover crystals are cleared at the map end.
extends MapRule

## Per chamber: {"crystals": [[TdEnemy, generation], ...], "broken": bool, "at": game s it broke (-1)}.
var chambers: Array[Dictionary] = []
## The chamber floor layer.
var _layer: UnitLayer = null


func setup() -> void:
	for row: Dictionary in Act1RuleData.CHAMBERS:
		var cs: Array = []  # Its crystals.
		for p: Vector2 in row["crystals"]:
			var c := Structures.raise(game, "ward_crystal", p)
			cs.append([c, c.generation])
		chambers.append({"crystals": cs, "broken": false, "at": -1.0})
	_layer = UnitLayer.new()
	_layer.z_index = -9  # Over the floor, under the roads' units and spots.
	_layer.draw_fn = _draw_chambers
	game.world.add_child(_layer)
	for t: Tower in game.towers:
		t.recompute()


func step(_dt: float) -> void:
	for i in chambers.size():
		var ch: Dictionary = chambers[i]
		if bool(ch["broken"]):
			continue
		var standing := false  # Some crystal still stands.
		for pair: Array in ch["crystals"]:
			standing = standing or TdEnemy.valid(pair[0], int(pair[1]))
		if standing:
			continue
		ch["broken"] = true
		ch["at"] = game.time
		game.banner("A sanctified chamber's wards are broken")
		EnemyTrait.note(game, "chambers_broken")
		for t: Tower in game.towers:
			t.recompute()
		_layer.queue_redraw()
	finish_structures()


func tower_damage_mult(t: Tower) -> float:
	for i in chambers.size():
		if not bool(chambers[i]["broken"]) and (Act1RuleData.CHAMBERS[i]["rect"] as Rect2).has_point(t.position):
			return Act1RuleData.CHAMBER_DAMAGE_MULT
	return 1.0


## Chamber floors: the halls tile over each rect, dimmed once broken.
func _draw_chambers(ci: CanvasItem) -> void:
	var tex := MapView.grid_texture(Act1RuleData.CHAMBER_TILE, true)  # Tiled floor (cached).
	SpriteBank.apply_sharp(ci)
	for i in chambers.size():
		var r: Rect2 = Act1RuleData.CHAMBERS[i]["rect"]
		var tint := Act1RuleData.CHAMBER_BROKEN_TINT if bool(chambers[i]["broken"]) else Act1RuleData.CHAMBER_TINT  # Look.
		if tex != null:
			ci.draw_texture_rect(tex, r, true, tint)
		else:
			ci.draw_rect(r, Color(tint, 0.2))


func summary() -> String:
	var parts: Array[String] = []  # When each chamber broke.
	var total := 0  # Crystals raised.
	for ch: Dictionary in chambers:
		total += (ch["crystals"] as Array).size()
		parts.append("%.0fs" % float(ch["at"]) if bool(ch["broken"]) else "never")
	return "crystals_broken=%d/%d chambers_broken_at=%s" % [int(game.stats["kills"].get("ward_crystal", 0)), total, ",".join(parts)]
