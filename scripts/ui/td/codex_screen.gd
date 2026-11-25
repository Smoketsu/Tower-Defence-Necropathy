## CodexScreen: the collection (GDD §8.3): tabs for towers, spells, foes,
## bosses and evolutions, a grid of entry tiles (dark silhouettes until a run
## has met them, Meta.seen()) and a detail column for the tapped entry.
## Evolutions are listed only once obtained, with their recipe then (never
## hinted before). Foes and bosses have an act filter (All + one numeral per
## act that adds kinds, Acts.act_of_kind()). Built from TowerData / SpellData /
## Acts.kinds() / EvolutionData / ActData, so new rows and acts appear by
## themselves. Only reads Meta.
class_name CodexScreen
extends MenuScreen

## Current tab (Meta.CODEX category).
var _tab: String = "towers"
## Tab id -> its button.
var _tabs: Dictionary = {}
## Act filter of the foe / boss tabs ("" = every act).
var _act: String = ""
## The act filter row (shown on the foe / boss tabs) and its buttons, act id ("" = All) -> button.
var _act_row: HBoxContainer = null
## See _act_row.
var _act_tabs: Dictionary = {}
## The entry grid.
var _grid: GridContainer = null
## Detail column: name, picture, lines.
var _d_name: Label = null
## See _d_name.
var _d_pic: TextureRect = null
## See _d_name.
var _d_text: Label = null


func _init() -> void:
	title_text = "Codex"


