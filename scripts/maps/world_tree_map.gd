## The World-Tree (Act XV map 3, the campaign's last; Necropathy stage
## "world_tree"): the roots, the trunk stair and the crown of the tree the whole
## world grew from. Three roads climb in to its heart: the west road along the
## crown and down round the root hall, the roots road from the bottom left that
## joins it, and the east road that coils round the trunk stair and meets it
## just below the heart. 18 plots, 6 posts, 24 waves. The Turning Year (act
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
		["obstacles/wild_great_root_m", Vector2(640, 630)], ["obstacles/wild_oak_l", Vector2(60, 560)],
		["obstacles/wild_stone_l", Vector2(1220, 180)], ["obstacles/wild_oak_s", Vector2(640, 110)],
		["obstacles/wild_great_root_m_v", Vector2(60, 380)], ["obstacles/wild_stone_s", Vector2(1240, 690)],
		["obstacles/wild_oak_l", Vector2(840, 650)], ["obstacles/wild_stone_s_v", Vector2(470, 120)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 200), Vector2(220, 200), Vector2(280, 260), Vector2(280, 460), Vector2(340, 520),
				Vector2(560, 520), Vector2(620, 460), Vector2(620, 350)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 520), Vector2(1060, 520), Vector2(1000, 460), Vector2(1000, 260), Vector2(940, 200),
				Vector2(740, 200), Vector2(680, 260), Vector2(680, 400), Vector2(620, 400)],
			"next": "main", "next_at": 994.6,  # joins main at (620, 400)
			"entrance": true,
		},
		"roots": {
			"points": [Vector2(-40, 660), Vector2(400, 660), Vector2(460, 600), Vector2(460, 520)],
			"next": "main", "next_at": 749.7,  # joins main at (460, 520)
			"entrance": true,
		},
	},
	"gate": Vector2(620, 322),
	"plots": [
		Vector2(500, 420), Vector2(780, 300), Vector2(180, 300), Vector2(1100, 420), Vector2(380, 420), Vector2(900, 300),
		Vector2(780, 430), Vector2(1180, 600), Vector2(880, 120), Vector2(380, 300), Vector2(1100, 300), Vector2(1100, 620),
		Vector2(900, 430), Vector2(180, 440), Vector2(540, 230), Vector2(500, 300), Vector2(1200, 360), Vector2(360, 120),
	],
	"posts": [Vector2(280, 360), Vector2(150, 200), Vector2(520, 520), Vector2(1000, 360), Vector2(300, 660), Vector2(820, 200)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.4,  # TUNING (not in GDD) Part Three: the act's (and the campaign's) hardest map
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "world_tree_default",
	"weak_order": "world_tree_weak",
	"waves": [
		{"banner": "The roots stir: Thornlings climb from the earth", "groups": [{"kind": "wild_thornling", "count": 13, "spacing": 0.96}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "east"}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 6, "spacing": 2.4, "road": "east"}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "roots"}]},
		{"banner": "Hounds of the Hunt", "groups": [{"kind": "wild_hunt_hound", "count": 10, "spacing": 1.28}, {"kind": "wild_fae_knight", "count": 5, "spacing": 2.4, "delay": 4.8, "road": "east"}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6, "road": "east"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8, "road": "roots"}]},
		{"banner": "Will-o'-Wisps drift over the posts", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44, "road": "east"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}]},
		{"banner": "Corpse-Blooms creep up the roots", "groups": [{"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "road": "roots"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2, "road": "east"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 4.8}]},
		{"banner": "Winter Fae: their frost bolts freeze a tower", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "road": "east"}, {"kind": "wild_hunt_hound", "count": 13, "spacing": 0.96, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "Great Stags charge up the trunk stair", "groups": [{"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "road": "east"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 4.8}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "roots"}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6, "road": "east"}]},
		{"banner": "Treants: the walking oaks root the posts they strike", "groups": [{"kind": "wild_treant", "count": 1, "spacing": 1.6, "road": "east"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "roots"}]},
		{"banner": "Riders of the Wild Hunt: each horn calls hounds", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 3.2, "road": "east"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "east"}, {"kind": "wild_thornling", "count": 16, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The Gardener of Roots wakes beneath the tree!", "groups": [{"kind": "wild_gardener", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 6.4, "road": "east"}, {"kind": "wild_hunt_hound", "count": 8, "spacing": 1.28, "delay": 12.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "road": "east"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "east"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0, "road": "east"}, {"kind": "wild_winter_fae", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 18, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "road": "east"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The trunk stair: the whole Wild climbs", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "east"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4, "road": "roots"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "east"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4}, {"kind": "wild_hunt_hound", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "east"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "east"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8, "road": "roots"}]},
		{"banner": "The crown of the tree: the year turns faster", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "east"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_thornling", "count": 21, "spacing": 0.64, "delay": 4.8, "road": "roots"}]},
		{"banner": "The roots of the world rise against you", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4, "road": "east"}, {"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "roots"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.8, "delay": 9.6, "road": "east"}]},
		{"banner": "The Green Mother rises from the World-Tree to take back her dead!", "groups": [{"kind": "wild_green_mother", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 9.6, "road": "east"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 19.2, "road": "roots"}, {"kind": "wild_treant", "count": 1, "spacing": 1.6, "delay": 28.8, "road": "east"}]},
	],
}
