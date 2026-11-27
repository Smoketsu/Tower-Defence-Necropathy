## Castle Kurogane (Act V map 2; Necropathy stage "kurogane"): the Shogun's
## fortress. Square concentric baileys (right angles are the theme): the north
## and south roads come in at the outer bailey's west corners, run its top and
## bottom walls and meet at its east gate; the keep road then goes in through
## the inner bailey's gate, round three of its walls, and up to the Ossuary gate
## at the keep in the centre. 16 plots, 5 posts, 23 waves. The Sun's Course:
## dusk from wave 9, night from wave 16. The General of the Left (miniboss,
## chest) on wave 12; Shogun Kurogane on wave 23: his regiments are his health
## bar. Keys as graveyard_map.gd plus lanterns / ambush
## (rules/shogunate/sun_course.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and sun_course.gd).
const MAP: Dictionary = {
	"id": "kurogane",
	"name": "Castle Kurogane",
	"floor": "tiles/kurogane_courtyard",
	"decals": [],
	"obstacles": [
		["obstacles/castle_wall_l", Vector2(100, 90)], ["obstacles/castle_wall_l", Vector2(829, 184)],
		["obstacles/castle_wall_s", Vector2(1000, 90)], ["obstacles/castle_wall_l_v", Vector2(1240, 240)],
		["obstacles/castle_well_s", Vector2(859, 240)], ["obstacles/black_pine_l", Vector2(60, 380)],
		["obstacles/black_pine_s", Vector2(260, 400)], ["obstacles/castle_wall_l", Vector2(1100, 400)],
		["obstacles/black_pine_l", Vector2(660, 560)], ["obstacles/castle_wall_s", Vector2(560, 700)],
		["obstacles/black_pine_s", Vector2(1220, 700)], ["obstacles/castle_well_l", Vector2(60, 700)],
	],
	"roads": {
		"north": {
			"points": [Vector2(250, -40), Vector2(250, 115), Vector2(940, 115), Vector2(940, 360)],
			"next": "keep", "next_at": 0.0,  # joins keep at (940, 360)
			"entrance": true,
		},
		"south": {
			"points": [Vector2(250, 760), Vector2(250, 605), Vector2(940, 605), Vector2(940, 360)],
			"next": "keep", "next_at": 0.0,  # joins keep at (940, 360)
			"entrance": true,
		},
		"keep": {
			"points": [Vector2(940, 360), Vector2(790, 360), Vector2(790, 235), Vector2(480, 235), Vector2(480, 485),
				Vector2(640, 485), Vector2(640, 380)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(640, 352),
	"plots": [
		Vector2(360, 170), Vector2(390, 550), Vector2(400, 660), Vector2(550, 540), Vector2(1000, 230), Vector2(510, 180),
		Vector2(730, 370), Vector2(560, 380), Vector2(860, 270), Vector2(830, 500), Vector2(590, 170), Vector2(710, 540),
		Vector2(1000, 490), Vector2(320, 660), Vector2(280, 170), Vector2(690, 180),
	],
	"posts": [Vector2(534, 115), Vector2(484, 605), Vector2(824, 360), Vector2(566, 235), Vector2(586, 485)],
	"lanterns": [Vector2(737, 163), Vector2(890, 425), Vector2(471, 665), Vector2(854, 545), Vector2(730, 307), Vector2(529, 337), Vector2(700, 452)],
	"ambush": [["north", 670.9], ["south", 649.0], ["keep", 521.3]],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.0,  # TUNING (not in GDD) L4: 2.8 before the road redraw; rising through the act
	"rule": "",
	"act_rule": "shogunate/sun_course",
	"build_order": "kurogane_default",
	"weak_order": "kurogane_weak",
	"waves": [
		{"banner": "The outer bailey: levies at both gates", "groups": [{"kind": "ashigaru", "count": 8, "spacing": 1.2}, {"kind": "ashigaru", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 4, "spacing": 2.2}, {"kind": "ashigaru", "count": 10, "spacing": 0.9, "delay": 2.0, "road": "south"}]},
		{"banner": "Arquebus lines on the walls", "groups": [{"kind": "teppo_gunner", "count": 6, "spacing": 1.4, "road": "south"}, {"kind": "ashigaru", "count": 10, "spacing": 0.9, "delay": 2.0}]},
		{"banner": "A Hatamoto's banner: his soldiers march faster", "groups": [{"kind": "hatamoto", "count": 1, "spacing": 1.0}, {"kind": "ashigaru", "count": 14, "spacing": 0.7, "delay": 0.5}, {"kind": "samurai", "count": 4, "spacing": 2.0, "delay": 3.0, "road": "south"}]},
		{"banner": "Kiba-musha: cavalry ride through your posts", "groups": [{"kind": "kiba_musha", "count": 3, "spacing": 3.5, "road": "south"}, {"kind": "ashigaru", "count": 12, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 8, "spacing": 1.4}, {"kind": "teppo_gunner", "count": 8, "spacing": 1.1, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "hatamoto", "count": 1, "spacing": 1.0, "road": "south"}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 0.5, "road": "south"}, {"kind": "kiba_musha", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "ashigaru", "count": 22, "spacing": 0.55}, {"kind": "teppo_gunner", "count": 10, "spacing": 1.0, "delay": 3.0, "road": "south"}]},
		{"banner": "Dusk over the gatehouse: ninja in the courtyards!", "groups": [{"kind": "ninja", "count": 8, "spacing": 1.3}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 3, "spacing": 3.5}, {"kind": "hatamoto", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "south"}, {"kind": "ashigaru", "count": 14, "spacing": 0.7, "delay": 2.5, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "kunoichi", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "ninja", "count": 10, "spacing": 1.0, "delay": 2.0}, {"kind": "teppo_gunner", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The General of the Left charges!", "groups": [{"kind": "general_left", "count": 1, "spacing": 1.0}, {"kind": "kiba_musha", "count": 4, "spacing": 2.5, "delay": 3.0, "road": "south"}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 12, "spacing": 1.0, "road": "south"}, {"kind": "hatamoto", "count": 2, "spacing": 4.0, "delay": 1.0}, {"kind": "ashigaru", "count": 14, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 12, "spacing": 0.9}, {"kind": "ninja", "count": 10, "spacing": 1.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 4, "spacing": 3.0, "road": "south"}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "Night over the keep: the oni come down from the mountain", "groups": [{"kind": "oni", "count": 2, "spacing": 5.0}, {"kind": "onryo", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "south"}, {"kind": "ashigaru", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "hatamoto", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "samurai", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "south"}, {"kind": "ninja", "count": 10, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 6, "spacing": 2.0}, {"kind": "oni", "count": 2, "spacing": 5.0, "delay": 3.0, "road": "south"}, {"kind": "teppo_gunner", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "kunoichi", "count": 3, "spacing": 3.5}, {"kind": "onryo", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "south"}, {"kind": "samurai", "count": 10, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "hatamoto", "count": 2, "spacing": 4.0}, {"kind": "ashigaru", "count": 20, "spacing": 0.55, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 8, "spacing": 1.8, "road": "south"}, {"kind": "ninja", "count": 12, "spacing": 0.9, "delay": 2.0}, {"kind": "teppo_gunner", "count": 10, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Shogun's guard marches from the keep", "groups": [{"kind": "samurai", "count": 14, "spacing": 0.9}, {"kind": "oni", "count": 3, "spacing": 4.0, "delay": 3.0, "road": "south"}, {"kind": "kunoichi", "count": 3, "spacing": 3.5, "delay": 5.0}, {"kind": "onryo", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "south"}]},
		{"banner": "Shogun Kurogane signals with his war fan: his regiments are his life!", "groups": [{"kind": "shogun", "count": 1, "spacing": 1.0}]},
	],
}
