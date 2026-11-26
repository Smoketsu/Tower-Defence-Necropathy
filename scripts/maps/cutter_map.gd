## The Smuggler's Cutter (Act II map 1, the Black Tide; Necropathy's
## "cutter" stage, GDD §7.3): a night deck. The boarders' gangway enters at
## the stern (left) and snakes over the deck to the necromancer's hatch on the
## bow (right); grapplers hook the bottom rail and board by a short second
## gangway that joins the main lane mid-deck; gunboats sail the sea lane under
## the rail (an off-road crossing: no lives lost). Act rule: the Broadsides
## (rules/corsair/broadsides.gd): deck cannons run out at the rail shell plots on
## a telegraph; powder barrels beside them spike them; Gunnery Mates man them.
## 16 plots, 6 posts, 22 waves; Bosun Gorran (miniboss) on wave 11, Captain
## Crow on wave 22. MAP keys: graveyard_map.gd. Data only, no logic.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "cutter",
	"name": "The Smuggler's Cutter",
	"floor": "tiles/corsair_cutter",
	"decals": [],
	"obstacles": [
		["obstacles/deck_mast_l", Vector2(660, 300)], ["obstacles/deck_hatch_l", Vector2(110, 300)],
		["obstacles/deck_barrels_l", Vector2(1180, 560)], ["obstacles/deck_hatch_l_v", Vector2(680, 140)],
		["obstacles/deck_barrels_s", Vector2(60, 560)], ["obstacles/deck_cannon_l_v", Vector2(1230, 470)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 160), Vector2(360, 160), Vector2(420, 220), Vector2(420, 420), Vector2(480, 480),
				Vector2(860, 480), Vector2(920, 420), Vector2(920, 240), Vector2(980, 180), Vector2(1190, 180)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"grapple": {
			"points": [Vector2(660, 664), Vector2(660, 540), Vector2(640, 480)],
			"next": "main", "next_at": 929.7, "entrance": true,
		},
		"sea": {
			"points": [Vector2(-40, 700), Vector2(1320, 700)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"gate": Vector2(1218, 150),
	"plots": [
		Vector2(200, 95), Vector2(330, 95), Vector2(520, 260), Vector2(520, 400), Vector2(680, 400), Vector2(820, 260),
		Vector2(820, 400), Vector2(1040, 110), Vector2(1150, 110), Vector2(1010, 300), Vector2(1040, 420), Vector2(330, 300),
		Vector2(330, 440), Vector2(560, 570), Vector2(760, 570), Vector2(900, 560),
	],
	"posts": [Vector2(240, 160), Vector2(420, 330), Vector2(560, 480), Vector2(800, 480), Vector2(920, 330), Vector2(1080, 180)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.3,  # TUNING (not in GDD) a little harder than the Sanctum through the roster
	"rule": "",
	"act_rule": "corsair/broadsides",
	"build_order": "cutter_default",
	"weak_order": "cutter_weak",
	"waves": [
		{"banner": "The Black Tide boards the Cutter", "groups": [{"kind": "tide_deckhand", "count": 10, "spacing": 1.3}]},
		{"banner": "", "groups": [{"kind": "tide_deckhand", "count": 12, "spacing": 1.0}, {"kind": "tide_musketeer", "count": 4, "spacing": 1.4, "delay": 6.0}]},
		{"banner": "Musketeers shoot your blockers from range", "groups": [{"kind": "tide_musketeer", "count": 8, "spacing": 1.2}, {"kind": "tide_deckhand", "count": 8, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "Grapplers hook the rail and board mid-deck", "groups": [{"kind": "tide_deckhand", "count": 10, "spacing": 1.0}, {"kind": "tide_grappler", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "grapple"}, {"kind": "tide_deckhand", "count": 6, "spacing": 1.0, "delay": 5.0, "road": "grapple"}]},
		{"banner": "Powder Runners: lit kegs that burst on your blockers", "groups": [{"kind": "tide_powder_runner", "count": 8, "spacing": 1.0}, {"kind": "tide_deckhand", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_musketeer", "count": 10, "spacing": 1.0}, {"kind": "tide_grappler", "count": 3, "spacing": 2.5, "delay": 4.0, "road": "grapple"}, {"kind": "tide_deckhand", "count": 10, "spacing": 0.9, "delay": 6.0}]},
		{"banner": "Boatswains bellow: their crew runs faster and shrugs off blows", "groups": [{"kind": "tide_deckhand", "count": 12, "spacing": 0.9}, {"kind": "tide_boatswain", "count": 2, "spacing": 5.0, "delay": 3.0}, {"kind": "tide_powder_runner", "count": 6, "spacing": 1.0, "delay": 7.0}]},
		{"banner": "Swashbucklers lunge past the post that holds them", "groups": [{"kind": "tide_swashbuckler", "count": 3, "spacing": 3.5}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "A gunboat sails under the rail", "groups": [{"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_musketeer", "count": 10, "spacing": 0.9, "delay": 2.0}, {"kind": "tide_grappler", "count": 4, "spacing": 2.0, "delay": 6.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_powder_runner", "count": 12, "spacing": 0.8}, {"kind": "tide_boatswain", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "tide_swashbuckler", "count": 3, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "Bosun Gorran rams the hull!", "groups": [{"kind": "bosun_gorran", "count": 1, "spacing": 1.0}, {"kind": "tide_deckhand", "count": 16, "spacing": 0.8, "delay": 3.0}, {"kind": "tide_deckhand", "count": 6, "spacing": 1.0, "delay": 6.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_swashbuckler", "count": 4, "spacing": 2.5}, {"kind": "tide_musketeer", "count": 12, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "Boarding Bruisers: armoured, their axes cleave two blockers", "groups": [{"kind": "tide_boarding_bruiser", "count": 3, "spacing": 4.0}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.8, "delay": 2.0}, {"kind": "tide_grappler", "count": 3, "spacing": 2.5, "delay": 5.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_powder_runner", "count": 14, "spacing": 0.7}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "sea"}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 4, "spacing": 3.0}, {"kind": "tide_swashbuckler", "count": 4, "spacing": 2.5, "delay": 4.0}, {"kind": "tide_musketeer", "count": 10, "spacing": 0.8, "delay": 6.0, "road": "grapple"}]},
		{"banner": "A swarm of deckhands over both rails", "groups": [{"kind": "tide_deckhand", "count": 24, "spacing": 0.5}, {"kind": "tide_deckhand", "count": 12, "spacing": 0.6, "delay": 3.0, "road": "grapple"}, {"kind": "tide_boatswain", "count": 2, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "tide_grappler", "count": 6, "spacing": 1.5, "road": "grapple"}, {"kind": "tide_boarding_bruiser", "count": 4, "spacing": 3.0, "delay": 2.0}, {"kind": "tide_powder_runner", "count": 10, "spacing": 0.7, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0}, {"kind": "tide_musketeer", "count": 14, "spacing": 0.7, "delay": 3.0}, {"kind": "tide_gunboat", "count": 2, "spacing": 8.0, "delay": 2.0, "road": "sea"}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 5, "spacing": 2.5}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "tide_deckhand", "count": 16, "spacing": 0.6, "delay": 4.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_powder_runner", "count": 18, "spacing": 0.6}, {"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0, "delay": 3.0}, {"kind": "tide_grappler", "count": 4, "spacing": 2.0, "delay": 6.0, "road": "grapple"}]},
		{"banner": "The whole crew of the Gull King", "groups": [{"kind": "tide_boarding_bruiser", "count": 6, "spacing": 2.5}, {"kind": "tide_swashbuckler", "count": 6, "spacing": 2.0, "delay": 3.0}, {"kind": "tide_musketeer", "count": 14, "spacing": 0.7, "delay": 5.0}, {"kind": "tide_boatswain", "count": 3, "spacing": 3.0, "delay": 8.0, "road": "grapple"}]},
		{"banner": "Captain Crow, the Gull King, swings aboard!", "groups": [{"kind": "crow", "count": 1, "spacing": 1.0}, {"kind": "tide_swashbuckler", "count": 4, "spacing": 3.0, "delay": 4.0}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.9, "delay": 7.0, "road": "grapple"}]},
	],
}
