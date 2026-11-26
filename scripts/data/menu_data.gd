## MenuData: layout numbers and fixed words of the Gravewatch menu screens
## (GDD §9.3: title, map select, pre-map setup, Ossuary, Codex, Settings,
## Credits, pause, results). Purely visual; data only, no logic. Every
## screen fits 1280 x 600 layout px (and TouchSupport.fit_to_screen() shrinks
## it further on a short phone screen).
class_name MenuData
extends RefCounted

## Title menu items, top to bottom: [id, button word, MaskIconData icon]. "quit" is hidden on the Web.
const TITLE_ITEMS: Array = [["play", "Play", "skull_crown"], ["codex", "Codex", "quill"], ["ossuary", "Ossuary", "icons/soul_ash"],
	["settings", "Settings", "candle"], ["credits", "Credits", "trophy"], ["quit", "Quit", "tomb"]]  # GDD §9.3; icons M5
## Size (px) of a title menu button.
const TITLE_BUTTON := Vector2(260.0, 44.0)  # TUNING (not in GDD) M5 (was 220 x 40)
## Size (px) of the title's Play button (first, larger, gold).
const TITLE_PLAY := Vector2(300.0, 56.0)  # TUNING (not in GDD) M5
## Layout px per art px of a title button's icon, and its inset (px) from the button's left edge.
const TITLE_ICON_SCALE: int = 2  # TUNING (not in GDD) M5
## See TITLE_ICON_SCALE.
const TITLE_ICON_INSET: float = 14.0  # TUNING (not in GDD) M5
## Size (px) of a title button's icon when it is a sprite icon ("icons/..." in TITLE_ITEMS).
const TITLE_SPRITE_ICON: float = 30.0  # TUNING (not in GDD) M5
## Gap (px) between the title column's rows.
const TITLE_GAP: int = 8  # TUNING (not in GDD) M5
## Width (design px) and alpha (0-1) of the dark band the backdrop draws behind the title column.
const TITLE_BAND_DARK_W: float = 420.0  # TUNING (not in GDD) M5
## See TITLE_BAND_DARK_W.
const TITLE_BAND_ALPHA: float = 0.6  # TUNING (not in GDD) M5
## Title progress plaque: icon scale (layout px per art px) and the gap (px) between stats.
const PLAQUE_ICON_SCALE: int = 2  # TUNING (not in GDD) M5
## See PLAQUE_ICON_SCALE.
const PLAQUE_GAP: int = 28  # TUNING (not in GDD) M5
## Size (px) the logo is drawn at (the 250 x 124 art at 2x).
const LOGO_SIZE := Vector2(500.0, 248.0)  # TUNING (not in GDD)

## Width (px) of the content column of a standard screen panel.
const PANEL_WIDTH: float = 960.0  # TUNING (not in GDD)
## Size (px) of a screen's Back / Start buttons.
const NAV_BUTTON := Vector2(140.0, 40.0)  # TUNING (not in GDD)
## --- Shared frame (menu overhaul, DECISIONS M4) ---------------------------------
## Margin (px) between the screen edge and the header / content / hints.
const SCREEN_MARGIN: float = 12.0  # TUNING (not in GDD) M4
## Size (px) of the header's Back button (and of the matching right column).
const BACK_BUTTON := Vector2(150.0, 48.0)  # TUNING (not in GDD) M4: 48 px = ~31 CSS px tall at 844x390, wide for a thumb
## Minimum width (px) of the header's title band.
const TITLE_BAND_W: float = 420.0  # TUNING (not in GDD) M4
## Size (px) of the Soul Ash icon in the header pill.
const ASH_ICON: float = 28.0  # TUNING (not in GDD) M4
## Minimum width (px) of the Soul Ash pill.
const ASH_PILL_W: float = 110.0  # TUNING (not in GDD) M4
## Room (px) kept above the content panel for its skull keystone (it rises 9 px).
const KEYSTONE_ROOM: float = 12.0  # TUNING (not in GDD) M4
## Default bottom hint strip of a screen: [[action(s), word], ...].
const DEFAULT_HINTS: Array = [["ui_accept", "Select"], ["ui_cancel", "Back"]]  # TUNING (not in GDD) M4
## Size (px) of a tab button (Codex, Settings, Credits, map select parts).
const TAB_BUTTON := Vector2(150.0, 44.0)  # TUNING (not in GDD) M4
## Gap (px) between tab buttons.
const TAB_GAP: int = 6  # TUNING (not in GDD) M4

## Gap (px) between rows of a screen.
const ROW_GAP: int = 10  # TUNING (not in GDD)

