## ResultsScreen: the end-of-map card (GDD §3, §9.3): Victory (gold) with the
## skull rating, or Defeat (crimson); waves cleared, lives kept, the Soul
## Ash this run paid (Main records the run before the card opens and leaves
## the amount in the run's "ash_paid" meta), a Reckoning offer after a clear
## when the run supports one (TdGame.start_reckoning(), read defensively),
## and Next (the next open map, the run's "on_next" meta) / Again / Menu.
class_name ResultsScreen
extends Control

## The run.
var game: TdGame = null
## True for a win.
var won: bool = false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(UiTheme.backdrop())
	var center := CenterContainer.new()  # Centres the card.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := UiTheme.ornate_panel("gold" if won else "crimson")  # The card.
	center.add_child(panel)
	var box := VBoxContainer.new()  # Its rows.
	box.add_theme_constant_override("separation", 8)
	box.custom_minimum_size = Vector2(420, 0)
	panel.add_child(box)
	var rk := Meta.reckoning_of(game)  # Reckoning waves reached (0 = none).
	box.add_child(UiTheme.title("Victory" if won else ("Reckoning %d" % rk if rk > 0 else "Defeat"), UiTheme.TEXT_GOLD if won else MenuData.CRIMSON))
	if won:
		box.add_child(MenuScreen.skull_row(game.skulls(), MenuData.SKULL_BIG))
	box.add_child(_centred(UiTheme.tier_label(String(game.map["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_DIM)))
	box.add_child(_centred(UiTheme.tier_label("Waves %d / %d" % [game.waves.cleared_count(), game.waves.total()], UiTheme.Tier.NAME)))
	box.add_child(_centred(UiTheme.tier_label("Lives %d / %d" % [game.lives, game.start_lives], UiTheme.Tier.NAME, UiTheme.TEXT if game.lives > 0 else MenuData.CRIMSON)))
	var ash := HBoxContainer.new()  # Soul Ash earned.
	ash.alignment = BoxContainer.ALIGNMENT_CENTER
	ash.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/soul_ash"), 32.0))
	var al := UiTheme.tier_label("+0", UiTheme.Tier.HEADER, UiTheme.TEXT_GOLD)  # Counts up.
	ash.add_child(al)
	box.add_child(ash)
	UiMotion.count_up(al, int(game.get_meta("ash_paid", 0)), "+%d")
	box.add_child(UiTheme.divider("gold" if won else "crimson"))
	var row := HBoxContainer.new()  # Buttons.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var first: Button = null  # Focused on open.
	if won and game.has_method("start_reckoning"):
		first = _button(row, "Reckoning", _reckoning, "crimson")
	var on_next: Variant = game.get_meta("on_next") if game.has_meta("on_next") else null  # Starts the next map (null = none open).
	if won and on_next is Callable:
		var nb := _button(row, "Next", on_next, "gold")
		first = nb if first == null else first
	var again := _button(row, "Again", func() -> void: game.restart_requested.emit())
	_button(row, "Menu", func() -> void: game.menu_requested.emit())
	UiTheme.focus_deferred(first if first != null else again)
	TouchSupport.fit_to_screen(center)
	UiMotion.open(self)


## `l` centred.
func _centred(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


## A button in `row`.
func _button(row: HBoxContainer, text: String, cb: Callable, accent: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.custom_minimum_size = MenuData.NAV_BUTTON
	b.pressed.connect(cb)
	if accent != "":
		UiTheme.style_button(b, "button", accent)
	row.add_child(b)
	return b


## Starts the Reckoning after a clear (the maps agent's TdGame.start_reckoning()).
func _reckoning() -> void:
	game.call("start_reckoning")
	queue_free()
