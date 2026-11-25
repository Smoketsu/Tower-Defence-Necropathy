## SoulEconomy: the one path for every soul change in a map (GDD §8.1):
## kill payouts, no-leak bonuses, early-call bonuses, building, upgrading,
## selling. Keeps the earned / spent totals for the summary.
class_name SoulEconomy
extends RefCounted

## Emitted after any change (HUD refresh).
signal changed

## Souls available now (>= 0).
var souls: int = 0
## Souls earned this map, by reason ("kills", "no_leak", "call", "refund"...).
var earned: Dictionary = {}
## Souls spent this map (total).
var spent: int = 0


func _init(start: int) -> void:
	souls = start


## Adds `amount` souls for `reason`.
func earn(amount: int, reason: String) -> void:
	if amount <= 0:
		return
	souls += amount
	earned[reason] = int(earned.get(reason, 0)) + amount
	changed.emit()


## True when `amount` souls can be paid.
func can_afford(amount: int) -> bool:
	return souls >= amount


## Pays `amount` souls; returns false (paying nothing) when short.
func spend(amount: int) -> bool:
	if souls < amount:
		return false
	souls -= amount
	spent += amount
	changed.emit()
	return true


## Total earned over every reason.
func total_earned() -> int:
	var t := 0  # Running total.
	for v: int in earned.values():
		t += v
	return t
