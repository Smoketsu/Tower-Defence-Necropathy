## TitleBackdrop: a static night graveyard behind the title and map select,
## layered from Necropathy's menu diorama art (assets/sprites/menu/): stars,
## the moon and its halo, far and near hills, the Covenant cathedral, a
## mausoleum, a fence and fog. A trimmed stand-in for Necropathy's animated
## MenuBackdrop (not carried over). Purely visual; redrawn on resize only.
class_name TitleBackdrop
extends Control

## Sky colour behind everything.
const SKY: Color = Color(0.05, 0.04, 0.09)  # TUNING (not in GDD)
## Stars drawn (pure hash positions in the upper half).
const STARS: int = 40  # TUNING (not in GDD)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


## Draws menu sprite `id` with its bottom centre at `p` (px).
func _put(id: String, p: Vector2, tint: Color = Color.WHITE) -> void:
	var tex := MapView.grid_texture("menu/" + id)  # The sprite.
	if tex != null:
		draw_texture_rect(tex, Rect2((p - Vector2(tex.get_width() * 0.5, tex.get_height())).round(), tex.get_size()), false, tint)


## Tiles menu sprite `id` across the width with its bottom at `y`.
func _band(id: String, y: float, tint: Color = Color.WHITE) -> void:
	var tex := MapView.grid_texture("menu/" + id)  # The sprite.
	if tex == null:
		return
	var x := 0.0  # Next tile's left edge.
	while x < size.x:
		draw_texture_rect(tex, Rect2(Vector2(x, y - tex.get_height()).round(), tex.get_size()), false, tint)
		x += tex.get_width()


func _draw() -> void:
	SpriteBank.apply_sharp(self)
	draw_rect(Rect2(Vector2.ZERO, size), SKY)
	for i in STARS:
		var h := hash(Vector2i(i, 31))  # Pure hash of the index.
		_put("stars", Vector2(float(h % maxi(int(size.x), 1)), 20.0 + float((h / 977) % maxi(int(size.y * 0.45), 1))))
	_put("moon_halo", Vector2(size.x * 0.78, size.y * 0.55), Color(1, 1, 1, 0.6))
	_put("moon", Vector2(size.x * 0.78, size.y * 0.36))
	_band("hills_far", size.y * 0.8, Color(0.7, 0.7, 0.8))
	_put("cathedral", Vector2(size.x * 0.22, size.y * 0.8))
	_band("hills_mid", size.y * 0.9)
	_put("mausoleum", Vector2(size.x * 0.68, size.y * 0.92))
	_band("fence", size.y * 0.95)
	_band("ground_lip", size.y + 2.0)
	_band("fog_1", size.y * 0.97, Color(1, 1, 1, 0.5))
