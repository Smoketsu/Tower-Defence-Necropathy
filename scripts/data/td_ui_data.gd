## TdUiData: layout numbers of the in-map interface (GDD §9.1): top bar,
## spell bar, spot menu, banners. Purely visual; data only, no logic.
class_name TdUiData
extends RefCounted

## Top bar height (layout px).
const TOP_BAR_H: float = 44.0  # TUNING (not in GDD)
## Size of a HUD icon (px; the 32 px Gravewatch icons are drawn 1:1).
const ICON: float = 32.0  # TUNING (not in GDD)
## Size of a spell / ultimate button (px, square).
const SPELL_BUTTON: float = 64.0  # TUNING (not in GDD) a fingertip on a phone
## Gap above the bottom edge for the spell bar (px).
const SPELL_BAR_MARGIN: float = 8.0  # TUNING (not in GDD)
## Size of the enemy sprites in the next-wave preview (px).
const PREVIEW_ICON: float = 28.0  # TUNING (not in GDD)
## Distance (px) from the tapped spot to the spot menu's near edge.
const MENU_OFFSET: float = 36.0  # TUNING (not in GDD)
## Spot menu: the far candidates sit this many MENU_OFFSETs further out, and a
## neighbouring spot counts as covered within this many tap radii of the menu.
const MENU_FAR: float = 1.5  # TUNING (not in GDD)
## See MENU_FAR.
const MENU_CLEAR: float = 1.4  # TUNING (not in GDD)
## Spot menu vs roads (DECISIONS X6): roads are sampled every MENU_ROAD_STEP map
## px and each sample under a candidate menu costs MENU_ROAD_COST (a covered
## neighbouring spot costs 1), so the menu opens off the road where it can.
const MENU_ROAD_STEP: float = 20.0  # TUNING (not in GDD)
## See MENU_ROAD_STEP.
const MENU_ROAD_COST: int = 2  # TUNING (not in GDD)
## Clearance (px) around the spell bar when it picks the slot covering the least
## road (TdHud._place_spell_bar, DECISIONS X6).
const SPELL_BAR_CLEAR: float = 12.0  # TUNING (not in GDD)
## Size of a tower icon on a spot-menu build tile (px).
const MENU_ICON: float = 40.0  # TUNING (not in GDD) M7 (was 32)
## Seconds a banner stays fully shown (real time), and its fade (s).
const BANNER_HOLD: float = 1.8  # TUNING (not in GDD)
## Most banners waiting behind the one showing; older ones are dropped so a
## line never shows long after its moment (back-to-back waves at x3).
const BANNER_QUEUE_MAX: int = 2  # TUNING (not in GDD)
## See BANNER_HOLD.
const BANNER_FADE: float = 0.4  # TUNING (not in GDD)
## Banner centre height as a fraction of the top bar's height: it sits in the
## middle of the bar, off the map's top road (DECISIONS V13).
const BANNER_BAR_FRAC: float = 0.5  # TUNING (not in GDD)
## Colour of the dark cooldown sweep over a spell icon.
const SWEEP: Color = Color(0.0, 0.0, 0.0, 0.62)  # TUNING (not in GDD)
## Colour of the ultimate meter fill (soul-teal, GDD §9 colour meaning).
const METER: Color = Color(0.35, 0.95, 0.8, 0.45)  # TUNING (not in GDD)
## Minimum height (px) of a spot-menu button (a fingertip at phone scale).
const MENU_BUTTON_H: float = 60.0  # TUNING (not in GDD) M7 (was 40): ~39 CSS px tall at 844 x 390
## Minimum size (px) of a top-bar button (a fingertip at phone scale).
const TOP_BUTTON := Vector2(64.0, 40.0)  # TUNING (not in GDD)
## Speed (px/s, map px) of the gamepad cursor while a spell is aimed.
const CURSOR_SPEED: float = 520.0  # TUNING (not in GDD)
## Half-angle (degrees) of the cone a stick flick searches for the next spot.
const CURSOR_CONE: float = 60.0  # TUNING (not in GDD)
## Colour of the gamepad cursor ring (gold = selection, GDD §9).
const CURSOR: Color = Color(1.0, 0.84, 0.4, 0.9)  # TUNING (not in GDD)
## Banner ribbon accents: a new enemy kind (violet) and a boss arrival (crimson).
const BANNER_NEW: String = "violet"  # TUNING (not in GDD)
## See BANNER_NEW.
const BANNER_BOSS: String = "crimson"  # TUNING (not in GDD)
## Spot menu build tiles per row, and one tile's size (px): icon, name, cost
## (DECISIONS Y8: one strip fits the gaps beside the roads; M7: roomier tiles,
## about 73 x 62 CSS px on an 844 x 390 phone).
const MENU_COLUMNS: int = 6  # TUNING (not in GDD) was 3: one strip
## See MENU_COLUMNS.
const MENU_TILE := Vector2(112.0, 96.0)  # TUNING (not in GDD) M7 (was 92 x 58; before Y8 140 x 82)
## Gap (px) between spot-menu tiles, pagers and button rows.
const MENU_GAP: int = 6  # TUNING (not in GDD) M7
## Spot menu page dots: size (px), gap (px), colour of a dot not shown (the shown one is gold).
const MENU_DOT := Vector2(14.0, 6.0)  # TUNING (not in GDD) M7
## See MENU_DOT.
const MENU_DOT_GAP: int = 6  # TUNING (not in GDD) M7
## See MENU_DOT.
const MENU_DOT_OFF: Color = Color(0.3, 0.26, 0.38)  # TUNING (not in GDD) M7
## Modulate of an unaffordable tile's icon.
const MENU_DIM: Color = Color(0.45, 0.45, 0.5)  # TUNING (not in GDD) M7
## Size (px) of the souls icon on a build tile's cost line.
const MENU_COST_ICON: float = 16.0  # TUNING (not in GDD) M7
## Built tower panel: its width (px), the header icon (px), a two-line button's icon (px), a level pip (px).
const MENU_TOWER_W: float = 320.0  # TUNING (not in GDD) M7
## See MENU_TOWER_W.
const MENU_HEAD_ICON: float = 44.0  # TUNING (not in GDD) M7
## See MENU_TOWER_W.
const MENU_ROW_ICON: float = 28.0  # TUNING (not in GDD) M7
## See MENU_TOWER_W.
const MENU_PIP := Vector2(12.0, 8.0)  # TUNING (not in GDD) M7
## Upgrade gains shown from TowerData.LEVELS: multiplier key -> word.
const MENU_GAIN_WORDS: Dictionary = {"damage": "dmg", "rate": "rate", "range": "range", "hp": "hp"}  # TUNING (not in GDD) M7
## Phones and tablets: top-bar and spell buttons are this much bigger (a thumb, GDD §9.3).
const TOUCH_SCALE: float = 1.35  # TUNING (not in GDD)
## Phones in landscape at least this wide (width / height) put the spell bar in a
## column in the free left margin instead of over the map's bottom spots.
const SIDE_SPELL_ASPECT: float = 1.95  # TUNING (not in GDD)
## Phones and tablets: top-bar buttons are this much bigger (about 40 CSS px tall on a phone).
const TOUCH_TOP_SCALE: float = 1.7  # TUNING (not in GDD)
## Build-menu tiles per page (gw2-kit): more open towers than this are paged
## (one strip of MENU_COLUMNS, phone landscape included).
const MENU_PAGE: int = 6  # TUNING (not in GDD)
## Size (px) of a build-menu page button at each end of the strip (a full tile tall).
const MENU_PAGER := Vector2(60.0, 96.0)  # TUNING (not in GDD) M7 (was 34 x 58): ~39 CSS px wide on a phone
## Z index of the map frame (TdGame._draw_frame: covers the screen beyond the
## map; above every world layer, under the HUD canvas layer), and how far (map
## px) it reaches past the map's edge.
const FRAME_Z: int = 4000  # TUNING (not in GDD) under RenderingServer.CANVAS_ITEM_Z_MAX
## See FRAME_Z.
const FRAME_REACH: float = 4000.0  # TUNING (not in GDD)
## Content margin (px) of the spot menu's frame (slim: the strip fits between road runs).
const MENU_PAD: float = 8.0  # TUNING (not in GDD)
