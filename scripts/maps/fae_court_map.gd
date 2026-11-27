## The Fae Court (Act XV map 2; Necropathy stage "fae_court"): the revel of the
## Summer Queen in an endless summer. Fairy rings: two roads come in from the
## left, the north road sweeping round one great ring through the rose maze and
## the south road round its mirror past the revel; they meet between the rings,
## and the joined road sweeps round a third ring by the mirror lake and down to
## the Throne of Blossoms. 17 plots, 5 posts, 23 waves. The Turning Year (act
## rule wild/turning_year) holds Summer all run (every enemy faster) until the
## Winter Prince (miniboss, chest, wave 12) brings a minute of winter; the
## Summer Queen on wave 23. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "fae_court",
	"name": "The Fae Court",
	"floor": "tiles/fae_court_revel",
	"decals": ["decals/sanctum_cloisters_flowers", "decals/sanctum_cloisters_flowers_2", "decals/sanctum_courtyard_petals", "decals/sanctum_courtyard_petals_2", "decals/graveyard_grass"],
	"obstacles": [
		["obstacles/wild_rose_hedge_m_v", Vector2(70, 370)], ["obstacles/wild_rose_hedge_m", Vector2(630, 590)],
		["obstacles/wild_oak_s", Vector2(1230, 160)], ["obstacles/wild_stone_l", Vector2(870, 640)],
		["obstacles/wild_rose_hedge_m", Vector2(398, 645)], ["obstacles/wild_oak_l", Vector2(1240, 680)],
		["obstacles/wild_stone_s", Vector2(640, 120)], ["obstacles/wild_rose_hedge_m_v", Vector2(890, 380)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 250), Vector2(140, 250), Vector2(135, 249), Vector2(131, 247), Vector2(127, 244),
				Vector2(124, 239), Vector2(121, 233), Vector2(119, 225), Vector2(118, 217), Vector2(118, 207),
				Vector2(119, 197), Vector2(121, 186), Vector2(125, 175), Vector2(130, 163), Vector2(137, 151),
				Vector2(145, 139), Vector2(154, 127), Vector2(165, 116), Vector2(177, 105), Vector2(191, 94),
				Vector2(205, 85), Vector2(221, 76), Vector2(238, 69), Vector2(256, 62), Vector2(274, 57),
				Vector2(293, 53), Vector2(312, 51), Vector2(331, 50), Vector2(351, 50), Vector2(370, 52),
				Vector2(389, 56), Vector2(407, 60), Vector2(425, 66), Vector2(442, 73), Vector2(459, 82),
				Vector2(474, 91), Vector2(488, 101), Vector2(500, 112), Vector2(512, 123), Vector2(522, 135),
				Vector2(530, 147), Vector2(537, 159), Vector2(543, 171), Vector2(547, 182), Vector2(550, 193),
				Vector2(552, 204), Vector2(552, 213), Vector2(551, 222), Vector2(550, 230), Vector2(547, 237),
				Vector2(544, 242), Vector2(540, 246), Vector2(536, 249), Vector2(531, 250), Vector2(543, 269),
				Vector2(560, 300), Vector2(569, 323), Vector2(578, 352), Vector2(588, 379), Vector2(600, 400),
				Vector2(632, 416), Vector2(660, 420), Vector2(655, 419), Vector2(651, 417), Vector2(647, 414),
				Vector2(644, 409), Vector2(641, 403), Vector2(639, 395), Vector2(638, 387), Vector2(638, 377),
				Vector2(639, 367), Vector2(641, 356), Vector2(645, 345), Vector2(650, 333), Vector2(657, 321),
				Vector2(665, 309), Vector2(674, 297), Vector2(685, 286), Vector2(697, 275), Vector2(711, 264),
				Vector2(725, 255), Vector2(741, 246), Vector2(758, 239), Vector2(776, 232), Vector2(794, 227),
				Vector2(813, 223), Vector2(832, 221), Vector2(851, 220), Vector2(871, 220), Vector2(890, 222),
				Vector2(909, 226), Vector2(927, 230), Vector2(945, 236), Vector2(962, 243), Vector2(979, 252),
				Vector2(994, 261), Vector2(1008, 271), Vector2(1020, 282), Vector2(1032, 293), Vector2(1042, 305),
				Vector2(1050, 317), Vector2(1057, 329), Vector2(1063, 341), Vector2(1067, 352), Vector2(1070, 363),
				Vector2(1072, 374), Vector2(1072, 383), Vector2(1071, 392), Vector2(1070, 400), Vector2(1067, 407),
				Vector2(1064, 412), Vector2(1060, 416), Vector2(1056, 419), Vector2(1051, 420), Vector2(1100, 430),
				Vector2(1120, 449), Vector2(1142, 475), Vector2(1160, 500), Vector2(1179, 534), Vector2(1190, 560)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(-40, 520), Vector2(140, 520), Vector2(135, 521), Vector2(131, 523), Vector2(127, 526),
				Vector2(124, 531), Vector2(121, 537), Vector2(119, 545), Vector2(118, 553), Vector2(118, 563),
				Vector2(119, 573), Vector2(121, 584), Vector2(125, 595), Vector2(130, 607), Vector2(137, 619),
				Vector2(145, 631), Vector2(154, 643), Vector2(165, 654), Vector2(177, 665), Vector2(191, 676),
				Vector2(205, 685), Vector2(221, 694), Vector2(238, 701), Vector2(256, 708), Vector2(274, 713),
				Vector2(293, 717), Vector2(312, 719), Vector2(331, 720), Vector2(351, 720), Vector2(370, 718),
				Vector2(389, 714), Vector2(407, 710), Vector2(425, 704), Vector2(442, 697), Vector2(459, 688),
				Vector2(474, 679), Vector2(488, 669), Vector2(500, 658), Vector2(512, 647), Vector2(522, 635),
				Vector2(530, 623), Vector2(537, 611), Vector2(543, 599), Vector2(547, 588), Vector2(550, 577),
				Vector2(552, 566), Vector2(552, 557), Vector2(551, 548), Vector2(550, 540), Vector2(547, 533),
				Vector2(544, 528), Vector2(540, 524), Vector2(536, 521), Vector2(531, 520), Vector2(560, 480),
				Vector2(575, 456), Vector2(591, 429), Vector2(602, 410)],
			"next": "main", "next_at": 1040.4,  # joins main at (606, 403)
			"entrance": true,
		},
	},
	"gate": Vector2(1200, 576),
	"plots": [
		Vector2(470, 580), Vector2(50, 190), Vector2(80, 110), Vector2(340, 660), Vector2(620, 510), Vector2(620, 260),
		Vector2(520, 380), Vector2(660, 190), Vector2(250, 610), Vector2(80, 650), Vector2(940, 310), Vector2(250, 140),
		Vector2(410, 150), Vector2(830, 290), Vector2(340, 110), Vector2(1170, 400), Vector2(1050, 480),
	],
	"posts": [Vector2(118, 201), Vector2(110, 520), Vector2(584, 368), Vector2(770, 234), Vector2(1100, 430)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.6,  # TUNING (not in GDD) L4: 4.2 before the road redraw; Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "fae_court_default",
	"weak_order": "fae_court_weak",
	"waves": [
		{"banner": "The revel spills onto the roads", "groups": [{"kind": "wild_thornling", "count": 16, "spacing": 0.96}, {"kind": "wild_fae_knight", "count": 4, "spacing": 3.2, "delay": 6.4, "road": "south"}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 6, "spacing": 2.4, "road": "south"}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "Masked Courtiers dance in from the rose maze", "groups": [{"kind": "wild_masked_courtier", "count": 6, "spacing": 2.4}, {"kind": "wild_fae_knight", "count": 5, "spacing": 2.4, "delay": 4.8, "road": "south"}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6, "road": "south"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8, "road": "south"}]},
		{"banner": "Will-o'-Wisps drift over the posts and gutter out of sight", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44}, {"kind": "wild_masked_courtier", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "south"}]},
		{"banner": "Winter Fae: their frost bolts freeze a tower", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_masked_courtier", "count": 10, "spacing": 1.6, "road": "south"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 4.8}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6, "road": "south"}]},
		{"banner": "Corpse-Blooms creep through the revel", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 8.0, "road": "south"}, {"kind": "wild_masked_courtier", "count": 8, "spacing": 1.92, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 5, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "south"}]},
		{"banner": "Great Stags break from the rose maze", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 8.0}, {"kind": "wild_masked_courtier", "count": 10, "spacing": 1.6, "delay": 3.2, "road": "south"}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "The Winter Prince rides in from the cold!", "groups": [{"kind": "wild_winter_prince", "count": 1, "spacing": 1.6}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 6.4, "road": "south"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 12.8}]},
		{"banner": "", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_masked_courtier", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 4.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "south"}, {"kind": "wild_winter_fae", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 18, "spacing": 0.64, "delay": 4.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_masked_courtier", "count": 13, "spacing": 1.44}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "south"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "road": "south"}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "The Throne of Blossoms: the whole court dances", "groups": [{"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28}, {"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 0.96, "delay": 6.4, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4}, {"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "The court's last dance before the Queen", "groups": [{"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28, "road": "south"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_thornling", "count": 16, "spacing": 0.64, "delay": 9.6, "road": "south"}]},
		{"banner": "The Summer Queen holds court!", "groups": [{"kind": "wild_summer_queen", "count": 1, "spacing": 1.6}, {"kind": "wild_masked_courtier", "count": 10, "spacing": 1.92, "delay": 8.0, "road": "south"}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 16.0}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 25.6, "road": "south"}]},
	],
}
