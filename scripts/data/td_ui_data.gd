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
## Size of a tower icon in the spot menu (px).
const MENU_ICON: float = 32.0  # TUNING (not in GDD)
## Seconds a banner stays fully shown (real time), and its fade (s).
const BANNER_HOLD: float = 1.8  # TUNING (not in GDD)
## See BANNER_HOLD.
const BANNER_FADE: float = 0.4  # TUNING (not in GDD)
## Banner centre height (px from the top).
const BANNER_Y: float = 92.0  # TUNING (not in GDD)
## Colour of the dark cooldown sweep over a spell icon.
const SWEEP: Color = Color(0.0, 0.0, 0.0, 0.62)  # TUNING (not in GDD)
## Colour of the ultimate meter fill (soul-teal, GDD §9 colour meaning).
const METER: Color = Color(0.35, 0.95, 0.8, 0.45)  # TUNING (not in GDD)
## Minimum height (px) of a spot-menu button (a fingertip at phone scale).
const MENU_BUTTON_H: float = 40.0  # TUNING (not in GDD)
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
