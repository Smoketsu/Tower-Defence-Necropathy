## SpotAuditData: the thresholds of the spot audit (SpotAudit, tools/spot_audit.tscn,
## DECISIONS S1-S2): what makes a grave plot or a road post a bad spot. Read by
## SpotAudit only; MapLoader.validate() fails a map with any flagged spot, so no map
## ships a plot from which no tower reaches the road. Data only, no logic.
class_name SpotAuditData
extends RefCounted

## Tower class whose level 1 range is the yardstick of a "typical" plot tower
## (printed beside the shortest-range one; flags use the shortest range).
const TYPICAL_TOWER: String = "archer"  # TUNING (not in GDD)
## Px/s of the standard fodder enemy (the Covenant Recruit's row speed) used to turn
## road px in range into seconds in range.
const FODDER_SPEED: float = 52.0  # TUNING (not in GDD) TdEnemyData "recruit" speed
## Weak plot: the shortest-range plot tower (the Banshee, 115 px) at level 1 covers
## less than this many px of real road (all roads summed): 52 px is 1 s of fodder
## walking, under the Banshee's 1.5 s wail interval, so a fodder can cross its ring
## untouched. Such a spot only suits the long-range classes.
const WEAK_PX: float = 52.0  # TUNING (not in GDD) 1 s x FODDER_SPEED
## Px between road samples (coverage is exact per segment; samples only serve the
## footprint and spell-bar tests).
const SAMPLE_STEP: float = 6.0  # TUNING (not in GDD)

## --- Footprint (what a built tower covers on screen) ---------------------------

## Half width (px) of a plot's footprint: the 56 px plot art (TdArtData plot_empty).
const FOOT_HALF: float = 28.0  # TUNING (not in GDD) 56 px plot art
## Too close: the road's drawn edge (half of TdArtData.ROAD_WIDTH) comes nearer than
## this many px to the plot art square (+-FOOT_HALF; 0 = touching: the tower's feet
## stand on the road). The tower's drawn body may rise over a road behind it.
const ROAD_MARGIN: float = 0.0  # TUNING (not in GDD)
## Too close: px between a plot and a road post's snapped point (the post mark is
## 70 x 34 px and its blocker bodies stand there, drawn x1.5).
const POST_CLEAR: float = 60.0  # TUNING (not in GDD)
## Crowded: two plots nearer than this (px, centre to centre) overlap their art.
const PLOT_CLEAR: float = 58.0  # TUNING (not in GDD) 56 px art + 2 px
## Crowded: px between a plot and the Ossuary gate (drawn ~96 px wide) or the start
## of an entrance road's on-screen part (the entrance arch).
const GATE_CLEAR: float = 80.0  # TUNING (not in GDD)
## Crowded: px between a plot and the on-screen point where an entrance road enters.
const ENTRANCE_CLEAR: float = 60.0  # TUNING (not in GDD)

## --- Covered (under the interface or off the map) ------------------------------

## Size (px) of the spell bar on a desktop (the three loadout spells + the ultimate,
## 64 px buttons 8 px apart; TdHud places it in the bottom slot covering the least road,
## mirrored here).
const SPELL_BAR: Vector2 = Vector2(280.0, 64.0)  # TUNING (not in GDD) 4 x 64 + 3 x 8 (SpellData.DEFAULT_LOADOUT is 3)
## Act HUD widget corner per act id ("tl" top-left under the top bar, "tr"
## top-right under it, "bl" bottom-left); acts not listed have none.
const WIDGET_CORNER: Dictionary = {
	"city": "tl", "pantheon": "tl", "inferno": "tl", "host": "tl", "eye": "tl", "empire": "tl", "primeval": "tl",  # TUNING (not in GDD) CLAUDE.md "HUD widgets of the acts"
	"court": "tr", "dynasty": "tr", "concord": "tr", "wild": "tr",  # TUNING (not in GDD)
	"shogunate": "bl", "norse": "bl",  # TUNING (not in GDD)
}
## Px room of an act's HUD widget from its corner (the widest cue, the Blood Moon's
## 240 x 44 box, plus its 10 px margin).
const WIDGET_BOX: Vector2 = Vector2(250.0, 60.0)  # TUNING (not in GDD)
## Act id -> px band along the map's bottom edge drawn over by the act (the Black
## Tide's sea, corsair_act_data LOOK sea_h).
const BOTTOM_BAND: Dictionary = {"corsair": 44.0}  # TUNING (not in GDD)

## --- On a prop ------------------------------------------------------------------

## Obstacle art rects (MapView) are shrunk by this fraction on each side before the
## footprint test (the art has clear margins).
const OBSTACLE_SHRINK: float = 0.2  # TUNING (not in GDD)
## Px between a plot and a point-like act object (lantern, brazier, rune-stone, jar,
## portal, pit, rock, cannon, powder keg, structure).
const POINT_CLEAR: float = 40.0  # TUNING (not in GDD)
## MAP keys holding a list of act object points.
const MAP_POINTS: Array[String] = ["lanterns", "braziers", "rune_stones", "pits", "rocks"]  # TUNING (not in GDD)
## MAP keys holding [centre, radius] areas a plot must stay out of (tar seeps, the watering hole).
const MAP_AREAS: Array[String] = ["tar", "hole"]  # TUNING (not in GDD)

## --- Posts ----------------------------------------------------------------------

## Off road: an authored post farther than this (px) from its road (it snaps there,
## so the data is misleading).
const POST_SNAP: float = 24.0  # TUNING (not in GDD) half the road width
## Overlap: two posts on the same road nearer than this along it (px; the 70 px mark).
const POST_GAP: float = 70.0  # TUNING (not in GDD)
## Dead end: a post nearer than this to its road's start (an entrance) or off the
## visible map: enemies barely meet it there.
const POST_END: float = 40.0  # TUNING (not in GDD)
## Dead end: a post nearer than this to the end of a road that ends at the gate (it
## would stand inside the gate art). A last-ditch post just in front of the gate is fine.
const POST_GATE: float = 24.0  # TUNING (not in GDD) half the road width

## --- The fixer (tools/spot_audit.tscn -- --fix: proposes new places for flagged plots) ---

## Road px the shortest-range tower must cover at level 1 from a proposed new place:
## 110 px is ~2.1 s of fodder, more than one Banshee wail interval with room to spare
## (a plot ~100 px from a straight road), so a moved plot is a clear choice, not borderline.
const FIX_PX: float = 110.0  # TUNING (not in GDD)
## Px grid of the proposed places (round numbers in the map data).
const FIX_STEP: float = 5.0  # TUNING (not in GDD)
## Farthest (px) the fixer moves a plot; past it the plot is reported as unfixable.
const FIX_REACH: float = 260.0  # TUNING (not in GDD)
