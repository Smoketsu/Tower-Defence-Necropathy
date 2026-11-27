## The Greenwood (Act XV map 1; Necropathy stage "greenwood"): the old forest
## where the Wild Hunt rides. The main road is a meandering forest trail: it
## wanders in irregular bends from the left along the top of the wood, back west
## through the glade and east again through the hunting grounds to the gate of
## the deep wood, with the plots between its loops; the hunters' trail wanders
## in along the forest floor at the bottom left and joins the last stretch. 18
## plots, 6 posts, 22 waves. The Turning Year (act rule wild/turning_year): the
## season turns every 4 waves (Spring thickets, Summer haste, Autumn sprouts,
## Winter cold). The Huntsman of the Wild Hunt (miniboss, chest) on wave 12; the
## Stag King on wave 22. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "greenwood",
	"name": "The Greenwood",
	"floor": "tiles/greenwood_glade",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_grass_3", "decals/sanctum_courtyard_moss", "decals/sanctum_courtyard_moss_2"],
	"obstacles": [
		["obstacles/wild_oak_l", Vector2(100, 250)], ["obstacles/wild_stone_l", Vector2(1200, 380)],
		["obstacles/wild_oak_s", Vector2(580, 96)], ["obstacles/wild_rose_hedge_m", Vector2(640, 660)],
		["obstacles/wild_oak_l", Vector2(1220, 640)], ["obstacles/wild_stone_s", Vector2(1230, 96)],
		["obstacles/wild_thicket_m", Vector2(1100, 600)], ["obstacles/wild_oak_s", Vector2(90, 520)],
		["obstacles/wild_great_root_m", Vector2(420, 670)], ["obstacles/wild_stone_s_v", Vector2(1210, 240)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 170), Vector2(-22, 166), Vector2(2, 159), Vector2(31, 152), Vector2(62, 145),
				Vector2(93, 141), Vector2(120, 140), Vector2(149, 147), Vector2(177, 160), Vector2(205, 174),
				Vector2(232, 186), Vector2(260, 190), Vector2(288, 183), Vector2(315, 169), Vector2(343, 152),
				Vector2(371, 137), Vector2(400, 130), Vector2(426, 133), Vector2(453, 141), Vector2(480, 152),
				Vector2(507, 164), Vector2(534, 172), Vector2(560, 175), Vector2(589, 169), Vector2(616, 155),
				Vector2(644, 139), Vector2(671, 125), Vector2(700, 120), Vector2(726, 125), Vector2(753, 135),
				Vector2(781, 149), Vector2(808, 163), Vector2(835, 174), Vector2(860, 180), Vector2(888, 177),
				Vector2(916, 166), Vector2(942, 154), Vector2(966, 143), Vector2(990, 140), Vector2(1020, 147),
				Vector2(1049, 161), Vector2(1074, 180), Vector2(1090, 200), Vector2(1096, 233), Vector2(1089, 270),
				Vector2(1070, 300), Vector2(1051, 313), Vector2(1026, 325), Vector2(998, 333), Vector2(968, 339),
				Vector2(940, 340), Vector2(913, 334), Vector2(885, 321), Vector2(856, 306), Vector2(828, 294),
				Vector2(800, 290), Vector2(777, 296), Vector2(753, 309), Vector2(730, 326), Vector2(707, 342),
				Vector2(683, 354), Vector2(660, 360), Vector2(632, 354), Vector2(604, 340), Vector2(576, 322),
				Vector2(548, 306), Vector2(520, 300), Vector2(492, 306), Vector2(464, 320), Vector2(436, 337),
				Vector2(408, 352), Vector2(380, 360), Vector2(351, 356), Vector2(321, 345), Vector2(292, 332),
				Vector2(264, 322), Vector2(240, 320), Vector2(212, 331), Vector2(187, 352), Vector2(168, 376),
				Vector2(160, 400), Vector2(165, 423), Vector2(181, 448), Vector2(203, 471), Vector2(230, 490),
				Vector2(255, 501), Vector2(285, 510), Vector2(317, 517), Vector2(349, 520), Vector2(380, 520),
				Vector2(409, 513), Vector2(437, 500), Vector2(464, 485), Vector2(492, 474), Vector2(520, 470),
				Vector2(543, 476), Vector2(567, 489), Vector2(590, 506), Vector2(613, 522), Vector2(637, 534),
				Vector2(660, 540), Vector2(688, 534), Vector2(716, 520), Vector2(743, 502), Vector2(771, 486),
				Vector2(800, 480), Vector2(825, 484), Vector2(850, 495), Vector2(876, 509), Vector2(901, 523),
				Vector2(926, 534), Vector2(950, 540), Vector2(978, 537), Vector2(1004, 528), Vector2(1030, 516),
				Vector2(1056, 505), Vector2(1080, 500), Vector2(1111, 503), Vector2(1143, 512), Vector2(1171, 523),
				Vector2(1190, 530)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"trail": {
			"points": [Vector2(-40, 640), Vector2(-22, 636), Vector2(2, 630), Vector2(31, 622), Vector2(62, 616),
				Vector2(93, 611), Vector2(120, 610), Vector2(150, 615), Vector2(178, 625), Vector2(206, 637),
				Vector2(234, 647), Vector2(260, 650), Vector2(286, 647), Vector2(310, 639), Vector2(335, 628),
				Vector2(358, 615), Vector2(380, 600), Vector2(403, 581), Vector2(425, 558), Vector2(447, 534),
				Vector2(465, 513), Vector2(478, 498)],
			"next": "main", "next_at": 2714.8,  # joins main at (471, 482)
			"entrance": true,
		},
	},
	"gate": Vector2(1216, 510),
	"plots": [
		Vector2(320, 440), Vector2(650, 420), Vector2(930, 230), Vector2(130, 530), Vector2(240, 570), Vector2(640, 220),
		Vector2(460, 420), Vector2(490, 600), Vector2(720, 230), Vector2(360, 230), Vector2(440, 250), Vector2(1010, 230),
		Vector2(740, 430), Vector2(970, 430), Vector2(890, 440), Vector2(220, 250), Vector2(140, 250), Vector2(1050, 440),
	],
	"posts": [Vector2(676, 537), Vector2(977, 537), Vector2(547, 306), Vector2(1064, 304), Vector2(211, 639), Vector2(427, 133)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.4,  # TUNING (not in GDD) L4: 2.8 before the road redraw; Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "greenwood_default",
	"weak_order": "greenwood_weak",
	"waves": [
		{"banner": "Thornlings swarm out of the glade", "groups": [{"kind": "wild_thornling", "count": 13, "spacing": 1.12}, {"kind": "wild_fae_knight", "count": 3, "spacing": 3.2, "delay": 8.0}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 5, "spacing": 2.88}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "trail"}]},
		{"banner": "Hounds of the Hunt run the trail", "groups": [{"kind": "wild_hunt_hound", "count": 8, "spacing": 1.6, "road": "trail"}, {"kind": "wild_fae_knight", "count": 4, "spacing": 2.4, "delay": 4.8}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_hunt_hound", "count": 13, "spacing": 1.28}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "trail"}]},
		{"banner": "Corpse-Blooms: each buds Thornlings as it creeps", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 8.0}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}]},
		{"banner": "Will-o'-Wisps drift over the posts and gutter out of sight", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44, "road": "trail"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "Great Stags: a charge carries them through the posts", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 8.0}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "trail"}]},
		{"banner": "", "groups": [{"kind": "wild_fae_knight", "count": 10, "spacing": 1.6}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "trail"}, {"kind": "wild_hunt_hound", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 5, "spacing": 1.6, "delay": 6.4, "road": "trail"}]},
		{"banner": "Riders of the Wild Hunt: each horn calls hounds", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "The Huntsman of the Wild Hunt sounds his horn: the pack is loose!", "groups": [{"kind": "wild_huntsman", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 6.4}, {"kind": "wild_hunt_hound", "count": 8, "spacing": 1.28, "delay": 12.8, "road": "trail"}]},
		{"banner": "Treants: the walking oaks root the posts they strike", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 3.2, "road": "trail"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "trail"}, {"kind": "wild_hunt_hound", "count": 16, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "trail"}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0, "road": "trail"}, {"kind": "wild_thornling", "count": 21, "spacing": 0.64, "delay": 3.2}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "The Stag's Hollow: the herd runs", "groups": [{"kind": "wild_great_stag", "count": 3, "spacing": 5.6}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "trail"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "trail"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "trail"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 6.4}]},
		{"banner": "The whole wood rises against you", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_hunt_hound", "count": 13, "spacing": 0.8, "delay": 9.6, "road": "trail"}]},
		{"banner": "The Stag King leads the Wild Hunt!", "groups": [{"kind": "wild_stag_king", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 8.0}, {"kind": "wild_hunt_hound", "count": 10, "spacing": 1.28, "delay": 16.0, "road": "trail"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 25.6}]},
	],
}
