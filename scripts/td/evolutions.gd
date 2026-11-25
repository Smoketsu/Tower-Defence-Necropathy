## Evolutions: the small evaluator of the hidden evolution recipes
## (EvolutionData, GDD §4.3). Tower.can_evolve() asks recipe_met(); nothing
## else reads a recipe. New recipe types are one more `match` branch here.
class_name Evolutions
extends RefCounted


## True when tower `t`'s evolution recipe is met right now.
static func recipe_met(t: Tower, game: TdGame) -> bool:
	var id := String(t.row.get("evolution", ""))  # Its EvolutionData id.
	if id == "" or not EvolutionData.EVOLUTIONS.has(id):
		return false
	var rec: Dictionary = EvolutionData.EVOLUTIONS[id]["recipe"]  # The recipe.
	match String(rec["type"]):
		"kills":
			return t.kills >= int(rec["n"])
		"near", "near_level":
			var r2 := float(rec["radius"]) * float(rec["radius"])  # Squared radius.
			for o: Tower in game.towers:
				if o != t and o.tower_id == String(rec["class"]) and t.position.distance_squared_to(o.position) <= r2 \
						and o.level >= int(rec.get("level", 1)):
					return true
	return false
