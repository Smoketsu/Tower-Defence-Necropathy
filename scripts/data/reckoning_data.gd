## ReckoningData: the optional endless mode after a cleared map (GDD §6.2
## "keeps escalating until the gate falls"). Its waves are made from the
## map's own wave table by WaveDirector.start_reckoning(). Data only, no logic.
class_name ReckoningData
extends RefCounted

## How many of the map's last non-boss waves the Reckoning cycles through.
const RECENT_WAVES: int = 6  # TUNING (not in GDD)
## Enemy count multiplier added per Reckoning wave (wave k: 1 + k x this).
const COUNT_GROWTH: float = 0.15  # TUNING (not in GDD)
## Enemy HP multiplier per Reckoning wave, compounding (wave k: this ^ k).
const HP_GROWTH: float = 1.15  # TUNING (not in GDD)
## Every this many Reckoning waves the map's miniboss marches with the wave (0 = never).
const MINIBOSS_EVERY: int = 5  # TUNING (not in GDD)
## Spacing multiplier on the cycled waves' groups (tighter columns as it escalates; 0..1].
const SPACING_MULT: float = 0.85  # TUNING (not in GDD)
