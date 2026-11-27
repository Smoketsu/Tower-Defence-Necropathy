## MapCard: one illustrated map card of the map select (menu overhaul,
## DECISIONS M6). A kit card Button holding:
##   * the vignette: a small pre-rendered picture of the real map (the bot at
##     wave 4, MenuData.THUMB_PATH; made by tools/gw_map_thumbs.sh) with the
##     map's boss standing on it (its sprite on a soft shadow) and the map's
##     place in its act on a ribbon; a locked map shows the picture dark, the
##     boss as a silhouette and a padlock;
##   * the name (gold once cleared), the best skulls per difficulty (a pixel
##     icon per difficulty, MaskIcon) or, while locked, the crimson lock line;
##   * the boss's name and the best Reckoning wave.
## Built from the map's data (MapRegistry) and Meta's records only. Purely visual.
class_name MapCard
extends Button

## Map id shown.
var map_id: String = ""


func _init(p_map: String, open: bool, lock_line: String) -> void:
	map_id = p_map
	var m := MapRegistry.get_map(p_map)  # Its data.
	var won := Meta.cleared(p_map)  # Beaten once.
	custom_minimum_size = MenuData.MAP_CARD
	disabled = not open
	UiTheme.style_button(self, "card", "gold" if won else "violet")
	var col := VBoxContainer.new()  # Picture, name, records.
	col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, MenuData.MAP_CARD_PAD)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_theme_constant_override("separation", 4)
	add_child(col)
	col.add_child(_picture(p_map, open))
	var nm := UiTheme.tier_label(String(m["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if won else (UiTheme.TEXT if open else UiTheme.TEXT_DIM))
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	col.add_child(nm)
	if not open:
		var lock := UiTheme.para(lock_line, 0.0, MenuData.CRIMSON)
		lock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(lock)
		return
	col.add_child(_skulls(p_map))
	var foot := HBoxContainer.new()  # Boss | Reckoning.
	foot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(foot)
	var boss := boss_of(m)  # Its boss kind ("" = none found).
	var bl := UiTheme.tier_label(String(Acts.kinds()[boss]["name"]) if boss != "" else "", UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
	bl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	foot.add_child(bl)
	var rk := Meta.best_reckoning(p_map)  # Best Reckoning wave.
	foot.add_child(UiTheme.tier_label("Reckoning %s" % (str(rk) if rk > 0 else "-"), UiTheme.Tier.BODY, MenuData.CRIMSON if rk > 0 else UiTheme.TEXT_DIM))


## The boss kind of map data `m`: the first boss-rank kind of its last wave ("" = none).
static func boss_of(m: Dictionary) -> String:
	var waves: Array = m.get("waves", [])
	if waves.is_empty():
		return ""
	for g: Dictionary in (waves[waves.size() - 1] as Dictionary).get("groups", []):
		var k := String(g.get("kind", ""))  # A kind of the last wave.
		if Acts.kinds().has(k) and String(Acts.kinds()[k]["rank"]) == "boss":
			return k
	return ""


## The vignette: the map's picture, its boss on a shadow, the act-place ribbon, a padlock while locked.
func _picture(p_map: String, open: bool) -> Control:
	var frame := PanelContainer.new()  # Recessed frame.
	frame.add_theme_stylebox_override("panel", UiTheme.style("slot", "grey"))
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic := Control.new()  # The picture area.
	pic.custom_minimum_size = MenuData.THUMB_SIZE
	pic.clip_contents = true
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(pic)
	var path := MenuData.THUMB_PATH % p_map  # Its pre-rendered picture.
	var shade := Color.WHITE if open else MenuData.THUMB_LOCKED  # Picture tint.
	if ResourceLoader.exists(path):
		var t := TextureRect.new()  # The map.
		t.texture = load(path) as Texture2D
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		t.modulate = shade
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(t)
	else:
		var c := ColorRect.new()  # No picture yet: the night.
		c.color = MenuData.THUMB_EMPTY
		c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(c)
	var boss := boss_of(MapRegistry.get_map(p_map))  # Its boss kind.
	if boss != "":
		var tex := SpriteBank.texture(String(Acts.kinds()[boss]["sprite"]))  # Its sprite.
		if tex != null:
			var glow := TextureRect.new()  # Soft shadow under the boss.
			glow.texture = MapView.grid_texture("menu/glow")
			glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			glow.stretch_mode = TextureRect.STRETCH_SCALE
			glow.modulate = MenuData.BOSS_SHADOW
			glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var b := TextureRect.new()  # The boss.
			b.texture = tex
			b.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			b.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			b.mouse_filter = Control.MOUSE_FILTER_IGNORE
			b.flip_h = true  # Faces left, into the map.
			var k := minf(MenuData.BOSS_MAX.y / tex.get_height(), MenuData.BOSS_MAX.x / tex.get_width())  # Fit scale.
			k = maxf(1.0, floorf(k)) if k >= 1.0 else k  # Whole steps keep the pixels square.
			var sz := (tex.get_size() * k).floor()  # Drawn size.
			var foot := Vector2(MenuData.THUMB_SIZE.x - MenuData.BOSS_RIGHT, MenuData.THUMB_SIZE.y - MenuData.BOSS_BOTTOM)  # Feet point.
			glow.position = foot - Vector2(sz.x * 0.6, sz.x * 0.15)
			glow.size = Vector2(sz.x * 1.2, sz.x * 0.3)
			b.position = foot - Vector2(sz.x * 0.5, sz.y)
			b.size = sz
			if not open:
				b.modulate = MenuData.BOSS_LOCKED
			pic.add_child(glow)
			pic.add_child(b)
	var rib := PanelContainer.new()  # Place in the act.
	rib.add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	rib.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rib.position = Vector2(4, 4)
	var pos := Acts.position_in_act(p_map)  # 0-based place in its act.
	var n := Acts.maps_of(Acts.act_of_map(p_map)).size()  # Maps in its act.
	rib.add_child(UiTheme.tier_label(MenuData.MAP_PLACE_FINALE if pos == n - 1 and n > 1 else MenuData.MAP_PLACE % (pos + 1), UiTheme.Tier.LABEL, UiTheme.TEXT_GOLD if pos == n - 1 else UiTheme.TEXT))
	pic.add_child(rib)
	if not open:
		var lock := MaskIcon.new("padlock", MenuData.LOCK_SCALE)  # Padlock in the middle.
		lock.position = ((MenuData.THUMB_SIZE - lock.custom_minimum_size) * 0.5).floor()
		pic.add_child(lock)
	return frame


## Best skulls per difficulty: its pixel icon then three small skulls, four groups in a row.
func _skulls(p_map: String) -> HBoxContainer:
	var row := HBoxContainer.new()  # The groups.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", MenuData.SKULL_GROUP_GAP)
	for d: String in DifficultyData.ORDER:
		var g := HBoxContainer.new()  # One difficulty.
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		g.add_theme_constant_override("separation", 2)
		var ic := MaskIcon.new(String(MenuData.DIFF_ICONS.get(d, "skull")), MenuData.DIFF_ICON_SCALE)  # Its icon.
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		g.add_child(ic)
		var sr := MenuScreen.skull_row(Meta.skulls(p_map, d), MenuData.SKULL_SMALL)  # Its skulls.
		sr.add_theme_constant_override("separation", 0)
		g.add_child(sr)
		row.add_child(g)
	return row
