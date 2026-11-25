## MetaModifiers: the one path through which permanent progression (the
## Ossuary, GDD §8.2) changes a run. No meta save exists yet, so every value
## is the baseline; the Ossuary agent fills `bonuses` from the save and adds
## keys here, never elsewhere.
class_name MetaModifiers
extends RefCounted

## Owned upgrade values, key -> value (empty = a fresh save). Keys read below:
##   start_souls (+souls), lives (+lives), sell_refund (+fraction),
##   spell_cooldown (fraction off, 0..0.5), respawn (fraction off, 0..0.5).
static var bonuses: Dictionary = {}


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
