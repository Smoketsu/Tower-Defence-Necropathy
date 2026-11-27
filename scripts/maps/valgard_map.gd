## Valgard, the Hall of Heroes (Act VI map 2; Necropathy stage "valgard"): the
## planked hall of the slain, its long tables down the middle. The doors are in
## the east: the north and south roads run west along the hall's long walls (the
## benches), turn in at the far end and meet, and the trunk walks back east
## straight up the central aisle to the gate at the high seat. Each wave group
## picks an aisle, so the hall's centre plots cover both. 15 plots, 4 posts, 23
## waves. The Long Winter (act rule norse/long_winter): cold from wave 3, deeper
## from waves 9 and 15; six hearth braziers; two Rune-Stones by the doors. The
## Einherjar Champion (miniboss, chest) on wave 12; Sigrun, the Shield-Queen, on
## wave 23 (the Charge, the Holmgang duel with one post, the Doors of the Hall).
## Beating her unlocks Valkyrie Spear and the Shield-Maiden. Keys as
## graveyard_map.gd plus braziers / rune_stones (rules/norse/long_winter.gd).
## Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and long_winter.gd).
const MAP: Dictionary = {
	"id": "valgard",
	"name": "Valgard, the Hall of Heroes",
	"floor": "tiles/norse_planks",
	"decals": [],
	"obstacles": [
		["obstacles/long_table_l", Vector2(520, 300)], ["obstacles/long_table_l", Vector2(520, 420)],
		["obstacles/standing_shield_l", Vector2(60, 140)], ["obstacles/standing_shield_s", Vector2(60, 600)],
		["obstacles/long_table_s", Vector2(1040, 230)], ["obstacles/standing_shield_l", Vector2(1240, 200)],
		["obstacles/long_table_s_v", Vector2(1240, 90)], ["obstacles/standing_shield_s", Vector2(820, 80)],
	],
	"roads": {
		"north": {
			"points": [Vector2(1320, 130), Vector2(230, 130), Vector2(230, 360)],
			"next": "trunk", "next_at": 0.0,  # joins trunk at (230, 360)
			"entrance": true,
		},
		"south": {
			"points": [Vector2(1320, 590), Vector2(230, 590), Vector2(230, 360)],
			"next": "trunk", "next_at": 0.0,  # joins trunk at (230, 360)
			"entrance": true,
		},
		"trunk": {
			"points": [Vector2(230, 360), Vector2(1010, 360)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(1038, 330),
	"plots": [
		Vector2(970, 500), Vector2(570, 220), Vector2(650, 220), Vector2(170, 460), Vector2(930, 220), Vector2(440, 500),
		Vector2(530, 500), Vector2(690, 500), Vector2(330, 260), Vector2(370, 190), Vector2(330, 480), Vector2(850, 220),
		Vector2(800, 500), Vector2(1130, 190), Vector2(1130, 530),
	],
	"posts": [Vector2(659, 360), Vector2(373, 360), Vector2(568, 130), Vector2(559, 590)],
	"braziers": [Vector2(400, 245), Vector2(760, 245), Vector2(400, 475), Vector2(760, 475), Vector2(1110, 300), Vector2(1110, 420)],
	"rune_stones": [Vector2(110, 290), Vector2(110, 440)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.4,  # TUNING (not in GDD) L4: 1.9 before the road redraw; Part Two
	"rule": "",
	"act_rule": "norse/long_winter",
	"build_order": "valgard_default",
	"weak_order": "valgard_weak",
	"waves": [
		{"banner": "The doors of the hall open: raiders in both aisles", "groups": [{"kind": "norse_raider", "count": 7, "spacing": 1.2, "road": "north"}, {"kind": "norse_raider", "count": 6, "spacing": 1.2, "delay": 5.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_shield_maiden", "count": 3, "spacing": 2.2, "road": "south"}, {"kind": "norse_raider", "count": 7, "spacing": 1.0, "delay": 2.0, "road": "north"}]},
		{"banner": "Skalds sing the war-song: warriors near them march faster", "groups": [{"kind": "norse_skald", "count": 2, "spacing": 3.0, "road": "north"}, {"kind": "norse_raider", "count": 9, "spacing": 0.9, "delay": 1.0, "road": "north"}, {"kind": "norse_raider", "count": 5, "spacing": 1.0, "delay": 4.0, "road": "south"}]},
		{"banner": "Einherjar: the heroes of the hall rise once more when they fall", "groups": [{"kind": "norse_einherjar", "count": 4, "spacing": 2.0, "road": "south"}, {"kind": "norse_raider", "count": 8, "spacing": 0.9, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 3, "spacing": 2.5, "road": "north"}, {"kind": "norse_shield_maiden", "count": 5, "spacing": 1.6, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 1, "spacing": 4.0, "road": "south"}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_einherjar", "count": 5, "spacing": 1.8, "road": "north"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 1.0, "road": "south"}, {"kind": "norse_raider", "count": 8, "spacing": 0.9, "delay": 3.0, "road": "south"}]},
		{"banner": "Valkyries ride over the tables", "groups": [{"kind": "norse_valkyrie", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "norse_seer", "count": 3, "spacing": 2.2, "delay": 2.0, "road": "south"}, {"kind": "norse_raider", "count": 10, "spacing": 0.8, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_einherjar", "count": 6, "spacing": 1.5, "road": "south"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 2.0, "road": "north"}]},
		{"banner": "A frost giant breaks through the eastern doors", "groups": [{"kind": "norse_frost_giant", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "north"}, {"kind": "norse_raider", "count": 12, "spacing": 0.7, "delay": 3.0, "road": "north"}]},
		{"banner": "The Einherjar Champion: his horn wakes the feast!", "groups": [{"kind": "einherjar_champion", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "norse_einherjar", "count": 4, "spacing": 1.8, "delay": 4.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 2, "spacing": 3.0, "road": "south"}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "north"}, {"kind": "norse_raider", "count": 10, "spacing": 0.7, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 4, "spacing": 2.0, "road": "north"}, {"kind": "norse_einherjar", "count": 6, "spacing": 1.4, "delay": 2.0, "road": "south"}, {"kind": "norse_shield_maiden", "count": 5, "spacing": 1.5, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "road": "south"}, {"kind": "norse_skald", "count": 3, "spacing": 2.5, "delay": 2.0, "road": "north"}, {"kind": "norse_raider", "count": 12, "spacing": 0.7, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 3, "spacing": 3.0, "road": "south"}, {"kind": "norse_valkyrie", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "north"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.4, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_einherjar", "count": 8, "spacing": 1.2, "road": "north"}, {"kind": "norse_seer", "count": 4, "spacing": 2.0, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "road": "north"}, {"kind": "norse_raider", "count": 14, "spacing": 0.6, "delay": 2.0, "road": "south"}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 2.5, "road": "south"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "north"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_einherjar", "count": 8, "spacing": 1.2, "road": "south"}, {"kind": "norse_berserker", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "north"}, {"kind": "norse_seer", "count": 3, "spacing": 2.2, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 3, "spacing": 5.0, "road": "south"}, {"kind": "norse_valkyrie", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "north"}, {"kind": "norse_raider", "count": 14, "spacing": 0.6, "delay": 3.0, "road": "north"}]},
		{"banner": "Every bench of the hall empties", "groups": [{"kind": "norse_berserker", "count": 4, "spacing": 3.0, "road": "north"}, {"kind": "norse_einherjar", "count": 8, "spacing": 1.1, "delay": 2.0, "road": "south"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.3, "delay": 4.0, "road": "north"}]},
		{"banner": "Sigrun the Shield-Queen rides out with her valkyries!", "groups": [{"kind": "sigrun", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "norse_valkyrie", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "south"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.3, "delay": 8.0, "road": "south"}]},
	],
}