func _build(b: VBoxContainer) -> void:
	var tabs := HBoxContainer.new()  # Category tabs.
	tabs.alignment = BoxContainer.ALIGNMENT_CENTER
	b.add_child(tabs)
	for c: String in Meta.CODEX:
		var t := button(tabs, String(MenuData.CODEX_TABS.get(c, c.capitalize())), _show.bind(c))
		_tabs[c] = t
	_act_row = HBoxContainer.new()
	_act_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_act_row.add_theme_constant_override("separation", MenuData.ACT_TAB_GAP)
	b.add_child(_act_row)
	var with_kinds := {}  # Act ids that define some kind.
	for id: String in Acts.kinds():
		with_kinds[Acts.act_of_kind(id)] = true
	for act: String in [""] + Acts.visible_acts().map(func(r: Dictionary) -> String: return String(r["id"])):
		if act != "" and not with_kinds.has(act):
			continue
		var ab := Button.new()  # The filter button.
		ab.text = MenuData.CODEX_ALL_ACTS if act == "" else Acts.numeral(act)
		ab.custom_minimum_size = MenuData.CODEX_ACT_TAB
		if act != "":
			ab.tooltip_text = "Act %s: %s" % [Acts.numeral(act), String(Acts.row(act)["name"])]
		ab.pressed.connect(func() -> void:
			_act = act
			_show(_tab))
		_act_row.add_child(ab)
		_act_tabs[act] = ab
	var row := HBoxContainer.new()  # Grid | detail.
	row.add_theme_constant_override("separation", 12)
	b.add_child(row)
	var scroll := ScrollContainer.new()  # The grid scrolls when a category grows.
	scroll.custom_minimum_size = Vector2((MenuData.CODEX_TILE.x + 6.0) * MenuData.CODEX_COLUMNS, MenuData.CODEX_TILE.y * 4.0 + 18.0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	row.add_child(scroll)
	_grid = GridContainer.new()
	_grid.columns = MenuData.CODEX_COLUMNS
	scroll.add_child(_grid)
	var det := PanelContainer.new()  # The detail column.
	det.add_theme_stylebox_override("panel", UiTheme.style("panel", "violet"))
	det.custom_minimum_size = Vector2(MenuData.CODEX_DETAIL_W, 0)
	row.add_child(det)
	var col := VBoxContainer.new()
	det.add_child(col)
	_d_name = UiTheme.tier_label("", UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	col.add_child(_d_name)
	_d_pic = MenuScreen.icon_rect(null, 96.0)
	col.add_child(_d_pic)
	_d_text = UiTheme.para("", MenuData.CODEX_DETAIL_W - 24.0)
	col.add_child(_d_text)
	_show("towers")
	TouchSupport.pass_drags(scroll)


## The entries of category `c`: [[id, name, texture, lines], ...] in table order.
func _entries(c: String) -> Array:
	var out: Array = []  # Entries.
	match c:
		"towers":
			for id: String in TowerData.ORDER:
				var r: Dictionary = TowerData.TOWERS[id]
				out.append([id, String(r["name"]), SpriteBank.texture("icons/" + String(r["icon"])),
					"%s. Cost %d. %s." % ["Road post" if String(r["spot"]) == "post" else "Grave plot", int(r["cost"]), String(r.get("desc", String(r["behavior"]).capitalize()))],
					r.get("unlock", {})])
		"spells":
			for id: String in SpellData.SPELLS:
				var r: Dictionary = SpellData.SPELLS[id]
				out.append([id, String(r["name"]), SpriteBank.texture("icons/" + String(r["icon"])),
					("%s. " % String(r["desc"]) if r.has("desc") else "") + "Cooldown %s s." % str(float(r["cooldown"])), r.get("unlock", {})])
		"enemies", "bosses":
			for id: String in Acts.kinds():
				var r: Dictionary = Acts.kinds()[id]
				if (String(r["rank"]) == "boss") != (c == "bosses") or (_act != "" and Acts.act_of_kind(id) != _act):
					continue
				if not Acts.shown(Acts.row(Acts.act_of_kind(id))):
					continue  # A hidden act's kinds (the test act) only with --test-act.
				out.append([id, String(r["name"]), SpriteBank.texture(String(r["sprite"])),
					"%s. HP %d, speed %d%s." % [String(r["rank"]).capitalize(), int(r["hp"]), int(r["speed"]), ", armour %d" % int(r["armour"]) if int(r.get("armour", 0)) > 0 else ""]])
		"evolutions":
			for id: String in EvolutionData.EVOLUTIONS:
				if not Meta.seen("evolutions", id):
					continue  # Never hinted before it is found (GDD §2).
				var r: Dictionary = EvolutionData.EVOLUTIONS[id]
				out.append([id, String(r["name"]), SpriteBank.texture("icons/" + String(r["icon"])), _recipe(r)])
	return out


## The recipe line of evolution row `r` (shown once found).
func _recipe(r: Dictionary) -> String:
	var from := String(TowerData.TOWERS[String(r["from"])]["name"]) if TowerData.TOWERS.has(String(r["from"])) else String(r["from"])  # Base class.
	var rec: Dictionary = r["recipe"]
	var cls := String(TowerData.TOWERS[String(rec["class"])]["name"]) if rec.has("class") and TowerData.TOWERS.has(String(rec["class"])) else String(rec.get("class", ""))  # Partner class.
	if String(rec["type"]) == "any":
		rec = rec["of"][rec["of"].size() - 1]  # The placement part names the pair (gw2-kit, Profane Bishop).
		cls = String(TowerData.TOWERS[String(rec["class"])]["name"]) if rec.has("class") and TowerData.TOWERS.has(String(rec["class"])) else ""
	match String(rec["type"]):
		"kills": return "%s at Lv 5 with %d kills." % [from, int(rec["n"])]
		"elite_kills": return "%s at Lv 5 with %d elite kills." % [from, int(rec["n"])]
		"near": return "%s at Lv 5 near a %s." % [from, cls]
		"near_level": return "%s at Lv 5 near a Lv %d %s." % [from, int(rec["level"]), cls]
	return "%s at Lv 5." % from


func _show(c: String) -> void:
	_tab = c
	for k: String in _tabs:
		UiTheme.style_button(_tabs[k], "button", "gold" if k == c else "")
	_act_row.visible = c == "enemies" or c == "bosses"
	for k: String in _act_tabs:
		UiTheme.style_button(_act_tabs[k], "button", "gold" if k == _act else "")
	for n: Node in _grid.get_children():
		_grid.remove_child(n)
		n.queue_free()
	var cat := c  # Codex category the entries are recorded under.
	var first: Button = null  # First tile (detail on open).
	for e: Array in _entries(c):
		var met := Meta.seen(cat, String(e[0]))  # Met in some run.
		var t := Button.new()  # The tile.
		t.custom_minimum_size = MenuData.CODEX_TILE
		var ic := MenuScreen.icon_rect(e[2], MenuData.CODEX_TILE.x - 16.0, not met)  # Icon or silhouette.
		ic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 8)
		t.add_child(ic)
		t.pressed.connect(_detail.bind(e, met))
		_grid.add_child(t)
		if first == null:
			first = t
			_detail(e, met)
	if first == null:
		_d_name.text = ""
		_d_pic.texture = null
		_d_text.text = "Nothing found yet." if c == "evolutions" else ""
	TouchSupport.pass_drags(_grid.get_parent() as ScrollContainer)


## Shows entry `e` in the detail column (a "?" while not met).
func _detail(e: Array, met: bool) -> void:
	_d_name.text = String(e[1]) if met else "?"
	_d_pic.texture = e[2]
	_d_pic.modulate = Color.WHITE if met else MenuData.SILHOUETTE
	var lock := Unlocks.line(e[4]) if e.size() > 4 and not Unlocks.met(e[4]) else ""  # Its unlock line while locked (gw2-kit).
	_d_text.text = String(e[3]) if met else ("Locked. %s." % lock if lock != "" else "Not met yet.")
