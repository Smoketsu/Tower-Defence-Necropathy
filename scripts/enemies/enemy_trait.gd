## EnemyTrait: the base of every enemy kind's road trait (GDD §6.1) and of
## every boss (GDD §6.3). One shared instance per trait id, loaded by name
## from scripts/enemies/traits/<id>.gd, else scripts/bosses/<id>.gd, and
## cached; per-enemy state lives in TdEnemy.vars. Override only the hooks a
## kind needs; the defaults do nothing. Numbers come from the kind's
## TdEnemyData "args" row, never from the script.
##
## Hooks (all called by the core, never by other traits):
##   on_spawn(e, game)                      — after the enemy is placed on the road.
##   step(e, game, dt)                      — every fixed step before it walks (auras go here:
##                                            query game.enemies_near() and set hastes / heals).
##   incoming_damage(e, game, amount, hit)  — returns the damage to apply (shields, fronts);
##                                            `hit` = {source, tower, origin, dot, armour_pierce}.
##   on_hit(e, game, amount, hit)           — after damage was applied and it survived.
##   on_death(e, game)                      — when killed (not when it leaks).
class_name EnemyTrait
extends RefCounted

## Trait id -> shared instance (null cached for "" and missing scripts).
static var _cache: Dictionary = {}


## The shared trait for id `id` ("" = none), loading it on first use.
static func for_kind(id: String) -> EnemyTrait:
	if id == "":
		return null
	if not _cache.has(id):
		var inst: EnemyTrait = null  # Loaded trait, or null when no script exists.
		for dir: String in ["res://scripts/enemies/traits/", "res://scripts/bosses/"]:
			var path := dir + id + ".gd"  # Candidate script.
			if ResourceLoader.exists(path):
				inst = (load(path) as GDScript).new() as EnemyTrait
				break
		if inst == null:
			push_error("EnemyTrait: no script for trait '%s'" % id)
		_cache[id] = inst
	return _cache[id]


## See the header.
func on_spawn(_e: TdEnemy, _game: TdGame) -> void:
	pass


## See the header.
func step(_e: TdEnemy, _game: TdGame, _dt: float) -> void:
	pass


## See the header.
func incoming_damage(_e: TdEnemy, _game: TdGame, amount: float, _hit: Dictionary) -> float:
	return amount


## See the header.
func on_hit(_e: TdEnemy, _game: TdGame, _amount: float, _hit: Dictionary) -> void:
	pass


## See the header.
func on_death(_e: TdEnemy, _game: TdGame) -> void:
	pass
