## Liberty Heights (Act IV map 3, the act's finale, Necropathy stage
## `liberty_heights`; GDD §7.3 the Last Line): the towers downtown where the
## army makes its last stand and the heroes come down. The avenue enters from
## the north-east, runs the whole skyline west, turns down and snakes back
## east to the gate; a side street climbs from the south, crosses the avenue
## and joins it in the plaza, so the central lots see three runs: 15 lots, 6 road posts. The army
## from wave 1, the heroes from wave 9 (Blitz, Aurora, Nightjar on the way);
## Atlas (miniboss, chest) on wave 13; the final wave is staged: Blitz,
## Aurora, Atlas and Nightjar, then Paragon, the Last Hero. Beating Paragon
## opens the Fallen Hero. Act rule: the escalation. Data only, no logic.
## MAP keys: graveyard_map.gd (+ "escalation", skid_row_map.gd).
extends RefCounted

## The map (keys: graveyard_map.gd, "escalation" as skid_row_map.gd).
const MAP: Dictionary = {
	"id": "liberty_heights",
	"name": "Liberty Heights",
	"floor": "tiles/city_plaza",
	"decals": ["decals/city_antenna", "decals/city_water_tank", "decals/city_ac_unit", "decals/city_vent"],
	"obstacles": [
		["tiles/city_roof_tower", Vector2(90, 80)], ["tiles/city_roof_tower", Vector2(1180, 400)],
		["tiles/city_roof_tenement", Vector2(120, 690)], ["tiles/city_roof_tower", Vector2(100, 560)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 140), Vector2(200, 140), Vector2(200, 600), Vector2(560, 600), Vector2(560, 320),
				Vector2(900, 320), Vector2(900, 600), Vector2(1190, 600)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(420, 760), Vector2(420, 460), Vector2(560, 460)],
			"next": "main", "next_at": 2080.0, "entrance": true,  # crosses the avenue at (420, 600), joins main at (560, 460)
		},
	},
	"gate": Vector2(1218, 570),
	"plots": [
		Vector2(330, 240), Vector2(480, 240), Vector2(700, 230), Vector2(1000, 230), Vector2(1150, 240),
		Vector2(300, 500), Vector2(480, 520), Vector2(640, 400), Vector2(800, 400), Vector2(800, 540),
		Vector2(640, 540), Vector2(1000, 500), Vector2(1050, 690), Vector2(100, 380), Vector2(330, 660),
	],
	"posts": [Vector2(700, 140), Vector2(200, 380), Vector2(300, 600), Vector2(560, 400), Vector2(420, 540), Vector2(900, 460)],
	"lives": 0,
	"souls": 450,  # TUNING (not in GDD)
	"wave_hp_end": 2.2,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "city/escalation",
	"escalation": [[1, "army"], [9, "heroes"]],  # Necropathy Liberty Heights: the army, then the heroes
	"build_order": "liberty_heights_default",
	"weak_order": "liberty_heights_weak",
	"waves": [
		{"banner": "Liberty Heights: the army's last stand", "groups": [{"kind": "city_conscript", "count": 14, "spacing": 1.0}, {"kind": "city_rifleman", "count": 2, "spacing": 1.4, "delay": 4.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "city_rifleman", "count": 4, "spacing": 1.2}, {"kind": "city_conscript", "count": 10, "spacing": 0.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "city_conscript", "count": 16, "spacing": 0.7}, {"kind": "city_rifleman", "count": 3, "spacing": 1.2, "road": "south"}, {"kind": "city_machine_gunner", "count": 1, "spacing": 1.0, "delay": 10.0}]},
		{"banner": "A tank: only heavy blockers hold it", "groups": [{"kind": "city_tank", "count": 1, "spacing": 1.0}, {"kind": "city_conscript", "count": 14, "spacing": 0.7, "delay": 4.0}, {"kind": "city_rifleman", "count": 3, "spacing": 1.2, "road": "south"}]},
		{"banner": "Blitz! Catch him with a blocker to expose him", "groups": [{"kind": "blitz", "count": 1, "spacing": 1.0}, {"kind": "city_conscript", "count": 16, "spacing": 0.7, "road": "south"}, {"kind": "city_rifleman", "count": 3, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "attack_helicopter", "count": 2, "spacing": 4.0}, {"kind": "city_rifleman", "count": 5, "spacing": 1.0, "road": "south"}, {"kind": "city_conscript", "count": 12, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 1, "spacing": 8.0}, {"kind": "city_machine_gunner", "count": 1, "spacing": 5.0, "road": "south"}, {"kind": "city_conscript", "count": 14, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "Aurora wards the heroes: cold breaks her", "groups": [{"kind": "aurora", "count": 1, "spacing": 1.0}, {"kind": "city_conscript", "count": 18, "spacing": 0.6, "road": "south"}, {"kind": "city_rifleman", "count": 4, "spacing": 1.0, "delay": 4.0}, {"kind": "attack_helicopter", "count": 1, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "Nightjar's smoke blinds towers: loud blasts break him", "groups": [{"kind": "city_rifleman", "count": 6, "spacing": 1.0}, {"kind": "city_tank", "count": 1, "spacing": 8.0, "road": "south"}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "city_machine_gunner", "count": 2, "spacing": 4.0}, {"kind": "city_conscript", "count": 20, "spacing": 0.6, "road": "south"}, {"kind": "attack_helicopter", "count": 2, "spacing": 4.0, "delay": 6.0}, {"kind": "blitz", "count": 1, "spacing": 1.0, "delay": 10.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 2, "spacing": 7.0}, {"kind": "city_rifleman", "count": 6, "spacing": 1.0, "road": "south"}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "city_conscript", "count": 24, "spacing": 0.5}, {"kind": "city_machine_gunner", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 6.0, "road": "south"}, {"kind": "attack_helicopter", "count": 2, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "Atlas throws cars: a shredded hide is his weakness", "groups": [{"kind": "atlas", "count": 1, "spacing": 1.0}, {"kind": "city_rifleman", "count": 5, "spacing": 1.1, "delay": 4.0}, {"kind": "city_tank", "count": 1, "spacing": 8.0, "road": "south"}, {"kind": "city_conscript", "count": 16, "spacing": 0.6, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "attack_helicopter", "count": 3, "spacing": 3.0}, {"kind": "blitz", "count": 1, "spacing": 1.0, "delay": 6.0}, {"kind": "city_rifleman", "count": 6, "spacing": 0.9, "road": "south"}, {"kind": "city_machine_gunner", "count": 2, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 2, "spacing": 7.0, "road": "south"}, {"kind": "aurora", "count": 1, "spacing": 1.0}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 6.0}, {"kind": "city_conscript", "count": 20, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "city_rifleman", "count": 8, "spacing": 0.9}, {"kind": "city_machine_gunner", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "attack_helicopter", "count": 2, "spacing": 4.0, "delay": 6.0}, {"kind": "blitz", "count": 1, "spacing": 1.0, "delay": 10.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 2, "spacing": 6.0}, {"kind": "city_conscript", "count": 24, "spacing": 0.5, "road": "south"}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 8.0, "road": "south"}, {"kind": "city_rifleman", "count": 5, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "nightjar", "count": 1, "spacing": 1.0}, {"kind": "blitz", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "city_conscript", "count": 26, "spacing": 0.5, "road": "south"}, {"kind": "attack_helicopter", "count": 2, "spacing": 4.0, "delay": 6.0}, {"kind": "city_tank", "count": 1, "spacing": 8.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "city_rifleman", "count": 9, "spacing": 0.8}, {"kind": "city_machine_gunner", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "city_tank", "count": 2, "spacing": 7.0, "delay": 6.0}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "city_conscript", "count": 30, "spacing": 0.4}, {"kind": "attack_helicopter", "count": 4, "spacing": 3.0, "road": "south"}, {"kind": "city_tank", "count": 2, "spacing": 7.0, "delay": 6.0}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 10.0, "road": "south"}, {"kind": "blitz", "count": 1, "spacing": 1.0, "delay": 12.0}]},
		{"banner": "", "groups": [{"kind": "city_tank", "count": 2, "spacing": 6.0}, {"kind": "city_rifleman", "count": 9, "spacing": 0.8, "road": "south"}, {"kind": "city_machine_gunner", "count": 2, "spacing": 4.0, "delay": 6.0}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 10.0}, {"kind": "attack_helicopter", "count": 2, "spacing": 4.0, "delay": 8.0, "road": "south"}]},
		{"banner": "No more heroes: Paragon comes down!", "groups": [{"kind": "blitz", "count": 1, "spacing": 1.0}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 5.0}, {"kind": "atlas", "count": 1, "spacing": 1.0, "delay": 10.0}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 15.0, "road": "south"}, {"kind": "paragon", "count": 1, "spacing": 1.0, "delay": 22.0}, {"kind": "city_conscript", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "south"}]},
	],
}
