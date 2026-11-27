## Skid Row (Act IV map 1, Necropathy stage `skid_row`; GDD §7.3 the Last Line):
## the docks and alleys where the gangs own the blocks. Cramped alleys of small,
## irregular blocks: the west street dog-legs through short jogs and right turns
## to the gate in the east, and the north street drops straight down, crosses it
## at an intersection and meets it at a T-junction further on: 16 lots for
## towers, 5 road posts. The escalation stops at SWAT (Necropathy's owner ladder
## for this stage): gangs, then police from wave 7, SWAT from wave 14. Big Sal
## (miniboss, chest) on wave 12 with his armoured limo; Don Marrow, the Kingpin,
## on wave 22. Act rule: the escalation (rules/city/escalation.gd). Data only,
## no logic. MAP keys: graveyard_map.gd; "escalation" is the act rule's key
## (below).
extends RefCounted

## The map (keys: graveyard_map.gd). Extra key:
##   escalation — [first wave (1-based), tier id] pairs in order: the tier each
##                wave belongs to (city act rule; tier ids in the act's RULE "tiers").
const MAP: Dictionary = {
	"id": "skid_row",
	"name": "Skid Row",
	"floor": "tiles/city_plaza",
	"decals": ["decals/city_ac_unit", "decals/city_vent", "decals/city_hatch", "decals/city_water_tank", "decals/skid_row_footing"],
	"obstacles": [
		["tiles/city_roof_tenement", Vector2(100, 90)], ["tiles/city_roof_warehouse", Vector2(1180, 120)],
		["tiles/city_roof_tenement", Vector2(60, 620)], ["tiles/city_roof_warehouse", Vector2(300, 690)],
		["tiles/city_roof_tenement", Vector2(700, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 400), Vector2(140, 400), Vector2(140, 470), Vector2(380, 470), Vector2(380, 240),
				Vector2(600, 240), Vector2(600, 300), Vector2(820, 300), Vector2(820, 560), Vector2(1010, 560),
				Vector2(1010, 490), Vector2(1190, 490)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(500, -40), Vector2(500, 440), Vector2(820, 440)],
			"next": "main", "next_at": 1360.0,  # joins main at (820, 440)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 460),
	"plots": [
		Vector2(1080, 560), Vector2(660, 370), Vector2(430, 170), Vector2(740, 370), Vector2(910, 430), Vector2(70, 470),
		Vector2(910, 630), Vector2(140, 330), Vector2(580, 370), Vector2(310, 350), Vector2(570, 150), Vector2(1050, 420),
		Vector2(240, 390), Vector2(750, 530), Vector2(450, 510), Vector2(430, 90),
	],
	"posts": [Vector2(140, 413), Vector2(327, 470), Vector2(500, 175), Vector2(667, 300), Vector2(965, 560)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.9,  # TUNING (not in GDD) B4: 4.2 before the balance pass; L4: 3.6 before the road redraw; S3: 3.2 before the spot fix; Act IV map 1: a step above the Sanctum's ramp with the escalation on top
	"rule": "",
	"act_rule": "city/escalation",
	"escalation": [[1, "gangs"], [7, "police"], [14, "swat"]],  # Necropathy Skid Row: the ladder stops at SWAT
	"build_order": "skid_row_default",
	"weak_order": "skid_row_weak",
	"waves": [
		{"banner": "The gangs own these blocks", "groups": [{"kind": "street_thug", "count": 13, "spacing": 1.3}, {"kind": "street_thug", "count": 5, "spacing": 1.3, "delay": 6.0, "road": "north"}]},
		{"banner": "Gang Gunners shoot your blockers", "groups": [{"kind": "street_thug", "count": 10, "spacing": 1.1}, {"kind": "gang_gunner", "count": 3, "spacing": 1.4, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "gang_gunner", "count": 4, "spacing": 1.0}, {"kind": "street_thug", "count": 10, "spacing": 1.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "street_thug", "count": 16, "spacing": 0.8}, {"kind": "gang_gunner", "count": 3, "spacing": 1.2, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "street_thug", "count": 13, "spacing": 0.9, "road": "north"}, {"kind": "gang_gunner", "count": 4, "spacing": 1.0, "delay": 3.0}, {"kind": "street_thug", "count": 6, "spacing": 0.9, "delay": 8.0}]},
		{"banner": "An armoured limo: light blockers cannot stop it", "groups": [{"kind": "street_thug", "count": 14, "spacing": 0.7}, {"kind": "gang_gunner", "count": 6, "spacing": 0.9, "road": "north"}, {"kind": "armoured_limo", "count": 1, "spacing": 1.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 3, "spacing": 1.2}, {"kind": "street_thug", "count": 13, "spacing": 0.8, "road": "north"}]},
		{"banner": "Squad Cars run over weak blockers", "groups": [{"kind": "squad_car", "count": 2, "spacing": 6.0}, {"kind": "riot_cop", "count": 2, "spacing": 1.2, "road": "north"}, {"kind": "gang_gunner", "count": 4, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 4, "spacing": 1.1}, {"kind": "gang_gunner", "count": 6, "spacing": 0.9, "road": "north"}, {"kind": "squad_car", "count": 1, "spacing": 1.0, "delay": 10.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "street_thug", "count": 22, "spacing": 0.6}, {"kind": "street_thug", "count": 14, "spacing": 0.7, "road": "north"}, {"kind": "squad_car", "count": 2, "spacing": 5.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 4, "spacing": 1.1, "road": "north"}, {"kind": "squad_car", "count": 3, "spacing": 5.0}, {"kind": "gang_gunner", "count": 6, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "Big Sal and his crew", "groups": [{"kind": "big_sal", "count": 1, "spacing": 1.0}, {"kind": "street_thug", "count": 12, "spacing": 0.8, "delay": 4.0}, {"kind": "armoured_limo", "count": 1, "spacing": 1.0, "delay": 8.0, "road": "north"}, {"kind": "riot_cop", "count": 3, "spacing": 1.2, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 7, "spacing": 1.0}, {"kind": "squad_car", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "gang_gunner", "count": 10, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "SWAT: flashbangs blind your towers", "groups": [{"kind": "swat_breacher", "count": 2, "spacing": 5.0}, {"kind": "riot_cop", "count": 4, "spacing": 1.1, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "Field Medics patch the squad up", "groups": [{"kind": "swat_breacher", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "north"}, {"kind": "street_thug", "count": 20, "spacing": 0.6}]},
		{"banner": "", "groups": [{"kind": "squad_car", "count": 4, "spacing": 4.0}, {"kind": "riot_cop", "count": 5, "spacing": 1.0, "road": "north"}, {"kind": "swat_breacher", "count": 2, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "swat_breacher", "count": 3, "spacing": 4.0}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "gang_gunner", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 7, "spacing": 0.9}, {"kind": "squad_car", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 6.0}, {"kind": "swat_breacher", "count": 2, "spacing": 4.0, "delay": 10.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "street_thug", "count": 24, "spacing": 0.5}, {"kind": "gang_gunner", "count": 12, "spacing": 0.7, "road": "north"}, {"kind": "armoured_limo", "count": 2, "spacing": 6.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "swat_breacher", "count": 4, "spacing": 3.5}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "riot_cop", "count": 6, "spacing": 1.0, "road": "north"}, {"kind": "squad_car", "count": 3, "spacing": 4.0, "delay": 8.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 8, "spacing": 0.9}, {"kind": "swat_breacher", "count": 3, "spacing": 4.0, "road": "north"}, {"kind": "squad_car", "count": 4, "spacing": 4.0, "delay": 6.0}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 10.0, "road": "north"}]},
		{"banner": "Don Marrow puts a price on your head!", "groups": [{"kind": "don_marrow", "count": 1, "spacing": 1.0}, {"kind": "riot_cop", "count": 4, "spacing": 1.1, "delay": 4.0}, {"kind": "swat_breacher", "count": 3, "spacing": 4.0, "delay": 6.0, "road": "north"}, {"kind": "street_thug", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "north"}]},
	],
}
