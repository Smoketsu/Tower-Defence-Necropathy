## MapHints: the map-space hints of the in-map interface (GDD §9.1 "range
## ring ... and a line to each tower it would form a synergy with"): for a
## selected EMPTY spot, the range ring of the tower class under the pointer /
## pad focus in the spot menu (SpotMenu.hover_id) and a soul-teal line to
## every tower a class buildable there would pair with (only the hovered
## class's when one is hovered); a gold ring on the selected spot; the
## gamepad cursor ring (SpotCursor).
## The selected tower's own ring and links stay TdGame's overlay. Textures
## only (range_ring / synergy_link masks), redrawn each frame while shown.
class_name MapHints
extends Node2D

## The HUD (game, spot menu, cursor).
var hud: TdHud = null


func _ready() -> void:
	z_index = 8


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var game := hud.game  # The run.
	var s := game.selected  # The selected spot.
	if s != null and s.tower == null and not game.over:
		SpriteBank.apply_sharp(self)
		var hover := hud.menu.hover_id  # Class under the pointer / focus.
		if hover != "" and TowerData.TOWERS.has(hover) and String(TowerData.TOWERS[hover]["spot"]) == "plot":
			var r := float(TowerData.TOWERS[hover]["range"])  # Its base range (px).
			var ring := TdArt.texture("range_ring")  # Grey ring mask.
			if ring != null:
				draw_texture_rect(ring, Rect2(s.position - Vector2(r, r), Vector2(r, r) * 2.0), false, Color(0.45, 1.0, 0.85, 0.6))
		var link := TdArt.texture("synergy_link", true)  # Grey link mask.
		if link != null:
			for id: String in TowerData.ORDER:
				if (hover != "" and id != hover) or String(TowerData.TOWERS[id]["spot"]) != s.kind:
					continue
				for t: Tower in _partners(game, id, s.position):
					var d := t.position - s.position  # Link vector.
					draw_set_transform(s.position, d.angle(), Vector2.ONE)
					draw_texture_rect(link, Rect2(Vector2(0, -4), Vector2(d.length(), 8)), true, Color(0.35, 0.95, 0.8, 0.9))
					draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if s != null and not game.over:
		var sel := TdArt.texture("range_ring")  # The selected spot's gold ring (gold = selection).
		if sel != null:
			var q := TdRulesData.SPOT_PICK  # Ring radius (px).
			draw_texture_rect(sel, Rect2(s.position - Vector2(q, q), Vector2(q, q) * 2.0), false, Color(1.0, 0.84, 0.4, 0.7))
	if hud.cursor.active and not game.over:
		var ring2 := TdArt.texture("range_ring")
		if ring2 != null:
			var c := TdRulesData.SPOT_PICK  # Ring radius (px).
			draw_texture_rect(ring2, Rect2(hud.cursor.pos - Vector2(c, c), Vector2(c, c) * 2.0), false, TdUiData.CURSOR)


## Towers class `id` built at `p` would pair with (SynergyData radius).
func _partners(game: TdGame, id: String, p: Vector2) -> Array[Tower]:
	var out: Array[Tower] = []  # Matching towers.
	for sid: String in SynergyData.SYNERGIES:
		var syn: Dictionary = SynergyData.SYNERGIES[sid]
		var other := String(syn["b"]) if String(syn["a"]) == id else (String(syn["a"]) if String(syn["b"]) == id else "")  # Partner class.
		if other == "":
			continue
		for t: Tower in game.towers:
			if t.tower_id == other and t.position.distance_to(p) <= float(syn["radius"]) and not out.has(t):
				out.append(t)
	return out