## Map select: size (px) of one map card (three in a row; M6: was 290 x 230 text only).
const MAP_CARD := Vector2(372.0, 300.0)  # TUNING (not in GDD) M6
## Map select: inner padding (px) of a card and the gap (px) between cards.
const MAP_CARD_PAD: int = 10  # TUNING (not in GDD) M6
## See MAP_CARD_PAD.
const MAP_CARD_GAP: int = 14  # TUNING (not in GDD) M6
## Map select: size (px) of a card's picture (the thumbnail is cropped to cover it).
const THUMB_SIZE := Vector2(344.0, 168.0)  # TUNING (not in GDD) M6
## Path of a map's pre-rendered picture ("%s" = map id; tools/gw_map_thumbs.sh, lossy WebP in the pack).
const THUMB_PATH: String = "res://assets/thumbs/%s.jpg"
## Modulate of a locked map's picture, and the colour shown when a map has no picture yet.
const THUMB_LOCKED: Color = Color(0.34, 0.31, 0.42)  # TUNING (not in GDD) M6
## See THUMB_LOCKED.
const THUMB_EMPTY: Color = Color(0.07, 0.05, 0.11)  # TUNING (not in GDD) M6
## Boss on a card: the box (px) its sprite is scaled into (whole steps when it grows),
## its feet's inset (px) from the picture's right and bottom edges, and its shadow's tint.
const BOSS_MAX := Vector2(130.0, 120.0)  # TUNING (not in GDD) M6
## See BOSS_MAX.
const BOSS_RIGHT: float = 70.0  # TUNING (not in GDD) M6
## See BOSS_MAX.
const BOSS_BOTTOM: float = 10.0  # TUNING (not in GDD) M6
## See BOSS_MAX.
const BOSS_SHADOW: Color = Color(0.0, 0.0, 0.0, 0.75)  # TUNING (not in GDD) M6
## Modulate of a locked map's boss (a black silhouette: not met yet).
const BOSS_LOCKED: Color = Color(0.03, 0.02, 0.05, 0.9)  # TUNING (not in GDD) M6
## Ribbon words of a map's place in its act ("%d" = 1-based), the last map's word.
const MAP_PLACE: String = "Map %d"  # TUNING (not in GDD) M6
## See MAP_PLACE.
const MAP_PLACE_FINALE: String = "Finale"  # TUNING (not in GDD) M6
## Scale (layout px per art px) of the padlock on a locked card.
const LOCK_SCALE: int = 4  # TUNING (not in GDD) M6
## Map cards: MaskIconData icon per difficulty, its scale, the skull size (px), the gap (px) between groups.
const DIFF_ICONS: Dictionary = {"initiate": "candle", "necromancer": "skull", "lich": "lich", "deathlord": "deathlord"}  # TUNING (not in GDD) M6 (Necropathy's difficulty icons)
## See DIFF_ICONS.
const DIFF_ICON_SCALE: int = 2  # TUNING (not in GDD) M6
## See DIFF_ICONS.
const SKULL_SMALL: float = 14.0  # TUNING (not in GDD) M6
## See DIFF_ICONS.
const SKULL_GROUP_GAP: int = 12  # TUNING (not in GDD) M6
## Map select: size (px) of a Part tab, its word ("%s" = numeral) and an act tab's numeral line.
const PART_TAB := Vector2(150.0, 44.0)  # TUNING (not in GDD) M6
## See PART_TAB.
const PART_WORD: String = "Part %s"  # TUNING (not in GDD) M6
## See PART_TAB.
const ACT_WORD: String = "Act %s"  # TUNING (not in GDD) M6
## Size (px) of a skull mark on the map cards and results.
const SKULL: float = 20.0  # TUNING (not in GDD)
## The 16 x 16 skull mark of the skull ratings (bone, tinted gold when earned).
const SKULL_ICON: String = "res://assets/sprites/td/icon_skull.png"
## Results: size (px) of a skull of the rating.
const SKULL_BIG: float = 40.0  # TUNING (not in GDD)

## Pre-map setup: size (px) of a character tile, a spell / ultimate tile. The
## characters and the spells each sit in ONE horizontally scrolling strip
## (DECISIONS Z8), so the tiles keep this size however many entries there are:
## on an 844 x 390 phone (about 1.54 layout px per CSS px) a character tile is
## about 80 x 73 CSS px with a 47 px portrait, a spell tile 95 x 60 with a 34 px icon.
const CHAR_TILE := Vector2(124.0, 112.0)  # TUNING (not in GDD) Z8 (118 x 112 in a shrinking grid before); fits "Plague Scholar"
## See CHAR_TILE.
const SPELL_TILE := Vector2(146.0, 92.0)  # TUNING (not in GDD) wide enough for "Corpse Explosion" (W4); Z8: 84 -> 92 tall
## Pre-map strips: width (px) of the scrolling window of a strip (between its arrows).
const STRIP_WIDTH: float = 880.0  # TUNING (not in GDD) Z8
## Height (px) added under a strip's tiles for its horizontal scroll bar.
const STRIP_BAR: float = 14.0  # TUNING (not in GDD) Z8
## Size (px) of a strip's scroll arrow button (beside the window, tile height).
const STRIP_ARROW_W: float = 36.0  # TUNING (not in GDD) Z8
## Fraction of the window one arrow press scrolls by.
const STRIP_PAGE: float = 0.8  # TUNING (not in GDD) Z8
## Gap (px) between two tiles of a strip.
const STRIP_GAP: int = 8  # TUNING (not in GDD) Z8
## Size (px) of a pre-map ultimate tile (four beside the difficulties; gw2-kit).
const ULT_TILE := Vector2(104.0, 84.0)  # TUNING (not in GDD)

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
## Map select: size (px) of one act tab (numeral over name; one part's five acts in a row; M6: was 52 x 38, numeral only).
const ACT_TAB := Vector2(218.0, 58.0)  # TUNING (not in GDD) M6
## Map select: gap (px) between act tabs.
const ACT_TAB_GAP: int = 6  # TUNING (not in GDD) M6
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
