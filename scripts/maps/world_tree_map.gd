## The World-Tree (Act XV map 3, the campaign's last; Necropathy stage
## "world_tree"): the roots, the trunk stair and the crown of the tree the whole
## world grew from. The main road spirals in to its heart from the bottom
## right: west through the root hall, up and east under the crown and round
## into the heart; the crown road comes in along the top and down the trunk
## stair to join it at the start, the roots road joins it in the root hall. 18 plots, 6 posts, 24 waves. The Turning Year (act
## rule wild/turning_year) turns twice as fast here: the season changes every
## 2 waves. The Gardener of Roots (miniboss, chest) on wave 13; the Green
## Mother on wave 24. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "world_tree",
	"name": "The World-Tree",
	"floor": "tiles/world_tree_roots",
	"decals": ["decals/sanctum_courtyard_moss", "decals/sanctum_courtyard_moss_2", "decals/graveyard_grass_2", "decals/sanctum_cloisters_flowers"],
	"obstacles": [
		["obstacles/wild_great_root_m", Vector2(640, 670)], ["obstacles/wild_oak_l", Vector2(60, 640)],
		["obstacles/wild_stone_l", Vector2(1230, 120)], ["obstacles/wild_oak_s", Vector2(240, 90)],
		["obstacles/wild_great_root_m_v", Vector2(1230, 560)], ["obstacles/wild_stone_s", Vector2(1240, 690)],
		["obstacles/wild_oak_l", Vector2(900, 670)], ["obstacles/wild_stone_s_v", Vector2(1000, 90)],
		["obstacles/wild_grove_tree", Vector2(560, 440)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 600), Vector2(220, 600), Vector2(160, 540), Vector2(160, 330), Vector2(220, 270),
				Vector2(940, 270), Vector2(1000, 330), Vector2(1000, 420), Vector2(940, 480), Vector2(640, 480)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"crown": {
			"points": [Vector2(-40, 150), Vector2(1100, 150), Vector2(1160, 210), Vector2(1160, 540), Vector2(1100, 600)],
			"next": "main", "next_at": 220.0,  # joins main at (1100, 600)
			"entrance": true,
		},
		"roots": {
			"points": [Vector2(-40, 450), Vector2(160, 450)],
			"next": "main", "next_at": 1274.9,  # joins main at (160, 450)
			"entrance": true,
		},
	},
	"gate": Vector2(612, 480),
	"plots": [
		Vector2(900, 375), Vector2(860, 540), Vector2(460, 210), Vector2(620, 210), Vector2(780, 375), Vector2(1080, 450),
		Vector2(780, 210), Vector2(300, 210), Vector2(1080, 300), Vector2(940, 210), Vector2(700, 540), Vector2(300, 375),
		Vector2(620, 375), Vector2(80, 300), Vector2(460, 375), Vector2(300, 540), Vector2(80, 525), Vector2(460, 540),
	],
	"posts": [Vector2(640, 600), Vector2(1160, 480), Vector2(580, 270), Vector2(160, 380), Vector2(800, 480), Vector2(600, 150)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.2,  # TUNING (not in GDD) DECISIONS Z4: 2.9 -> 3.2 with her calls every 20 s; Part Three: the act's (and the campaign's) hardest map
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "world_tree_default",
	"weak_order": "world_tree_weak",
	"waves": [
		{"banner": "The roots stir: Thornlings climb from the earth", "groups": [{"kind": "wild_thornling", "count": 13, "spacing": 0.96}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "crown"}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 6, "spacing": 2.4, "road": "crown"}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "roots"}]},
		{"banner": "Hounds of the Hunt", "groups": [{"kind": "wild_hunt_hound", "count": 10, "spacing": 1.28}, {"kind": "wild_fae_knight", "count": 5, "spacing": 2.4, "delay": 4.8, "road": "crown"}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8, "road": "roots"}]},
		{"banner": "Will-o'-Wisps drift over the posts", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}]},
		{"banner": "Corpse-Blooms creep up the roots", "groups": [{"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "road": "roots"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 4.8}]},
		{"banner": "Winter Fae: their frost bolts freeze a tower", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_hunt_hound", "count": 13, "spacing": 0.96, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "Great Stags charge up the trunk stair", "groups": [{"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 4.8}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "roots"}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6, "road": "crown"}]},
		{"banner": "Treants: the walking oaks root the posts they strike", "groups": [{"kind": "wild_treant", "count": 1, "spacing": 1.6, "road": "crown"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "roots"}]},
		{"banner": "Riders of the Wild Hunt: each horn calls hounds", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 3.2, "road": "crown"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "crown"}, {"kind": "wild_thornling", "count": 16, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The Gardener of Roots wakes beneath the tree!", "groups": [{"kind": "wild_gardener", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 6.4, "road": "crown"}, {"kind": "wild_hunt_hound", "count": 8, "spacing": 1.28, "delay": 12.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "crown"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0, "road": "crown"}, {"kind": "wild_winter_fae", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 18, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The trunk stair: the whole Wild climbs", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4, "road": "roots"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4}, {"kind": "wild_hunt_hound", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "crown"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "crown"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The crown of the tree: the year turns faster", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_thornling", "count": 21, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The roots of the world rise against you", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4, "road": "crown"}, {"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.8, "delay": 9.6, "road": "crown"}]},
		{"banner": "The Green Mother rises from the World-Tree to take back her dead!", "groups": [{"kind": "wild_green_mother", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 9.6, "road": "crown"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 19.2, "road": "roots"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 28.8, "road": "crown"}]},
	],
}
