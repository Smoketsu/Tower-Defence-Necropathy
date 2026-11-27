## Ravensmoor (the Sanguine Court, map 1; Necropathy Stage 19, GDD §7.3): the
## moor, the village and the old church under a cold moon. Two entrances: the
## moor road from the west is a crooked track that meanders in organic loops
## round the tors and the church, and the village lane curls down from the north
## and joins it in the middle, so the plots inside its loops see the column
## twice. 16 plots, 5 posts. Rule: four sleeping coffins beside the road
## (court/court_structures: a Vampire Noble climbs out of each unbroken coffin
## at the Blood Moon's rise). Act rule: the Blood Moon. 22 back-to-back waves:
## thralls, ghoul packs, bats, Blood Knights, werewolves and Vampire Nobles; Old
## Greymane (miniboss, chest) on wave 11 and Vargr, the Moon-Eater on wave 22.
## Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "ravensmoor",
	"name": "Ravensmoor",
	"floor": "tiles/ravensmoor_moor",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_fog", "decals/graveyard_fog_2", "decals/graveyard_grave", "decals/corpse"],
	"obstacles": [
		["obstacles/moor_pine_l", Vector2(60, 230)], ["obstacles/moor_cairn_m", Vector2(160, 70)],
		["obstacles/thatch_cottage_l", Vector2(600, 64)], ["obstacles/village_fence_l", Vector2(390, 66)],
		["obstacles/moor_pine_s", Vector2(1210, 120)], ["obstacles/moor_cairn_l", Vector2(1200, 260)],
		["obstacles/church_ruin_l", Vector2(110, 640)], ["obstacles/grave_cross_l", Vector2(262, 688)],
		["obstacles/grave_cross_s", Vector2(700, 660)], ["obstacles/moor_cairn_s", Vector2(1150, 680)],
		["obstacles/moor_pine_l", Vector2(60, 400)], ["obstacles/grave_cross_s", Vector2(700, 470)],
	],
	"roads": {
		"west": {
			"points": [Vector2(-40, 150), Vector2(-24, 150), Vector2(-2, 148), Vector2(24, 147), Vector2(53, 146),
				Vector2(84, 145), Vector2(115, 144), Vector2(145, 145), Vector2(174, 146), Vector2(200, 150),
				Vector2(232, 157), Vector2(265, 165), Vector2(297, 174), Vector2(327, 186), Vector2(354, 199),
				Vector2(375, 214), Vector2(390, 230), Vector2(398, 253), Vector2(399, 280), Vector2(393, 310),
				Vector2(382, 340), Vector2(367, 367), Vector2(350, 390), Vector2(330, 405), Vector2(302, 417),
				Vector2(270, 427), Vector2(238, 436), Vector2(208, 445), Vector2(184, 456), Vector2(170, 470),
				Vector2(164, 496), Vector2(168, 528), Vector2(182, 560), Vector2(203, 589), Vector2(230, 610),
				Vector2(249, 618), Vector2(273, 623), Vector2(300, 628), Vector2(329, 630), Vector2(360, 632),
				Vector2(390, 631), Vector2(419, 629), Vector2(446, 625), Vector2(470, 620), Vector2(498, 610),
				Vector2(524, 597), Vector2(550, 580), Vector2(572, 562), Vector2(592, 542), Vector2(608, 521),
				Vector2(620, 500), Vector2(625, 474), Vector2(621, 446), Vector2(612, 416), Vector2(603, 386),
				Vector2(597, 357), Vector2(600, 330), Vector2(609, 307), Vector2(622, 284), Vector2(637, 262),
				Vector2(656, 240), Vector2(676, 220), Vector2(697, 203), Vector2(720, 190), Vector2(745, 180),
				Vector2(774, 171), Vector2(805, 166), Vector2(836, 162), Vector2(867, 162), Vector2(895, 164),
				Vector2(920, 170), Vector2(946, 182), Vector2(972, 199), Vector2(996, 221), Vector2(1014, 244),
				Vector2(1027, 268), Vector2(1030, 290), Vector2(1022, 308), Vector2(1005, 326), Vector2(982, 344),
				Vector2(956, 362), Vector2(931, 381), Vector2(911, 400), Vector2(900, 420), Vector2(897, 445),
				Vector2(900, 472), Vector2(908, 500), Vector2(919, 527), Vector2(934, 551), Vector2(950, 570),
				Vector2(970, 585), Vector2(995, 598), Vector2(1022, 608), Vector2(1051, 615), Vector2(1077, 619),
				Vector2(1100, 620), Vector2(1129, 611), Vector2(1154, 593), Vector2(1175, 573), Vector2(1190, 560)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(520, -40), Vector2(516, -22), Vector2(510, 4), Vector2(503, 33), Vector2(499, 63),
				Vector2(500, 90), Vector2(509, 120), Vector2(524, 150), Vector2(542, 177), Vector2(560, 200),
				Vector2(588, 223), Vector2(619, 239), Vector2(640, 250)],
			"next": "west", "next_at": 1691.5,  # joins west at (644, 254)
			"entrance": true,
		},
	},
	"gate": Vector2(1211, 511),
	"plots": [
		Vector2(710, 280), Vector2(1030, 500), Vector2(320, 520), Vector2(240, 530), Vector2(500, 500), Vector2(520, 410),
		Vector2(600, 140), Vector2(440, 150), Vector2(160, 210), Vector2(510, 250), Vector2(870, 260), Vector2(250, 260),
		Vector2(950, 270), Vector2(400, 530), Vector2(1100, 540), Vector2(970, 440),
	],
	"posts": [Vector2(287, 421), Vector2(546, 182), Vector2(567, 566), Vector2(1015, 316), Vector2(1033, 611)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.0,  # TUNING (not in GDD) B4: 3.2 before the balance pass; L4: 4.2 before the road redraw; a step above the Sanctum's late waves (two columns share them)
	"rule": "court/court_structures",
	"act_rule": "court/blood_moon",
	"build_order": "ravensmoor_default",
	"weak_order": "ravensmoor_weak",
	"waves": [
		{"banner": "The moor road and the village lane", "groups": [{"kind": "blood_thrall", "count": 10, "spacing": 1.3}, {"kind": "ghoul", "count": 4, "spacing": 1.0, "delay": 8.0, "road": "north"}]},
		{"banner": "Ghouls stop to eat the fallen and heal", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.8}, {"kind": "blood_thrall", "count": 6, "spacing": 1.1, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 1, "spacing": 6.0}, {"kind": "blood_thrall", "count": 10, "spacing": 1.0, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_thrall", "count": 12, "spacing": 0.9}, {"kind": "ghoul", "count": 8, "spacing": 0.8, "delay": 3.0, "road": "north"}, {"kind": "vampire_bat", "count": 6, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "Werewolves shoot until the moon turns them", "groups": [{"kind": "werewolf", "count": 1, "spacing": 6.0}, {"kind": "ghoul", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 8, "spacing": 0.6}, {"kind": "blood_knight", "count": 2, "spacing": 5.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_thrall", "count": 14, "spacing": 0.8}, {"kind": "werewolf", "count": 2, "spacing": 5.0, "delay": 5.0, "road": "north"}]},
		{"banner": "Vampire Nobles drain the blockers", "groups": [{"kind": "vampire_noble", "count": 2, "spacing": 7.0}, {"kind": "ghoul", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 3, "spacing": 5.0}, {"kind": "blood_thrall", "count": 16, "spacing": 0.7, "delay": 2.0, "road": "north"}, {"kind": "vampire_bat", "count": 8, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 4, "spacing": 4.0}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0, "road": "north"}]},
		{"banner": "Old Greymane howls the pack into beasts", "groups": [{"kind": "old_greymane", "count": 1, "spacing": 1.0}, {"kind": "werewolf", "count": 3, "spacing": 5.0, "delay": 5.0, "road": "north"}, {"kind": "ghoul", "count": 10, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 14, "spacing": 0.5}, {"kind": "vampire_noble", "count": 2, "spacing": 6.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 5, "spacing": 4.0}, {"kind": "werewolf", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "blood_thrall", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 18, "spacing": 0.5}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "vampire_bat", "count": 10, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 5, "spacing": 4.0}, {"kind": "blood_thrall", "count": 18, "spacing": 0.6, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 6, "spacing": 3.5, "road": "north"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 3.0}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 20, "spacing": 0.5}, {"kind": "werewolf", "count": 5, "spacing": 4.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 4, "spacing": 5.0}, {"kind": "blood_knight", "count": 5, "spacing": 4.0, "delay": 3.0, "road": "north"}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "ghoul", "count": 18, "spacing": 0.5, "road": "north"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 8, "spacing": 3.0}, {"kind": "vampire_noble", "count": 4, "spacing": 5.0, "road": "north"}, {"kind": "blood_thrall", "count": 20, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "The whole Court rides out", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "blood_knight", "count": 6, "spacing": 3.5, "road": "north"}, {"kind": "vampire_bat", "count": 16, "spacing": 0.5, "delay": 6.0}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "delay": 12.0}]},
		{"banner": "Vargr, the Moon-Eater, comes for the moon", "groups": [{"kind": "vargr", "count": 1, "spacing": 1.0}, {"kind": "werewolf", "count": 4, "spacing": 5.0, "delay": 6.0, "road": "north"}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}, {"kind": "blood_knight", "count": 4, "spacing": 4.0, "delay": 14.0, "road": "north"}]},
	],
}
