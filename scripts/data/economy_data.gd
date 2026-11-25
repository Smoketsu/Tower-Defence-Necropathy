## EconomyData: the in-map soul economy (GDD §8.1). Read only by SoulEconomy
## and the cost helpers in Tower; every soul change goes through SoulEconomy.
## Data only, no logic.
class_name EconomyData
extends RefCounted

## Souls at the start of a map (before meta bonuses).
const START_SOULS: int = 150  # GDD §8.1
## Souls per kill by enemy rank (TdEnemyData row key "rank").
const KILL_SOULS: Dictionary = {
	"fodder": 3,  # GDD §8.1
	"elite": 12,  # GDD §8.1
	"miniboss": 80,  # GDD §8.1
	"boss": 0,  # TUNING (not in GDD) the boss ends the map; nothing to spend after
}
## No-leak wave bonus: BASE + PER_WAVE x the wave number (1-based).
const NO_LEAK_BASE: int = 10  # GDD §8.1
## See NO_LEAK_BASE.
const NO_LEAK_PER_WAVE: int = 2  # GDD §8.1
## Souls per whole second skipped when the next wave is called early.
const CALL_PER_SECOND: float = 1.0  # GDD §8.1
## Upgrade cost to level 2, 3, 4, 5, as a fraction of the tower's base cost.
const UPGRADE_FRACTIONS: Array[float] = [0.6, 0.9, 1.3, 1.8]  # GDD §8.1
## Evolution (tier 6) cost as a fraction of the base cost.
const EVOLUTION_FRACTION: float = 3.0  # GDD §8.1
## Fraction (0..1) of all souls spent on a tower returned when it is sold.
const SELL_REFUND: float = 0.7  # GDD §8.1
