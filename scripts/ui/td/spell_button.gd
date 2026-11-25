## SpellButton: one spell (or the ultimate) on the spell bar: its icon, a
## dark cooldown sweep falling away as it recharges (a rect, cheap on the
## Web), a soul-teal meter fill for the ultimate, a gold rim while armed.
## The HUD sets `frac` / `armed` each frame; pressing it is the HUD's job.
class_name SpellButton
extends Button

## Icon key (icons/<id>).
var icon_key: String = ""
## 0 (just cast / empty meter) .. 1 (ready / full).
var frac: float = 1.0
## True while this spell is armed for targeting.
var armed: bool = false
## True for the ultimate (meter fill instead of a sweep).
var is_ultimate: bool = false


func _draw() -> void:
	var r := Rect2(Vector2(6, 6), size - Vector2(12, 12))  # Icon box.
	SpriteBank.draw_icon_art(self, icon_key, r)
	if is_ultimate:
		var h := r.size.y * frac  # Meter fill height.
		draw_rect(Rect2(r.position + Vector2(0, r.size.y - h), Vector2(r.size.x, h)), TdUiData.METER)
	elif frac < 1.0:
		draw_rect(Rect2(r.position, Vector2(r.size.x, r.size.y * (1.0 - frac))), TdUiData.SWEEP)
	if armed:
		draw_rect(r.grow(2), UiTheme.TEXT_GOLD, false, 2.0)
