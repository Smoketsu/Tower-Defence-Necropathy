## MenuScreen: the shared frame of every Gravewatch menu screen (GDD §9.3;
## menu overhaul, DECISIONS M4). Full screen, three bands:
##   * a header row: Back top-left (with its ui_cancel key chip), the screen
##     title in Jacquard on the kit's header band in the middle, and an
##     optional Soul Ash pill top-right (`show_ash`);
##   * the content: a centred ornate panel holding `box` (the column a
##     subclass fills in _build()) and, at its bottom, `nav` (Start / Refund...);
##     the panel shrinks to fit the space left (phones) instead of overflowing;
##   * a bottom hint strip of key / pad chips (`hints`, from the current
##     bindings and the last device; hidden on touch).
## Behind it the living graveyard (MenuBackdrop, copied from Necropathy) or,
## over a run (`overlay`), a dim backdrop. Esc / pad B (ui_cancel) is Back;
## the opening motion is UiMotion's (instant under the autotest and Reduce
## motion). Purely visual; subclasses override _build(box) / _after_nav().
class_name MenuScreen
extends Control

## Emitted on Back (the button or ui_cancel).
signal back

## Screen title ("" = none).
var title_text: String = ""
## Kit accent of the panel and header ("violet", "gold", "crimson").
var accent: String = "violet"
## True: drawn over a run (dim backdrop) instead of the living graveyard.
var overlay: bool = false
## True: a Back button in the header.
var has_back: bool = true
## True: the Soul Ash held shows top-right in the header.
var show_ash: bool = false
## Bottom hint strip: [[action or [actions], word], ...] (InputHints.strip()).
var hints: Array = MenuData.DEFAULT_HINTS
## The content column (built before _build()).
var box: VBoxContainer = null
## The row under the content (subclasses add Start / Refund... to it; hidden while empty).
var nav: HBoxContainer = null
## The Back button (null when has_back is false).
var back_button: Button = null
## The title Label in the header band (null without a title).
var title_label: Label = null
## The Soul Ash count in the header (null unless show_ash).
var ash_label: Label = null
## The ornate content panel (scaled down to fit its area).
var panel: PanelContainer = null
## The area the panel is centred in.
var _area: Control = null


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiTheme.backdrop(0.82) if overlay else MenuBackdrop.new())
	var frame := MarginContainer.new()  # Screen margins (moved as a whole by UiMotion.open()).
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side: String in ["left", "right", "top", "bottom"]:
		frame.add_theme_constant_override("margin_" + side, int(MenuData.SCREEN_MARGIN))
	add_child(frame)
	var col := VBoxContainer.new()  # Header, content, hints.
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_theme_constant_override("separation", MenuData.ROW_GAP)
	frame.add_child(col)
	col.add_child(_header())
	_area = Control.new()
	_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_area.clip_contents = false
	col.add_child(_area)
	panel = UiTheme.ornate_panel(accent)
	_area.add_child(panel)
	var inner := VBoxContainer.new()  # Content, then nav.
	inner.add_theme_constant_override("separation", MenuData.ROW_GAP)
	panel.add_child(inner)
	box = VBoxContainer.new()
	box.add_theme_constant_override("separation", MenuData.ROW_GAP)
	inner.add_child(box)
	_build(box)
	nav = HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 16)
	inner.add_child(nav)
	_after_nav()
	nav.visible = nav.get_child_count() > 0
	if not hints.is_empty():
		col.add_child(InputHints.strip(hints))
	_area.resized.connect(_fit_panel)
	panel.minimum_size_changed.connect(_fit_panel.call_deferred)
	UiMotion.open(self)


## The header row: Back | title band | Soul Ash pill (equal side columns keep the title centred).
func _header() -> HBoxContainer:
	var row := HBoxContainer.new()  # The header.
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 12)
	var left := Control.new()  # Back's column.
	left.custom_minimum_size = MenuData.BACK_BUTTON
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left)
	if has_back:
		back_button = Button.new()
		back_button.text = "Back"
		back_button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		back_button.pressed.connect(_on_back)
		InputHints.attach(back_button, "ui_cancel", false, 10.0)
		left.add_child(back_button)
	var mid := CenterContainer.new()  # Title band, centred.
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(mid)
	if title_text != "":
		var band := PanelContainer.new()  # The kit header band.
		band.add_theme_stylebox_override("panel", UiTheme.style("header", accent))
		band.mouse_filter = Control.MOUSE_FILTER_IGNORE
		band.custom_minimum_size.x = MenuData.TITLE_BAND_W
		title_label = UiTheme.title(title_text, UiTheme.HEADER_TEXT.get(accent, UiTheme.TEXT_GOLD) if accent != "violet" else UiTheme.TEXT_GOLD)
		title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		band.add_child(title_label)
		mid.add_child(band)
	var right := HBoxContainer.new()  # Soul Ash pill column.
	right.custom_minimum_size = MenuData.BACK_BUTTON
	right.alignment = BoxContainer.ALIGNMENT_END
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(right)
	if show_ash:
		right.add_child(ash_pill())
	return row


