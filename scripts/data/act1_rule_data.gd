## Act1RuleData: the numbers of the Act I map rules (GDD §7.2): the Crimson
## March's Holy Ward Generators and the Sanctum's sanctified chambers. The
## structures' own HP / shield rows are TdEnemyData "ward_generator" and
## "ward_crystal". Data only, no logic.
class_name Act1RuleData
extends RefCounted

## Crimson March: Holy Ward Generators. Each row: pos (map px beside a road; the
## generator stands on the nearest road's edge at that point), wave (raised
## when this wave starts, 1-based; 0 = from the start of the map).
const GENERATORS: Array[Dictionary] = [
	{"pos": Vector2(305, 190), "wave": 0},  # TUNING (not in GDD) L3: beside the north road's second chevron leg
	{"pos": Vector2(305, 530), "wave": 0},  # TUNING (not in GDD) L3: beside the south road's second chevron leg
	{"pos": Vector2(820, 400), "wave": 8},  # TUNING (not in GDD) beside the trunk
	{"pos": Vector2(620, 320), "wave": 14},  # TUNING (not in GDD) beside the trunk, north side
	{"pos": Vector2(745, 190), "wave": 19},  # TUNING (not in GDD) L3: beside the north road's fourth chevron leg
	{"pos": Vector2(745, 530), "wave": 19},  # TUNING (not in GDD) L3: beside the south road's fourth chevron leg
]

## Sanctum: the sanctified chambers. Each row: rect (map px; a tower whose spot
## lies inside deals CHAMBER_DAMAGE_MULT damage while any of its crystals
## stands), crystals (map px beside the road, one ward crystal each).
const CHAMBERS: Array[Dictionary] = [
	{"rect": Rect2(300, 60, 640, 190), "crystals": [Vector2(520, 160), Vector2(760, 160)]},  # TUNING (not in GDD) L3: around the north ambulatory
	{"rect": Rect2(150, 255, 620, 235), "crystals": [Vector2(420, 315), Vector2(620, 405)]},  # TUNING (not in GDD) L3: around the nave
]
## Damage multiplier of a tower inside an unbroken chamber.
const CHAMBER_DAMAGE_MULT: float = 0.75  # GDD §7.2 "deal 25% less"
## SpriteData-style floor tile drawn over a chamber's rect, and its tint (alpha = strength).
const CHAMBER_TILE: String = "tiles/sanctum_halls"  # TUNING (not in GDD) visual
## See CHAMBER_TILE: tint while the chamber is sanctified.
const CHAMBER_TINT: Color = Color(1.0, 0.85, 0.55, 0.7)  # TUNING (not in GDD) visual
## See CHAMBER_TILE: tint once its crystals are broken.
const CHAMBER_BROKEN_TINT: Color = Color(0.6, 0.6, 0.7, 0.35)  # TUNING (not in GDD) visual
