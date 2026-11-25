## TdArt: loads the Gravewatch art roles of TdArtData and draws them as grid
## pixel art (1 art px = 1 layout px) through Necropathy's sharp-pixel shader
## (SpriteBank.apply_sharp). Missing files return null / false so callers draw
## a plain fallback. Purely visual.
class_name TdArt
extends RefCounted

## Role -> wrapped texture (a linear CanvasTexture for the sharp shader), or null.
static var _cache: Dictionary = {}


## The texture of `role` (null when its file is missing). `repeat` = the
## tiled variant (roads).
static func texture(role: String, repeat: bool = false) -> Texture2D:
	var key := role + ("#r" if repeat else "")  # Cache key.
	if not _cache.has(key):
		var path := String(TdArtData.ROLES.get(role, ""))  # Its PNG.
		var tex: Texture2D = null  # Wrapped texture.
		if path != "" and ResourceLoader.exists(path):
			var ct := CanvasTexture.new()
			ct.diffuse_texture = load(path) as Texture2D
			ct.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			ct.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED if repeat else CanvasItem.TEXTURE_REPEAT_DISABLED
			tex = ct
		_cache[key] = tex
	return _cache[key]


## Draws `role` centred on `o` at its art size times `scale` (tinted by
## `tint`); returns false when the art is missing.
static func draw(ci: CanvasItem, role: String, o: Vector2, scale: float = 1.0, tint: Color = Color.WHITE) -> bool:
	var tex := texture(role)  # Its texture.
	if tex == null:
		return false
	SpriteBank.apply_sharp(ci)
	var size := tex.get_size() * scale  # Drawn size (px).
	ci.draw_texture_rect(tex, Rect2((o - size * 0.5).round(), size), false, tint)
	return true
