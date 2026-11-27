## The Temple of the Lioness (Act VII map 2; Necropathy stage "lioness_temple"):
## an avenue of statues to a sun temple. A hypostyle hall: the west and east
## roads slalom down their sides between the column rows (mirror images), meet
## at the bottom of the hall, and the joined road slaloms up the central aisle
## to the gate at the sanctuary in the north. Five Canopic Jars beside the road
## (JARS). 16 plots, 5 posts, 23 waves. The Sandstorm from wave 5 (the temple's
## storms come often). The Lion Warden (miniboss, chest) on wave 12; Sekhmet on
## wave 23 (she calls the Red Wind and sets down wine jars). Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "lioness_temple",
	"name": "The Temple of the Lioness",
	"floor": "tiles/lioness_temple_avenue",
	"decals": [],
	"obstacles": [
		["obstacles/dyn_statue_row_l", Vector2(171, 76)], ["obstacles/dyn_statue_row_l", Vector2(1092, 77)],
		["obstacles/dyn_colonnade_l_v", Vector2(552, 380)], ["obstacles/dyn_colonnade_l_v", Vector2(720, 320)],
		["obstacles/dyn_brazier", Vector2(640, 90)], ["obstacles/dyn_sphinx_head_m", Vector2(1210, 420)],
		["obstacles/dyn_statue_row_s", Vector2(80, 300)], ["obstacles/dyn_obelisk_l", Vector2(1210, 600)],
		["obstacles/dyn_brazier", Vector2(408, 340)], ["obstacles/dyn_colonnade_s", Vector2(870, 680)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 140), Vector2(-24, 139), Vector2(-2, 138), Vector2(23, 137), Vector2(52, 136),
				Vector2(84, 136), Vector2(116, 137), Vector2(150, 140), Vector2(174, 143), Vector2(203, 146),
				Vector2(234, 150), Vector2(268, 155), Vector2(302, 160), Vector2(334, 165), Vector2(364, 171),
				Vector2(390, 178), Vector2(411, 185), Vector2(424, 192), Vector2(430, 200), Vector2(425, 209),
				Vector2(409, 218), Vector2(384, 229), Vector2(353, 240), Vector2(319, 251), Vector2(283, 263),
				Vector2(249, 275), Vector2(218, 286), Vector2(193, 298), Vector2(176, 309), Vector2(170, 320),
				Vector2(177, 331), Vector2(196, 343), Vector2(225, 354), Vector2(260, 365), Vector2(298, 376),
				Vector2(336, 386), Vector2(371, 397), Vector2(400, 408), Vector2(421, 419), Vector2(430, 430),
				Vector2(424, 442), Vector2(405, 455), Vector2(376, 468), Vector2(342, 481), Vector2(305, 494),
				Vector2(269, 507), Vector2(239, 519), Vector2(218, 530), Vector2(210, 540), Vector2(216, 551),
				Vector2(232, 561), Vector2(257, 571), Vector2(288, 580), Vector2(322, 588), Vector2(357, 595),
				Vector2(390, 601), Vector2(420, 605), Vector2(449, 607), Vector2(481, 609), Vector2(515, 609),
				Vector2(548, 607), Vector2(579, 605), Vector2(606, 601), Vector2(627, 596), Vector2(640, 590),
				Vector2(635, 573), Vector2(604, 550), Vector2(570, 525), Vector2(560, 500), Vector2(573, 486),
				Vector2(598, 472), Vector2(629, 458), Vector2(661, 443), Vector2(691, 429), Vector2(712, 414),
				Vector2(720, 400), Vector2(712, 386), Vector2(691, 371), Vector2(661, 357), Vector2(629, 343),
				Vector2(598, 328), Vector2(573, 314), Vector2(560, 300), Vector2(565, 274), Vector2(590, 248),
				Vector2(620, 224), Vector2(640, 205), Vector2(640, 170)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 140), Vector2(1304, 139), Vector2(1282, 138), Vector2(1257, 137), Vector2(1228, 136),
				Vector2(1196, 136), Vector2(1164, 137), Vector2(1130, 140), Vector2(1106, 143), Vector2(1077, 146),
				Vector2(1046, 150), Vector2(1012, 155), Vector2(978, 160), Vector2(946, 165), Vector2(916, 171),
				Vector2(890, 178), Vector2(869, 185), Vector2(856, 192), Vector2(850, 200), Vector2(855, 209),
				Vector2(871, 218), Vector2(896, 229), Vector2(927, 240), Vector2(961, 251), Vector2(997, 263),
				Vector2(1031, 275), Vector2(1062, 286), Vector2(1087, 298), Vector2(1104, 309), Vector2(1110, 320),
				Vector2(1103, 331), Vector2(1084, 343), Vector2(1055, 354), Vector2(1020, 365), Vector2(982, 376),
				Vector2(944, 386), Vector2(909, 397), Vector2(880, 408), Vector2(859, 419), Vector2(850, 430),
				Vector2(856, 442), Vector2(875, 455), Vector2(904, 468), Vector2(938, 481), Vector2(975, 494),
				Vector2(1011, 507), Vector2(1041, 519), Vector2(1062, 530), Vector2(1070, 540), Vector2(1064, 551),
				Vector2(1048, 561), Vector2(1023, 571), Vector2(992, 580), Vector2(958, 588), Vector2(923, 595),
				Vector2(890, 601), Vector2(860, 605), Vector2(832, 607), Vector2(801, 607), Vector2(769, 605),
				Vector2(738, 602), Vector2(708, 598), Vector2(681, 595), Vector2(659, 592), Vector2(642, 590)],
			"next": "main", "next_at": 1758.8,  # joins main at (640, 590)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 150),
	"plots": [
		Vector2(670, 290), Vector2(790, 540), Vector2(1050, 210), Vector2(870, 540), Vector2(330, 320), Vector2(490, 520),
		Vector2(500, 260), Vector2(1130, 210), Vector2(980, 100), Vector2(1010, 440), Vector2(950, 320), Vector2(240, 210),
		Vector2(380, 540), Vector2(150, 210), Vector2(240, 450), Vector2(720, 500),
	],
	"posts": [Vector2(225, 354), Vector2(1101, 332), Vector2(633, 571), Vector2(567, 493), Vector2(565, 306)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.2,  # TUNING (not in GDD) L4: 3.0 before the road redraw; S3: 2.8 before the spot fix
	"rule": "",
	"act_rule": "dynasty/rebirth",
	"build_order": "lioness_temple_default",
	"weak_order": "lioness_temple_weak",
	"waves": [
		{"banner": "Pilgrims of the dead climb the avenue of statues", "groups": [{"kind": "dyn_mummy", "count": 8, "spacing": 1.1}, {"kind": "dyn_mummy", "count": 6, "spacing": 1.1, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy_runner", "count": 8, "spacing": 1.0, "road": "east"}, {"kind": "nile_archer", "count": 4, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 4, "spacing": 1.8}, {"kind": "scarab_swarm", "count": 10, "spacing": 0.5, "delay": 2.0, "road": "east"}]},
		{"banner": "Bastet Hunters dive into the sand and slip past the posts", "groups": [{"kind": "bastet_hunter", "count": 2, "spacing": 3.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.8, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "embalmer", "count": 3, "spacing": 2.5}, {"kind": "dyn_mummy_runner", "count": 14, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "Awakening Statues: stone servants, flat armour", "groups": [{"kind": "awakening_statue", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "nile_archer", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "heka_priest", "count": 3, "spacing": 3.0}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 20, "spacing": 0.45}, {"kind": "bastet_hunter", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 3, "spacing": 2.6, "road": "east"}, {"kind": "dyn_mummy", "count": 16, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 3, "spacing": 3.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 2.0, "road": "east"}, {"kind": "dyn_mummy_runner", "count": 12, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "nile_archer", "count": 12, "spacing": 0.8, "road": "east"}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "The Lion Warden leaves his doorway!", "groups": [{"kind": "lion_warden", "count": 1, "spacing": 1.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.8, "delay": 3.0, "road": "east"}, {"kind": "heka_priest", "count": 2, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 3, "spacing": 2.6}, {"kind": "scarab_swarm", "count": 20, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.6, "road": "east"}, {"kind": "embalmer", "count": 4, "spacing": 2.2, "delay": 2.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 4, "spacing": 2.4}, {"kind": "nile_archer", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 12, "spacing": 1.0, "road": "east"}, {"kind": "heka_priest", "count": 3, "spacing": 2.6, "delay": 3.0}, {"kind": "dyn_mummy_runner", "count": 12, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 4, "spacing": 2.2}, {"kind": "awakening_statue", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 22, "spacing": 0.55, "road": "east"}, {"kind": "embalmer", "count": 4, "spacing": 2.0, "delay": 2.0}, {"kind": "scarab_swarm", "count": 14, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 5, "spacing": 2.0, "road": "east"}, {"kind": "khopesh_guard", "count": 10, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.4}, {"kind": "nile_archer", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "heka_priest", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 4, "spacing": 2.0, "road": "east"}, {"kind": "dyn_mummy_runner", "count": 18, "spacing": 0.5, "delay": 2.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "The temple's whole guard turns out", "groups": [{"kind": "jackal_warrior", "count": 5, "spacing": 2.0}, {"kind": "awakening_statue", "count": 4, "spacing": 2.4, "delay": 2.0, "road": "east"}, {"kind": "khopesh_guard", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "Sekhmet, the Lioness of Retribution, descends!", "groups": [{"kind": "sekhmet", "count": 1, "spacing": 1.0}, {"kind": "bastet_hunter", "count": 3, "spacing": 2.5, "delay": 4.0, "road": "east"}, {"kind": "dyn_mummy", "count": 12, "spacing": 0.8, "delay": 8.0}]},
	],
}
