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
		["obstacles/wild_rose_hedge_m", Vector2(420, 690)], ["obstacles/wild_oak_l", Vector2(1240, 680)],
		["obstacles/wild_stone_s", Vector2(640, 120)], ["obstacles/wild_rose_hedge_m_v", Vector2(890, 380)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 255), Vector2(180, 255), Vector2(182, 232), Vector2(188, 209), Vector2(197, 188),
				Vector2(210, 169), Vector2(226, 152), Vector2(244, 137), Vector2(265, 126), Vector2(287, 119),
				Vector2(310, 115), Vector2(333, 116), Vector2(356, 120), Vector2(378, 127), Vector2(398, 139),
				Vector2(416, 153), Vector2(432, 170), Vector2(444, 190), Vector2(453, 212), Vector2(458, 234),
				Vector2(460, 257), Vector2(458, 280), Vector2(452, 303), Vector2(468, 316), Vector2(491, 336),
				Vector2(516, 356), Vector2(540, 370), Vector2(570, 379), Vector2(600, 381), Vector2(620, 382),
				Vector2(740, 382), Vector2(742, 359), Vector2(748, 337), Vector2(757, 315), Vector2(770, 296),
				Vector2(785, 279), Vector2(803, 265), Vector2(824, 254), Vector2(846, 246), Vector2(868, 242),
				Vector2(892, 242), Vector2(914, 246), Vector2(936, 254), Vector2(957, 265), Vector2(975, 279),
				Vector2(990, 296), Vector2(1003, 315), Vector2(1012, 337), Vector2(1018, 359), Vector2(1020, 382),
				Vector2(1025, 405), Vector2(1032, 437), Vector2(1043, 472), Vector2(1060, 500), Vector2(1082, 517),
				Vector2(1112, 531), Vector2(1143, 543), Vector2(1171, 553), Vector2(1190, 560)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(-40, 465), Vector2(180, 465), Vector2(182, 488), Vector2(188, 511), Vector2(197, 532),
				Vector2(210, 551), Vector2(226, 568), Vector2(244, 583), Vector2(265, 594), Vector2(287, 601),
				Vector2(310, 605), Vector2(333, 604), Vector2(356, 600), Vector2(378, 593), Vector2(398, 581),
				Vector2(416, 567), Vector2(432, 550), Vector2(444, 530), Vector2(453, 508), Vector2(458, 486),
				Vector2(460, 463), Vector2(458, 440), Vector2(452, 417), Vector2(475, 411), Vector2(508, 402),
				Vector2(540, 395), Vector2(571, 390), Vector2(601, 386), Vector2(622, 384)],
			"next": "main", "next_at": 902.6,  # joins main at (622, 382)
			"entrance": true,
		},
	},
	"gate": Vector2(1216, 540),
	"plots": [
		Vector2(390, 490), Vector2(130, 160), Vector2(390, 230), Vector2(50, 400), Vector2(530, 460), Vector2(600, 310),
		Vector2(520, 270), Vector2(310, 220), Vector2(310, 500), Vector2(120, 360), Vector2(930, 330), Vector2(850, 360),
		Vector2(680, 310), Vector2(1100, 420), Vector2(130, 560), Vector2(960, 410), Vector2(1170, 460),
	],
	"posts": [Vector2(168, 255), Vector2(92, 465), Vector2(584, 380), Vector2(818, 257), Vector2(1065, 503)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.2,  # TUNING (not in GDD) L7: 3.6 before the break fixes; L4: 4.2 before the road redraw; Part Three: a step above the Empyrean
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
