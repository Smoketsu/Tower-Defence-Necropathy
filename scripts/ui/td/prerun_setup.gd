## PreRunSetup: the pre-map setup (GDD §9.3, §5): the character (locked ones
## dark with their unlock line), the spells (the character's own spell fixed
## in slot 1, then picks up to MetaModifiers.spell_slots(); spells whose row
## is not "ready" are shown but not offered), the ultimate (CharacterData.
## ULTIMATES) and the difficulty with its Soul Ash multiplier. Remembers the
## choices in Meta's prerun section. Built from the data tables, so new
## characters / spells appear by themselves. The characters and the spells
## each sit in one horizontally scrolling strip of fixed-size tiles
## (DECISIONS Z8): a finger drags it (TouchSupport.pass_drags: a drag never
## selects, a tap does), the wheel and the arrow buttons scroll it, and pad /
## key focus scrolls the focused tile into view (follow_focus).
## Menu overhaul (DECISIONS M9): the chosen character is the hero on the left
## (big portrait, name, innate, the spell it brings, the map); the strips,
## the ultimate and the difficulty (each with its pixel icon) on the right;
## the totals beside Start.
class_name PreRunSetup
extends MenuScreen

## Emitted on Start with the run's choices.
signal start(map_id: String, difficulty: String, character: String, loadout: Array[String])

## Map the run will play.
var map_id: String = MapRegistry.DEFAULT_ID
## Chosen character id.
var _character: String = CharacterData.DEFAULT_ID
## Chosen spells in slot order (slot 1 = the character's spell).
var _spells: Array[String] = []
## Chosen ultimate id (SpellCaster.ultimate_id; gw2-kit).
var _ultimate: String = "dread_rally"
## Chosen difficulty id.
var _difficulty: String = DifficultyData.DEFAULT_ID
## Character id -> tile; spell id -> tile; "d:" + difficulty -> button (selection looks).
var _tiles: Dictionary = {}
## The hero column: the chosen character's portrait, name, innate line and its spell (icon, name).
var _hero_pic: TextureRect = null
## See _hero_pic.
var _hero_name: Label = null
## See _hero_pic.
var _innate: Label = null
## See _hero_pic.
var _own_icon: TextureRect = null
## See _hero_pic.
var _own_name: Label = null
## The hero column's ultimate line (the chosen ultimate and what it does).
var _ult_line: Label = null
## The spells section label (shows the slots used).
var _spell_label: Label = null
## The total Soul Ash multiplier line.
var _mult: Label = null
## The character strip and the spell strip (opened on the selection).
var _char_strip: ScrollContainer = null
## See _char_strip.
var _spell_strip: ScrollContainer = null


func _init() -> void:
	title_text = "Prepare"
	show_ash = true


