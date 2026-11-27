## The Maelstrom (Act II map 3, the Black Tide's finale; Necropathy's
## "maelstrom" stage, GDD §7.3): the deck of the Hollow Queen, a ghost ship in a
## whirlpool. One long lane spirals in from the stern (left) round the whirlpool
## two and a quarter times (a true spiral, wider than tall) to the necromancer's
## hatch at its eye, so the inner plots see the column pass two or three times;
## the drowned crew also board over the starboard rail (right) onto the outer
## turn. A sea serpent and gunboats ride the sea lane under the rail. Act rule:
## the Broadsides (rules/corsair/broadsides.gd), four cannons. 18 plots, 6
## posts, 25 waves; the Ghost Bosun (miniboss) on wave 13, Captain Vandermere on
## wave 25. MAP keys: graveyard_map.gd. Data only, no logic.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "maelstrom",
	"name": "The Maelstrom",
	"floor": "tiles/corsair_maelstrom",
	"decals": [],
	"obstacles": [
		["obstacles/deck_mast_l", Vector2(652, 382)], ["obstacles/deck_hatch_l", Vector2(260, 320)],
		["obstacles/deck_barrels_l", Vector2(1240, 360)], ["obstacles/deck_hatch_l_v", Vector2(55, 426)],
		["obstacles/deck_barrels_s", Vector2(880, 660)], ["obstacles/deck_cannon_l", Vector2(400, 660)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 360), Vector2(100, 360), Vector2(106, 334), Vector2(116, 309), Vector2(132, 284),
				Vector2(152, 260), Vector2(177, 237), Vector2(206, 216), Vector2(240, 196), Vector2(277, 178),
				Vector2(317, 162), Vector2(361, 148), Vector2(408, 136), Vector2(456, 127), Vector2(506, 120),
				Vector2(558, 116), Vector2(609, 115), Vector2(661, 116), Vector2(712, 121), Vector2(762, 128),
				Vector2(811, 137), Vector2(856, 149), Vector2(899, 164), Vector2(939, 181), Vector2(974, 200),
				Vector2(1005, 221), Vector2(1031, 243), Vector2(1052, 267), Vector2(1067, 292), Vector2(1076, 317),
				Vector2(1079, 343), Vector2(1076, 369), Vector2(1067, 395), Vector2(1052, 420), Vector2(1031, 443),
				Vector2(1004, 466), Vector2(972, 486), Vector2(935, 504), Vector2(894, 520), Vector2(849, 533),
				Vector2(801, 543), Vector2(751, 550), Vector2(700, 554), Vector2(648, 554), Vector2(597, 550),
				Vector2(547, 543), Vector2(499, 533), Vector2(455, 520), Vector2(414, 503), Vector2(379, 484),
				Vector2(350, 463), Vector2(327, 440), Vector2(312, 415), Vector2(304, 389), Vector2(304, 363),
				Vector2(312, 338), Vector2(328, 313), Vector2(351, 290), Vector2(382, 269), Vector2(419, 251),
				Vector2(461, 236), Vector2(508, 226), Vector2(558, 219), Vector2(610, 217), Vector2(662, 219),
				Vector2(711, 227), Vector2(757, 238), Vector2(798, 254), Vector2(831, 274), Vector2(856, 297),
				Vector2(871, 321), Vector2(875, 347), Vector2(868, 373), Vector2(850, 397), Vector2(821, 418),
				Vector2(782, 435), Vector2(736, 447), Vector2(686, 452), Vector2(635, 451), Vector2(587, 442),
				Vector2(546, 426), Vector2(518, 405), Vector2(505, 380), Vector2(512, 355), Vector2(538, 333),
				Vector2(580, 319), Vector2(630, 318), Vector2(640, 320)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"grapple": {
			"points": [Vector2(1320, 250), Vector2(1210, 250), Vector2(1170, 300)],
			"next": "main", "next_at": 1283.5,  # joins main at (1076, 317)
			"entrance": true,
		},
		"sea": {
			"points": [Vector2(-40, 700), Vector2(1320, 700)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"gate": Vector2(668, 295),
	"plots": [
		Vector2(90, 230), Vector2(380, 80), Vector2(890, 230), Vector2(1120, 250), Vector2(750, 610), Vector2(1160, 360),
		Vector2(670, 610), Vector2(470, 300), Vector2(780, 320), Vector2(890, 450), Vector2(710, 370), Vector2(930, 350),
		Vector2(300, 240), Vector2(830, 80), Vector2(450, 380), Vector2(610, 380), Vector2(190, 330), Vector2(480, 460),
	],
	"posts": [Vector2(282, 176), Vector2(880, 158), Vector2(903, 516), Vector2(396, 494), Vector2(597, 217), Vector2(653, 451)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.0,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "corsair/broadsides",
	"build_order": "maelstrom_default",
	"weak_order": "maelstrom_weak",
	"waves": [
		{"banner": "The Hollow Queen's drowned crew stirs", "groups": [{"kind": "tide_ghost_deckhand", "count": 12, "spacing": 1.2}]},
		{"banner": "", "groups": [{"kind": "tide_deckhand", "count": 12, "spacing": 1.0}, {"kind": "tide_ghost_gunner", "count": 4, "spacing": 1.4, "delay": 5.0}]},
		{"banner": "The drowned board over the starboard rail", "groups": [{"kind": "tide_ghost_deckhand", "count": 10, "spacing": 1.0, "road": "grapple"}, {"kind": "tide_musketeer", "count": 8, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "tide_powder_runner", "count": 10, "spacing": 0.9}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "tide_swashbuckler", "count": 4, "spacing": 3.0}, {"kind": "tide_ghost_deckhand", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_voodoo_navigator", "count": 2, "spacing": 4.0}, {"kind": "tide_ghost_gunner", "count": 10, "spacing": 0.9, "delay": 2.0}]},
		{"banner": "A sea serpent coils under the rail", "groups": [{"kind": "tide_sea_serpent", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.8, "delay": 2.0}, {"kind": "tide_boatswain", "count": 2, "spacing": 4.0, "delay": 5.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 3, "spacing": 3.5, "road": "grapple"}, {"kind": "tide_powder_runner", "count": 12, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 3, "spacing": 3.5}, {"kind": "tide_gunnery_mate", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "tide_ghost_deckhand", "count": 12, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_swashbuckler", "count": 5, "spacing": 2.5, "delay": 2.0, "road": "grapple"}, {"kind": "tide_ghost_gunner", "count": 12, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_voodoo_navigator", "count": 3, "spacing": 3.0}, {"kind": "tide_grappler", "count": 4, "spacing": 2.0, "delay": 2.0, "road": "grapple"}, {"kind": "tide_deckhand", "count": 16, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 4, "spacing": 3.0}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "tide_powder_runner", "count": 12, "spacing": 0.6, "delay": 5.0, "road": "grapple"}]},
		{"banner": "The Ghost Bosun's whistle calls the drowned!", "groups": [{"kind": "ghost_bosun", "count": 1, "spacing": 1.0}, {"kind": "tide_ghost_deckhand", "count": 18, "spacing": 0.7, "delay": 3.0}, {"kind": "tide_ghost_gunner", "count": 6, "spacing": 1.0, "delay": 8.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 4, "spacing": 3.0}, {"kind": "tide_gunnery_mate", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "grapple"}, {"kind": "tide_musketeer", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_sea_serpent", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0, "delay": 1.0}, {"kind": "tide_ghost_deckhand", "count": 14, "spacing": 0.6, "delay": 4.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_voodoo_navigator", "count": 3, "spacing": 3.0}, {"kind": "tide_hull_crab", "count": 4, "spacing": 3.0, "delay": 2.0, "road": "grapple"}, {"kind": "tide_powder_runner", "count": 14, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 5, "spacing": 2.5}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "tide_ghost_gunner", "count": 14, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "A drowned swarm over both rails", "groups": [{"kind": "tide_ghost_deckhand", "count": 24, "spacing": 0.5}, {"kind": "tide_ghost_deckhand", "count": 14, "spacing": 0.6, "delay": 2.0, "road": "grapple"}, {"kind": "tide_gunnery_mate", "count": 3, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "tide_gunboat", "count": 2, "spacing": 8.0, "road": "sea"}, {"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0, "delay": 1.0}, {"kind": "tide_grappler", "count": 5, "spacing": 2.0, "delay": 4.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 5, "spacing": 2.5}, {"kind": "tide_voodoo_navigator", "count": 3, "spacing": 3.0, "delay": 3.0, "road": "grapple"}, {"kind": "tide_musketeer", "count": 16, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 6, "spacing": 2.5}, {"kind": "tide_powder_runner", "count": 16, "spacing": 0.5, "delay": 3.0, "road": "grapple"}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "tide_sea_serpent", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_swashbuckler", "count": 8, "spacing": 1.8}, {"kind": "tide_ghost_gunner", "count": 16, "spacing": 0.6, "delay": 4.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 6, "spacing": 2.5, "road": "grapple"}, {"kind": "tide_gunnery_mate", "count": 4, "spacing": 2.5, "delay": 2.0}, {"kind": "tide_ghost_deckhand", "count": 20, "spacing": 0.5, "delay": 5.0}]},
		{"banner": "The whirlpool gives up all its dead", "groups": [{"kind": "tide_boarding_bruiser", "count": 6, "spacing": 2.5}, {"kind": "tide_voodoo_navigator", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0, "delay": 5.0, "road": "grapple"}, {"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "sea"}]},
		{"banner": "Captain Vandermere sails out of the whirlpool, lashed to his wheel!", "groups": [{"kind": "vandermere", "count": 1, "spacing": 1.0}, {"kind": "tide_ghost_deckhand", "count": 12, "spacing": 0.9, "delay": 4.0, "road": "grapple"}, {"kind": "tide_hull_crab", "count": 3, "spacing": 4.0, "delay": 8.0}]},
	],
}
