## The Road to the Sun (Act V map 3, the finale; Necropathy stage "sun_road"): a
## pilgrim road of torii gates climbing to the sun goddess's shrine. One long
## pilgrim road rising in three smooth, sweeping S-bends from the bottom-left to
## the shrine top-right, so the plots inside each bend cover two runs. 15 plots,
## 6 posts, 24 waves. The Sun's Course: dusk from wave 8, night from wave 14.
## The Kirin (miniboss, chest) on wave 12; Amaterasu on wave 24: she forces day
## at dawn and noon and the eclipse (night) at sunset. Beating her unlocks the
## Bound Oni tower. Keys as graveyard_map.gd plus lanterns / ambush
## (rules/shogunate/sun_course.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and sun_course.gd).
const MAP: Dictionary = {
	"id": "sun_road",
	"name": "The Road to the Sun",
	"floor": "tiles/sun_road_torii",
	"decals": [],
	"obstacles": [
		["obstacles/torii_post_l", Vector2(45, 581)], ["obstacles/torii_post_l", Vector2(115, 580)],
		["obstacles/cloud_rock_l", Vector2(1220, 690)], ["obstacles/black_pine_l", Vector2(1220, 600)],
		["obstacles/torii_post_s", Vector2(1150, 370)], ["obstacles/sun_mirror_s", Vector2(180, 190)],
		["obstacles/cloud_rock_m", Vector2(60, 250)], ["obstacles/black_pine_s", Vector2(310, 267)],
		["obstacles/torii_post_l", Vector2(1000, 110)], ["obstacles/sun_mirror_l", Vector2(600, 120)],
		["obstacles/cloud_rock_s", Vector2(260, 110)], ["obstacles/burning_censer_s", Vector2(840, 110)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 650), Vector2(-25, 650), Vector2(-6, 650), Vector2(14, 649), Vector2(38, 649),
				Vector2(63, 649), Vector2(90, 649), Vector2(119, 648), Vector2(149, 648), Vector2(180, 648),
				Vector2(211, 647), Vector2(243, 646), Vector2(275, 646), Vector2(308, 644), Vector2(339, 643),
				Vector2(370, 642), Vector2(400, 640), Vector2(425, 638), Vector2(452, 637), Vector2(479, 635),
				Vector2(507, 632), Vector2(535, 630), Vector2(564, 628), Vector2(594, 625), Vector2(623, 623),
				Vector2(652, 620), Vector2(681, 617), Vector2(709, 615), Vector2(737, 612), Vector2(764, 609),
				Vector2(790, 606), Vector2(815, 603), Vector2(838, 599), Vector2(861, 596), Vector2(881, 593),
				Vector2(900, 590), Vector2(945, 581), Vector2(982, 572), Vector2(1012, 563), Vector2(1036, 553),
				Vector2(1055, 543), Vector2(1070, 532), Vector2(1080, 520), Vector2(1088, 495), Vector2(1081, 467),
				Vector2(1059, 440), Vector2(1020, 420), Vector2(1003, 416), Vector2(982, 412), Vector2(959, 409),
				Vector2(934, 407), Vector2(908, 406), Vector2(879, 405), Vector2(850, 404), Vector2(820, 404),
				Vector2(790, 403), Vector2(759, 402), Vector2(729, 401), Vector2(700, 400), Vector2(675, 399),
				Vector2(648, 398), Vector2(620, 397), Vector2(592, 396), Vector2(563, 395), Vector2(533, 395),
				Vector2(504, 394), Vector2(476, 393), Vector2(448, 392), Vector2(421, 390), Vector2(396, 388),
				Vector2(372, 386), Vector2(350, 383), Vector2(330, 380), Vector2(289, 370), Vector2(254, 359),
				Vector2(224, 345), Vector2(202, 330), Vector2(187, 315), Vector2(180, 300), Vector2(181, 283),
				Vector2(190, 264), Vector2(206, 244), Vector2(229, 226), Vector2(261, 211), Vector2(300, 200),
				Vector2(319, 198), Vector2(340, 196), Vector2(364, 196), Vector2(389, 196), Vector2(416, 197),
				Vector2(445, 198), Vector2(474, 200), Vector2(504, 202), Vector2(534, 204), Vector2(564, 206),
				Vector2(593, 208), Vector2(622, 209), Vector2(650, 210), Vector2(676, 211), Vector2(700, 210),
				Vector2(731, 208), Vector2(762, 206), Vector2(792, 202), Vector2(821, 199), Vector2(849, 195),
				Vector2(877, 190), Vector2(903, 186), Vector2(929, 182), Vector2(954, 177), Vector2(977, 173),
				Vector2(1000, 170), Vector2(1035, 165), Vector2(1068, 160), Vector2(1099, 155), Vector2(1128, 150),
				Vector2(1153, 146), Vector2(1174, 143), Vector2(1190, 140)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(1218, 106),
	"plots": [
		Vector2(560, 540), Vector2(340, 300), Vector2(930, 490), Vector2(430, 550), Vector2(420, 290), Vector2(840, 520),
		Vector2(270, 590), Vector2(880, 280), Vector2(1010, 490), Vector2(740, 270), Vector2(670, 530), Vector2(150, 590),
		Vector2(610, 290), Vector2(260, 290), Vector2(1050, 230),
	],
	"posts": [Vector2(626, 623), Vector2(1084, 480), Vector2(494, 393), Vector2(199, 327), Vector2(716, 209), Vector2(1149, 147)],
	"lanterns": [Vector2(442, 687), Vector2(1054, 600), Vector2(1161, 472), Vector2(662, 348), Vector2(153, 417), Vector2(428, 148), Vector2(773, 154), Vector2(1108, 93)],
	"ambush": [["main", 729.0], ["main", 1562.2], ["main", 2291.2]],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.2,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "shogunate/sun_course",
	"build_order": "sun_road_default",
	"weak_order": "sun_road_weak",
	"waves": [
		{"banner": "Pilgrims' guards on the torii road", "groups": [{"kind": "ashigaru", "count": 14, "spacing": 1.0}]},
		{"banner": "Sohei: their naginata strike the post from reach", "groups": [{"kind": "sohei", "count": 3, "spacing": 3.0}, {"kind": "ashigaru", "count": 12, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 6, "spacing": 1.8}, {"kind": "teppo_gunner", "count": 6, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "sohei", "count": 4, "spacing": 2.5}, {"kind": "ashigaru", "count": 16, "spacing": 0.7, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 10, "spacing": 1.0}, {"kind": "samurai", "count": 6, "spacing": 1.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 3, "spacing": 3.0}, {"kind": "hatamoto", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "ashigaru", "count": 16, "spacing": 0.6, "delay": 2.5}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 10, "spacing": 1.2}, {"kind": "sohei", "count": 4, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "Dusk in the sacred forest: ninja on the steps!", "groups": [{"kind": "ninja", "count": 10, "spacing": 1.1}, {"kind": "teppo_gunner", "count": 8, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kunoichi", "count": 2, "spacing": 4.0}, {"kind": "samurai", "count": 10, "spacing": 1.1, "delay": 2.0}, {"kind": "ninja", "count": 6, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 5, "spacing": 2.4}, {"kind": "sohei", "count": 5, "spacing": 2.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "ashigaru", "count": 26, "spacing": 0.5}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "ninja", "count": 8, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "The Kirin, a holy beast of light, gallops down the steps!", "groups": [{"kind": "kirin", "count": 1, "spacing": 1.0}, {"kind": "sohei", "count": 5, "spacing": 2.2, "delay": 3.0}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 14, "spacing": 0.8}, {"kind": "hatamoto", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "ninja", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "Night on the shrine steps: kitsune conjure fox-fire", "groups": [{"kind": "kitsune", "count": 2, "spacing": 4.0}, {"kind": "onryo", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 2, "spacing": 5.0}, {"kind": "kappa", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kitsune", "count": 3, "spacing": 3.5}, {"kind": "sohei", "count": 6, "spacing": 2.0, "delay": 2.0}, {"kind": "onryo", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 6, "spacing": 2.0}, {"kind": "oni", "count": 2, "spacing": 5.0, "delay": 3.0}, {"kind": "ninja", "count": 12, "spacing": 0.9, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 14, "spacing": 0.9}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "kappa", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 3, "spacing": 4.0}, {"kind": "kunoichi", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "teppo_gunner", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "sohei", "count": 8, "spacing": 1.6}, {"kind": "onryo", "count": 18, "spacing": 0.6, "delay": 2.0}, {"kind": "hatamoto", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 8, "spacing": 1.8}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 3.0}, {"kind": "ninja", "count": 14, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 4, "spacing": 3.5}, {"kind": "samurai", "count": 14, "spacing": 0.9, "delay": 2.0}, {"kind": "kappa", "count": 12, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "The high plain of heaven: the whole night host", "groups": [{"kind": "oni", "count": 3, "spacing": 4.0}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "sohei", "count": 8, "spacing": 1.6, "delay": 3.0}, {"kind": "onryo", "count": 16, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "Amaterasu rises in the east: the night breaks!", "groups": [{"kind": "amaterasu", "count": 1, "spacing": 1.0}, {"kind": "sohei", "count": 6, "spacing": 2.0, "delay": 4.0}, {"kind": "samurai", "count": 10, "spacing": 1.1, "delay": 8.0}, {"kind": "kiba_musha", "count": 4, "spacing": 2.5, "delay": 14.0}]},
	],
}
