## Spot: one buildable place of a map: a grave plot beside the road or a
## road post on it (GDD §4). Draws its base art (TdArtData plot_empty /
## plot_occupied / road_post) and holds the tower raised on it. Redrawn only
## when that changes.
class_name Spot
extends Node2D

## "plot" or "post".
var kind: String = "plot"
## Index among the map's plots / posts (build orders name spots "plot:N").
var index: int = 0
## Road the post stands on (posts only).
var road_id: String = ""
## Distance (px) along that road (posts only).
var road_dist: float = 0.0
## The tower on it, or null.
var tower: Tower = null


## Its build-order id, "plot:N" / "post:N".
func spot_id() -> String:
	return "%s:%d" % [kind, index]


## Sets the tower (null when sold) and redraws the base.
func set_tower(t: Tower) -> void:
	tower = t
	queue_redraw()


func _ready() -> void:
	set_process(DisplayServer.get_name() != "headless")


## Empty plots pulse gently (real time; visual only); everything else stays plain.
func _process(_delta: float) -> void:
	var on := kind == "plot" and tower == null and not TdVfx.reduced() and TdVfx.motion()  # Pulsing now.
	var k := 1.0 + TdMoodData.PLOT_PULSE * (0.5 + 0.5 * sin(float(Time.get_ticks_msec()) * 0.001 * TAU / TdMoodData.PLOT_PULSE_PERIOD)) if on else 1.0  # Brightness.
	var c := Color(k, k, k)  # Its modulate.
	if modulate != c:
		modulate = c


func _draw() -> void:
	if kind == "post":  # A dark crimson ground mark: posts read apart from plots.
		var m := TdMoodData.POST_MARK  # Mark size (px).
		draw_texture_rect(SpriteBank.disc(), Rect2(-m * 0.5 + Vector2(0, 4), m), false, TdMoodData.POST_MARK_TINT)
	var role := "road_post" if kind == "post" else ("plot_occupied" if tower != null else "plot_empty")  # Art role.
	if not TdArt.draw(self, role, Vector2.ZERO):
		draw_rect(Rect2(-22, -14, 44, 28), Color(0.25, 0.2, 0.3) if kind == "plot" else Color(0.6, 0.55, 0.45))
