## CreditsScreen: the credits roll and the licence texts (GDD §9.3; adapted
## from Necropathy's): two pages, Credits (CreditsData.ROLL) and Licences
## (Godot's MIT licence and its third-party notices, the fonts' OFL), in a
## scroll area that a finger can drag.
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
	var tabs := HBoxContainer.new()  # Page tabs.
	tabs.alignment = BoxContainer.ALIGNMENT_CENTER
	b.add_child(tabs)
	for p: Array in CreditsData.PAGES:
		_tabs[p[0]] = button(tabs, String(p[1]), _show.bind(String(p[0])))
	_scroll = ScrollContainer.new()
	_scroll.custom_minimum_size = CreditsData.AREA
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	b.add_child(_scroll)
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
	for k: String in _tabs:
		UiTheme.style_button(_tabs[k], "button", "gold" if k == page else "")
	for c: Node in _col.get_children():
		_col.remove_child(c)
		c.queue_free()
	_scroll.scroll_vertical = 0
	if page == "credits":
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
