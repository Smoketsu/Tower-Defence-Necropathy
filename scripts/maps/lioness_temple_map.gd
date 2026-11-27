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
		["obstacles/dyn_brazier", Vector2(400, 410)], ["obstacles/dyn_colonnade_s", Vector2(870, 680)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 140), Vector2(-23, 139), Vector2(0, 138), Vector2(28, 136), Vector2(58, 135),
				Vector2(91, 135), Vector2(125, 136), Vector2(160, 140), Vector2(184, 144), Vector2(213, 148),
				Vector2(245, 153), Vector2(278, 158), Vector2(312, 164), Vector2(344, 171), Vector2(374, 178),
				Vector2(400, 186), Vector2(420, 195), Vector2(434, 205), Vector2(440, 215), Vector2(435, 227),
				Vector2(420, 240), Vector2(397, 254), Vector2(367, 269), Vector2(334, 285), Vector2(300, 301),
				Vector2(266, 317), Vector2(236, 334), Vector2(212, 350), Vector2(196, 365), Vector2(190, 380),
				Vector2(194, 395), Vector2(206, 409), Vector2(223, 424), Vector2(246, 439), Vector2(273, 454),
				Vector2(302, 468), Vector2(332, 482), Vector2(362, 495), Vector2(391, 508), Vector2(417, 519),
				Vector2(440, 530), Vector2(469, 544), Vector2(500, 557), Vector2(531, 570), Vector2(561, 581),
				Vector2(588, 590), Vector2(611, 596), Vector2(629, 600), Vector2(640, 600), Vector2(634, 587),
				Vector2(602, 561), Vector2(570, 529), Vector2(560, 500), Vector2(573, 486), Vector2(598, 471),
				Vector2(629, 457), Vector2(661, 443), Vector2(691, 429), Vector2(712, 414), Vector2(720, 400),
				Vector2(712, 386), Vector2(691, 371), Vector2(661, 357), Vector2(629, 343), Vector2(598, 328),
				Vector2(573, 314), Vector2(560, 300), Vector2(565, 274), Vector2(590, 248), Vector2(620, 224),
				Vector2(640, 205), Vector2(640, 170)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 140), Vector2(1303, 139), Vector2(1280, 138), Vector2(1252, 136), Vector2(1222, 135),
				Vector2(1189, 135), Vector2(1155, 136), Vector2(1120, 140), Vector2(1096, 144), Vector2(1067, 148),
				Vector2(1035, 153), Vector2(1002, 158), Vector2(968, 164), Vector2(936, 171), Vector2(906, 178),
				Vector2(880, 186), Vector2(860, 195), Vector2(846, 205), Vector2(840, 215), Vector2(845, 227),
				Vector2(860, 240), Vector2(883, 254), Vector2(913, 269), Vector2(946, 285), Vector2(980, 301),
				Vector2(1014, 317), Vector2(1044, 334), Vector2(1068, 350), Vector2(1084, 365), Vector2(1090, 380),
				Vector2(1086, 395), Vector2(1074, 409), Vector2(1056, 424), Vector2(1034, 439), Vector2(1007, 454),
				Vector2(978, 468), Vector2(948, 482), Vector2(918, 495), Vector2(889, 508), Vector2(863, 519),
				Vector2(840, 530), Vector2(811, 543), Vector2(782, 555), Vector2(753, 565), Vector2(725, 574),
				Vector2(699, 582), Vector2(676, 589), Vector2(657, 595), Vector2(642, 600)],
			"next": "main", "next_at": 1314.0,  # joins main at (640, 600)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 150),
	"plots": [
		Vector2(490, 170), Vector2(930, 110), Vector2(480, 620), Vector2(1130, 220), Vector2(540, 430), Vector2(1000, 230),
		Vector2(240, 510), Vector2(120, 80), Vector2(1020, 520), Vector2(350, 380), Vector2(690, 500), Vector2(270, 220),
		Vector2(930, 380), Vector2(150, 220), Vector2(770, 490), Vector2(500, 250),
	],
	"posts": [Vector2(334, 285), Vector2(912, 269), Vector2(629, 583), Vector2(563, 496), Vector2(566, 307)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.2,  # TUNING (not in GDD) B4: 1.9 before the balance pass; L7: 2.2 before the break fixes; L4: 3.0 before the road redraw; S3: 2.8 before the spot fix
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
