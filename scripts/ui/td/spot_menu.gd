## SpotMenu: the menu around the tapped spot (GDD §9.1). Empty spot: the
## towers that fit it with their costs, and the synergies each would join
## there (hinted, never secret, GDD §4.4). Occupied spot: Upgrade (or Free
## with a chest credit), Target (cycles the mode), Sell, and Evolve only
## once the hidden recipe is met (gold). Follows TdGame.selected; rebuilt by
## refresh() whenever the run changes. Calls only TdGame's player actions.
class_name SpotMenu
extends PanelContainer

## The run.
var game: TdGame = null
## Spot the menu was built for.
var _for: Spot = null
## Souls / level / mode snapshot it was built with (rebuilt when it changes).
var _sig: String = ""


func _ready() -> void:
	add_theme_stylebox_override("panel", UiTheme.style("ornate", "violet"))
	visible = false


## Shows the menu for TdGame.selected (hides it when none), rebuilding it
## when what it shows changed.
func refresh() -> void:
	var s := game.selected  # The selected spot.
	if s == null or game.over:
		visible = false
		_for = null
		return
	var t := s.tower  # Its tower, or null.
	var sig := "%s|%d|%d|%s|%d|%s" % [s.spot_id(), game.economy.souls, game.free_upgrades,
		t.tower_id + str(t.level) + t.target_mode + t.evolution + str(t.can_evolve()) if t != null else "-", game.towers.size(), str(game.over)]  # What the menu shows.
	if s == _for and sig == _sig and visible:
		return
	_for = s
	_sig = sig
	for c: Node in get_children():
		remove_child(c)  # At once, so reset_size() measures only the new rows.
		c.queue_free()
	var box := VBoxContainer.new()  # The menu's rows.
	add_child(box)
	if t == null:
		_build_empty(box, s)
	else:
		_build_tower(box, t)
	visible = true
	reset_size()
	_place.call_deferred(s)


## Puts the menu beside spot `s`, kept on screen.
func _place(s: Spot) -> void:
	var p := game.world.get_global_transform_with_canvas() * s.position  # Spot on screen.
	var vp := get_viewport().get_visible_rect().size  # Screen size.
	reset_size()
	var x := p.x + TdUiData.MENU_OFFSET if p.x + TdUiData.MENU_OFFSET + size.x < vp.x else p.x - TdUiData.MENU_OFFSET - size.x  # Right of it, else left.
	position = Vector2(x, clampf(p.y - size.y * 0.5, TdUiData.TOP_BAR_H + 4.0, vp.y - size.y - 4.0))


## A menu button with icon texture `tex`, text and callback.
func _button(box: Container, tex: Texture2D, text: String, cb: Callable, accent: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.icon = tex
	b.expand_icon = false
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(cb)
	if accent != "":
		UiTheme.style_button(b, "button", accent)
	box.add_child(b)
	return b


func _build_empty(box: VBoxContainer, s: Spot) -> void:
	box.add_child(UiTheme.tier_label("Grave plot" if s.kind == "plot" else "Road post", UiTheme.Tier.LABEL, UiTheme.TEXT_DIM))
	for id: String in TowerData.ORDER:
		var row: Dictionary = TowerData.TOWERS[id]
		if String(row["spot"]) != s.kind:
			continue
		var joins := _would_join(id, s)  # Synergy names it would form here.
		var text := "%s  %d" % [String(row["name"]), int(row["cost"])]  # Name and cost.
		if not joins.is_empty():
			text += "  + " + ", ".join(joins)
		var b := _button(box, SpriteBank.texture("icons/" + String(row["icon"])), text, _do_build.bind(s, id), "soul" if not joins.is_empty() else "")
		b.disabled = not game.economy.can_afford(int(row["cost"]))
		var hints: Array[String] = []  # Every synergy this class can join (tooltip).
		for sid: String in Synergies.hints_for(id):
			hints.append(String(SynergyData.SYNERGIES[sid]["hint"]))
		b.tooltip_text = "\n".join(hints)


## Names of the synergies tower class `id` would form on spot `s` now.
func _would_join(id: String, s: Spot) -> Array[String]:
	var out: Array[String] = []  # Synergy names.
	for sid: String in SynergyData.SYNERGIES:
		var syn: Dictionary = SynergyData.SYNERGIES[sid]
		var other := String(syn["b"]) if String(syn["a"]) == id else (String(syn["a"]) if String(syn["b"]) == id else "")  # Partner class.
		if other == "":
			continue
		for t: Tower in game.towers:
			if t.tower_id == other and t.position.distance_to(s.position) <= float(syn["radius"]):
				out.append(String(syn["name"]))
				break
	return out


func _build_tower(box: VBoxContainer, t: Tower) -> void:
	var title := "%s  Lv %d" % [String(t.stats["name"]), t.level] if t.evolution == "" else String(t.stats["name"])  # Header line.
	box.add_child(UiTheme.tier_label(title, UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if t.evolution != "" else UiTheme.TEXT))
	box.add_child(UiTheme.tier_label("Kills %d" % t.kills, UiTheme.Tier.BODY, UiTheme.TEXT_DIM))
	if t.level < 5:
		var cost := t.upgrade_cost()  # Souls for the next level.
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var b := _button(box, TdArt.texture("icon_upgrade"), "Upgrade  " + ("Free" if free else str(cost)), _act.bind(game.upgrade, t.spot), "gold" if free else "")
		b.disabled = not free and not game.economy.can_afford(cost)
	if t.can_evolve():
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var e := _button(box, TdArt.texture("icon_evolve"), "Evolve  " + ("Free" if free else str(t.evolve_cost())), _act.bind(game.evolve, t.spot), "gold")
		e.disabled = not free and not game.economy.can_afford(t.evolve_cost())
	if t.block == null:
		_button(box, TdArt.texture("icon_target_" + t.target_mode), "Target  " + t.target_mode.capitalize(), func() -> void: game.set_target(t.spot))
	_button(box, TdArt.texture("icon_sell"), "Sell  +%d" % t.sell_value(), _act.bind(game.sell, t.spot), "crimson")
	for pair: Array in t.synergies:
		box.add_child(UiTheme.tier_label("+ " + String(SynergyData.SYNERGIES[pair[0]]["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_GOOD))


## Builds tower `id` on `s` and closes the menu (tap the spot again for its upgrades).
func _do_build(s: Spot, id: String) -> void:
	if game.build(s, id):
		game.selected = null
	else:
		game.sound("denied")
	game.changed.emit()


## Runs action `fn(spot)`; a sale closes the menu.
func _act(fn: Callable, s: Spot) -> void:
	if not bool(fn.call(s)):
		game.sound("denied")
	if s.tower == null:
		game.selected = null
	game.changed.emit()
