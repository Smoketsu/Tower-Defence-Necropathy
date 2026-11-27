## CreditsScreen: the credits roll and the licence texts (GDD §9.3; adapted
## from Necropathy's): two pages, Credits (CreditsData.ROLL) and Licences
## (Godot's MIT licence and its third-party notices, the fonts' OFL), in a
## scroll area that a finger can drag. Menu overhaul (DECISIONS M14): kit
## tabs, the logo at the top of the roll, the scroll in a framed card.
class_name CreditsScreen
extends MenuScreen

## Page id -> its tab button.
var _tabs: Dictionary = {}
## The scroll area and its column.
var _scroll: ScrollContainer = null
## See _scroll.
var _col: VBoxContainer = null


func _init() -> void:
	title_text = "Credits"


func _build(b: VBoxContainer) -> void:
	_tabs = tab_row(b, CreditsData.PAGES, _show)
	var card := PanelContainer.new()  # The scroll's frame.
	card.add_theme_stylebox_override("panel", UiTheme.style("card", "violet"))
	b.add_child(card)
	var pad := MarginContainer.new()  # Room inside the frame.
	for side: String in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, MenuData.CARD_PAD)
	card.add_child(pad)
	_scroll = ScrollContainer.new()
	_scroll.custom_minimum_size = CreditsData.AREA
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	pad.add_child(_scroll)
	_col = VBoxContainer.new()
	_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_col)
	_show("credits")


## A paragraph of `text` in the column.
func _para(text: String, color: Color = UiTheme.TEXT_DIM) -> void:
	var l := UiTheme.para(text, CreditsData.AREA.x - 30.0, color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_col.add_child(l)


func _show(page: String) -> void:
	mark_tabs(_tabs, page)
	for c: Node in _col.get_children():
		_col.remove_child(c)
		c.queue_free()
	_scroll.scroll_vertical = 0
	if page == "credits":
		var logo := MenuScreen.icon_rect(TdArt.texture("logo"), 0.0)  # The logo heads the roll.
		logo.custom_minimum_size = MenuData.CREDITS_LOGO
		logo.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		_col.add_child(logo)
		for row: Array in CreditsData.ROLL:
			match String(row[0]):
				"label": _col.add_child(section(String(row[1])))
				"header":
					var h := UiTheme.tier_label(String(row[1]), UiTheme.Tier.HEADER, UiTheme.TEXT_GOLD)
					h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
					_col.add_child(h)
				"name": _para(String(row[1]), UiTheme.TEXT)
				"body": _para(String(row[1]))
				"divider": _col.add_child(UiTheme.divider())
		return
	_col.add_child(section("Godot Engine"))
	_para(Engine.get_license_text())
	_col.add_child(section("Fonts: SIL Open Font License 1.1"))
	for f: Array in CreditsData.FONT_LICENCES:
		_para(String(f[0]), UiTheme.TEXT)
		if FileAccess.file_exists(String(f[1])):
			_para(FileAccess.get_file_as_string(String(f[1])))
	_col.add_child(section("Godot's third-party components"))
	for info: Dictionary in Engine.get_copyright_info():
		var lines: Array[String] = []  # Its copyright lines.
		for part: Dictionary in info["parts"]:
			for c: String in part["copyright"]:
				lines.append(c)
		_para("%s: %s" % [info["name"], "; ".join(lines)])
