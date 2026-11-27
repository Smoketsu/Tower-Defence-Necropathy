## The Treasure Galleon (Act II map 2, the Black Tide; Necropathy's "galleon"
## stage, GDD §7.3): a wide dawn deck. The road traces the hull: from the stern
## gangway (top left) along the top rail to the pointed bow (right), back along
## the bottom rail, round the stern and in to the necromancer's hatch amidships.
## Boarders climb onto the bow's tip (right); grapplers hook the bottom rail and
## join it. Gunboats sail the sea lane under the rail. Act rule: the Broadsides
## (rules/corsair/broadsides.gd), four cannons this time. 18 plots, 6 posts, 24
## waves; Old Hollow-Eye (miniboss) on wave 12, Admiral Marrec on wave 24. MAP
## keys: graveyard_map.gd. Data only, no logic.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "galleon",
	"name": "The Treasure Galleon",
	"floor": "tiles/corsair_galleon",
	"decals": [],
	"obstacles": [
		["obstacles/deck_mast_l", Vector2(815, 199)], ["obstacles/deck_mast_l", Vector2(305, 309)],
		["obstacles/deck_hatch_l", Vector2(860, 480)], ["obstacles/deck_barrels_l", Vector2(40, 470)],
		["obstacles/deck_hatch_l_v", Vector2(1220, 600)], ["obstacles/deck_barrels_s", Vector2(560, 650)],
		["obstacles/deck_cannon_l", Vector2(60, 640)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 130), Vector2(840, 130), Vector2(1100, 360), Vector2(840, 590), Vector2(300, 590),
				Vector2(273, 587), Vector2(248, 578), Vector2(225, 564), Vector2(206, 545), Vector2(192, 522),
				Vector2(183, 497), Vector2(180, 470), Vector2(180, 360), Vector2(183, 333), Vector2(192, 308),
				Vector2(206, 285), Vector2(225, 266), Vector2(248, 252), Vector2(273, 243), Vector2(300, 240),
				Vector2(470, 240)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"bow": {
			"points": [Vector2(1320, 360), Vector2(1100, 360)],
			"next": "main", "next_at": 1227.1,  # joins main at (1100, 360)
			"entrance": true,
		},
		"grapple": {
			"points": [Vector2(760, 664), Vector2(760, 592)],
			"next": "main", "next_at": 1654.3,  # joins main at (760, 590)
			"entrance": true,
		},
		"sea": {
			"points": [Vector2(-40, 700), Vector2(1320, 700)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"gate": Vector2(498, 210),
	"plots": [
		Vector2(140, 210), Vector2(580, 190), Vector2(660, 190), Vector2(930, 400), Vector2(1130, 290), Vector2(910, 620),
		Vector2(770, 520), Vector2(690, 530), Vector2(1140, 430), Vector2(770, 190), Vector2(840, 230), Vector2(470, 530),
		Vector2(370, 530), Vector2(300, 480), Vector2(240, 420), Vector2(300, 340), Vector2(220, 190), Vector2(1000, 360),
	],
	"posts": [Vector2(372, 130), Vector2(803, 130), Vector2(993, 455), Vector2(771, 590), Vector2(269, 585), Vector2(237, 259)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.95,  # TUNING (not in GDD)
	"rule": "",
	"act_rule": "corsair/broadsides",
	"build_order": "galleon_default",
	"weak_order": "galleon_weak",
	"waves": [
		{"banner": "The Galleon's prize crew comes over the stern", "groups": [{"kind": "tide_deckhand", "count": 12, "spacing": 1.2}]},
		{"banner": "Boarders from the bow as well", "groups": [{"kind": "tide_deckhand", "count": 8, "spacing": 1.0}, {"kind": "tide_deckhand", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "bow"}, {"kind": "tide_musketeer", "count": 4, "spacing": 1.3, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "tide_musketeer", "count": 8, "spacing": 1.1, "road": "bow"}, {"kind": "tide_powder_runner", "count": 6, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "Gunnery Mates lob grenadoes and man the broadsides", "groups": [{"kind": "tide_gunnery_mate", "count": 2, "spacing": 4.0}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.9, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "tide_grappler", "count": 4, "spacing": 2.5, "road": "grapple"}, {"kind": "tide_swashbuckler", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "bow"}, {"kind": "tide_deckhand", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_musketeer", "count": 10, "spacing": 0.9}, {"kind": "tide_deckhand", "count": 10, "spacing": 0.9, "delay": 3.0, "road": "bow"}]},
		{"banner": "Hull Crabs climb the hull: their shells turn frontal blows", "groups": [{"kind": "tide_hull_crab", "count": 2, "spacing": 5.0, "road": "grapple"}, {"kind": "tide_boatswain", "count": 1, "spacing": 4.0}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.8, "delay": 2.0}, {"kind": "tide_powder_runner", "count": 8, "spacing": 0.8, "delay": 4.0, "road": "bow"}]},
		{"banner": "A gunboat under the rail", "groups": [{"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "road": "sea"}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "bow"}, {"kind": "tide_swashbuckler", "count": 4, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "Voodoo Navigators call the sea down on your towers", "groups": [{"kind": "tide_voodoo_navigator", "count": 1, "spacing": 4.0}, {"kind": "tide_deckhand", "count": 16, "spacing": 0.8, "delay": 2.0, "road": "bow"}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 2, "spacing": 3.5}, {"kind": "tide_musketeer", "count": 12, "spacing": 0.8, "delay": 3.0, "road": "bow"}, {"kind": "tide_hull_crab", "count": 1, "spacing": 4.0, "delay": 5.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_powder_runner", "count": 14, "spacing": 0.7}, {"kind": "tide_boatswain", "count": 1, "spacing": 4.0, "delay": 2.0, "road": "bow"}, {"kind": "tide_gunnery_mate", "count": 1, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "Old Hollow-Eye rises beside the hull!", "groups": [{"kind": "old_hollow_eye", "count": 1, "spacing": 1.0, "road": "bow"}, {"kind": "tide_deckhand", "count": 18, "spacing": 0.8, "delay": 3.0}, {"kind": "tide_swashbuckler", "count": 2, "spacing": 3.0, "delay": 8.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_voodoo_navigator", "count": 1, "spacing": 4.0, "road": "bow"}, {"kind": "tide_boarding_bruiser", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "tide_musketeer", "count": 12, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 3, "spacing": 3.0, "road": "grapple"}, {"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "sea"}, {"kind": "tide_powder_runner", "count": 12, "spacing": 0.7, "delay": 4.0, "road": "bow"}]},
		{"banner": "", "groups": [{"kind": "tide_swashbuckler", "count": 4, "spacing": 2.2}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bow"}, {"kind": "tide_deckhand", "count": 16, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 3, "spacing": 3.0, "road": "bow"}, {"kind": "tide_boatswain", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "tide_grappler", "count": 4, "spacing": 2.0, "delay": 4.0, "road": "grapple"}]},
		{"banner": "A swarm over three rails", "groups": [{"kind": "tide_deckhand", "count": 16, "spacing": 0.7}, {"kind": "tide_deckhand", "count": 10, "spacing": 0.8, "delay": 3.0, "road": "bow"}, {"kind": "tide_powder_runner", "count": 6, "spacing": 0.8, "delay": 6.0, "road": "grapple"}]},
		{"banner": "", "groups": [{"kind": "tide_voodoo_navigator", "count": 2, "spacing": 3.0}, {"kind": "tide_hull_crab", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "bow"}, {"kind": "tide_musketeer", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_gunboat", "count": 2, "spacing": 8.0, "road": "sea"}, {"kind": "tide_swashbuckler", "count": 4, "spacing": 2.0, "delay": 1.0, "road": "bow"}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_boarding_bruiser", "count": 4, "spacing": 2.5}, {"kind": "tide_boatswain", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bow"}, {"kind": "tide_powder_runner", "count": 12, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "tide_hull_crab", "count": 4, "spacing": 2.5, "road": "grapple"}, {"kind": "tide_voodoo_navigator", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "bow"}, {"kind": "tide_deckhand", "count": 18, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "tide_swashbuckler", "count": 6, "spacing": 1.8}, {"kind": "tide_musketeer", "count": 16, "spacing": 0.6, "delay": 3.0, "road": "bow"}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "The Sea Wolf's fleet closes in", "groups": [{"kind": "tide_boarding_bruiser", "count": 4, "spacing": 2.5, "road": "bow"}, {"kind": "tide_hull_crab", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "grapple"}, {"kind": "tide_swashbuckler", "count": 4, "spacing": 2.0, "delay": 5.0}, {"kind": "tide_gunboat", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "sea"}]},
		{"banner": "Admiral Marrec, the Sea Wolf, lays her plank!", "groups": [{"kind": "marrec", "count": 1, "spacing": 1.0}, {"kind": "tide_gunnery_mate", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "bow"}, {"kind": "tide_deckhand", "count": 14, "spacing": 0.8, "delay": 8.0, "road": "bow"}]},
	],
}
