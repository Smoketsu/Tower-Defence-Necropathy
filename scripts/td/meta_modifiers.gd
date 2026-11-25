## MetaModifiers: the one path through which permanent progression (the
## Ossuary and Masteries, GDD §8.2) changes a run. Meta fills `bonuses` and
## `masteries` from the save (or the autotest from --meta); empty = a fresh
## save = the baseline game. Every key is an Ossuary upgrade id
## (MetaData.UPGRADES) whose value is its owned level x its "per".
class_name MetaModifiers
extends RefCounted

## Owned upgrade values, upgrade id -> level x per (empty = a fresh save):
##   start_souls (+souls), lives (+lives), sell_refund (+fraction),
##   spell_cooldown (fraction off, 0..0.5), spell_slot (+slots), respawn
##   (fraction off, 0..0.5), tree_ranged / tree_aura / tree_blocker (+fraction),
##   ult_charge (+fraction of ultimate meter charge, gw2-kit).
static var bonuses: Dictionary = {}
## Tower class ids whose Mastery is open (each true).
static var masteries: Dictionary = {}


## Souls at the start of a map whose base is `base`.
static func start_souls(base: int) -> int:
	return base + int(bonuses.get("start_souls", 0))


## Gate lives at the start of a map whose base is `base`.
static func start_lives(base: int) -> int:
	return base + int(bonuses.get("lives", 0))


## Fraction (0..1) of spent souls returned on a sale.
static func sell_refund() -> float:
	return EconomyData.SELL_REFUND + float(bonuses.get("sell_refund", 0.0))


## Multiplier on every spell cooldown.
static func spell_cooldown_mult() -> float:
	return 1.0 - float(bonuses.get("spell_cooldown", 0.0))


## Multiplier on every blocker respawn time.
static func respawn_mult() -> float:
	return 1.0 - float(bonuses.get("respawn", 0.0))


## Spell slots brought into a map (3, or 4 with the Fourth Rite).
static func spell_slots() -> int:
	return 3 + int(bonuses.get("spell_slot", 0))


## Multiplier on the ultimate meter's charge per kill (Soul Hunger; 1 = none).
static func ultimate_charge_mult() -> float:
	return 1.0 + float(bonuses.get("ult_charge", 0.0))


## The family ("ranged" / "aura" / "blocker", MetaData.FAMILIES) of tower row `r`
## (its "family" key wins: the Crypt Warder is an aura without the aura behaviour).
static func family(r: Dictionary) -> String:
	if r.has("family"):
		return String(r["family"])
	if String(r.get("spot", "")) == "post":
		return "blocker"
	return "aura" if String(r.get("behavior", "")) == "aura" else "ranged"


## Scales tower `t`'s stat multipliers `mult` (Tower.recompute()) by its
## family tree and its class Mastery.
static func apply_tower(t: Tower, mult: Dictionary) -> void:
	if bonuses.is_empty() and masteries.is_empty():
		return
	var fam: Array = MetaData.FAMILIES[family(t.row)]  # [tree id, stat key].
	var m := 1.0 + float(bonuses.get(String(fam[0]), 0.0))  # Tree multiplier.
	if masteries.has(t.tower_id):
		m *= MetaData.MASTERY_MULT
	mult[String(fam[1])] = float(mult[String(fam[1])]) * m
	if family(t.row) == "aura":
		mult["hp"] = float(mult["hp"]) * m  # Aura heals scale with "hp" in Tower.recompute().


## Every upgrade at its max level and every class mastered (--meta=max).
static func set_max() -> void:
	bonuses.clear()
	for id: String in MetaData.UPGRADES:
		var u: Dictionary = MetaData.UPGRADES[id]
		bonuses[id] = float(u["per"]) * float((u["costs"] as Array).size())
	masteries.clear()
	for id: String in TowerData.TOWERS:
		masteries[id] = true
