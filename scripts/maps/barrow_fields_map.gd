## The Barrow Fields (Act VI map 1; Necropathy stage "barrow_fields"): snow over
## the burial mounds of the north. Two entrances: the west road and the east
## road curve in wide arcs round the round barrow mounds in the top corners and
## meet in the middle; the trunk swings east round a mound, then weaves back
## west along the bottom between the barrows to the gate, so the middle plots
## cover three runs. 14 plots, 4 posts, 22 waves. The Long Winter (act rule
## norse/long_winter): cold from wave 4, deeper from waves 10 and 17; six
## braziers beside the roads keep the towers near them warm; one Rune-Stone
## stands on the trunk. The Barrow-Wight (miniboss, chest) on wave 11; Hrimgar
## the Draugr-King on wave 22 (he rises three times). Beating him unlocks Barrow
## Grasp and the Rune-Seer. Keys as graveyard_map.gd plus the Long Winter keys
## (documented in rules/norse/long_winter.gd): braziers (map px of each brazier)
## and rune_stones (map px of each Rune-Stone). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and long_winter.gd).
const MAP: Dictionary = {
	"id": "barrow_fields",
	"name": "The Barrow Fields",
	"floor": "tiles/norse_snow",
	"decals": ["decals/corpse", "decals/corpse_2"],
	"obstacles": [
		["obstacles/mound_l", Vector2(110, 300)], ["obstacles/mound_s", Vector2(640, 200)],
		["obstacles/snow_pine_l", Vector2(40, 100)], ["obstacles/snow_pine_s", Vector2(1240, 300)],
		["obstacles/barrow_closed", Vector2(1180, 100)], ["obstacles/mound_l_v", Vector2(1240, 640)],
		["obstacles/snow_pine_l", Vector2(60, 660)], ["obstacles/mound_s", Vector2(640, 660)],
		["obstacles/snow_pine_s", Vector2(905, 690)], ["obstacles/barrow_closed", Vector2(375, 686)],
	],
	"roads": {
		"west": {
			"points": [Vector2(-40, 150), Vector2(-23, 149), Vector2(0, 147), Vector2(28, 144), Vector2(59, 141),
				Vector2(91, 139), Vector2(123, 138), Vector2(153, 138), Vector2(180, 140), Vector2(209, 144),
				Vector2(238, 150), Vector2(266, 158), Vector2(293, 166), Vector2(318, 176), Vector2(341, 188),
				Vector2(360, 200), Vector2(379, 221), Vector2(391, 245), Vector2(399, 271), Vector2(407, 297),
				Vector2(420, 320), Vector2(438, 341), Vector2(459, 362), Vector2(481, 381), Vector2(502, 398),
				Vector2(520, 410), Vector2(556, 421), Vector2(580, 420)],
			"next": "trunk", "next_at": 0.0,  # joins trunk at (580, 420)
			"entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 150), Vector2(1303, 149), Vector2(1280, 147), Vector2(1252, 144), Vector2(1221, 141),
				Vector2(1189, 139), Vector2(1157, 138), Vector2(1127, 138), Vector2(1100, 140), Vector2(1071, 144),
				Vector2(1042, 150), Vector2(1014, 158), Vector2(987, 166), Vector2(962, 176), Vector2(939, 188),
				Vector2(920, 200), Vector2(900, 221), Vector2(886, 245), Vector2(877, 271), Vector2(869, 297),
				Vector2(860, 320), Vector2(844, 355), Vector2(831, 387), Vector2(820, 410), Vector2(800, 420)],
			"next": "trunk", "next_at": 220.0,  # joins trunk at (800, 420)
			"entrance": true,
		},
		"trunk": {
			"points": [Vector2(580, 420), Vector2(597, 420), Vector2(620, 420), Vector2(647, 419), Vector2(678, 419),
				Vector2(709, 419), Vector2(741, 419), Vector2(772, 419), Vector2(800, 420), Vector2(830, 421),
				Vector2(862, 422), Vector2(892, 423), Vector2(922, 425), Vector2(951, 429), Vector2(977, 433),
				Vector2(1000, 440), Vector2(1029, 453), Vector2(1056, 471), Vector2(1078, 490), Vector2(1094, 511),
				Vector2(1100, 530), Vector2(1096, 551), Vector2(1082, 573), Vector2(1062, 595), Vector2(1037, 614),
				Vector2(1010, 625), Vector2(988, 628), Vector2(962, 628), Vector2(935, 626), Vector2(905, 621),
				Vector2(876, 615), Vector2(847, 608), Vector2(820, 600), Vector2(795, 590), Vector2(770, 577),
				Vector2(746, 562), Vector2(722, 547), Vector2(698, 534), Vector2(674, 524), Vector2(650, 520),
				Vector2(626, 522), Vector2(602, 530), Vector2(578, 541), Vector2(554, 555), Vector2(529, 568),
				Vector2(505, 581), Vector2(480, 590), Vector2(454, 598), Vector2(428, 605), Vector2(401, 612),
				Vector2(374, 618), Vector2(348, 623), Vector2(323, 625), Vector2(300, 625), Vector2(270, 620),
				Vector2(241, 610), Vector2(215, 597), Vector2(191, 583), Vector2(170, 570), Vector2(143, 545),
				Vector2(123, 519), Vector2(110, 500)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(96, 474),
	"plots": [
		Vector2(260, 230), Vector2(540, 480), Vector2(970, 340), Vector2(280, 530), Vector2(360, 550), Vector2(310, 300),
		Vector2(1020, 540), Vector2(940, 500), Vector2(830, 480), Vector2(750, 480), Vector2(460, 460), Vector2(1120, 200),
		Vector2(160, 200), Vector2(1000, 230),
	],
	"posts": [Vector2(368, 619), Vector2(1017, 622), Vector2(774, 419), Vector2(867, 303)],
	"braziers": [Vector2(674, 473), Vector2(778, 523), Vector2(350, 271), Vector2(982, 571), Vector2(929, 319), Vector2(244, 557)],
	"rune_stones": [Vector2(883, 477)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.5,  # TUNING (not in GDD) L4: 2.5 before the road redraw; Part Two: a step above the Road to the Sun
	"rule": "",
	"act_rule": "norse/long_winter",
	"build_order": "barrow_fields_default",
	"weak_order": "barrow_fields_weak",
	"waves": [
		{"banner": "Raiders come down from the barrows", "groups": [{"kind": "norse_raider", "count": 8, "spacing": 1.2, "road": "west"}, {"kind": "norse_raider", "count": 5, "spacing": 1.2, "delay": 6.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 4, "spacing": 1.8, "road": "west"}, {"kind": "norse_raider", "count": 7, "spacing": 1.1, "delay": 3.0, "road": "east"}]},
		{"banner": "Wolves of the wastes: they lunge past the posts", "groups": [{"kind": "norse_wolf", "count": 8, "spacing": 0.7, "road": "east"}, {"kind": "norse_draugr_female", "count": 4, "spacing": 1.7, "delay": 3.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_shield_maiden", "count": 3, "spacing": 2.2, "road": "west"}, {"kind": "norse_raider", "count": 9, "spacing": 0.9, "delay": 2.0, "road": "east"}]},
		{"banner": "Seers douse the braziers: tap a cold one to relight it", "groups": [{"kind": "norse_seer", "count": 3, "spacing": 2.5, "road": "west"}, {"kind": "norse_draugr", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 1, "spacing": 4.0, "road": "east"}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_skald", "count": 2, "spacing": 3.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 4, "spacing": 1.8, "delay": 1.0, "road": "west"}, {"kind": "norse_wolf", "count": 8, "spacing": 0.7, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 6, "spacing": 1.3, "road": "east"}, {"kind": "norse_draugr_female", "count": 6, "spacing": 1.3, "delay": 1.0, "road": "west"}]},
		{"banner": "A frost giant: its boulders freeze the towers", "groups": [{"kind": "norse_frost_giant", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_raider", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 4, "spacing": 2.2, "road": "east"}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 4.0, "road": "west"}]},
		{"banner": "The Barrow-Wight howls: the mounds crack open!", "groups": [{"kind": "barrow_wight", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_draugr", "count": 8, "spacing": 1.3, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_wolf", "count": 14, "spacing": 0.5, "road": "west"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "east"}, {"kind": "norse_raider", "count": 12, "spacing": 0.7, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.3, "delay": 2.0, "road": "west"}]},
		{"banner": "Valkyries fly over the posts", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "road": "west"}, {"kind": "norse_draugr_female", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 3, "spacing": 3.0, "road": "west"}, {"kind": "norse_seer", "count": 4, "spacing": 2.0, "delay": 2.0, "road": "east"}, {"kind": "norse_raider", "count": 14, "spacing": 0.6, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 12, "spacing": 0.9, "road": "west"}, {"kind": "norse_wolf", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "delay": 2.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.2, "delay": 3.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_skald", "count": 3, "spacing": 2.5, "road": "east"}, {"kind": "norse_berserker", "count": 3, "spacing": 3.0, "delay": 1.0, "road": "east"}, {"kind": "norse_raider", "count": 16, "spacing": 0.6, "delay": 2.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 5, "spacing": 1.8, "road": "west"}, {"kind": "norse_draugr_female", "count": 12, "spacing": 0.9, "delay": 2.0, "road": "east"}, {"kind": "norse_valkyrie", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 3, "spacing": 5.0, "road": "west"}, {"kind": "norse_wolf", "count": 14, "spacing": 0.5, "delay": 2.0, "road": "east"}]},
		{"banner": "The whole host of the barrows", "groups": [{"kind": "norse_berserker", "count": 4, "spacing": 3.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "west"}, {"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "delay": 4.0, "road": "east"}]},
		{"banner": "Hrimgar the Draugr-King rises from his barrow!", "groups": [{"kind": "hrimgar", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_draugr", "count": 10, "spacing": 1.1, "delay": 4.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 10.0, "road": "west"}]},
	],
}
