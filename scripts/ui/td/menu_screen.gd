## MenuScreen: the shared frame of every Gravewatch menu screen (GDD §9.3):
## a full-rect Control holding the night graveyard (or a dim backdrop over a
## run), a centred ornate panel with a Jacquard title and a content column,
## an optional Back button, Esc / pad B (ui_cancel) for Back, the opening
## motion (UiMotion, instant under the autotest and Reduce motion) and the
## phone fit (TouchSupport.fit_to_screen). Subclasses override _build(box).
class_name MenuScreen
extends Control

## Emitted on Back (the button or ui_cancel).
signal back

## Screen title ("" = none).
var title_text: String = ""
## Kit accent of the panel ("violet", "gold", "crimson").
var accent: String = "violet"
## True: drawn over a run (dim backdrop) instead of the night graveyard.
var overlay: bool = false
## True: a Back button under the content.
var has_back: bool = true
## The content column (built before _build()).
var box: VBoxContainer = null
## The bottom row holding Back (subclasses add their buttons to it).
var nav: HBoxContainer = null
## The Back button (null when has_back is false).
var back_button: Button = null


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiTheme.backdrop(0.8) if overlay else TitleBackdrop.new())
	var center := CenterContainer.new()  # Centres the panel.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	var panel := UiTheme.ornate_panel(accent)  # The card.
	center.add_child(panel)
	box = VBoxContainer.new()
	box.add_theme_constant_override("separation", MenuData.ROW_GAP)
	panel.add_child(box)
	if title_text != "":
		box.add_child(UiTheme.title(title_text))
	_build(box)
	nav = HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 16)
	box.add_child(nav)
	if has_back:
		back_button = button(nav, "Back", _on_back)
	_after_nav()
	TouchSupport.fit_to_screen(center)
	UiMotion.open(self)


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
