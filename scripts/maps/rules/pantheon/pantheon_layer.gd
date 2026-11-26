## PantheonLayer: the Olympian Republic's battlefield look (drawing only,
## nothing headless; added under game.world by the act rule). Every frame:
##   * the SHIELD ARC of every phalanx body (the phalanx trait or a boss that
##     extends it): the bronze arc texture (TdArt "shield_arc") standing in
##     front of it, turned to its walking direction, so the player sees which
##     side is shielded;
##   * a gold GLORY aura under every Hero with stacks (bigger per stack), on
##     the additive glow; dropped on Reduced effects.
## Textures only. Numbers in the act's LOOK.
extends Node2D

## The phalanx trait script (achilles.gd extends it).
const Phalanx := preload("res://scripts/enemies/traits/pantheon/phalanx.gd")

## The run.
var game: TdGame = null


func _ready() -> void:
	z_index = 4  # Over the units' bodies, under hostile fire (5).


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if game == null or not game.vfx.on:
		return
	var lk: Dictionary = PantheonActRules.look()
	var arc := TdArt.texture("shield_arc")  # Bronze arc facing +x.
	var soft := TdVfx._soft()  # Glow disc.
	var glow := not TdVfx.reduced()  # Glory auras are glows.
	for e: TdEnemy in game.enemies:
		if glow and int(e.vars.get("glory", 0)) > 0:
			var g := float(lk["glory_r"]) * (1.0 + float(lk["glory_grow"]) * float(int(e.vars["glory"])))  # Aura radius (px).
			draw_texture_rect(soft, Rect2(e.position - Vector2(g, g * 0.6), Vector2(g, g * 0.6) * 2.0), false, Color(lk["glory_tint"], float(lk["glory_alpha"])))
		if arc == null or e.traits == null or not (e.traits is Phalanx) or game.time < float(e.vars.get("cloak_until", 0.0)):
			continue
		var dir := e.follower.direction()  # Its facing.
		var at := e.position + dir * (e.radius + float(lk["arc_gap"])) + Vector2(0, -float(lk["arc_lift"]))  # The shield's face.
		var sz := arc.get_size() * float(lk["arc_scale"]) * (float(lk["arc_boss_scale"]) if e.row["rank"] == "boss" else 1.0)  # Drawn size (px).
		draw_set_transform(at, dir.angle(), Vector2.ONE)
		draw_texture_rect(arc, Rect2(-sz * 0.5, sz), false, lk["arc_tint"])
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
