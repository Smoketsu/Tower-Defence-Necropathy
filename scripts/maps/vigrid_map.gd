## Vigrid, the Last Field (Act VI map 3, the finale; Necropathy stage "vigrid"):
## the ash plain where the gods' last battle is fought, Muspel's embers on the
## wind. An open battlefield: one long war-road charges across it in five
## straight diagonal battle lines (a broad W from the north-west to the gate in
## the east), so the plots inside each V cover two of them; from wave 6 a flank
## road comes in from the south-east and joins it at the W's middle point. 14
## plots, 5 posts, 24 waves. The Long Winter (act rule norse/long_winter): cold
## from wave 3, deeper from waves 8 and 14; six braziers; two Rune-Stones. The
## Fire-Giant of the South (miniboss, chest) on wave 12; Odin the All-Father
## with Fenrir on wave 24 (the Wolf, the All-Father, Ragnarok). Beating him
## unlocks the Draugr Thane tower, Gungnir and the Berserker. Keys as
## graveyard_map.gd plus braziers / rune_stones (rules/norse/long_winter.gd).
## Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and long_winter.gd).
const MAP: Dictionary = {
	"id": "vigrid",
	"name": "Vigrid, the Last Field",
	"floor": "tiles/norse_ash",
	"decals": ["decals/march_burned_ash", "decals/march_burned_ash_2", "decals/march_burned_embers", "decals/march_burned_embers_2"],
	"obstacles": [
		["obstacles/standing_shield_l", Vector2(90, 230)], ["obstacles/mound_l", Vector2(640, 230)],
		["obstacles/standing_shield_s", Vector2(1240, 120)], ["obstacles/mound_s", Vector2(1000, 430)],
		["obstacles/standing_shield_l_v", Vector2(60, 620)], ["obstacles/mound_l_v", Vector2(1222, 593)],
		["obstacles/standing_shield_s", Vector2(640, 650)], ["obstacles/mound_s", Vector2(450, 430)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 120), Vector2(210, 600), Vector2(460, 130), Vector2(710, 600), Vector2(960, 130),
				Vector2(1190, 520)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"flank": {
			"points": [Vector2(1320, 660), Vector2(960, 660), Vector2(712, 602)],
			"next": "main", "next_at": 1605.9,  # joins main at (710, 600)
			"entrance": true,
		},
	},
	"gate": Vector2(1202, 535),
	"plots": [
		Vector2(890, 570), Vector2(460, 300), Vector2(200, 440), Vector2(500, 370), Vector2(970, 290), Vector2(130, 300),
		Vector2(700, 420), Vector2(820, 530), Vector2(190, 360), Vector2(1010, 360), Vector2(850, 200), Vector2(560, 180),
		Vector2(1110, 570), Vector2(1030, 570),
	],
	"posts": [Vector2(1070, 316), Vector2(775, 477), Vector2(605, 402), Vector2(1039, 660), Vector2(202, 584)],
	"braziers": [Vector2(89, 483), Vector2(351, 449), Vector2(639, 352), Vector2(820, 279), Vector2(1093, 251), Vector2(353, 216)],
	"rune_stones": [Vector2(700, 467), Vector2(928, 700)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.15,  # TUNING (not in GDD) B4: 2.3 before the balance pass; L4: 3.2 before the road redraw; the act's finale presses hardest
	"rule": "",
	"act_rule": "norse/long_winter",
	"build_order": "vigrid_default",
	"weak_order": "vigrid_weak",
	"waves": [
		{"banner": "The last field: raiders on the ash", "groups": [{"kind": "norse_raider", "count": 14, "spacing": 1.0}]},
		{"banner": "", "groups": [{"kind": "norse_wolf", "count": 8, "spacing": 0.7}, {"kind": "norse_raider", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_shield_maiden", "count": 4, "spacing": 2.0}, {"kind": "norse_draugr", "count": 6, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_skald", "count": 2, "spacing": 3.0}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 3, "spacing": 2.5}, {"kind": "norse_einherjar", "count": 5, "spacing": 1.6, "delay": 2.0}]},
		{"banner": "Fire giants march up the flank road", "groups": [{"kind": "norse_fire_giant", "count": 1, "spacing": 1.0, "road": "flank"}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 2, "spacing": 4.0}, {"kind": "norse_wolf", "count": 10, "spacing": 0.6, "delay": 2.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 2, "spacing": 4.0}, {"kind": "norse_draugr_female", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "flank"}, {"kind": "norse_shield_maiden", "count": 4, "spacing": 1.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 1, "spacing": 1.0}, {"kind": "norse_einherjar", "count": 6, "spacing": 1.4, "delay": 2.0, "road": "flank"}, {"kind": "norse_raider", "count": 10, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 4, "spacing": 2.0, "road": "flank"}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_fire_giant", "count": 1, "spacing": 6.0}, {"kind": "norse_wolf", "count": 14, "spacing": 0.5, "delay": 2.0, "road": "flank"}]},  # DECISIONS Y6: one giant (three stomping giants with the miniboss were the cliff)
		{"banner": "The Fire-Giant of the South: the ash burns where he walks!", "groups": [{"kind": "muspel_giant", "count": 1, "spacing": 1.0}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 4.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "road": "flank"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.3, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "norse_einherjar", "count": 8, "spacing": 1.2}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 3.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "road": "flank"}, {"kind": "norse_seer", "count": 4, "spacing": 2.0, "delay": 2.0}, {"kind": "norse_raider", "count": 12, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_fire_giant", "count": 2, "spacing": 6.0}, {"kind": "norse_skald", "count": 3, "spacing": 2.5, "delay": 2.0, "road": "flank"}, {"kind": "norse_wolf", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 4, "spacing": 2.5}, {"kind": "norse_draugr", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 3, "spacing": 3.0}, {"kind": "norse_einherjar", "count": 8, "spacing": 1.1, "delay": 2.0, "road": "flank"}]},
		{"banner": "", "groups": [{"kind": "norse_fire_giant", "count": 2, "spacing": 5.0, "road": "flank"}, {"kind": "norse_frost_giant", "count": 2, "spacing": 5.0, "delay": 2.0}, {"kind": "norse_raider", "count": 14, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 4, "spacing": 2.0}, {"kind": "norse_shield_maiden", "count": 10, "spacing": 1.1, "delay": 2.0, "road": "flank"}, {"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 4, "spacing": 3.0, "road": "flank"}, {"kind": "norse_wolf", "count": 16, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "norse_fire_giant", "count": 3, "spacing": 5.0}, {"kind": "norse_einherjar", "count": 8, "spacing": 1.1, "delay": 2.0, "road": "flank"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "The gods' last host gathers on the plain", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 5.0, "road": "flank"}, {"kind": "norse_valkyrie", "count": 4, "spacing": 2.5, "delay": 2.0}, {"kind": "norse_berserker", "count": 3, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "Odin the All-Father comes, and Fenrir runs before him!", "groups": [{"kind": "odin", "count": 1, "spacing": 1.0}, {"kind": "norse_einherjar", "count": 6, "spacing": 1.4, "delay": 6.0, "road": "flank"}, {"kind": "norse_wolf", "count": 10, "spacing": 0.6, "delay": 12.0}]},
	],
}
