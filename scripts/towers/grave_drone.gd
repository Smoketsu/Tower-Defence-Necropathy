## Grave Drone kit (Act XII's first unlockable summon; Necropathy's Grave Drone:
## "a flying swarm of skull drones that hover over the army and fire bone
## darts"): a cheap, quick plot tower whose skull drone HOVERS over its plot
## (drawn bobbing over its shadow) and every `interval` s fires `feathers` bone
## darts, the first at its target by mode and each other at a different enemy
## in range, flyers included (the Fallen Seraph's spread shot, fallen_seraph.gd;
## `ruin_every` 0: no dive). From level 3 the volley adds seeking darts.
## Evolved into the Wraith Drone (EvolutionData "wraith_drone"): three darts
## that pierce one foe each, wreathed in ghost flame.
extends "res://scripts/towers/fallen_seraph.gd"


func draw_body(t: Tower, ci: CanvasItem, _index: int) -> void:
	var bob := sin(t.game.time * 3.0 + t.position.x * 0.01) * float(Acts.data("empire")["LOOK"]["drone_hover"])  # Hover (drawn only).
	SpriteBank.draw_disc(ci, Vector2(0, -TowerData.BODY_LIFT + 2.0), 9.0, Color(0, 0, 0, 0.3))  # Its shadow on the plot.
	var tint := Color(1.6, 1.6, 1.5) if t.game.vfx.on and t.firing_flash() else Color.WHITE  # Brightens as it fires (drawn only).
	if not SpriteBank.draw(ci, String(t.stats["sprite"]), Vector2(0, -TowerData.BODY_LIFT - 14.0 + bob), false, tint):
		ci.draw_rect(Rect2(-10, -40, 20, 16), Color(0.7, 0.7, 0.8))
