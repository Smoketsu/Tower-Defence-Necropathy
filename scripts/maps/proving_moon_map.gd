## The Proving Moon (Act XIII map 2; Necropathy stage "proving_moon"): the Vrask
## hunting ground, a grey moon of craters where they prove themselves on worthy
## prey. An arena: the hunting road comes in from the west and laps most of the
## oval track round the duelling ring, then cuts in along a straight to the gate
## on the dais at its heart, so the plots inside the ring cover the lap and the
## straight; the landing road comes in through the arena's east gate onto the
## track. Two sky lanes cross the ring diagonally (map road key "sky"). 16
## plots, 6 posts, 23 waves. Abduction (act rule concord/abduction). The
## Warbeast (miniboss, chest) on wave 12; Vrask'Tal, the Hunt-Lord, on wave 23.
## Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "proving_moon",
	"name": "The Proving Moon",
	"floor": "tiles/proving_moon_craters",
	"decals": ["decals/proving_moon_craters_crater", "decals/proving_moon_landing_crater"],
	"obstacles": [
		["obstacles/moon_boulder_l", Vector2(452, 388)], ["obstacles/moon_shrine_l", Vector2(140, 140)],
		["obstacles/moon_boulder_m", Vector2(1220, 520)], ["obstacles/trophy_pillar_l_v", Vector2(1180, 180)],
		["obstacles/moon_boulder_s", Vector2(80, 520)], ["obstacles/moon_shrine_s", Vector2(900, 680)],
		["obstacles/moon_boulder_m", Vector2(100, 700)], ["obstacles/trophy_pillar_s_v", Vector2(1060, 100)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 380), Vector2(220, 380), Vector2(221, 394), Vector2(223, 408), Vector2(227, 422),
				Vector2(233, 436), Vector2(240, 449), Vector2(248, 463), Vector2(258, 476), Vector2(269, 488),
				Vector2(282, 501), Vector2(296, 512), Vector2(312, 524), Vector2(329, 534), Vector2(346, 544),
				Vector2(365, 554), Vector2(385, 563), Vector2(406, 571), Vector2(428, 579), Vector2(451, 585),
				Vector2(474, 591), Vector2(498, 596), Vector2(522, 601), Vector2(547, 604), Vector2(572, 607),
				Vector2(598, 609), Vector2(624, 610), Vector2(649, 610), Vector2(675, 609), Vector2(701, 608),
				Vector2(726, 605), Vector2(751, 602), Vector2(776, 598), Vector2(800, 593), Vector2(823, 587),
				Vector2(846, 580), Vector2(868, 573), Vector2(889, 565), Vector2(909, 556), Vector2(929, 547),
				Vector2(947, 537), Vector2(964, 527), Vector2(980, 515), Vector2(994, 504), Vector2(1007, 492),
				Vector2(1019, 479), Vector2(1029, 466), Vector2(1038, 453), Vector2(1046, 440), Vector2(1052, 426),
				Vector2(1056, 412), Vector2(1059, 398), Vector2(1060, 384), Vector2(1060, 370), Vector2(1058, 356),
				Vector2(1054, 342), Vector2(1049, 328), Vector2(1043, 314), Vector2(1034, 301), Vector2(1025, 288),
				Vector2(1014, 275), Vector2(1001, 263), Vector2(988, 251), Vector2(972, 239), Vector2(956, 229),
				Vector2(939, 218), Vector2(920, 209), Vector2(900, 199), Vector2(880, 191), Vector2(858, 183),
				Vector2(836, 176), Vector2(813, 170), Vector2(789, 165), Vector2(764, 160), Vector2(740, 157),
				Vector2(714, 154), Vector2(689, 152), Vector2(663, 150), Vector2(638, 150), Vector2(612, 151),
				Vector2(586, 152), Vector2(561, 154), Vector2(536, 157), Vector2(511, 161), Vector2(487, 166),
				Vector2(463, 171), Vector2(440, 178), Vector2(418, 185), Vector2(397, 193), Vector2(376, 201),
				Vector2(357, 210), Vector2(338, 220), Vector2(321, 231), Vector2(305, 242), Vector2(290, 253),
				Vector2(276, 265), Vector2(620, 370)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"low": {
			"points": [Vector2(1320, 380), Vector2(1062, 380)],
			"next": "main", "next_at": 1302.7,  # joins main at (1060, 380)
			"entrance": true,
		},
		"sky_a": {
			"points": [Vector2(-60, 240), Vector2(1340, 480)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
		"sky_b": {
			"points": [Vector2(1340, 230), Vector2(-60, 490)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
	},
	"gate": Vector2(647, 348),
	"plots": [
		Vector2(520, 230), Vector2(440, 250), Vector2(230, 320), Vector2(1000, 380), Vector2(1130, 320), Vector2(1130, 440),
		Vector2(600, 220), Vector2(330, 410), Vector2(460, 490), Vector2(140, 460), Vector2(620, 520), Vector2(870, 500),
		Vector2(830, 240), Vector2(790, 530), Vector2(540, 510), Vector2(750, 220),
	],
	"posts": [Vector2(156, 380), Vector2(361, 552), Vector2(749, 602), Vector2(1036, 457), Vector2(740, 157), Vector2(1228, 380)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.0,  # TUNING (not in GDD) (DECISIONS Z4: kept, with Vrask'Tal 9000 -> 8000) rising through the act
	"rule": "",
	"act_rule": "concord/abduction",
	"build_order": "proving_moon_default",
	"weak_order": "proving_moon_weak",
	"waves": [
		{"banner": "The Hunt begins: prey is sent onto the moon", "groups": [{"kind": "concord_broodling", "count": 15, "spacing": 0.6}, {"kind": "concord_broodling", "count": 9, "spacing": 0.6, "delay": 4.0, "road": "low"}]},
		{"banner": "A saucer: shoot it down while its beam grows", "groups": [{"kind": "concord_grey_drone", "count": 2, "spacing": 1.5, "road": "low"}, {"kind": "concord_broodling", "count": 13, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 5, "spacing": 1.5}, {"kind": "concord_acid_spitter", "count": 3, "spacing": 1.5, "delay": 3.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 4, "spacing": 1.4}, {"kind": "concord_broodling", "count": 15, "spacing": 0.5, "delay": 2.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 17, "spacing": 0.5, "road": "low"}, {"kind": "concord_burrower", "count": 5, "spacing": 1.4, "delay": 2.0}]},
		{"banner": "A Lumen Sentinel: its shield soaks the first hits", "groups": [{"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0}, {"kind": "concord_grey_drone", "count": 4, "spacing": 1.2, "delay": 1.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_acid_spitter", "count": 6, "spacing": 1.2}, {"kind": "concord_burrower", "count": 7, "spacing": 1.2, "delay": 2.0, "road": "low"}]},
		{"banner": "A Star-Seer: her prism shields the hunters near her", "groups": [{"kind": "concord_prism", "count": 1, "spacing": 1.0, "road": "low"}, {"kind": "concord_grey_drone", "count": 4, "spacing": 1.1, "delay": 1.0, "road": "low"}, {"kind": "concord_broodling", "count": 17, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "A Vrask Hunter: a shimmer that moves. Posts hold it, spells reveal it", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 4.0}, {"kind": "concord_burrower", "count": 7, "spacing": 1.1, "delay": 2.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_acid_spitter", "count": 7, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_broodling", "count": 17, "spacing": 0.5, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 9, "spacing": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "low"}]},
		{"banner": "The Warbeast is loosed: it charges through your posts!", "groups": [{"kind": "concord_warbeast", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 7, "spacing": 1.3, "delay": 4.0, "road": "low"}, {"kind": "concord_grey_drone", "count": 5, "spacing": 1.3, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 21, "spacing": 0.4}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "low"}, {"kind": "concord_acid_spitter", "count": 7, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_burrower", "count": 10, "spacing": 1.0, "delay": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9, "road": "low"}, {"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "delay": 2.0}]},
		{"banner": "The trophy hall: the Vrask come for skulls", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.0}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "low"}, {"kind": "concord_broodling", "count": 21, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 11, "spacing": 0.9, "road": "low"}, {"kind": "concord_acid_spitter", "count": 8, "spacing": 0.9, "delay": 2.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0}, {"kind": "concord_grey_drone", "count": 10, "spacing": 0.9, "delay": 1.0, "road": "low"}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 19, "spacing": 0.4, "road": "low"}, {"kind": "concord_burrower", "count": 11, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_prism", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.5, "road": "low"}, {"kind": "concord_acid_spitter", "count": 9, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "The duelling ring fills", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9}, {"kind": "concord_burrower", "count": 11, "spacing": 0.9, "delay": 2.0, "road": "low"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Hunt-Lord's guard", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.0, "delay": 1.0}, {"kind": "concord_broodling", "count": 19, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "Vrask'Tal, the Hunt-Lord, stalks onto the moon!", "groups": [{"kind": "concord_vrask_tal", "count": 1, "spacing": 1.0}, {"kind": "concord_grey_drone", "count": 8, "spacing": 1.2, "delay": 5.0, "road": "low"}, {"kind": "concord_burrower", "count": 9, "spacing": 1.2, "delay": 10.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 16.0, "road": "low"}]},
	],
}
