## Fort Kessler (Act IV map 2, Necropathy stage `fort_kessler`; GDD §7.3 the
## Last Line): the army's checkpoint city. A star fort: the main street comes in
## from the west and follows the zig-zag bastion perimeter (a six-pointed star)
## almost all the way round, then cuts in to the command post at the centre; the
## north road drops past the barracks onto the first bastion: 15 lots, 6 road
## posts. The full ladder short of the heroes: gangs, police from wave 4, SWAT
## from 8, the army from 12 (riflemen, machine gunners, tanks, helicopters). The
## Mammoth (miniboss, chest) on wave 14; General Harrow, the Hammer, on wave 23.
## Act rule: the escalation. Data only, no logic. MAP keys: graveyard_map.gd (+
## "escalation", skid_row_map.gd).
extends RefCounted

## The map (keys: graveyard_map.gd, "escalation" as skid_row_map.gd).
const MAP: Dictionary = {
	"id": "fort_kessler",
	"name": "Fort Kessler",
	"floor": "tiles/city_plaza",
	"decals": ["decals/fk_sandbags", "decals/city_vent", "decals/city_hatch", "decals/city_ac_unit"],
	"obstacles": [
		["tiles/city_roof_bunker", Vector2(60, 140)], ["tiles/city_roof_warehouse", Vector2(1210, 560)],
		["tiles/city_roof_bunker", Vector2(1200, 690)], ["tiles/city_roof_warehouse", Vector2(200, 700)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 380), Vector2(312, 380), Vector2(478, 292), Vector2(501, 146), Vector2(690, 205),
				Vector2(879, 146), Vector2(902, 292), Vector2(1068, 380), Vector2(902, 468), Vector2(879, 614),
				Vector2(690, 555), Vector2(501, 614), Vector2(600, 420)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(380, -40), Vector2(380, 120), Vector2(478, 292)],
			"next": "main", "next_at": 539.5,  # joins main at (478, 292)
			"entrance": true,
		},
	},
	"gate": Vector2(611, 393),
	"plots": [
		Vector2(740, 480), Vector2(360, 250), Vector2(590, 270), Vector2(730, 110), Vector2(450, 80), Vector2(1000, 250),
		Vector2(890, 380), Vector2(820, 250), Vector2(480, 460), Vector2(660, 480), Vector2(990, 520), Vector2(220, 310),
		Vector2(820, 480), Vector2(140, 310), Vector2(440, 540),
	],
	"posts": [Vector2(147, 380), Vector2(410, 328), Vector2(380, 52), Vector2(892, 229), Vector2(745, 572), Vector2(545, 528)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.1,  # TUNING (not in GDD)L4: 3.1 before the road redraw; 
	"rule": "",
	"act_rule": "city/escalation",
	"escalation": [[1, "gangs"], [4, "police"], [8, "swat"], [12, "army"]],  # Necropathy Fort Kessler: the ladder stops at the army
	"build_order": "fort_kessler_default",
	"weak_order": "fort_kessler_weak",
	"waves": [
		{"banner": "Fort Kessler: the last checkpoint", "groups": [{"kind": "street_thug", "count": 12, "spacing": 1.1}, {"kind": "gang_gunner", "count": 4, "spacing": 1.3, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "street_thug", "count": 10, "spacing": 1.0, "road": "north"}, {"kind": "gang_gunner", "count": 6, "spacing": 1.1, "delay": 2.0}, {"kind": "street_thug", "count": 6, "spacing": 1.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "gang_gunner", "count": 8, "spacing": 1.0}, {"kind": "street_thug", "count": 10, "spacing": 0.9, "road": "north"}]},
		{"banner": "The police arrive", "groups": [{"kind": "riot_cop", "count": 4, "spacing": 1.2}, {"kind": "squad_car", "count": 2, "spacing": 6.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 6, "spacing": 1.1, "road": "north"}, {"kind": "gang_gunner", "count": 8, "spacing": 0.9}, {"kind": "squad_car", "count": 2, "spacing": 5.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "squad_car", "count": 3, "spacing": 5.0}, {"kind": "riot_cop", "count": 6, "spacing": 1.0, "road": "north"}, {"kind": "street_thug", "count": 10, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 7, "spacing": 1.0}, {"kind": "squad_car", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "gang_gunner", "count": 8, "spacing": 0.9, "delay": 4.0, "road": "north"}]},
		{"banner": "SWAT breaches the line", "groups": [{"kind": "swat_breacher", "count": 3, "spacing": 5.0}, {"kind": "riot_cop", "count": 6, "spacing": 1.1, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "swat_breacher", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "north"}, {"kind": "riot_cop", "count": 7, "spacing": 1.0}, {"kind": "squad_car", "count": 2, "spacing": 5.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "squad_car", "count": 4, "spacing": 4.0}, {"kind": "swat_breacher", "count": 3, "spacing": 4.0, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 8.0}, {"kind": "street_thug", "count": 16, "spacing": 0.6, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "riot_cop", "count": 8, "spacing": 1.0}, {"kind": "swat_breacher", "count": 4, "spacing": 4.0, "road": "north"}, {"kind": "field_medic", "count": 3, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "The army takes the streets", "groups": [{"kind": "city_conscript", "count": 16, "spacing": 0.7}, {"kind": "city_rifleman", "count": 3, "spacing": 1.4, "road": "north"}]},
		{"banner": "Tanks: only heavy blockers hold them", "groups": [{"kind": "city_rifleman", "count": 5, "spacing": 1.2}, {"kind": "city_conscript", "count": 12, "spacing": 0.8, "road": "north"}, {"kind": "city_tank", "count": 1, "spacing": 1.0, "delay": 10.0}]},
		{"banner": "The Mammoth rolls out", "groups": [{"kind": "mammoth", "count": 1, "spacing": 1.0}, {"kind": "city_rifleman", "count": 4, "spacing": 1.2, "delay": 4.0}, {"kind": "city_conscript", "count": 14, "spacing": 0.8, "road": "north"}]},
		{"banner": "Helicopters fly over the blockers", "groups": [{"kind": "attack_helicopter", "count": 2, "spacing": 4.0}, {"kind": "city_conscript", "count": 16, "spacing": 0.7, "road": "north"}, {"kind": "city_rifleman", "count": 3, "spacing": 1.2, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 1, "spacing": 8.0}, {"kind": "city_machine_gunner", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "city_conscript", "count": 16, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "city_rifleman", "count": 7, "spacing": 1.0}, {"kind": "attack_helicopter", "count": 3, "spacing": 4.0, "road": "north"}, {"kind": "field_medic", "count": 2, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 1, "spacing": 8.0, "road": "north"}, {"kind": "city_machine_gunner", "count": 3, "spacing": 4.0}, {"kind": "city_conscript", "count": 18, "spacing": 0.6}, {"kind": "swat_breacher", "count": 3, "spacing": 4.0, "delay": 6.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "city_conscript", "count": 24, "spacing": 0.5}, {"kind": "city_rifleman", "count": 6, "spacing": 0.9, "road": "north"}, {"kind": "city_tank", "count": 1, "spacing": 8.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "attack_helicopter", "count": 4, "spacing": 3.0}, {"kind": "city_machine_gunner", "count": 3, "spacing": 4.0, "road": "north"}, {"kind": "city_rifleman", "count": 5, "spacing": 1.0, "delay": 4.0}, {"kind": "field_medic", "count": 3, "spacing": 4.0, "delay": 10.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 2, "spacing": 7.0}, {"kind": "city_rifleman", "count": 8, "spacing": 0.9, "road": "north"}, {"kind": "city_machine_gunner", "count": 3, "spacing": 4.0, "delay": 8.0}, {"kind": "city_conscript", "count": 16, "spacing": 0.6, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "city_conscript", "count": 20, "spacing": 0.6}, {"kind": "city_rifleman", "count": 7, "spacing": 0.9, "road": "north"}, {"kind": "attack_helicopter", "count": 3, "spacing": 4.0, "delay": 6.0}, {"kind": "city_tank", "count": 1, "spacing": 8.0, "delay": 10.0, "road": "north"}]},
		{"banner": "General Harrow takes command!", "groups": [{"kind": "harrow", "count": 1, "spacing": 1.0}, {"kind": "city_rifleman", "count": 4, "spacing": 1.2, "delay": 4.0}, {"kind": "city_tank", "count": 1, "spacing": 1.0, "delay": 10.0, "road": "north"}, {"kind": "city_conscript", "count": 12, "spacing": 0.7, "road": "north"}]},
	],
}
