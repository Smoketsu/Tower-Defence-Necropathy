## TdRulesData: the fixed rules of a map run that are not souls (GDD §3, owner
## decisions on pacing): the game clock, lives and leaks, wave pacing, skull
## rating, speeds. Data only, no logic.
class_name TdRulesData
extends RefCounted

## Simulation ticks per game second (fixed step, deterministic).
const TICK_RATE: int = 60  # TUNING (not in GDD)
## Gate lives at the start of a map (before meta bonuses).
const START_LIVES: int = 20  # GDD §3 "Start with 20 lives"
## Lives lost when an enemy of each rank reaches the gate; -1 = all (the map is
## lost). A kind row may set "leak_lives" (int, -1 = all) instead (DECISIONS Y3).
const LEAK_LIVES: Dictionary = {
	"fodder": 1,  # GDD §3
	"elite": 3,  # GDD §3
	"miniboss": 5,  # TUNING (not in GDD)
	"boss": 10,  # TUNING (not in GDD) DECISIONS Y3: half the start lives (GDD §3 said "a boss ends the map": a cliff)
}
## Ranks that, meeting a post whose bodies are all full, push a lesser enemy
## (any rank not in this list) out of a body's hold and take its place
## (RoadBlock.free_body / make_room; DECISIONS Y3).
const BUMPING_RANKS: Array[String] = ["miniboss"]  # TUNING (not in GDD) bosses not: a held boss empties the post and its column walks through (DECISIONS Y3)
## Seconds an enemy pushed out of a hold cannot be held again (it walks past the post).
const BUMP_FREE_TIME: float = 0.5  # TUNING (not in GDD)
## Seconds after a wave's LAST SPAWN before the next wave starts by itself
## (owner decision: back-to-back waves; no build phase). Call skips it.
const AUTO_GAP: float = 5.0  # TUNING (not in GDD) owner decision, about 5 s
## Default spacing (s) between two enemies of a wave group when a row omits it.
const DEFAULT_SPACING: float = 0.7  # TUNING (not in GDD) owner decision: tightly spaced
## Skull rating: minimum fraction (0..1) of start lives kept for 3 and 2 skulls;
## any clear below the second value earns 1 skull.
const SKULL_THRESHOLDS: Array[float] = [0.9, 0.5]  # TUNING (not in GDD) GDD §3 "rated 1 to 3 skulls by lives kept"
## Game speed multipliers offered by the speed button (GDD owner decision x1/x2/x3).
const SPEEDS: Array[int] = [1, 2, 3]  # GDD §9.1 / owner decision
## Lateral spread (px, +-) of enemies across the road, picked from the run RNG.
const LANE_SPREAD: float = 12.0  # TUNING (not in GDD)
## Gap (px) between a held enemy's body edge and the block it stands at.
const HOLD_GAP: float = 2.0  # TUNING (not in GDD)
## Px walked per walk-strip frame (visual only).
const WALK_PX_PER_FRAME: float = 5.0  # TUNING (not in GDD)
## Seconds a hit flash lasts on an enemy (visual only).
const HIT_FLASH: float = 0.08  # TUNING (not in GDD)
## Minimum fraction (0..1) of a hit's damage that gets through flat armour.
const ARMOUR_MIN_FRACTION: float = 0.2  # TUNING (not in GDD)
## Slowest speed multiplier any stack of slows can reach (0..1).
const SLOW_FLOOR: float = 0.3  # TUNING (not in GDD)
## Free-upgrade credits a miniboss chest grants (each makes one upgrade or evolution free).
const CHEST_FREE_UPGRADES: int = 1  # GDD §3 "one free upgrade or an evolution"
## Multiplier on every freeze duration by enemy rank (bosses shrug freezes off faster).
const FREEZE_MULT: Dictionary = {"fodder": 1.0, "elite": 1.0, "miniboss": 0.6, "boss": 0.4}  # TUNING (not in GDD)
## Px around a piercing shot's target searched for the extra enemies it passes through.
const PIERCE_REACH: float = 40.0  # TUNING (not in GDD)
## Seconds a walking (not held, not frozen) enemy may stand still before the run counts it stuck.
const STUCK_TIME: float = 5.0  # TUNING (not in GDD)
## Px around a tap within which the nearest spot is picked.
const SPOT_PICK: float = 34.0  # TUNING (not in GDD) about a fingertip at phone scale
## Multiplier on every held enemy's attack on its blocker body (TdEnemy._fight):
## kind rows keep Necropathy-scaled damage, this makes the column a real threat
## to blockers so the Mender, the free respawn and Dread Rally's revive matter.
const BLOCKER_HIT_MULT: float = 2.0  # TUNING (not in GDD) 4 before the blocker HP fix (DECISIONS W2)
## Rank -> extra multiplier on a held enemy's blows on its body (DECISIONS X3):
## a post holds a miniboss longer, so it is a mid-map fight the towers finish
## instead of a walk to the gate. Missing ranks = 1.0.
const BLOCKER_HIT_RANK: Dictionary = {"miniboss": 0.6}  # TUNING (not in GDD)
## Rank -> px of road a "first"-targeting tower adds to an enemy's progress
## (DECISIONS X3): a slow miniboss or boss in range is shot before fodder up to
## this far ahead of it, instead of trailing the column untouched. Missing = 0.
const FIRST_RANK_BONUS: Dictionary = {"miniboss": 260.0, "boss": 260.0}  # TUNING (not in GDD)
## Wave HP ramp (integration balance): every non-boss, non-miniboss enemy (X3: a
## miniboss's row HP is its real HP) of map wave i
## (0-based, of n) gets HP x lerp(WAVE_HP_START, WAVE_HP_END, i / (n - 1)), so a
## map starts a little softer and its late waves press harder; Reckoning waves
## start from WAVE_HP_END and compound ReckoningData.HP_GROWTH on top.
const WAVE_HP_START: float = 0.75  # TUNING (not in GDD)
## See WAVE_HP_START.
const WAVE_HP_END: float = 2.4  # TUNING (not in GDD)
