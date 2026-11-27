## The Witchwood (the Sanguine Court, map 2; Necropathy Stage 20, GDD §7.3): the
## fen, the hanging wood, the standing stones and the cauldron. Two entrances, a
## north fen path and a south fen path, each curl half way round the witches'
## circle (mirrored arcs, the hex stones inside it) and merge at its east side
## into one trunk that winds down to the gate, so the circle's plots see both
## paths and the trunk's posts take everything. 15 plots, 5 posts. Rule: three
## hex stones beside the paths (court/court_structures: a Crimson Witch near a
## standing stone casts twice as fast and heals the Court). Act rule: the Blood
## Moon. 23 back-to-back waves: covens of Crimson Witches, Bloated Thralls,
## ghouls, bats, knights, werewolves and nobles; the Bog Mother (miniboss,
## chest) on wave 12 and Isolde Vane, the Witch of the Red Moon on wave 23. Data
## only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "witchwood",
	"name": "The Witchwood",
	"floor": "tiles/witchwood_fen",
	"decals": ["decals/graveyard_fog", "decals/graveyard_fog_2", "decals/graveyard_fog_3", "decals/graveyard_grass_3", "decals/corpse_2"],
	"obstacles": [
		["obstacles/fen_snag_l", Vector2(260, 80)], ["obstacles/fen_snag_m", Vector2(470, 90)],
		["obstacles/charm_fence_l", Vector2(760, 110)], ["obstacles/witch_cauldron_l", Vector2(950, 200)],
		["obstacles/standing_stone_l", Vector2(240, 360)], ["obstacles/standing_stone_m", Vector2(600, 360)],
		["obstacles/fen_snag_l", Vector2(1210, 160)], ["obstacles/charm_fence_l_v", Vector2(1230, 300)],
		["obstacles/fen_snag_m", Vector2(260, 660)], ["obstacles/charm_fence_l", Vector2(470, 650)],
		["obstacles/witch_cauldron_m", Vector2(880, 680)], ["obstacles/standing_stone_s", Vector2(1150, 500)],
	],
	"roads": {
		"north": {
			"points": [Vector2(120, -40), Vector2(122, -22), Vector2(123, 5), Vector2(126, 36), Vector2(130, 67),
				Vector2(138, 97), Vector2(150, 120), Vector2(168, 137), Vector2(192, 152), Vector2(219, 163),
				Vector2(248, 173), Vector2(275, 182), Vector2(300, 190), Vector2(335, 201), Vector2(369, 209),
				Vector2(398, 214), Vector2(419, 219), Vector2(439, 200), Vector2(463, 185), Vector2(488, 174),
				Vector2(514, 165), Vector2(542, 161), Vector2(569, 160), Vector2(597, 163), Vector2(624, 170),
				Vector2(649, 181), Vector2(673, 195), Vector2(695, 212), Vector2(714, 232), Vector2(730, 255),
				Vector2(743, 279), Vector2(752, 305), Vector2(758, 332), Vector2(760, 360)],
			"next": "trunk", "next_at": 0.0,  # joins trunk at (760, 360)
			"entrance": true,
		},
		"south": {
			"points": [Vector2(120, 760), Vector2(122, 742), Vector2(123, 715), Vector2(126, 684), Vector2(130, 653),
				Vector2(138, 623), Vector2(150, 600), Vector2(168, 583), Vector2(192, 568), Vector2(219, 557),
				Vector2(248, 547), Vector2(275, 538), Vector2(300, 530), Vector2(335, 519), Vector2(369, 511),
				Vector2(398, 506), Vector2(419, 501), Vector2(439, 520), Vector2(463, 535), Vector2(488, 546),
				Vector2(514, 555), Vector2(542, 559), Vector2(569, 560), Vector2(597, 557), Vector2(624, 550),
				Vector2(649, 539), Vector2(673, 525), Vector2(695, 508), Vector2(714, 488), Vector2(730, 465),
				Vector2(743, 441), Vector2(752, 415), Vector2(758, 388), Vector2(760, 360)],
			"next": "trunk", "next_at": 0.0,  # joins trunk at (760, 360)
			"entrance": true,
		},
		"trunk": {
			"points": [Vector2(760, 360), Vector2(780, 358), Vector2(809, 355), Vector2(842, 352), Vector2(874, 353),
				Vector2(900, 360), Vector2(920, 375), Vector2(937, 395), Vector2(952, 419), Vector2(966, 445),
				Vector2(980, 470), Vector2(992, 496), Vector2(1001, 526), Vector2(1010, 555), Vector2(1023, 581),
				Vector2(1040, 600), Vector2(1067, 611), Vector2(1101, 617), Vector2(1136, 619), Vector2(1168, 619),
				Vector2(1190, 620)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(1218, 591),
	"plots": [
		Vector2(1080, 500), Vector2(840, 460), Vector2(1150, 540), Vector2(520, 490), Vector2(590, 230), Vector2(220, 630),
		Vector2(600, 450), Vector2(660, 280), Vector2(810, 290), Vector2(340, 130), Vector2(510, 240), Vector2(90, 160),
		Vector2(90, 560), Vector2(260, 110), Vector2(320, 590),
	],
	"posts": [Vector2(516, 165), Vector2(516, 555), Vector2(840, 352), Vector2(982, 475), Vector2(1102, 617)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.8,  # TUNING (not in GDD) the act's middle map presses a little harder than Ravensmoor
	"rule": "court/court_structures",
	"act_rule": "court/blood_moon",
	"build_order": "witchwood_default",
	"weak_order": "witchwood_weak",
	"waves": [
		{"banner": "Two fen paths through the Witchwood", "groups": [{"kind": "blood_thrall", "count": 8, "spacing": 1.3}, {"kind": "blood_thrall", "count": 8, "spacing": 1.3, "delay": 4.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.8, "road": "south"}, {"kind": "vampire_bat", "count": 6, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "Crimson Witches hex the towers", "groups": [{"kind": "crimson_witch", "count": 1, "spacing": 5.0}, {"kind": "blood_thrall", "count": 12, "spacing": 0.9, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.7}, {"kind": "blood_thrall", "count": 10, "spacing": 0.8, "road": "south"}, {"kind": "vampire_bat", "count": 8, "spacing": 0.6, "delay": 6.0, "road": "south"}]},
		{"banner": "Bloated Thralls burst into healing blood", "groups": [{"kind": "bloated_thrall", "count": 1, "spacing": 6.0, "road": "south"}, {"kind": "ghoul", "count": 10, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "blood_knight", "count": 2, "spacing": 5.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 12, "spacing": 0.5}, {"kind": "werewolf", "count": 2, "spacing": 5.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 1, "spacing": 6.0}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 12, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 16, "spacing": 0.6, "road": "south"}, {"kind": "vampire_noble", "count": 2, "spacing": 6.0, "delay": 3.0}, {"kind": "vampire_bat", "count": 8, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 3, "spacing": 4.0}, {"kind": "blood_knight", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "crimson_witch", "count": 2, "spacing": 5.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "bloated_thrall", "count": 2, "spacing": 5.0, "delay": 3.0}, {"kind": "ghoul", "count": 12, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "The Bog Mother rises from the fen", "groups": [{"kind": "bog_mother", "count": 1, "spacing": 1.0}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 14, "spacing": 0.7, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 16, "spacing": 0.45}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 2, "spacing": 5.0}, {"kind": "werewolf", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "ghoul", "count": 16, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 3, "spacing": 3.5}, {"kind": "blood_knight", "count": 4, "spacing": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 18, "spacing": 0.5, "road": "south"}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0}, {"kind": "vampire_bat", "count": 12, "spacing": 0.5, "delay": 7.0}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 3, "spacing": 4.5}, {"kind": "crimson_witch", "count": 3, "spacing": 3.5, "road": "south"}, {"kind": "werewolf", "count": 3, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 4, "spacing": 3.5}, {"kind": "blood_knight", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "ghoul", "count": 20, "spacing": 0.5}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 3, "spacing": 4.5}, {"kind": "bloated_thrall", "count": 3, "spacing": 4.5, "road": "south"}, {"kind": "blood_thrall", "count": 18, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 4, "spacing": 3.0}, {"kind": "werewolf", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "vampire_bat", "count": 16, "spacing": 0.45, "delay": 6.0, "road": "south"}]},
		{"banner": "The covens gather at the cauldron", "groups": [{"kind": "blood_knight", "count": 5, "spacing": 3.0, "road": "south"}, {"kind": "vampire_noble", "count": 3, "spacing": 4.5}, {"kind": "bloated_thrall", "count": 3, "spacing": 4.5, "delay": 8.0}, {"kind": "crimson_witch", "count": 3, "spacing": 3.5, "delay": 12.0, "road": "south"}]},
		{"banner": "Isolde Vane calls the Red Moon", "groups": [{"kind": "isolde", "count": 1, "spacing": 1.0}, {"kind": "crimson_witch", "count": 3, "spacing": 4.0, "delay": 5.0, "road": "south"}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}, {"kind": "bloated_thrall", "count": 3, "spacing": 5.0, "delay": 12.0, "road": "south"}]},
	],
}
