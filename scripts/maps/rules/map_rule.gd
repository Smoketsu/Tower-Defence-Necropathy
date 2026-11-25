## MapRule: the base of a map's own rule (GDD §7.2: Holy Ward Generators on
## the Crimson March, the Sanctum's chambers). A map names it in MAP "rule";
## TdGame loads scripts/maps/rules/<id>.gd, sets `game` and calls the hooks.
## Rule numbers belong in a data file (scripts/data/<map>_rule_data.gd).
##
## Hooks:
##   setup()            — once, after the map scene is built (add nodes under game.world).
##   step(dt)           — every fixed step, after the waves and spells.
##   tower_damage_mult(t: Tower) -> float — multiplier on tower `t`'s damage
##                         (read by Tower.recompute(); the Sanctum's chambers).
##   summary() -> String — the rule's line in the autotest summary.
## Helper: finish_structures() removes the rule's leftover structures (ward
## generators, crystals: enemies with row key "structure") once every wave has
## spawned and only structures remain, so the map can end.
class_name MapRule
extends RefCounted

## The run.
var game: TdGame = null


## See the header.
func setup() -> void:
	pass


## See the header.
func step(_dt: float) -> void:
	pass


## See the header.
func tower_damage_mult(_t: Tower) -> float:
	return 1.0


## See the header.
func summary() -> String:
	return ""


## See the header. Call from step().
func finish_structures() -> void:
	if not game.waves.all_spawned() or game.enemies.is_empty():
		return
	for e: TdEnemy in game.enemies:
		if not bool(e.row.get("structure", false)):
			return
	for e: TdEnemy in game.enemies.duplicate():
		game.remove_enemy(e, false)
