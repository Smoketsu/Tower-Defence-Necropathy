## ResultsScreen: the end-of-map card (GDD §3): Victory (gold) with the skull
## rating, or Defeat (crimson), the waves cleared and lives kept, and the two
## buttons Again / Menu (handled by Main through TdGame's requests).
class_name ResultsScreen
extends Control

## The run.
var game: TdGame = null
## True for a win.
var won: bool = false


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(UiTheme.backdrop())
	var center := CenterContainer.new()  # Centres the card.
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := UiTheme.ornate_panel("gold" if won else "crimson")  # The card.
	center.add_child(panel)
	var box := VBoxContainer.new()  # Its rows.
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	box.add_child(UiTheme.title("Victory" if won else "Defeat", UiTheme.TEXT_GOLD if won else Color(0.95, 0.35, 0.35)))
	if won:
		var skulls := HBoxContainer.new()  # The skull rating, filled and dim.
		skulls.alignment = BoxContainer.ALIGNMENT_CENTER
		for i in 3:
			var r := TextureRect.new()  # One skull.
			r.texture = SpriteBank.texture("icons/soul_ash")
			r.modulate = Color.WHITE if i < game.skulls() else Color(0.3, 0.3, 0.3, 0.6)
			skulls.add_child(r)
		box.add_child(skulls)
	box.add_child(UiTheme.tier_label("Waves %d / %d" % [game.waves.cleared_count(), game.waves.total()], UiTheme.Tier.NAME))
	box.add_child(UiTheme.tier_label("Lives %d / %d" % [game.lives, game.start_lives], UiTheme.Tier.NAME))
	var row := HBoxContainer.new()  # Buttons.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var again := Button.new()  # Replay.
	again.text = "Again"
	again.pressed.connect(func() -> void: game.restart_requested.emit())
	row.add_child(again)
	var menu := Button.new()  # Back to the title.
	menu.text = "Menu"
	menu.pressed.connect(func() -> void: game.menu_requested.emit())
	row.add_child(menu)
	UiTheme.focus_deferred(again)
	UiMotion.open(self)
