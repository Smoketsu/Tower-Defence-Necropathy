## TdMoodData: the battlefield dressing of each map (DECISIONS V9-V12): its
## props (lanterns, campfires, banners, candles) with their glows, the
## Graveyard's drifting fog, the Sanctum's stained-glass light pools, the road
## wear, the vignette, the spot looks and the range ring. Purely visual: none
## of it collides or is read by the simulation. Read by MapMood, MapView, Spot
## and TdGame's overlay. Data only, no logic.
class_name TdMoodData
extends RefCounted

## Map id -> mood. Keys:
##   props — Array of prop rows (below), placed by MapMood at hashed free points.
##   fog   — fog bands drifting across the map (0 = none).
##   pools — stained-glass light pools (0 = none).
## Prop row keys:
##   art     — TdArtData role of its art; or sprite — a SpriteData key (drawn by SpriteBank.draw).
##   frames  — frames side by side in the art (1 = a still); animated at FIRE_FPS.
##   count   — how many are placed.
##   scale   — drawn size multiplier.
##   glow    — Color of its additive glow (alpha = strength); glow_r its radius (px), glow_at its offset (px).
##   flicker — glow flicker amplitude (0..1 of the radius and alpha).
##   flame   — TdArtData role drawn flickering over it ("" = none), at flame_at (px).
##   sway    — banner sway: horizontal scale amplitude (0 = still).
const MOODS: Dictionary = {
	"graveyard": {
		"props": [{"art": "mood_lantern", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.7, 0.3, 0.7), "glow_r": 64.0,
			"glow_at": Vector2(0, -24), "flicker": 0.08, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) lit lanterns, warm glow
		"fog": 4,  # TUNING (not in GDD) drifting ground fog
		"pools": 0,
	},
	"crimson_march": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.55, 0.2, 0.6), "glow_r": 70.0,
			"glow_at": Vector2(0, -6), "flicker": 0.22, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) campfires
			{"sprite": "markers/rally_pennant", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0, 0, 0, 0), "glow_r": 0.0,
			"glow_at": Vector2.ZERO, "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.12}],  # TUNING (not in GDD) Covenant banners
		"fog": 0,
		"pools": 0,
	},
	"sanctum": {
		"props": [{"art": "mood_candles", "frames": 1, "count": 8, "scale": 1.0, "glow": Color(1.0, 0.82, 0.45, 0.5), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) candles: generated 20x30 art with its own flames (V17), drawn 1:1, glow flickers
		"fog": 0,
		"pools": 5,  # TUNING (not in GDD) stained-glass light pools
	},
}

## --- Placement (a pure hash of the try index: the same every run) --------------

## Candidate points tried per map.
const PLACE_TRIES: int = 600  # TUNING (not in GDD)
## Px a prop keeps from a road centre line, a spot, an obstacle and another prop.
const CLEAR_ROAD: float = 48.0  # TUNING (not in GDD)
## See CLEAR_ROAD.
const CLEAR_SPOT: float = 50.0  # TUNING (not in GDD)
## See CLEAR_ROAD.
const CLEAR_OBSTACLE: float = 44.0  # TUNING (not in GDD)
## See CLEAR_ROAD.
const CLEAR_PROP: float = 140.0  # TUNING (not in GDD) spreads them over the map
## Map margins (px) props stay inside: left / right and top (under the HUD bar) / bottom.
const MARGIN_X: float = 40.0  # TUNING (not in GDD)
## See MARGIN_X.
const MARGIN_TOP: float = 80.0  # TUNING (not in GDD)
## See MARGIN_X.
const MARGIN_BOTTOM: float = 30.0  # TUNING (not in GDD)

## --- Animation -----------------------------------------------------------------

## Frames per second of animated props (campfires).
const FIRE_FPS: float = 10.0  # TUNING (not in GDD)
## Glow flicker speed (radians per s; two sines mixed).
const FLICKER_HZ: float = 9.0  # TUNING (not in GDD)
## Banner sway period (s).
const SWAY_PERIOD: float = 2.6  # TUNING (not in GDD)

## Fog banks: tint (alpha = density), puff height and width (px), drift speed
## (px/s) and puffs per bank.
const FOG_TINT: Color = Color(0.72, 0.82, 0.8, 0.12)  # TUNING (not in GDD)
## See FOG_TINT.
const FOG_H: float = 90.0  # TUNING (not in GDD)
## See FOG_TINT.
const FOG_W: float = 420.0  # TUNING (not in GDD)
## See FOG_TINT.
const FOG_SPEED: float = 9.0  # TUNING (not in GDD)
## See FOG_TINT.
const FOG_PUFFS: int = 5  # TUNING (not in GDD)

## Stained-glass pools: drawn scale, alpha, pulse period (s) and pulse amplitude (0..1).
const POOL_SCALE: float = 2.4  # TUNING (not in GDD)
## See POOL_SCALE.
const POOL_ALPHA: float = 0.4  # TUNING (not in GDD)
## See POOL_SCALE.
const POOL_PERIOD: float = 5.0  # TUNING (not in GDD)
## See POOL_SCALE.
const POOL_PULSE: float = 0.25  # TUNING (not in GDD)

## Vignette: depth of each edge band (fraction of the screen's width / height)
## and the alpha at the very edge.
const VIGNETTE_BAND: float = 0.14  # TUNING (not in GDD)
## See VIGNETTE_BAND.
const VIGNETTE_ALPHA: float = 0.5  # TUNING (not in GDD)

## --- Roads (MapView, drawn once) -----------------------------------------------------

## Worn shoulder: px it reaches past the road edge, and its colour.
const SHOULDER_PX: float = 9.0  # TUNING (not in GDD)
## See SHOULDER_PX.
const SHOULDER_TINT: Color = Color(0.05, 0.04, 0.03, 0.35)  # TUNING (not in GDD)
## Cart ruts: px from the centre line, width (px) and colour.
const RUT_OFFSET: float = 10.0  # TUNING (not in GDD)
## See RUT_OFFSET.
const RUT_W: float = 3.0  # TUNING (not in GDD)
## See RUT_OFFSET.
const RUT_TINT: Color = Color(0.1, 0.08, 0.06, 0.22)  # TUNING (not in GDD)
## Loose cobbles: hashed tries per road px, their size (px) and colour.
const COBBLE_PER_PX: float = 0.05  # TUNING (not in GDD)
## See COBBLE_PER_PX.
const COBBLE_PX: float = 3.0  # TUNING (not in GDD)
## See COBBLE_PER_PX.
const COBBLE_TINT: Color = Color(0.12, 0.1, 0.09, 0.4)  # TUNING (not in GDD)

## --- Spots and the range ring --------------------------------------------------------

## Empty plots pulse: brightness amplitude (fraction) and period (s, real time).
const PLOT_PULSE: float = 0.22  # TUNING (not in GDD)
## See PLOT_PULSE.
const PLOT_PULSE_PERIOD: float = 1.8  # TUNING (not in GDD)
## Road posts: a dark crimson ground mark under the stakes, size (px) and colour.
const POST_MARK: Vector2 = Vector2(70.0, 34.0)  # TUNING (not in GDD)
## See POST_MARK.
const POST_MARK_TINT: Color = Color(0.45, 0.06, 0.08, 0.55)  # TUNING (not in GDD)
## Range ring: fill alpha inside the ring and the ring's colour.
const RANGE_FILL_A: float = 0.1  # TUNING (not in GDD)
## See RANGE_FILL_A.
const RANGE_TINT: Color = Color(0.45, 1.0, 0.85, 0.95)  # TUNING (not in GDD)
