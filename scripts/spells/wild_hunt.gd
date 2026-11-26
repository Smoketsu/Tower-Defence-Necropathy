## Wild Hunt (Act XV spell, the Stag King's reward; Necropathy's Wild Hunt,
## "spectral riders ride out in a line"): Wheel of Eyes' road pass
## (wheel_of_eyes.gd: set down at the tap within `max_snap` px, it runs back
## along the road toward the entrance at `speed` px/s for `length` px, every foe
## within `width` px taking `damage` once per pass; `rebounds` passes back, the
## Horned Herald's innate "wheel_rebounds" adds one) drawn as a rider of the
## Wild Hunt galloping with a spectral glow. Row: SpellData "wild_hunt".
extends "res://scripts/spells/wheel_of_eyes.gd"


func draw(ci: CanvasItem) -> void:
	var px := float(Acts.data("wild")["LOOK"]["rider_px"])  # Drawn size.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for w: Dictionary in _wheels:
		var rd: Road = w["road"]
		var d := clampf(float(w["d"]), 0.0, rd.length)
		var p := rd.point_at(d)
		var back := rd.point_at(clampf(d - float(w["dir"]) * px, 0.0, rd.length))  # A ghostly trail behind it.
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(px, px * 0.7), Vector2(px, px * 0.7) * 2.0), false, Color(tint, 0.45))
		ci.draw_texture_rect(TdVfx._soft(), Rect2(back - Vector2(px, px) * 0.4, Vector2(px, px) * 0.8), false, Color(tint, 0.25))
		if not SpriteBank.draw(ci, "wild/wild_rider", p, false, Color(tint.r, tint.g, tint.b, 0.85), TdVfxData.UNIT_SCALE_TOWER):
			SpriteBank.draw_disc(ci, p, px * 0.4, tint)
