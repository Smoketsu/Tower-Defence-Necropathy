## Synergies: the small evaluator of SynergyData (GDD §4.4). After any
## build, sale or evolution it gives every tower the list of active pairs
## (Tower.synergies: [id, partner]) and recomputes the towers whose list
## changed; the stat effects themselves apply in Tower.recompute().
class_name Synergies
extends RefCounted


## Re-evaluates every synergy over `towers` (all towers of the run).
static func evaluate(towers: Array[Tower]) -> void:
	var lists := {}  # Tower -> its new pair list.
	for t: Tower in towers:
		lists[t] = []
	for id: String in SynergyData.SYNERGIES:
		var syn: Dictionary = SynergyData.SYNERGIES[id]  # Synergy row.
		var r2 := float(syn["radius"]) * float(syn["radius"])  # Squared pair radius.
		for a: Tower in towers:
			if a.tower_id != String(syn["a"]):
				continue
			for b: Tower in towers:
				if b.tower_id == String(syn["b"]) and a.position.distance_squared_to(b.position) <= r2:
					(lists[a] as Array).append([id, b])
					(lists[b] as Array).append([id, a])
	for t: Tower in towers:
		if lists[t] != t.synergies:
			t.synergies = lists[t]
			t.recompute()


## Synergy ids class `tower_id` can take part in (the spot menu's hints).
static func hints_for(tower_id: String) -> Array[String]:
	var out: Array[String] = []  # Matching synergy ids.
	for id: String in SynergyData.SYNERGIES:
		var syn: Dictionary = SynergyData.SYNERGIES[id]  # Synergy row.
		if String(syn["a"]) == tower_id or String(syn["b"]) == tower_id:
			out.append(id)
	return out
