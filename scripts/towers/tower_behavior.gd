## TowerBehavior: the base of what a tower does each step. One shared
## instance per behaviour id, loaded by name from scripts/towers/<id>.gd
## (TowerData row key "behavior") and cached; per-tower state lives in
## Tower.vars. Numbers come from Tower.stats only.
##
## Hooks (override what the class needs):
##   setup(t)            — once, after the tower is built (blockers make their bodies).
##   on_recompute(t)     — after every Tower.recompute() (stats changed).
##   step(t, dt)         — every fixed step.
##   volley(t, target)   — the Lv3+ volley burst (default: extra tinted shots, see below).
##   on_removed(t)       — the tower is sold (blockers let go of their enemies).
##   draw(t)             — draws the tower on its own node (default: the unit sprite).
## A class-specific behaviour (e.g. scripts/towers/lich.gd) extends the
## behaviour it builds on (projectile.gd / aura.gd / blocker.gd) by path.
class_name TowerBehavior
extends RefCounted

## Behaviour id -> shared instance.
static var _cache: Dictionary = {}


## The shared behaviour for id `id`, loaded on first use (push_error and the
## projectile behaviour when no script exists).
static func for_id(id: String) -> TowerBehavior:
	if not _cache.has(id):
		var path := "res://scripts/towers/%s.gd" % id  # Its script.
		if not ResourceLoader.exists(path):
			push_error("TowerBehavior: no script for behaviour '%s'" % id)
			path = "res://scripts/towers/projectile.gd"
		_cache[id] = (load(path) as GDScript).new()
	return _cache[id]


## See the header.
func setup(_t: Tower) -> void:
	pass


## See the header.
func on_recompute(_t: Tower) -> void:
	pass


## See the header.
func step(_t: Tower, _dt: float) -> void:
	pass


## See the header. Default: from level 3, every `volley.every` shots, fire
## `volley.count` extra shots of `volley.damage` x the shot damage at the
## nearest other enemies in range (the target again when alone), drawn with
## the volley sprite and tint (Necropathy's bullet heaven pass look).
func volley(t: Tower, target: TdEnemy) -> void:
	var v: Dictionary = t.stats.get("volley", {})  # The class's volley row.
	if v.is_empty() or t.level < 3 or t.shots % int(v["every"]) != 0:
		return
	var others := t.game.enemies_near(t.position, float(t.stats["range"]))  # Candidates.
	for i in int(v["count"]):
		var e: TdEnemy = others[i % others.size()] if not others.is_empty() else target  # Its target.
		t.game.projectiles.fire(t, e, float(t.stats["damage"]) * float(v["damage"]), String(v["sprite"]), v["tint"], true)
	t.game.fx.spawn("volley_flash", t.position + Vector2(0, -20), 48.0, 0.25, v["tint"])


## See the header.
func on_removed(_t: Tower) -> void:
	pass


## See the header. Default: the unit sprite on the spot, mirrored to face,
## squashed briefly after a shot.
func draw(t: Tower) -> void:
	var squash := 0.0  # 0..1 squash amount.
	if t.game.time < t.squash_until:
		squash = (t.squash_until - t.game.time) / TowerData.FIRE_SQUASH_TIME
	t.draw_set_transform(Vector2(0, 8), 0.0, Vector2(t.facing * (1.0 + TowerData.FIRE_SQUASH * squash), 1.0 - TowerData.FIRE_SQUASH * squash))
	if not SpriteBank.draw(t, String(t.stats["sprite"]), Vector2(0, -8), false):
		t.draw_rect(Rect2(-10, -26, 20, 30), Color(0.6, 0.8, 0.6))
	t.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
