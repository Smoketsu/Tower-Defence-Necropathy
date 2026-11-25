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