func _build(b: VBoxContainer) -> void:
	var c := String(Meta.prerun("character", CharacterData.DEFAULT_ID))  # Remembered character.
	_character = c if CharacterData.CHARACTERS.has(c) and (Meta.character_open(c) or GameState.unlock_all) else CharacterData.DEFAULT_ID
	var d := String(Meta.prerun("difficulty", DifficultyData.DEFAULT_ID))  # Remembered difficulty.
	_difficulty = d if DifficultyData.LEVELS.has(d) else DifficultyData.DEFAULT_ID
	for id: Variant in Meta.prerun("spells", SpellData.DEFAULT_LOADOUT):
		if _offered(String(id)) and not _spells.has(String(id)):
			_spells.append(String(id))
	var u := String(Meta.prerun("ultimate", "dread_rally"))  # Remembered ultimate.
	_ultimate = u if CharacterData.ULTIMATES.has(u) and _ult_open(u) else "dread_rally"
	var cols := HBoxContainer.new()  # Hero | choices.
	cols.add_theme_constant_override("separation", MenuData.PRERUN_GAP)
	b.add_child(cols)
	cols.add_child(_hero())
	var right := VBoxContainer.new()  # Strips, ultimate and difficulty.
	right.add_theme_constant_override("separation", 6)
	cols.add_child(right)
	right.add_child(section("Characters"))
	_char_strip = _strip(right, MenuData.CHAR_TILE)  # Character tiles.
	for id: String in CharacterData.ORDER:
		_char_strip.get_child(0).add_child(_char_tile(id))
	_spell_label = section("Spells")
	right.add_child(_spell_label)
	_spell_strip = _strip(right, MenuData.SPELL_TILE)  # Spell tiles.
	for id: String in SpellData.SPELLS:
		_spell_strip.get_child(0).add_child(_spell_tile(id))
	TouchSupport.pass_drags(_char_strip)
	TouchSupport.pass_drags(_spell_strip)
	var heads := HBoxContainer.new()  # The two group labels over the last row.
	heads.add_theme_constant_override("separation", MenuData.PRERUN_GAP)
	right.add_child(heads)
	var low := _row(right)  # Ultimate and difficulty.
	low.add_theme_constant_override("separation", 6)
	for id: String in CharacterData.ULTIMATES:
		var ur := SpellCaster.ult_row(id)  # Its row.
		var open := _ult_open(id)  # Pickable now.
		var t := _tile(SpriteBank.texture("icons/" + String(ur["icon"])), String(ur.get("short", ur["name"])) if open else "?", MenuData.ULT_TILE, not open)  # The ultimate.
		t.disabled = not open
		t.tooltip_text = String(ur.get("desc", "Revives every blocker; towers +40% for 8 s")) if open else Unlocks.line(ur.get("unlock", {}))
		t.pressed.connect(func() -> void:
			_ultimate = id
			_mark())
		low.add_child(t)
		_tiles["u:" + id] = t
	var gap := Control.new()  # Space between the two groups.
	gap.custom_minimum_size = Vector2(MenuData.PRERUN_GAP, 0)
	low.add_child(gap)
	for id: String in DifficultyData.ORDER:
		var row: Dictionary = DifficultyData.LEVELS[id]
		var db := _tile(null, "", MenuData.ULT_TILE)  # One difficulty.
		var ic := MaskIcon.new(String(MenuData.DIFF_ICONS.get(id, "skull")), MenuData.PRERUN_DIFF_SCALE)  # Its pixel icon, in the icon's place.
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
		var col := db.get_child(0) as VBoxContainer  # Icon over name.
		col.get_child(0).free()  # The empty icon slot.
		col.add_child(ic)
		col.move_child(ic, 0)
		var lab := col.get_child(1) as Label  # Name over its Soul Ash multiplier.
		lab.text = "%s\nx%s" % [String(row["name"]), str(float(row["ash_mult"]))]
		lab.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		db.pressed.connect(_pick_difficulty.bind(id))
		low.add_child(db)
		_tiles["d:" + id] = db
	var ul := section("Ultimate")  # Group labels, each over its half of the row.
	ul.custom_minimum_size.x = MenuData.ULT_TILE.x * 4.0 + 18.0
	heads.add_child(ul)
	var dl := section("Difficulty")
	dl.custom_minimum_size.x = MenuData.ULT_TILE.x * 4.0 + 18.0
	heads.add_child(dl)
	heads.alignment = BoxContainer.ALIGNMENT_CENTER
	_fix_spells()
	_mark()
	_open_on_selection.call_deferred()


