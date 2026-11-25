## Eclipse, a later ultimate (GDD §5; Necropathy's "darkness: every foe
## freezes, then takes +30% damage"): on the Dread Rally meter. Freezes every
## enemy on the map for `freeze` s (TdCombat.freeze_enemy: bosses and minibosses
## by their rank's freeze multiplier) and curses it (tower hits x `curse_mult`
## for `curse_time` s, TdCombat.curse_enemy). Structures are untouched. Row:
## SpellData.ULTIMATES "eclipse". Cast anywhere.
extends TdSpell

## Game s the darkness ends (drawn only).
var _dark_until: float = 0.0


func cast(_pos: Vector2) -> bool:
	for e: TdEnemy in game.enemies.duplicate():
		if not e.alive or bool(e.row.get("structure", false)):
			continue
		TdCombat.freeze_enemy(game, e, float(row["freeze"]))
		TdCombat.curse_enemy(game, e, float(row["curse_mult"]), float(row["curse_time"]))
		game.stats["eclipsed"] = int(game.stats.get("eclipsed", 0)) + 1
	_dark_until = game.time + float(row["freeze"])
	Sfx.play(String(row["sound"]))
	game.banner(String(row["name"]) + "!")
	return true


func draw(ci: CanvasItem) -> void:
	if game.time >= _dark_until:
		return
	# Darkness as soft violet pools under every frozen foe (no full-screen overlay, V-rule 5).
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for e: TdEnemy in game.enemies:
		if e.alive and game.time < e.freeze_until:
			ci.draw_texture_rect(TdVfx._soft(), Rect2(e.position - Vector2(30, 18), Vector2(60, 36)), false, Color(tint, 0.55))


func busy() -> bool:
	return game.time < _dark_until
