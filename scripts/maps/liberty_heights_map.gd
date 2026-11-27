## Liberty Heights (Act IV map 3, the act's finale, Necropathy stage
## `liberty_heights`; GDD §7.3 the Last Line): the towers downtown where the
## army makes its last stand and the heroes come down. A grand grid: the avenue
## runs the whole skyline from the west, turns down a cross street onto a
## diagonal boulevard into a traffic circle, rounds three quarters of it, and
## leaves west, then down and back east along the bottom avenue to the gate; a
## side street climbs from the south, crosses the bottom avenue and enters the
## circle: 15 lots, 6 road posts. The army from wave 1, the heroes from wave 9
## (Blitz, Aurora, Nightjar on the way); Atlas (miniboss, chest) on wave 13; the
## final wave is staged: Blitz, Aurora, Atlas and Nightjar, then Paragon, the
## Last Hero. Beating Paragon opens the Fallen Hero. Act rule: the escalation.
## Data only, no logic. MAP keys: graveyard_map.gd (+ "escalation",
## skid_row_map.gd).
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
			"points": [Vector2(-40, 130), Vector2(1050, 130), Vector2(1050, 260), Vector2(767, 353), Vector2(781, 371),
				Vector2(791, 392), Vector2(795, 415), Vector2(793, 439), Vector2(786, 461), Vector2(773, 480),
				Vector2(757, 496), Vector2(736, 508), Vector2(714, 514), Vector2(691, 515), Vector2(668, 509),
				Vector2(647, 499), Vector2(630, 484), Vector2(616, 465), Vector2(608, 443), Vector2(605, 420),
				Vector2(250, 460), Vector2(250, 625), Vector2(1190, 625)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(940, 760), Vector2(940, 540), Vector2(782, 468)],
			"next": "main", "next_at": 1641.7,  # joins main at (782, 467)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 595),
	"plots": [
		Vector2(180, 530), Vector2(700, 430), Vector2(900, 200), Vector2(910, 430), Vector2(460, 200), Vector2(600, 200),
		Vector2(800, 210), Vector2(390, 540), Vector2(580, 550), Vector2(480, 530), Vector2(980, 200), Vector2(1010, 550),
		Vector2(160, 200), Vector2(260, 200), Vector2(1090, 550),
	],
	"posts": [Vector2(624, 130), Vector2(825, 334), Vector2(645, 497), Vector2(250, 505), Vector2(940, 563), Vector2(729, 625)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
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
		{"banner": "No more heroes: Paragon comes down!", "groups": [{"kind": "blitz", "count": 1, "spacing": 1.0}, {"kind": "aurora", "count": 1, "spacing": 1.0, "delay": 5.0}, {"kind": "city_tank", "count": 1, "spacing": 1.0, "delay": 10.0}, {"kind": "nightjar", "count": 1, "spacing": 1.0, "delay": 15.0, "road": "south"}, {"kind": "paragon", "count": 1, "spacing": 1.0, "delay": 22.0}, {"kind": "city_conscript", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "south"}]},
	],
}