## The hero column: the map, the chosen character's portrait and name, its innate and its spell.
func _hero() -> PanelContainer:
	var p := PanelContainer.new()  # Framed column.
	p.add_theme_stylebox_override("panel", UiTheme.style("card", "gold"))
	p.custom_minimum_size = Vector2(MenuData.HERO_W, 0)
	var col := VBoxContainer.new()  # Its rows.
	col.add_theme_constant_override("separation", 4)
	p.add_child(col)
	var map := UiTheme.tier_label(String(MapRegistry.get_map(map_id)["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_DIM)  # The map.
	map.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(map)
	var slot := PanelContainer.new()  # Recessed portrait frame.
	slot.add_theme_stylebox_override("panel", UiTheme.style("slot", "grey"))
	col.add_child(slot)
	_hero_pic = MenuScreen.icon_rect(null, MenuData.HERO_PORTRAIT)
	_hero_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	slot.add_child(_hero_pic)
	_hero_name = UiTheme.tier_label("", UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	_hero_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_hero_name)
	col.add_child(UiTheme.divider("gold"))
	_innate = UiTheme.para("", MenuData.HERO_W - 30.0, UiTheme.TEXT)
	_innate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_innate)
	var own := HBoxContainer.new()  # Its spell.
	own.alignment = BoxContainer.ALIGNMENT_CENTER
	own.add_theme_constant_override("separation", 6)
	col.add_child(own)
	_own_icon = MenuScreen.icon_rect(null, MenuData.HERO_SPELL_ICON)
	own.add_child(_own_icon)
	_own_name = UiTheme.tier_label("", UiTheme.Tier.BODY, MenuData.TEAL)
	_own_name.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	own.add_child(_own_name)
	col.add_child(UiTheme.divider("gold"))
	_ult_line = UiTheme.para("", MenuData.HERO_W - 30.0, UiTheme.TEXT_DIM)
	_ult_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_ult_line)
	return p


func _after_nav() -> void:
	_mult = UiTheme.tier_label("", UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	nav.add_child(_mult)
	var go := button(nav, "Start", _go, "gold")
	go.custom_minimum_size = MenuData.START_BUTTON
	go.add_theme_color_override("font_color", UiTheme.TEXT_GOLD)
	UiTheme.focus_deferred(go)
	_mark()


## A centred row in `b`.
func _row(b: VBoxContainer) -> HBoxContainer:
	var r := HBoxContainer.new()  # The row.
	r.alignment = BoxContainer.ALIGNMENT_CENTER
	r.add_theme_constant_override("separation", 8)
	b.add_child(r)
	return r


## A scrolling strip in `b` for tiles of `tile` px: [<] window [>]. Returns
## the ScrollContainer; its child 0 is the HBoxContainer the tiles go in.
func _strip(b: VBoxContainer, tile: Vector2) -> ScrollContainer:
	var r := _row(b)  # Arrows around the window.
	var sc := ScrollContainer.new()  # The window.
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS  # The bar shows it scrolls.
	sc.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.follow_focus = true
	sc.custom_minimum_size = Vector2(MenuData.STRIP_WIDTH, tile.y + MenuData.STRIP_BAR)
	sc.get_h_scroll_bar().custom_minimum_size.y = MenuData.STRIP_BAR - 4.0  # The kit's scroll style is cut for vertical bars (no top / bottom margin).
	var tiles := HBoxContainer.new()  # The tiles.
	tiles.add_theme_constant_override("separation", MenuData.STRIP_GAP)
	sc.add_child(tiles)
	r.add_child(_arrow(sc, -1))
	r.add_child(sc)
	r.add_child(_arrow(sc, 1))
	return sc


## A scroll arrow for strip `sc` (`dir` -1 left, 1 right): pages the window,
## disabled at that end (follows the scroll bar's value, no per-frame work).
func _arrow(sc: ScrollContainer, dir: int) -> Button:
	var a := Button.new()  # The arrow.
	a.text = "<" if dir < 0 else ">"
	a.focus_mode = Control.FOCUS_NONE  # Pad / keys move between tiles instead.
	a.custom_minimum_size = Vector2(MenuData.STRIP_ARROW_W, 0.0)
	a.pressed.connect(func() -> void:
		sc.scroll_horizontal += int(dir * sc.size.x * MenuData.STRIP_PAGE))
	var bar := sc.get_h_scroll_bar()  # Its value says where the window is.
	var upd := func(_v: float = 0.0) -> void:
		a.disabled = bar.value <= 0.5 if dir < 0 else bar.value >= bar.max_value - bar.page - 0.5
	bar.value_changed.connect(upd)
	bar.changed.connect(upd)
	return a


## Scrolls each strip so its selection is in the middle of the window (after layout).
func _open_on_selection() -> void:
	await get_tree().process_frame
	_centre(_char_strip, _tiles[_character] as Control)
	_centre(_spell_strip, _tiles["s:" + (_spells[_spells.size() - 1] if not _spells.is_empty() else _own())] as Control)


## Centres tile `t` in strip `sc`.
func _centre(sc: ScrollContainer, t: Control) -> void:
	sc.scroll_horizontal = int(t.position.x + t.size.x * 0.5 - sc.size.x * 0.5)


## True when ultimate `id` can be brought (Dread Rally always; Unlocks).
func _ult_open(id: String) -> bool:
	return id == String(SpellData.ULTIMATE["id"]) or Unlocks.ultimate_open(id)


## A tile button: icon `tex` over `text`, `px` in size.
func _tile(tex: Texture2D, text: String, px: Vector2, dark: bool = false) -> Button:
	var t := Button.new()  # The tile.
	t.custom_minimum_size = px
	var col := VBoxContainer.new()  # Icon over name.
	col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 6)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	t.add_child(col)
	var ic := MenuScreen.icon_rect(tex, px.y - 40.0, dark)  # Icon / portrait.
	ic.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(ic)
	var l := UiTheme.tier_label(text, UiTheme.Tier.BODY)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	col.add_child(l)
	return t


func _char_tile(id: String) -> Button:
	var row: Dictionary = CharacterData.CHARACTERS[id]
	var open := GameState.autotest or GameState.unlock_all or Meta.character_open(id)  # Pickable now.
	var t := _tile(SpriteBank.texture(String(row["sprite"])), String(row.get("short", row["name"])) if open else "?", MenuData.CHAR_TILE, not open)
	t.pressed.connect(_pick_character.bind(id))
	t.disabled = not open
	if not open:
		t.tooltip_text = "Beat the boss of %s" % String(MapRegistry.get_map(String(row["unlock_after"]))["name"])
	_tiles[id] = t
	return t


func _spell_tile(id: String) -> Button:
	var row: Dictionary = SpellData.SPELLS[id]
	var t := _tile(SpriteBank.texture("icons/" + String(row["icon"])), String(row["name"]) if _offered(id) else "?", MenuData.SPELL_TILE, not _offered(id))
	t.disabled = not _offered(id)
	t.tooltip_text = String(row.get("desc", ""))
	if not _offered(id):
		t.tooltip_text = "Soon" if not bool(row.get("ready", true)) else Unlocks.line(row.get("unlock", {}))
	t.pressed.connect(_toggle_spell.bind(id))
	_tiles["s:" + id] = t
	return t


## True when spell `id` can be brought (its script is built: row "ready"; and open, Unlocks).
func _offered(id: String) -> bool:
	return SpellData.SPELLS.has(id) and bool(SpellData.SPELLS[id].get("ready", true)) and Unlocks.spell_open(id)


func _pick_difficulty(id: String) -> void:
	_difficulty = id
	_mark()


func _pick_character(id: String) -> void:
	_character = id
	_fix_spells()
	_mark()
	_centre(_spell_strip, _tiles["s:" + _own()] as Control)  # Its own spell comes along: show it.


## Taps a spell: adds it (replacing the last pick when full) or removes it.
func _toggle_spell(id: String) -> void:
	if id == _own():
		return
	if _spells.has(id):
		_spells.erase(id)
	else:
		if _spells.size() >= MetaModifiers.spell_slots():
			_spells.pop_back()
		_spells.append(id)
	_fix_spells()
	_mark()


## The character's own spell.
func _own() -> String:
	return String(CharacterData.CHARACTERS[_character]["spell"])


## Puts the character's spell first and trims to the slot count.
func _fix_spells() -> void:
	_spells.erase(_own())
	_spells.push_front(_own())
	while _spells.size() > MetaModifiers.spell_slots():
		_spells.pop_back()


## Gold frame on every chosen tile (gold = selection, GDD §9).
func _mark() -> void:
	if _innate == null:
		return
	for k: String in _tiles:
		var on := k == _character or k == "d:" + _difficulty or k == "u:" + _ultimate or (k.begins_with("s:") and _spells.has(k.substr(2)))  # Chosen.
		UiTheme.style_button(_tiles[k], "card" if not k.begins_with("d:") else "button", "gold" if on else "")
	var crow: Dictionary = CharacterData.CHARACTERS[_character]
	var inn: Dictionary = crow["innate"]
	_hero_pic.texture = SpriteBank.texture(String(crow["sprite"]))
	_hero_name.text = String(crow["name"])
	_innate.text = "%s: %s" % [inn["name"], inn["desc"]] if not inn.is_empty() else "No innate."
	var sp: Dictionary = SpellData.SPELLS[_own()]
	_own_icon.texture = SpriteBank.texture("icons/" + String(sp["icon"]))
	_own_name.text = "Brings %s%s" % [String(sp["name"]), ", stronger" if not inn.is_empty() else ""]
	var ur := SpellCaster.ult_row(_ultimate)  # The chosen ultimate's row.
	_ult_line.text = "%s: %s" % [String(ur["name"]), String(ur.get("desc", "Revives every blocker; towers +40% for 8 s"))]
	_spell_label.text = "SPELLS  %d / %d" % [_spells.size(), MetaModifiers.spell_slots()]
	if _mult != null:
		_mult.text = "Soul Ash x%s" % str(float(DifficultyData.LEVELS[_difficulty]["ash_mult"]))


func _go() -> void:
	Meta.set_prerun("character", _character)
	Meta.set_prerun("difficulty", _difficulty)
	Meta.set_prerun("spells", _spells.duplicate())
	Meta.set_prerun("map", map_id)
	Meta.set_prerun("ultimate", _ultimate)
	SpellCaster.ultimate_id = _ultimate  # The run's ultimate (kept by Restart and Next).
	Meta.save()
	start.emit(map_id, _difficulty, _character, _spells.duplicate())
