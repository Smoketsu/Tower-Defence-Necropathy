## Fort Kessler (Act IV map 2, Necropathy stage `fort_kessler`; GDD §7.3 the
## Last Line): the army's checkpoint city. The main street winds in from the
## south-west, the north road drops past the barracks and joins it on the
## last climb, which runs up past the airfield to the gate in the north-east:
## 15 lots, 6 road posts. The full ladder short of the heroes: gangs, police
## from wave 4, SWAT from 8, the army from 12 (riflemen, machine gunners,
## tanks, helicopters). The Mammoth (miniboss, chest) on wave 14; General
## Harrow, the Hammer, on wave 23. Act rule: the escalation. Data only, no
## logic. MAP keys: graveyard_map.gd (+ "escalation", skid_row_map.gd).
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
			"points": [Vector2(-40, 600), Vector2(260, 600), Vector2(260, 360), Vector2(640, 360), Vector2(640, 620),
				Vector2(960, 620), Vector2(960, 200), Vector2(1190, 200)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(380, -40), Vector2(380, 240), Vector2(800, 240), Vector2(800, 500), Vector2(960, 500)],
			"next": "main", "next_at": 1620.0, "entrance": true,  # joins main at (960, 500)
		},
	},
	"gate": Vector2(1218, 170),
	"plots": [
		Vector2(150, 480), Vector2(370, 470), Vector2(530, 470), Vector2(195, 330), Vector2(520, 150),
		Vector2(700, 160), Vector2(720, 440), Vector2(880, 380), Vector2(880, 560), Vector2(1060, 320),
		Vector2(1060, 500), Vector2(810, 690), Vector2(500, 300), Vector2(1100, 90), Vector2(60, 520),
	],
	"posts": [Vector2(130, 600), Vector2(260, 480), Vector2(380, 120), Vector2(640, 500), Vector2(960, 400), Vector2(1080, 200)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.1,  # TUNING (not in GDD)
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
