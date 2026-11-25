## Holy Ward Generators (GDD §7.2, the Crimson March's rule): generators
## (TdEnemyData "ward_generator", a structure) stand beside the roads and
## shield every enemy near them until destroyed. They rise at the waves
## listed in Act1RuleData.GENERATORS; towers shoot them when nothing else is
## in range (or on Strongest). Leftovers are cleared when the map ends.
extends MapRule

## Generators raised so far.
var raised: int = 0
## Indices of GENERATORS rows already raised.
var _done: Dictionary = {}


func setup() -> void:
	_raise_due()


func step(_dt: float) -> void:
	_raise_due()
	finish_structures()


## Raises every generator whose wave has started.
func _raise_due() -> void:
	for i in Act1RuleData.GENERATORS.size():
		var g: Dictionary = Act1RuleData.GENERATORS[i]
		if _done.has(i) or game.waves.current + 1 < int(g["wave"]):
			continue
		_done[i] = true
		Structures.raise(game, "ward_generator", g["pos"])
		raised += 1
		if int(g["wave"]) > 0:
			game.banner("A Holy Ward Generator rises beside the road")


func summary() -> String:
	return "generators_raised=%d destroyed=%d" % [raised, int(game.stats["kills"].get("ward_generator", 0))]
