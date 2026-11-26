## TitleScreen: the title (GDD §9.3): the Gravewatch logo over the night
## graveyard, the Soul Ash held, and Play / Codex / Ossuary / Settings /
## Credits (Quit too, off the Web; it asks first). Emits `chosen` with the
## item id (MenuData.TITLE_ITEMS); Main opens the screen.
class_name TitleScreen
extends Control

## Emitted with the picked item id ("play", "codex", "ossuary", "settings", "credits").
signal chosen(id: String)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	add_child(MenuBackdrop.new())
	var center := CenterContainer.new()  # Centres the column.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()  # Logo and buttons.
	col.add_theme_constant_override("separation", 8)
	center.add_child(col)
	var logo := MenuScreen.icon_rect(TdArt.texture("logo"), 0.0)  # NECROPATHY + Gravewatch, at 2x.
	logo.custom_minimum_size = MenuData.LOGO_SIZE
	col.add_child(logo)
	var ash := HBoxContainer.new()  # Soul Ash held.
	ash.alignment = BoxContainer.ALIGNMENT_CENTER
	ash.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/soul_ash"), 28.0))
	ash.add_child(UiTheme.tier_label(str(Meta.ash()), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD))
	col.add_child(ash)
	var first: Button = null  # Focused on open.
	var buttons: Array = []  # For the staggered entrance.
	for item: Array in MenuData.TITLE_ITEMS:
		var id := String(item[0])  # Item id.
		if id == "quit" and OS.has_feature("web"):
			continue
		var b := Button.new()  # One item.
		b.text = String(item[1])
		b.custom_minimum_size = MenuData.TITLE_BUTTON
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		if id == "quit":
			b.pressed.connect(func() -> void: ConfirmDialog.ask(self, "Quit?", "Leave the crypt for now.", "Quit", get_tree().quit))
		else:
			b.pressed.connect(func() -> void: chosen.emit(id))
		if id == "play":
			UiTheme.style_button(b, "button", "gold")
		col.add_child(b)
		buttons.append(b)
		if first == null:
			first = b
	UiMotion.stagger(buttons)
	UiTheme.focus_deferred(first)
	TouchSupport.fit_to_screen(center)
