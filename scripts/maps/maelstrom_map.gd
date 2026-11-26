## The Maelstrom (Act II map 3, the Black Tide's finale; Necropathy's
## "maelstrom" stage, GDD §7.3): the deck of the Hollow Queen, a ghost ship in
## a whirlpool. One long lane spirals in from the stern (top left) round the
## deck four times to the necromancer's hatch at the heart, so the inner plots
## see the column pass two or three times; the drowned crew also board over
## the starboard rail (right) onto the outer ring. A sea serpent and gunboats
## ride the sea lane under the rail. Act rule: the Broadsides
## (rules/corsair/broadsides.gd), four cannons. 18 plots, 6 posts, 25 waves;
## the Ghost Bosun (miniboss) on wave 13, Captain Vandermere on wave 25.
## MAP keys: graveyard_map.gd. Data only, no logic.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "maelstrom",
	"name": "The Maelstrom",
	"floor": "tiles/corsair_maelstrom",
	"decals": [],
	"obstacles": [
		["obstacles/deck_mast_l", Vector2(640, 420)], ["obstacles/deck_hatch_l", Vector2(260, 320)],
		["obstacles/deck_barrels_l", Vector2(1240, 360)], ["obstacles/deck_hatch_l_v", Vector2(40, 400)],
		["obstacles/deck_barrels_s", Vector2(880, 660)], ["obstacles/deck_cannon_l", Vector2(400, 660)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 120), Vector2(1100, 120), Vector2(1160, 180), Vector2(1160, 540), Vector2(1100, 600),
				Vector2(220, 600), Vector2(160, 540), Vector2(160, 300), Vector2(220, 240), Vector2(940, 240),
				Vector2(1000, 300), Vector2(1000, 420), Vector2(940, 480), Vector2(420, 480), Vector2(360, 420),
				Vector2(360, 360), Vector2(400, 360)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"grapple": {
			"points": [Vector2(1320, 360), Vector2(1160, 360)],
			"next": "main", "next_at": 1404.9, "entrance": true,
		},
		"sea": {
			"points": [Vector2(-40, 700), Vector2(1320, 700)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"gate": Vector2(428, 330),
	"plots": [
		Vector2(300, 60), Vector2(640, 60), Vector2(980, 60), Vector2(1240, 250), Vector2(1240, 470), Vector2(1080, 300),
		Vector2(1080, 480), Vector2(800, 540), Vector2(500, 540), Vector2(260, 420), Vector2(80, 300), Vector2(80, 500),
		Vector2(500, 180), Vector2(800, 180), Vector2(620, 360), Vector2(820, 360), Vector2(280, 180), Vector2(1060, 660),
	],
	"posts": [Vector2(500, 120), Vector2(1160, 300), Vector2(700, 600), Vector2(160, 420), Vector2(700, 240), Vector2(680, 480)],
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
