## TdArtData: the one table mapping each Gravewatch-only art role (road, plots,
## posts, gate, entrance, range ring, HUD icons, logo) to its PNG. Swapping art
## is a one-line change here. Every path is grid pixel art drawn 1 art px =
## 1 layout px through the sharp-pixel shader (TdArt). A role whose file is
## missing draws a plain code fallback (TdArt callers), so art can lag code.
## The Necropathy sprites (units, floors, obstacles) keep their SpriteData keys.
## Data only, no logic.
class_name TdArtData
extends RefCounted

## Folder of the Gravewatch art (copied from the art pipeline's out/ folder).
const ROOT: String = "res://assets/sprites/td/"

## Role -> PNG path. Sizes are the art's own (art px = layout px).
const ROLES: Dictionary = {
	"road_fill": ROOT + "road_fill.png",  # 48x48 seamless flagstone, tiled in world space under every road
	"road_edge": ROOT + "road_edge.png",  # 48x8 kerb strip, repeated along both road edges
	"plot_empty": ROOT + "plot_empty.png",  # 56x56 open grave: "build here"
	"plot_occupied": ROOT + "plot_occupied.png",  # 56x56 grave base under a raised tower
	"road_post": ROOT + "road_post.png",  # 56x40 bone stakes across the road (blocker spot)
	"gate_intact": ROOT + "gate_intact.png",  # 120x120 Ossuary gate, lives above GATE_DAMAGED_FRAC
	"gate_damaged": ROOT + "gate_damaged.png",  # 120x120 gate, lives above GATE_BROKEN_FRAC
	"gate_broken": ROOT + "gate_broken.png",  # 120x120 gate, lives at or below GATE_BROKEN_FRAC
	"entrance": ROOT + "entrance.png",  # 96x96 Covenant banner arch at a road start
	"range_ring": ROOT + "range_ring.png",  # 256x256 grey ring mask, scaled to the range and tinted
	"synergy_link": ROOT + "synergy_link.png",  # 32x8 grey link mask, stretched between two towers and tinted
	"icon_lives": ROOT + "icon_lives.png",  # 32x32 HUD icons from here on
	"icon_souls": ROOT + "icon_souls.png",
	"icon_wave": ROOT + "icon_wave.png",
	"icon_speed": ROOT + "icon_speed.png",
	"icon_call": ROOT + "icon_call.png",
	"icon_sell": ROOT + "icon_sell.png",
	"icon_upgrade": ROOT + "icon_upgrade.png",
	"icon_evolve": ROOT + "icon_evolve.png",
	"icon_target_first": ROOT + "icon_target_first.png",
	"icon_target_last": ROOT + "icon_target_last.png",
	"icon_target_strongest": ROOT + "icon_target_strongest.png",
	"icon_target_nearest": ROOT + "icon_target_nearest.png",
	"logo": ROOT + "logo_gravewatch.png",  # 250x124 NECROPATHY logo with the Gravewatch subtitle
	"vfx_slash": ROOT + "vfx_slash.png",  # 6 frames of 48x48 grey sword crescent facing +x, tinted (tools/vfx_art.py)
	"vfx_streak": ROOT + "vfx_streak.png",  # 32x8 white trail mask, opaque at +x, stretched behind shots
	"vfx_status": ROOT + "vfx_status.png",  # 7 status icons of 9x9: burning, rot, cursed, slowed, frozen, weakened, charmed
	"vfx_crack": ROOT + "vfx_crack.png",  # 44x20 ground crack (Abomination smash, boulder impact)
	"mood_lantern": ROOT + "mood_lantern.png",  # 28x40 lit stone lantern (Necropathy obstacles/stone_lantern_lit), Graveyard mood
	"mood_fire": ROOT + "mood_fire.png",  # 8 frames of 32x32 lit brazier (Necropathy norse/brazier_lit_anim), Crimson March campfires
	"mood_candles": ROOT + "mood_candles.png",  # 20x30 lit candle cluster with flames (generated, V17), Sanctum mood, drawn 1:1
	"mood_candle_flame": ROOT + "mood_candle_flame.png",  # 9x5 flames over the candles (Necropathy menu/candle_flame)
	"mood_glass": ROOT + "mood_glass.png",  # 72x44 stained-glass light pool, drawn additively (tools/vfx_art.py)
	"shield_arc": ROOT + "shield_arc.png",  # 12x30 bronze shield arc facing +x, drawn turned in front of every phalanx body (Act VIII, tools/pantheon_art.py)
}

## Lives fraction (0..1) above which the gate draws intact.
const GATE_DAMAGED_FRAC: float = 0.66  # TUNING (not in GDD)
## Lives fraction (0..1) at or below which the gate draws broken.
const GATE_BROKEN_FRAC: float = 0.25  # TUNING (not in GDD)
## Width (px) of a drawn road; the road_fill tile size, so one tile spans it.
const ROAD_WIDTH: float = 48.0  # TUNING (not in GDD) matches the 48 px road tiles
## Centre-line radius (px) of the drawn bend at each road joint (MapView.rounded(); drawing
## only, enemies walk the sharp polyline). Above half ROAD_WIDTH so the inner kerb never
## folds; a 90 degree bend then leaves the corner by 13 px, well inside the road.
const ROAD_TURN_RADIUS: float = 32.0  # TUNING (not in GDD)
## Max angle (degrees) per straight piece of a drawn bend (smaller = rounder, more polygons).
const ROAD_TURN_STEP_DEG: float = 7.5  # TUNING (not in GDD)
## Max length (px) of one drawn road piece: kerbs are cut there, so a kerb under another
## road's fill (a merge or crossing) is skipped piece by piece.
const ROAD_PIECE_PX: float = 8.0  # TUNING (not in GDD)
## Sprite key (SpriteData) of the necromancer drawn beside the gate.
const NECROMANCER: String = "player/necromancer"
## Offset (px) of the necromancer from the gate centre.
const NECROMANCER_OFFSET: Vector2 = Vector2(-30.0, 46.0)  # TUNING (not in GDD)
## Sprite key of the portrait-overlay phone art (copied RotateOverlay reads it).
const ROTATE_PHONE: String = "ui/rotate_phone"  # TUNING (not in GDD)
