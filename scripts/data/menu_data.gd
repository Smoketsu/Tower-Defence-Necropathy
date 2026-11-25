## MenuData: layout numbers and fixed words of the Gravewatch menu screens
## (GDD §9.3: title, map select, pre-map setup, Ossuary, Codex, Settings,
## Credits, pause, results). Purely visual; data only, no logic. Every
## screen fits 1280 x 600 layout px (and TouchSupport.fit_to_screen() shrinks
## it further on a short phone screen).
class_name MenuData
extends RefCounted

## Title menu items, top to bottom: [id, button word]. "quit" is hidden on the Web.
const TITLE_ITEMS: Array = [["play", "Play"], ["codex", "Codex"], ["ossuary", "Ossuary"],
	["settings", "Settings"], ["credits", "Credits"], ["quit", "Quit"]]  # GDD §9.3
## Size (px) of a title menu button.
const TITLE_BUTTON := Vector2(220.0, 40.0)  # TUNING (not in GDD)
## Size (px) the logo is drawn at (the 250 x 124 art at 2x).
const LOGO_SIZE := Vector2(500.0, 248.0)  # TUNING (not in GDD)

## Width (px) of the content column of a standard screen panel.
const PANEL_WIDTH: float = 960.0  # TUNING (not in GDD)
## Size (px) of a screen's Back / Start buttons.
const NAV_BUTTON := Vector2(140.0, 40.0)  # TUNING (not in GDD)
## Gap (px) between rows of a screen.
const ROW_GAP: int = 10  # TUNING (not in GDD)

## Map select: size (px) of one map card.
const MAP_CARD := Vector2(290.0, 230.0)  # TUNING (not in GDD)
## Size (px) of a skull mark on the map cards and results.
const SKULL: float = 20.0  # TUNING (not in GDD)
## The 16 x 16 skull mark of the skull ratings (bone, tinted gold when earned).
const SKULL_ICON: String = "res://assets/sprites/td/icon_skull.png"
## Results: size (px) of a skull of the rating.
const SKULL_BIG: float = 40.0  # TUNING (not in GDD)

## Pre-map setup: size (px) of a character tile, a spell / ultimate tile.
const CHAR_TILE := Vector2(150.0, 118.0)  # TUNING (not in GDD)
## See CHAR_TILE.
const SPELL_TILE := Vector2(134.0, 84.0)  # TUNING (not in GDD)

## Ossuary: size (px) of an upgrade tile and of a mastery badge.
const OSSUARY_TILE := Vector2(300.0, 84.0)  # TUNING (not in GDD)
## See OSSUARY_TILE.
const MASTERY_ICON: float = 40.0  # TUNING (not in GDD)

## Codex: tab words per Meta.CODEX category.
const CODEX_TABS: Dictionary = {"towers": "Towers", "spells": "Spells", "enemies": "Foes", "bosses": "Bosses", "evolutions": "Evolutions"}  # TUNING (not in GDD)
## Codex: size (px) of an entry tile; the detail column width (px).
const CODEX_TILE := Vector2(72.0, 72.0)  # TUNING (not in GDD)
## See CODEX_TILE.
const CODEX_DETAIL_W: float = 300.0  # TUNING (not in GDD)
## Codex: tiles per row of the grid.
const CODEX_COLUMNS: int = 8  # TUNING (not in GDD)
## Modulate of an entry not met yet (a dark silhouette, GDD §8.3).
const SILHOUETTE: Color = Color(0.16, 0.12, 0.22, 1.0)  # TUNING (not in GDD)

## Settings tabs: [id, word].
const SETTINGS_TABS: Array = [["audio", "Audio"], ["video", "Video"], ["controls", "Controls"], ["save", "Save"]]  # TUNING (not in GDD)
## Settings: width (px) of a row's label column and of a slider.
const SETTINGS_LABEL_W: float = 220.0  # TUNING (not in GDD)
## See SETTINGS_LABEL_W.
const SLIDER_W: float = 320.0  # TUNING (not in GDD)

## Crimson text (danger / defeat / cannot afford, GDD §9 colour meaning).
const CRIMSON: Color = Color(0.95, 0.35, 0.35)  # TUNING (not in GDD)
## Soul-teal text (affordable / new, GDD §9 colour meaning).
const TEAL: Color = Color(0.35, 0.95, 0.8)  # TUNING (not in GDD)

## --- Act framework (gw2-acts) ---------------------------------------------------
## Map select: size (px) of one act tab (its numeral; 15 acts fit one row of the panel).
const ACT_TAB := Vector2(52.0, 38.0)  # TUNING (not in GDD)
## Map select: gap (px) between act tabs.
const ACT_TAB_GAP: int = 4  # TUNING (not in GDD)
## Map select: modulate of a locked act's tab (its first map not open yet).
const ACT_LOCKED: Color = Color(0.55, 0.5, 0.62, 0.8)  # TUNING (not in GDD)
## Map select: size (px) of the "Coming soon" panel of an act with no playable map.
const COMING_SOON := Vector2(600.0, 230.0)  # TUNING (not in GDD)
## Map select / Codex words.
const COMING_SOON_TEXT: String = "Coming soon"  # TUNING (not in GDD)
## Codex: the act filter's "every act" button word.
const CODEX_ALL_ACTS: String = "All"  # TUNING (not in GDD)
## Codex: size (px) of an act filter button.
const CODEX_ACT_TAB := Vector2(44.0, 32.0)  # TUNING (not in GDD)
