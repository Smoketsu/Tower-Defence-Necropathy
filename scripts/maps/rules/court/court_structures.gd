## Court structures, the map rule of the Sanguine Court's three maps (MAP
## "rule": "court/court_structures"): raises the map's structures from the act
## data file's STRUCTURES (Ravensmoor's sleeping coffins, the Witchwood's hex
## stones, Castle Sanguis' blood fountains) beside the road at the start of
## the map; their behaviour is their kind's trait (court/coffin,
## court/fountain; the witches read the hex stones). Leftovers are cleared at
## the map's end (finish_structures). Summary: raised / broken / opened.
extends MapRule

## Raised structures: [[TdEnemy, generation], ...].
var raised: Array = []


func setup() -> void:
	for row: Array in Acts.data("court")["STRUCTURES"].get(game.map_id, []):
		var e := Structures.raise(game, String(row[0]), row[1])
		raised.append([e, e.generation])


func step(_dt: float) -> void:
	finish_structures()


func summary() -> String:
	var broken := 0  # Destroyed by the towers.
	for k: String in ["court_coffin", "hex_stone", "blood_fountain"]:
		broken += int(game.stats["kills"].get(k, 0))
	return "structures=%d broken=%d coffins_opened=%d" % [raised.size(), broken, int(game.stats.get("events", {}).get("coffins_opened", 0))]
