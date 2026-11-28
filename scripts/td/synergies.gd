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
			if side_of(a.tower_id, syn) != "a":
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
		if side_of(tower_id, syn) != "":
			out.append(id)
	return out


## Damage multiplier of tower `t`'s hit on enemy `e` from its active synergies'
## conditional "hit" bonuses (the highest one only; 1 = none). Called once per
## hit from TdCombat.damage_enemy().
static func hit_mult(t: Tower, e: TdEnemy, game: TdGame) -> float:
	var best := 1.0  # Highest matching bonus.
	for pair: Array in t.synergies:
		var syn: Dictionary = SynergyData.SYNERGIES[pair[0]]  # Synergy row.
		var hits: Variant = syn.get("hit", [])  # Its conditional bonus (one row or a list).
		for h: Dictionary in (hits if hits is Array else [hits]):
			if side_of(t.tower_id, syn) == String(h["side"]) and has_status(e, String(h["vs"]), game):
				best = maxf(best, float(h["mult"]))
	return best


## Which side ("a" | "b") class `tower_id` takes in synergy row `syn`, or ""
## (the row's optional "a_alt" counts as "a": Winter's Edge).
static func side_of(tower_id: String, syn: Dictionary) -> String:
	if tower_id == String(syn["b"]):
		return "b"
	if tower_id == String(syn["a"]) or tower_id == String(syn.get("a_alt", "")):
		return "a"
	return ""


## True when enemy `e` has status `vs` ("frozen" | "staggered" | "weakened" |
## "slowed" | "swooped" | "bleeding" | "pinned" | "held") now.
static func has_status(e: TdEnemy, vs: String, game: TdGame) -> bool:
	match vs:
		"frozen": return game.time < e.freeze_until
		"staggered": return game.time < e.staggered_until
		"weakened": return game.time < e.weaken_until
		"slowed": return game.time < e.slow_until
		"swooped": return game.time < float(e.vars.get("k_swooped", 0.0))  # Gargoyle landing mark (gw2-kit).
		"bleeding": return e.dots.any(func(d: Array) -> bool: return String(d[2]) == "rogue_bleed" and game.time < float(d[1]))  # A Rogue's bleed still running (DECISIONS Q3).
		"pinned": return game.time < float(e.vars.get("k_pinned", 0.0))  # Iron Revenant shell mark (TdCombat.pin_enemy).
		"held": return e.holder != null or game.time < e.freeze_until  # Held still: stopped at a blocker body, or stunned / seized (DECISIONS Q4).
	return false


## The value of key `key` of the first active synergy of `t` that
## has it, or `default` (Requiem's extend_weaken, Killing Field's aim).
static func value(t: Tower, key: String, default: Variant) -> Variant:
	for pair: Array in t.synergies:
		var syn: Dictionary = SynergyData.SYNERGIES[pair[0]]  # Synergy row.
		if syn.has(key):
			return syn[key]
	return default
