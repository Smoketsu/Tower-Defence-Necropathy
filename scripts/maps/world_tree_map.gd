## The World-Tree (Act XV map 3, the campaign's last; Necropathy stage
## "world_tree"): the roots, the trunk stair and the crown of the tree the whole
## world grew from. The roads draw the tree: the crown road traces the canopy's
## billowing outline along the top and down the east side; the main road comes
## in along the wavy root line at the bottom (where the crown road joins it),
## climbs the west side and curls in along a branch to the gate at the heart;
## the roots road comes in from the west onto the root hall. 18 plots, 6 posts,
## 24 waves. The Turning Year (act rule wild/turning_year) turns twice as fast
## here: the season changes every 2 waves. The Gardener of Roots (miniboss,
## chest) on wave 13; the Green Mother on wave 24. Keys as graveyard_map.gd.
## Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "world_tree",
	"name": "The World-Tree",
	"floor": "tiles/world_tree_roots",
	"decals": ["decals/sanctum_courtyard_moss", "decals/sanctum_courtyard_moss_2", "decals/graveyard_grass_2", "decals/sanctum_cloisters_flowers"],
	"obstacles": [
		["obstacles/wild_great_root_m", Vector2(640, 670)], ["obstacles/wild_oak_l", Vector2(60, 640)],
		["obstacles/wild_stone_l", Vector2(1230, 120)], ["obstacles/wild_oak_s", Vector2(240, 90)],
		["obstacles/wild_great_root_m_v", Vector2(1233, 670)], ["obstacles/wild_stone_s", Vector2(1170, 695)],
		["obstacles/wild_oak_l", Vector2(910, 687)], ["obstacles/wild_stone_s_v", Vector2(1000, 90)],
		["obstacles/wild_grove_tree", Vector2(560, 440)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 610), Vector2(1304, 609), Vector2(1284, 608), Vector2(1260, 607), Vector2(1233, 605),
				Vector2(1203, 604), Vector2(1172, 602), Vector2(1141, 601), Vector2(1110, 600), Vector2(1079, 599),
				Vector2(1050, 599), Vector2(1023, 599), Vector2(1000, 600), Vector2(965, 604), Vector2(934, 611),
				Vector2(906, 620), Vector2(879, 629), Vector2(854, 637), Vector2(828, 643), Vector2(800, 645),
				Vector2(771, 643), Vector2(743, 636), Vector2(714, 627), Vector2(686, 618), Vector2(657, 609),
				Vector2(629, 602), Vector2(600, 600), Vector2(571, 602), Vector2(542, 609), Vector2(513, 618),
				Vector2(484, 627), Vector2(455, 636), Vector2(427, 643), Vector2(400, 645), Vector2(369, 643),
				Vector2(338, 639), Vector2(308, 632), Vector2(279, 622), Vector2(253, 612), Vector2(230, 600),
				Vector2(201, 579), Vector2(178, 555), Vector2(161, 528), Vector2(150, 500), Vector2(147, 471),
				Vector2(150, 439), Vector2(158, 408), Vector2(170, 380), Vector2(184, 354), Vector2(202, 329),
				Vector2(224, 307), Vector2(250, 290), Vector2(275, 280), Vector2(304, 272), Vector2(336, 267),
				Vector2(368, 265), Vector2(400, 265), Vector2(426, 269), Vector2(453, 277), Vector2(479, 287),
				Vector2(506, 296), Vector2(533, 303), Vector2(560, 305), Vector2(586, 301), Vector2(613, 292),
				Vector2(639, 280), Vector2(665, 268), Vector2(692, 259), Vector2(720, 255), Vector2(746, 256),
				Vector2(773, 258), Vector2(801, 263), Vector2(829, 270), Vector2(855, 277), Vector2(879, 286),
				Vector2(900, 295), Vector2(931, 314), Vector2(956, 338), Vector2(974, 362), Vector2(980, 385),
				Vector2(973, 407), Vector2(954, 430), Vector2(928, 450), Vector2(900, 465), Vector2(875, 473),
				Vector2(847, 478), Vector2(817, 481), Vector2(787, 482), Vector2(760, 480), Vector2(728, 473),
				Vector2(696, 461), Vector2(669, 448), Vector2(650, 440)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"crown": {
			"points": [Vector2(-40, 150), Vector2(-22, 146), Vector2(2, 139), Vector2(30, 132), Vector2(61, 124),
				Vector2(93, 117), Vector2(123, 112), Vector2(150, 110), Vector2(183, 113), Vector2(213, 122),
				Vector2(242, 133), Vector2(271, 142), Vector2(300, 145), Vector2(325, 141), Vector2(349, 133),
				Vector2(372, 123), Vector2(397, 113), Vector2(423, 104), Vector2(450, 100), Vector2(475, 100),
				Vector2(501, 103), Vector2(529, 108), Vector2(556, 114), Vector2(585, 119), Vector2(613, 123),
				Vector2(640, 125), Vector2(667, 124), Vector2(695, 120), Vector2(724, 115), Vector2(751, 109),
				Vector2(779, 104), Vector2(805, 101), Vector2(830, 100), Vector2(863, 104), Vector2(893, 112),
				Vector2(922, 122), Vector2(951, 131), Vector2(980, 135), Vector2(1011, 132), Vector2(1044, 124),
				Vector2(1075, 116), Vector2(1105, 111), Vector2(1130, 115), Vector2(1151, 129), Vector2(1170, 150),
				Vector2(1186, 175), Vector2(1198, 203), Vector2(1205, 230), Vector2(1206, 258), Vector2(1200, 288),
				Vector2(1191, 319), Vector2(1183, 350), Vector2(1180, 380), Vector2(1184, 410), Vector2(1192, 440),
				Vector2(1201, 469), Vector2(1207, 496), Vector2(1205, 520), Vector2(1187, 546), Vector2(1159, 569),
				Vector2(1130, 587), Vector2(1110, 600)],
			"next": "main", "next_at": 210.2,  # joins main at (1110, 600)
			"entrance": true,
		},
		"roots": {
			"points": [Vector2(-40, 450), Vector2(-17, 456), Vector2(15, 464), Vector2(50, 471), Vector2(80, 475),
				Vector2(112, 471), Vector2(139, 462), Vector2(158, 455)],
			"next": "main", "next_at": 1292.6,  # joins main at (148, 454)
			"entrance": true,
		},
	},
	"gate": Vector2(624, 399),
	"plots": [
		Vector2(820, 360), Vector2(850, 570), Vector2(220, 500), Vector2(510, 190), Vector2(770, 560), Vector2(1070, 500),
		Vector2(810, 200), Vector2(430, 190), Vector2(730, 180), Vector2(1120, 660), Vector2(200, 220), Vector2(550, 540),
		Vector2(90, 530), Vector2(450, 570), Vector2(120, 210), Vector2(1110, 430), Vector2(1100, 260), Vector2(1100, 180),
	],
	"posts": [Vector2(675, 614), Vector2(1206, 490), Vector2(526, 301), Vector2(149, 448), Vector2(797, 481), Vector2(629, 124)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.3,  # TUNING (not in GDD) B4: 2.6 before the balance pass; L4: 3.2 before the road redraw; DECISIONS Z4: 2.9 -> 3.2 with her calls every 20 s; Part Three: the act's (and the campaign's) hardest map
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "world_tree_default",
	"weak_order": "world_tree_weak",
	"waves": [
		{"banner": "The roots stir: Thornlings climb from the earth", "groups": [{"kind": "wild_thornling", "count": 13, "spacing": 0.96}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "crown"}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 6, "spacing": 2.4, "road": "crown"}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "roots"}]},
		{"banner": "Hounds of the Hunt", "groups": [{"kind": "wild_hunt_hound", "count": 10, "spacing": 1.28}, {"kind": "wild_fae_knight", "count": 5, "spacing": 2.4, "delay": 4.8, "road": "crown"}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8, "road": "roots"}]},
		{"banner": "Will-o'-Wisps drift over the posts", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}]},
		{"banner": "Corpse-Blooms creep up the roots", "groups": [{"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "road": "roots"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 4.8}]},
		{"banner": "Winter Fae: their frost bolts freeze a tower", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_hunt_hound", "count": 13, "spacing": 0.96, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "Great Stags charge up the trunk stair", "groups": [{"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 4.8}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "roots"}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6, "road": "crown"}]},
		{"banner": "Treants: the walking oaks root the posts they strike", "groups": [{"kind": "wild_treant", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "roots"}]},
		{"banner": "Riders of the Wild Hunt: each horn calls hounds", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 3.2, "road": "crown"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "crown"}, {"kind": "wild_thornling", "count": 16, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The Gardener of Roots wakes beneath the tree!", "groups": [{"kind": "wild_gardener", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 6.4, "road": "crown"}, {"kind": "wild_hunt_hound", "count": 8, "spacing": 1.28, "delay": 12.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "crown"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0, "road": "crown"}, {"kind": "wild_winter_fae", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 18, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The trunk stair: the whole Wild climbs", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4, "road": "roots"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4}, {"kind": "wild_hunt_hound", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "crown"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The crown of the tree: the year turns faster", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_thornling", "count": 21, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The roots of the world rise against you", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.8, "delay": 9.6, "road": "crown"}]},
		{"banner": "The Green Mother rises from the World-Tree to take back her dead!", "groups": [{"kind": "wild_green_mother", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 9.6, "road": "crown"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 19.2, "road": "roots"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 28.8, "road": "crown"}]},
	],
}
