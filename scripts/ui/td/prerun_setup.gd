## PreRunSetup: the pre-map setup (GDD §9.3, §5): the character (locked ones
## dark with their unlock line), the spells (the character's own spell fixed
## in slot 1, then picks up to MetaModifiers.spell_slots(); spells whose row
## is not "ready" are shown but not offered), the ultimate (CharacterData.
## ULTIMATES) and the difficulty with its Soul Ash multiplier. Remembers the
## choices in Meta's prerun section. Built from the data tables, so new
## characters / spells appear by themselves.
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
## Chosen difficulty id.
var _difficulty: String = DifficultyData.DEFAULT_ID
## Character id -> tile; spell id -> tile; "d:" + difficulty -> button (selection looks).
var _tiles: Dictionary = {}
## The innate line under the characters.
var _innate: Label = null
## The total Soul Ash multiplier line.
var _mult: Label = null


func _init() -> void:
	title_text = "Prepare"


func _build(b: VBoxContainer) -> void:
	var c := String(Meta.prerun("character", CharacterData.DEFAULT_ID))  # Remembered character.
	_character = c if CharacterData.CHARACTERS.has(c) and Meta.character_open(c) else CharacterData.DEFAULT_ID
	var d := String(Meta.prerun("difficulty", DifficultyData.DEFAULT_ID))  # Remembered difficulty.
	_difficulty = d if DifficultyData.LEVELS.has(d) else DifficultyData.DEFAULT_ID
	for id: Variant in Meta.prerun("spells", SpellData.DEFAULT_LOADOUT):
		if _offered(String(id)) and not _spells.has(String(id)):
			_spells.append(String(id))
	b.add_child(UiTheme.tier_label(String(MapRegistry.get_map(map_id)["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_DIM))
	(b.get_child(b.get_child_count() - 1) as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var chars := _row(b)  # Character tiles.
	for id: String in CharacterData.ORDER:
		chars.add_child(_char_tile(id))
	_innate = UiTheme.para("", MenuData.PANEL_WIDTH, UiTheme.TEXT)
	_innate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.add_child(_innate)
	b.add_child(section("Spells"))
	var spells := _row(b)  # Spell tiles.
	for id: String in SpellData.SPELLS:
		spells.add_child(_spell_tile(id))
	var low := _row(b)  # Ultimate and difficulty.
	for id: String in CharacterData.ULTIMATES:
		var t := _tile(SpriteBank.texture("icons/" + id), String(SpellData.ULTIMATE["name"]) if id == String(SpellData.ULTIMATE["id"]) else id, MenuData.SPELL_TILE)  # The ultimate.
		UiTheme.style_button(t, "card", "gold")
		low.add_child(t)
	var gap := Control.new()  # Space between the two groups.
	gap.custom_minimum_size = Vector2(24, 0)
	low.add_child(gap)
	for id: String in DifficultyData.ORDER:
		var row: Dictionary = DifficultyData.LEVELS[id]
		var db := Button.new()  # One difficulty.
		db.text = "%s\nx%s" % [String(row["name"]), str(float(row["ash_mult"]))]
		db.custom_minimum_size = Vector2(118, MenuData.SPELL_TILE.y)
		db.pressed.connect(_pick_difficulty.bind(id))
		low.add_child(db)
		_tiles["d:" + id] = db
	_fix_spells()
	_mark()


func _after_nav() -> void:
	_mult = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	nav.add_child(_mult)
	var go := button(nav, "Start", _go, "gold")
	UiTheme.focus_deferred(go)
	_mark()


## A centred row in `b`.
func _row(b: VBoxContainer) -> HBoxContainer:
	var r := HBoxContainer.new()  # The row.
	r.alignment = BoxContainer.ALIGNMENT_CENTER
	r.add_theme_constant_override("separation", 8)
	b.add_child(r)
	return r


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
	l.clip_text = true
	col.add_child(l)
	return t


func _char_tile(id: String) -> Button:
	var row: Dictionary = CharacterData.CHARACTERS[id]
	var open := GameState.autotest or Meta.character_open(id)  # Pickable now.
	var t := _tile(SpriteBank.texture(String(row["sprite"])), String(row["name"]) if open else "?", MenuData.CHAR_TILE, not open)
	t.pressed.connect(_pick_character.bind(id))
	t.disabled = not open
	if not open:
		t.tooltip_text = "Beat the boss of %s" % String(MapRegistry.get_map(String(row["unlock_after"]))["name"])
	_tiles[id] = t
	return t


func _spell_tile(id: String) -> Button:
	var row: Dictionary = SpellData.SPELLS[id]
	var t := _tile(SpriteBank.texture("icons/" + String(row["icon"])), String(row["name"]), MenuData.SPELL_TILE, not _offered(id))
	t.disabled = not _offered(id)
	if not _offered(id):
		t.tooltip_text = "Soon"
	t.pressed.connect(_toggle_spell.bind(id))
	_tiles["s:" + id] = t
	return t


## True when spell `id` can be brought (its script is built: row "ready").
func _offered(id: String) -> bool:
	return SpellData.SPELLS.has(id) and bool(SpellData.SPELLS[id].get("ready", true))


func _pick_difficulty(id: String) -> void:
	_difficulty = id
	_mark()


func _pick_character(id: String) -> void:
	_character = id
	_fix_spells()
	_mark()


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
		var on := k == _character or k == "d:" + _difficulty or (k.begins_with("s:") and _spells.has(k.substr(2)))  # Chosen.
		UiTheme.style_button(_tiles[k], "card" if not k.begins_with("d:") else "button", "gold" if on else "")
	var inn: Dictionary = CharacterData.CHARACTERS[_character]["innate"]
	_innate.text = "%s: %s" % [inn["name"], inn["desc"]] if not inn.is_empty() else "No innate. Brings %s." % String(SpellData.SPELLS[_own()]["name"])
	if not inn.is_empty():
		_innate.text += "  Brings %s, stronger." % String(SpellData.SPELLS[_own()]["name"])
	if _mult != null:
		_mult.text = "Soul Ash x%s   %d / %d spells" % [str(float(DifficultyData.LEVELS[_difficulty]["ash_mult"])), _spells.size(), MetaModifiers.spell_slots()]


func _go() -> void:
	Meta.set_prerun("character", _character)
	Meta.set_prerun("difficulty", _difficulty)
	Meta.set_prerun("spells", _spells.duplicate())
	Meta.set_prerun("map", map_id)
	Meta.save()
	start.emit(map_id, _difficulty, _character, _spells.duplicate())
