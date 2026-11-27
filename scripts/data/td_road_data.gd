## TdRoadData: the themed road styles (DECISIONS R1-R3). A style is the pair of
## 48 x 48 seamless fill + 48 x 8 kerb PNGs under assets/sprites/td/roads/ (made by
## tools/gw_road_art.py) and optional wear colours. "" (no style) = the original
## grey flagstones (TdArtData road_fill / road_edge, TdMoodData wear).
## The one reader is MapRegistry.get_map(), which writes the result into the map's
## "road" key; MapView and TdArt only ever read that key. An act picks its style with the
## "road" key of its ActData row; a map that differs a lot (a finale, an indoor map) is
## listed in MAP_STYLES below, never in its map file. Act IV's streets are drawn by
## CityStreets and keep "". Data only, no logic except the path helper.
class_name TdRoadData
extends RefCounted

## Folder of the road tiles.
const ROOT: String = "res://assets/sprites/td/roads/"

## Style id -> optional wear colours (keys documented below; a missing key keeps the
## TdMoodData default): "shoulder" (Color, the worn band past the kerb), "rut" (Color,
## the two cart ruts), "cobble" (Color, the loose pebbles). Tiles: ROOT + id + "_fill.png"
## and ROOT + id + "_edge.png".
const STYLES: Dictionary = {
	"deck": {},  # TUNING (not in GDD)
	"cobble": {},  # TUNING (not in GDD)
	"carpet": {},  # TUNING (not in GDD)
	"earth": {},  # TUNING (not in GDD)
	"frost": {"rut": Color(0.2, 0.18, 0.15, 0.12), "cobble": Color(0.3, 0.27, 0.24, 0.35)},  # TUNING (not in GDD)
	"hall": {},  # TUNING (not in GDD)
	"sandstone": {"rut": Color(0.2, 0.18, 0.15, 0.12), "cobble": Color(0.3, 0.27, 0.24, 0.35)},  # TUNING (not in GDD)
	"marble": {"rut": Color(0.2, 0.18, 0.15, 0.12), "cobble": Color(0.3, 0.27, 0.24, 0.35)},  # TUNING (not in GDD)
	"ash_stone": {},  # TUNING (not in GDD)
	"basalt": {},  # TUNING (not in GDD)
	"cloud": {"rut": Color(0.2, 0.18, 0.15, 0.12), "cobble": Color(0.3, 0.27, 0.24, 0.35)},  # TUNING (not in GDD)
	"harbour": {},  # TUNING (not in GDD)
	"steel": {},  # TUNING (not in GDD)
	"hex": {},  # TUNING (not in GDD)
	"mud": {},  # TUNING (not in GDD)
	"moss_path": {},  # TUNING (not in GDD)
}

## Map id -> style id, beating its act's style (a finale, an indoor map). "" = flagstones.
const MAP_STYLES: Dictionary = {
	"castle_sanguis": "carpet",  # TUNING (not in GDD) the castle's indoor halls
	"valgard": "hall",  # TUNING (not in GDD) the feast hall (a timber-floored map)
	"underworld": "ash_stone",  # TUNING (not in GDD) grey ash, not Olympian marble
}


## The style id for map `map_id` of act style `act_style` ("" = flagstones).
static func style_for(map_id: String, act_style: String) -> String:
	return String(MAP_STYLES.get(map_id, act_style))


## PNG path of `part` ("fill" | "edge") of style `style`.
static func path(style: String, part: String) -> String:
	return ROOT + style + "_" + part + ".png"
