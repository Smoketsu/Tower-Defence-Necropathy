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
		["obstacles/moon_boulder_l", Vector2(440, 350)], ["obstacles/moon_shrine_l", Vector2(140, 140)],
		["obstacles/moon_boulder_m", Vector2(1220, 520)], ["obstacles/trophy_pillar_l_v", Vector2(1180, 180)],
		["obstacles/moon_boulder_s", Vector2(80, 520)], ["obstacles/moon_shrine_s", Vector2(900, 680)],
		["obstacles/moon_boulder_m", Vector2(100, 700)], ["obstacles/trophy_pillar_s_v", Vector2(1060, 100)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 380), Vector2(220, 380), Vector2(221, 394), Vector2(223, 408), Vector2(227, 422),
				Vector2(233, 436), Vector2(240, 449), Vector2(248, 463), Vector2(258, 476), Vector2(269, 488),
				Vector2(282, 500), Vector2(296, 512), Vector2(312, 523), Vector2(328, 534), Vector2(346, 544),
				Vector2(365, 554), Vector2(385, 563), Vector2(406, 571), Vector2(428, 578), Vector2(450, 585),
				Vector2(473, 591), Vector2(497, 596), Vector2(522, 601), Vector2(547, 604), Vector2(572, 607),
				Vector2(597, 609), Vector2(623, 610), Vector2(649, 610), Vector2(674, 609), Vector2(700, 608),
				Vector2(725, 605), Vector2(750, 602), Vector2(775, 598), Vector2(799, 593), Vector2(822, 587),
				Vector2(845, 581), Vector2(867, 573), Vector2(888, 566), Vector2(909, 557), Vector2(928, 548),
				Vector2(946, 538), Vector2(963, 527), Vector2(979, 516), Vector2(993, 504), Vector2(1007, 492),
				Vector2(1018, 480), Vector2(1029, 467), Vector2(1038, 454), Vector2(1045, 440), Vector2(1051, 427),
				Vector2(1056, 413), Vector2(1059, 399), Vector2(1060, 385), Vector2(1060, 371), Vector2(1058, 357),
				Vector2(1054, 343), Vector2(1049, 329), Vector2(1043, 315), Vector2(1035, 302), Vector2(1026, 289),
				Vector2(1015, 276), Vector2(1002, 264), Vector2(989, 252), Vector2(974, 240), Vector2(957, 229),
				Vector2(940, 219), Vector2(921, 209), Vector2(902, 200), Vector2(881, 192), Vector2(860, 184),
				Vector2(838, 177), Vector2(814, 171), Vector2(791, 165), Vector2(767, 161), Vector2(742, 157),
				Vector2(717, 154), Vector2(691, 152), Vector2(666, 150), Vector2(640, 150), Vector2(640, 360)],
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
	"gate": Vector2(640, 378),
	"plots": [
		Vector2(1000, 380), Vector2(770, 250), Vector2(700, 290), Vector2(950, 310), Vector2(1130, 320), Vector2(1130, 440),
		Vector2(150, 450), Vector2(700, 210), Vector2(870, 500), Vector2(350, 470), Vector2(480, 530), Vector2(590, 550),
		Vector2(680, 550), Vector2(770, 530), Vector2(190, 520), Vector2(130, 320),
	],
	"posts": [Vector2(156, 380), Vector2(361, 552), Vector2(749, 602), Vector2(1036, 457), Vector2(912, 205), Vector2(1228, 380)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.9,  # TUNING (not in GDD) B4: 2.3 before the balance pass; L7: 3.0 before the break fixes; (DECISIONS Z4: kept, with Vrask'Tal 9000 -> 8000) rising through the act
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