## A Soul Ash pill (icon + amount held) in a dim kit panel; sets ash_label.
func ash_pill() -> PanelContainer:
	var p := PanelContainer.new()  # The pill.
	p.add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var r := HBoxContainer.new()  # Icon and number.
	r.add_theme_constant_override("separation", 6)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(r)
	r.add_child(icon_rect(SpriteBank.texture("icons/soul_ash"), MenuData.ASH_ICON))
	ash_label = UiTheme.tier_label(str(Meta.ash()), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	ash_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	r.add_child(ash_label)
	return p


## Centres the panel in its area, scaled down when its minimum size does not fit (phones).
func _fit_panel() -> void:
	if not is_instance_valid(panel) or _area.size.x <= 0.0:
		return
	var want := panel.get_combined_minimum_size()  # Natural size.
	var k := minf(1.0, minf(_area.size.x / want.x, (_area.size.y - MenuData.KEYSTONE_ROOM) / want.y))  # Fit scale.
	panel.size = want
	panel.scale = Vector2.ONE * k
	panel.position = ((_area.size - want * k) * 0.5 + Vector2(0.0, MenuData.KEYSTONE_ROOM * 0.5)).floor()


## Fills the content column (override).
func _build(_box: VBoxContainer) -> void:
	pass


## Called after the nav row is built (override to add Start / Next...).
func _after_nav() -> void:
	pass


## A button with `text` calling `cb` in `parent` (NAV_BUTTON size, optional kit accent).
func button(parent: Control, text: String, cb: Callable, p_accent: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.custom_minimum_size = MenuData.NAV_BUTTON
	b.pressed.connect(cb)
	if p_accent != "":
		UiTheme.style_button(b, "button", p_accent)
	parent.add_child(b)
	return b


## A row of tab buttons in `parent` from `tabs` ([[id, word], ...]), each calling
## `cb(id)`; returns id -> Button. Mark the current one with mark_tabs().
func tab_row(parent: Control, tabs: Array, cb: Callable, px: Vector2 = MenuData.TAB_BUTTON) -> Dictionary:
	var row := HBoxContainer.new()  # The tabs.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", MenuData.TAB_GAP)
	parent.add_child(row)
	var out := {}  # id -> button.
	for t: Array in tabs:
		var b := Button.new()  # One tab.
		b.text = String(t[1])
		b.custom_minimum_size = px
		b.pressed.connect(cb.bind(String(t[0])))
		b.set_meta("ui_lift", false)
		row.add_child(b)
		out[String(t[0])] = b
	return out


## Gold frame and gold text on tab `on` of `tabs` (gold = selection), the rest plain.
static func mark_tabs(tabs: Dictionary, on: String) -> void:
	for k: String in tabs:
		var b := tabs[k] as Button
		UiTheme.style_button(b, "button", "gold" if k == on else "")
		if k == on:
			b.add_theme_color_override("font_color", UiTheme.TEXT_GOLD)
		else:
			b.remove_theme_color_override("font_color")


## A centred LABEL-tier section label.
func section(text: String) -> Label:
	var l := UiTheme.tier_label(text.to_upper(), UiTheme.Tier.LABEL, UiTheme.TEXT_DIM)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


## An icon TextureRect of texture `tex` at `px` square (dimmed to a silhouette when `dark`).
static func icon_rect(tex: Texture2D, px: float, dark: bool = false) -> TextureRect:
	var r := TextureRect.new()  # The icon.
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(px, px)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if dark:
		r.modulate = MenuData.SILHOUETTE
	return r


## A row of three skulls, `n` lit (gold) and the rest dim, each `px` square.
static func skull_row(n: int, px: float) -> HBoxContainer:
	var row := HBoxContainer.new()  # The skulls.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in 3:
		var r := icon_rect(load(MenuData.SKULL_ICON) as Texture2D, px)  # One skull.
		r.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		r.modulate = UiTheme.TEXT_GOLD if i < n else Color(0.3, 0.3, 0.35, 0.6)
		row.add_child(r)
	return row


func _on_back() -> void:
	if UiMotion.is_closing(self):
		return
	back.emit()


func _unhandled_input(event: InputEvent) -> void:
	if has_back and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_back()
