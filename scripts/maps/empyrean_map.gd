## The Empyrean (Act X map 3, the act's finale and the end of Part Two;
## Necropathy stage "empyrean"): the highest heaven, a white rose of light,
## endless and silent. The rose window: two roads come in from the west and the
## east along the bottom, each traces one half of the rose's scalloped outline
## (three lobes), and they meet at its top, then fall straight down the spoke to
## the gate at its heart. 16 plots, 5 posts, 24 waves. The Hallowed Light:
## diagonal shafts cross the rose, and every live Choir Angel widens them (the
## Choir). Three cloud banks drift over the petals. The Herald of the Seventh
## Trumpet (miniboss, chest) on wave 12; the Voice on wave 24: it never moves,
## Be Not Afraid stuns every tower out of the shade and the Last Word sends the
## run's sins back as Judges. Beating it unlocks the Bound Ophan. Keys as
## graveyard_map.gd plus "clouds" (rules/host/hallowed_light.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and hallowed_light.gd).
const MAP: Dictionary = {
	"id": "empyrean",
	"name": "The Empyrean",
	"floor": "tiles/empyrean_petals",
	"decals": [],
	"obstacles": [
		["obstacles/host_petal_m", Vector2(40, 250)], ["obstacles/host_petal_m", Vector2(1240, 250)],
		["obstacles/host_pillar_m", Vector2(480, 100)], ["obstacles/host_pillar_m", Vector2(800, 100)],
		["obstacles/host_petal_m_v", Vector2(640, 690)], ["obstacles/host_cloudstone_m", Vector2(280, 437)],
		["obstacles/host_cloudstone_m", Vector2(1010, 420)], ["obstacles/host_petal_m", Vector2(560, 480)],
		["obstacles/host_petal_m", Vector2(720, 480)], ["obstacles/host_pillar_m", Vector2(40, 560)],
		["obstacles/host_pillar_m", Vector2(1240, 560)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 650), Vector2(420, 650), Vector2(591, 594), Vector2(578, 597), Vector2(564, 599),
				Vector2(551, 600), Vector2(537, 599), Vector2(524, 598), Vector2(511, 596), Vector2(498, 592),
				Vector2(486, 588), Vector2(475, 582), Vector2(465, 576), Vector2(455, 568), Vector2(447, 560),
				Vector2(439, 551), Vector2(433, 542), Vector2(428, 532), Vector2(424, 521), Vector2(421, 511),
				Vector2(419, 500), Vector2(418, 489), Vector2(418, 479), Vector2(413, 471), Vector2(402, 465),
				Vector2(391, 459), Vector2(380, 453), Vector2(370, 446), Vector2(361, 438), Vector2(352, 429),
				Vector2(345, 420), Vector2(339, 411), Vector2(334, 401), Vector2(330, 390), Vector2(328, 380),
				Vector2(328, 369), Vector2(328, 359), Vector2(331, 348), Vector2(334, 338), Vector2(339, 328),
				Vector2(346, 319), Vector2(353, 310), Vector2(362, 301), Vector2(371, 294), Vector2(381, 286),
				Vector2(392, 280), Vector2(403, 274), Vector2(415, 269), Vector2(418, 260), Vector2(418, 250),
				Vector2(419, 239), Vector2(421, 228), Vector2(424, 218), Vector2(428, 207), Vector2(434, 197),
				Vector2(440, 188), Vector2(448, 179), Vector2(456, 171), Vector2(466, 164), Vector2(476, 157),
				Vector2(488, 152), Vector2(500, 147), Vector2(513, 144), Vector2(526, 142), Vector2(539, 141),
				Vector2(552, 141), Vector2(566, 141), Vector2(579, 143), Vector2(592, 146), Vector2(605, 150),
				Vector2(617, 154), Vector2(629, 159), Vector2(640, 165), Vector2(640, 325)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 650), Vector2(860, 650), Vector2(689, 594), Vector2(702, 597), Vector2(716, 599),
				Vector2(729, 600), Vector2(743, 599), Vector2(756, 598), Vector2(769, 596), Vector2(782, 592),
				Vector2(794, 588), Vector2(805, 582), Vector2(815, 576), Vector2(825, 568), Vector2(833, 560),
				Vector2(841, 551), Vector2(847, 542), Vector2(852, 532), Vector2(856, 521), Vector2(859, 511),
				Vector2(861, 500), Vector2(862, 489), Vector2(862, 479), Vector2(867, 471), Vector2(878, 465),
				Vector2(889, 459), Vector2(900, 453), Vector2(910, 446), Vector2(919, 438), Vector2(928, 429),
				Vector2(935, 420), Vector2(941, 411), Vector2(946, 401), Vector2(950, 390), Vector2(952, 380),
				Vector2(952, 369), Vector2(952, 359), Vector2(949, 348), Vector2(946, 338), Vector2(941, 328),
				Vector2(934, 319), Vector2(927, 310), Vector2(918, 301), Vector2(909, 294), Vector2(899, 286),
				Vector2(888, 280), Vector2(877, 274), Vector2(865, 269), Vector2(862, 260), Vector2(862, 250),
				Vector2(861, 239), Vector2(859, 228), Vector2(856, 218), Vector2(852, 207), Vector2(846, 197),
				Vector2(840, 188), Vector2(832, 179), Vector2(824, 171), Vector2(814, 164), Vector2(804, 157),
				Vector2(792, 152), Vector2(780, 147), Vector2(767, 144), Vector2(754, 142), Vector2(741, 141),
				Vector2(728, 141), Vector2(714, 141), Vector2(701, 143), Vector2(688, 146), Vector2(675, 150),
				Vector2(663, 154), Vector2(651, 159), Vector2(642, 167)],
			"next": "main", "next_at": 1480.4,  # joins main at (640, 167)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 343),
	"plots": [
		Vector2(780, 260), Vector2(380, 580), Vector2(900, 580), Vector2(580, 540), Vector2(300, 560), Vector2(980, 560),
		Vector2(540, 200), Vector2(710, 210), Vector2(700, 540), Vector2(560, 280), Vector2(150, 590), Vector2(780, 520),
		Vector2(460, 420), Vector2(830, 330), Vector2(460, 320), Vector2(1130, 590),
	],
	"posts": [Vector2(221, 650), Vector2(1060, 650), Vector2(377, 451), Vector2(901, 452), Vector2(640, 246)],
	"clouds": [[Vector2(497, 165), 84.0], [Vector2(537, 499), 70.0], [Vector2(732, 499), 70.0]],  # TUNING (not in GDD) the rose's shadowed petals
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.7,  # TUNING (not in GDD) L4: 3.0 before the road redraw; S3: 3.2 before the spot fix; the act's finale presses hardest
	"rule": "",
	"act_rule": "host/hallowed_light",
	"build_order": "empyrean_default",
	"weak_order": "empyrean_weak",
	"waves": [
		{"banner": "The Rose's Edge: lights from either side", "groups": [{"kind": "host_lesser_light", "count": 10, "spacing": 0.7}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 4, "spacing": 1.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 6, "spacing": 1.3}, {"kind": "host_power", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "east"}]},
		{"banner": "The Choir: every Choir Angel alive widens the Light", "groups": [{"kind": "host_choir_angel", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "east"}, {"kind": "host_power", "count": 6, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_herald", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 1.0}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 6, "spacing": 1.2}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "host_power", "count": 8, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_herald", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Petals", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_ophan", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "host_ophan", "count": 1, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "The Herald of the Seventh Trumpet: each blast calls an earlier host!", "groups": [{"kind": "host_seventh_herald", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 4.0, "road": "east"}, {"kind": "host_power", "count": 6, "spacing": 1.2, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 1, "spacing": 4.0, "road": "east"}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The Choir: the hymn of the whole Host", "groups": [{"kind": "host_choir_angel", "count": 3, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 3.0, "delay": 1.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 1, "spacing": 3.5, "road": "east"}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 1.0, "road": "east"}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_ophan", "count": 1, "spacing": 3.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0}, {"kind": "host_herald", "count": 3, "spacing": 3.5, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The Heart of the Rose", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 3.0}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_lesser_light", "count": 18, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 3.0, "road": "east"}]},
		{"banner": "The whole Host stands before the Voice", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "host_ophan", "count": 1, "spacing": 3.0, "delay": 2.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "The Voice speaks at the heart of the rose. Be not afraid.", "groups": [{"kind": "host_voice", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.1, "delay": 6.0, "road": "east"}, {"kind": "host_power", "count": 10, "spacing": 1.1, "delay": 12.0}]},
	],
}
