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
			"points": [Vector2(-40, 610), Vector2(380, 610), Vector2(493, 591), Vector2(484, 587), Vector2(475, 582),
				Vector2(466, 577), Vector2(458, 571), Vector2(451, 564), Vector2(445, 558), Vector2(439, 550),
				Vector2(434, 542), Vector2(429, 534), Vector2(425, 526), Vector2(423, 518), Vector2(420, 509),
				Vector2(419, 500), Vector2(418, 492), Vector2(418, 483), Vector2(418, 474), Vector2(411, 469),
				Vector2(402, 465), Vector2(392, 460), Vector2(384, 455), Vector2(375, 450), Vector2(367, 444),
				Vector2(360, 437), Vector2(353, 430), Vector2(347, 423), Vector2(341, 415), Vector2(337, 407),
				Vector2(333, 399), Vector2(330, 391), Vector2(329, 382), Vector2(328, 374), Vector2(328, 365),
				Vector2(329, 357), Vector2(331, 348), Vector2(334, 340), Vector2(337, 332), Vector2(342, 324),
				Vector2(347, 316), Vector2(354, 309), Vector2(361, 302), Vector2(368, 296), Vector2(376, 290),
				Vector2(385, 284), Vector2(393, 279), Vector2(403, 274), Vector2(412, 270), Vector2(418, 265),
				Vector2(418, 256), Vector2(418, 247), Vector2(419, 239), Vector2(421, 230), Vector2(423, 222),
				Vector2(426, 213), Vector2(430, 205), Vector2(434, 197), Vector2(439, 189), Vector2(445, 182),
				Vector2(452, 175), Vector2(459, 169), Vector2(467, 163), Vector2(476, 158), Vector2(485, 153),
				Vector2(494, 149), Vector2(504, 146), Vector2(515, 143), Vector2(525, 142), Vector2(536, 141),
				Vector2(547, 140), Vector2(558, 141), Vector2(569, 142), Vector2(640, 180), Vector2(640, 325)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 610), Vector2(900, 610), Vector2(787, 591), Vector2(796, 587), Vector2(805, 582),
				Vector2(814, 577), Vector2(822, 571), Vector2(829, 564), Vector2(835, 558), Vector2(841, 550),
				Vector2(846, 542), Vector2(851, 534), Vector2(855, 526), Vector2(857, 518), Vector2(860, 509),
				Vector2(861, 500), Vector2(862, 492), Vector2(862, 483), Vector2(862, 474), Vector2(869, 469),
				Vector2(878, 465), Vector2(888, 460), Vector2(896, 455), Vector2(905, 450), Vector2(913, 444),
				Vector2(920, 437), Vector2(927, 430), Vector2(933, 423), Vector2(939, 415), Vector2(943, 407),
				Vector2(947, 399), Vector2(950, 391), Vector2(951, 382), Vector2(952, 374), Vector2(952, 365),
				Vector2(951, 357), Vector2(949, 348), Vector2(946, 340), Vector2(943, 332), Vector2(938, 324),
				Vector2(933, 316), Vector2(926, 309), Vector2(919, 302), Vector2(912, 296), Vector2(904, 290),
				Vector2(895, 284), Vector2(887, 279), Vector2(877, 274), Vector2(868, 270), Vector2(862, 265),
				Vector2(862, 256), Vector2(862, 247), Vector2(861, 239), Vector2(859, 230), Vector2(857, 222),
				Vector2(854, 213), Vector2(850, 205), Vector2(846, 197), Vector2(841, 189), Vector2(835, 182),
				Vector2(828, 175), Vector2(821, 169), Vector2(813, 163), Vector2(804, 158), Vector2(795, 153),
				Vector2(786, 149), Vector2(776, 146), Vector2(765, 143), Vector2(755, 142), Vector2(744, 141),
				Vector2(733, 140), Vector2(722, 141), Vector2(711, 142), Vector2(642, 182)],
			"next": "main", "next_at": 1284.2,  # joins main at (640, 182)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 343),
	"plots": [
		Vector2(790, 250), Vector2(340, 530), Vector2(940, 530), Vector2(460, 420), Vector2(550, 210), Vector2(820, 420),
		Vector2(490, 270), Vector2(710, 220), Vector2(830, 330), Vector2(260, 530), Vector2(150, 550), Vector2(1020, 530),
		Vector2(350, 670), Vector2(920, 670), Vector2(420, 340), Vector2(1130, 550),
	],
	"posts": [Vector2(186, 610), Vector2(1094, 610), Vector2(330, 390), Vector2(949, 392), Vector2(640, 254)],
	"clouds": [[Vector2(497, 186), 84.0], [Vector2(518, 489), 70.0], [Vector2(757, 495), 70.0]],  # TUNING (not in GDD) the rose's shadowed petals
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 1.9,  # TUNING (not in GDD) B4: 2.1 before the balance pass; L7: 2.7 before the break fixes; L4: 3.0 before the road redraw; S3: 3.2 before the spot fix; the act's finale presses hardest
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
