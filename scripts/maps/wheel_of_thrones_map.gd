## The Wheel of Thrones (Act X map 2; Necropathy stage "wheel_of_thrones"): the
## turning spheres of heaven. One road runs the wheels within wheels: in from
## the west round most of the outer ring, through a spoke onto the middle ring
## and back round it the other way, then onto the inner ring to the gate at the
## hub, so every plot between two rings covers both. 16 plots, 6 posts, 23
## waves. The Hallowed Light: shafts sweep from every side in turn. Two cloud
## banks drift over the inner ring. The Dominion of the Spheres (miniboss,
## chest) on wave 12; the Throne on wave 23. Keys as graveyard_map.gd plus
## "clouds" (rules/host/hallowed_light.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and hallowed_light.gd).
const MAP: Dictionary = {
	"id": "wheel_of_thrones",
	"name": "The Wheel of Thrones",
	"floor": "tiles/wheel_stars",
	"decals": [],
	"obstacles": [
		["obstacles/host_crystal_m", Vector2(60, 110)], ["obstacles/host_crystal_m_v", Vector2(1220, 110)],
		["obstacles/host_crystal_m", Vector2(1220, 690)], ["obstacles/host_pillar_m", Vector2(460, 695)],
		["obstacles/host_crystal_m", Vector2(300, 690)], ["obstacles/host_pillar_m", Vector2(585, 385)],
		["obstacles/host_crystal_m_v", Vector2(77, 447)], ["obstacles/host_pillar_m", Vector2(1083, 550)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 380), Vector2(194, 380), Vector2(195, 364), Vector2(198, 349), Vector2(201, 333),
				Vector2(207, 318), Vector2(213, 303), Vector2(221, 288), Vector2(231, 273), Vector2(242, 259),
				Vector2(254, 245), Vector2(268, 232), Vector2(283, 219), Vector2(299, 206), Vector2(316, 195),
				Vector2(334, 184), Vector2(354, 173), Vector2(374, 163), Vector2(395, 154), Vector2(417, 146),
				Vector2(440, 139), Vector2(464, 132), Vector2(488, 126), Vector2(512, 121), Vector2(537, 117),
				Vector2(563, 114), Vector2(588, 112), Vector2(614, 110), Vector2(640, 110), Vector2(666, 110),
				Vector2(692, 112), Vector2(717, 114), Vector2(743, 117), Vector2(768, 121), Vector2(792, 126),
				Vector2(816, 132), Vector2(840, 139), Vector2(863, 146), Vector2(885, 154), Vector2(906, 163),
				Vector2(926, 173), Vector2(946, 184), Vector2(964, 195), Vector2(981, 206), Vector2(997, 219),
				Vector2(1012, 232), Vector2(1026, 245), Vector2(1038, 259), Vector2(1049, 273), Vector2(1059, 288),
				Vector2(1067, 303), Vector2(1073, 318), Vector2(1079, 333), Vector2(1082, 349), Vector2(1085, 364),
				Vector2(1086, 380), Vector2(1085, 396), Vector2(1082, 411), Vector2(1079, 427), Vector2(1073, 442),
				Vector2(1067, 457), Vector2(1059, 472), Vector2(1049, 487), Vector2(1038, 501), Vector2(1026, 515),
				Vector2(1012, 528), Vector2(997, 541), Vector2(981, 554), Vector2(964, 565), Vector2(946, 576),
				Vector2(926, 587), Vector2(906, 597), Vector2(885, 606), Vector2(863, 614), Vector2(840, 621),
				Vector2(816, 628), Vector2(792, 634), Vector2(768, 639), Vector2(743, 643), Vector2(717, 646),
				Vector2(692, 648), Vector2(666, 650), Vector2(640, 650), Vector2(614, 650), Vector2(588, 648),
				Vector2(563, 646), Vector2(537, 643), Vector2(512, 639), Vector2(488, 634), Vector2(464, 628),
				Vector2(440, 621), Vector2(417, 614), Vector2(496, 532), Vector2(518, 539), Vector2(542, 545),
				Vector2(567, 549), Vector2(592, 553), Vector2(617, 554), Vector2(643, 555), Vector2(668, 554),
				Vector2(694, 552), Vector2(718, 548), Vector2(743, 544), Vector2(766, 537), Vector2(789, 530),
				Vector2(810, 521), Vector2(830, 512), Vector2(849, 501), Vector2(866, 489), Vector2(881, 477),
				Vector2(894, 463), Vector2(905, 449), Vector2(914, 435), Vector2(921, 420), Vector2(926, 405),
				Vector2(928, 389), Vector2(929, 374), Vector2(927, 358), Vector2(922, 343), Vector2(916, 328),
				Vector2(907, 313), Vector2(896, 299), Vector2(883, 286), Vector2(869, 273), Vector2(852, 261),
				Vector2(834, 250), Vector2(814, 240), Vector2(793, 232), Vector2(771, 224), Vector2(748, 218),
				Vector2(723, 212), Vector2(699, 209), Vector2(673, 206), Vector2(648, 205), Vector2(622, 205),
				Vector2(597, 207), Vector2(571, 210), Vector2(547, 214), Vector2(523, 220), Vector2(500, 227),
				Vector2(478, 235), Vector2(458, 244), Vector2(439, 255), Vector2(421, 266), Vector2(405, 278),
				Vector2(391, 291), Vector2(379, 305), Vector2(369, 319), Vector2(361, 334), Vector2(356, 349),
				Vector2(352, 364), Vector2(351, 380), Vector2(505, 380), Vector2(506, 367), Vector2(512, 354),
				Vector2(520, 342), Vector2(532, 330), Vector2(547, 320), Vector2(564, 312), Vector2(583, 306),
				Vector2(604, 301), Vector2(625, 298), Vector2(647, 298), Vector2(669, 300), Vector2(690, 304),
				Vector2(710, 310), Vector2(728, 318), Vector2(743, 327), Vector2(756, 338), Vector2(766, 350),
				Vector2(772, 362), Vector2(775, 376), Vector2(775, 389), Vector2(770, 402), Vector2(763, 414),
				Vector2(752, 426), Vector2(738, 436), Vector2(722, 445), Vector2(703, 452), Vector2(683, 458),
				Vector2(662, 461), Vector2(640, 462), Vector2(660, 350)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(664, 320),
	"plots": [
		Vector2(580, 420), Vector2(830, 380), Vector2(500, 470), Vector2(970, 470), Vector2(420, 510), Vector2(860, 80),
		Vector2(420, 80), Vector2(130, 280), Vector2(270, 360), Vector2(990, 360), Vector2(310, 290), Vector2(860, 680),
		Vector2(1000, 140), Vector2(420, 680), Vector2(940, 660), Vector2(340, 100),
	],
	"posts": [Vector2(339, 181), Vector2(1063, 464), Vector2(456, 626), Vector2(916, 329), Vector2(445, 251), Vector2(592, 304)],
	"clouds": [[Vector2(453, 357), 84.0], [Vector2(699, 320), 70.0]],  # TUNING (not in GDD) shade over the hub
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.2,  # TUNING (not in GDD) L4: 3.6 before the road redraw; rising through the act
	"rule": "",
	"act_rule": "host/hallowed_light",
	"build_order": "wheel_of_thrones_default",
	"weak_order": "wheel_of_thrones_weak",
	"waves": [
		{"banner": "The spheres turn: lights and Virtues", "groups": [{"kind": "host_lesser_light", "count": 12, "spacing": 0.7}, {"kind": "host_virtue", "count": 6, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 10, "spacing": 1.1}, {"kind": "host_power", "count": 4, "spacing": 1.5, "delay": 3.0}]},
		{"banner": "An Ophan rolls: no post holds it unless it is staggered or frozen", "groups": [{"kind": "host_ophan", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_power", "count": 8, "spacing": 1.2}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_herald", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 5.0}, {"kind": "host_power", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.5, "delay": 2.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_power", "count": 6, "spacing": 1.1, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 14, "spacing": 0.8}, {"kind": "host_ophan", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Dominion of the Spheres: every angel near him stays quick and whole!", "groups": [{"kind": "host_dominion_of_the_spheres", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 3.0}, {"kind": "host_power", "count": 6, "spacing": 1.1, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.5}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 2.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Sphere of the Stars: wheels within wheels", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 4, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0}, {"kind": "host_dominion", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.0}, {"kind": "host_herald", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "The Wheel itself turns toward you", "groups": [{"kind": "host_ophan", "count": 4, "spacing": 3.0}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "The Throne rolls into the Wheel: strike its Core when the wheels part!", "groups": [{"kind": "host_throne", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.1, "delay": 5.0}, {"kind": "host_ophan", "count": 2, "spacing": 4.0, "delay": 10.0}, {"kind": "host_power", "count": 8, "spacing": 1.2, "delay": 16.0}]},
	],
}
