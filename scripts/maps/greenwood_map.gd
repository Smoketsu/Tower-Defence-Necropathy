## The Greenwood (Act XV map 1; Necropathy stage "greenwood"): the old forest
## where the Wild Hunt rides. The main road comes in from the left along the
## top of the wood, winds back west through the glade and east again through
## the hunting grounds to the gate of the deep wood, three long rows with the
## plots between them; the hunters' trail comes in along the forest floor at
## the bottom left and joins the last row. 18 plots, 6 posts, 22 waves.
## The Turning Year (act rule wild/turning_year): the season turns every 4
## waves (Spring thickets, Summer haste, Autumn sprouts, Winter cold). The
## Huntsman of the Wild Hunt (miniboss, chest) on wave 12; the Stag King on
## wave 22. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "greenwood",
	"name": "The Greenwood",
	"floor": "tiles/greenwood_glade",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_grass_3", "decals/sanctum_courtyard_moss", "decals/sanctum_courtyard_moss_2"],
	"obstacles": [
		["obstacles/wild_oak_l", Vector2(100, 250)], ["obstacles/wild_stone_l", Vector2(1200, 380)],
		["obstacles/wild_oak_s", Vector2(580, 96)], ["obstacles/wild_rose_hedge_m", Vector2(640, 660)],
		["obstacles/wild_oak_l", Vector2(1220, 640)], ["obstacles/wild_stone_s", Vector2(1230, 96)],
		["obstacles/wild_thicket_m", Vector2(1100, 600)], ["obstacles/wild_oak_s", Vector2(90, 520)],
		["obstacles/wild_great_root_m", Vector2(420, 670)], ["obstacles/wild_stone_s_v", Vector2(1210, 240)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 170), Vector2(1040, 170), Vector2(1100, 230), Vector2(1100, 270), Vector2(1040, 330),
				Vector2(240, 330), Vector2(180, 390), Vector2(180, 430), Vector2(240, 490), Vector2(1190, 490)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"trail": {
			"points": [Vector2(-40, 620), Vector2(300, 620), Vector2(360, 560), Vector2(360, 490)],
			"next": "main", "next_at": 2419.4,  # joins main at (360, 490)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 490),
	"plots": [
		Vector2(360, 410), Vector2(300, 250), Vector2(520, 410), Vector2(460, 250), Vector2(680, 410), Vector2(1000, 410),
		Vector2(840, 410), Vector2(940, 250), Vector2(240, 560), Vector2(620, 250), Vector2(780, 250), Vector2(560, 570),
		Vector2(760, 570), Vector2(960, 570), Vector2(400, 96), Vector2(760, 96), Vector2(90, 410), Vector2(1175, 250),
	],
	"posts": [Vector2(600, 490), Vector2(950, 490), Vector2(640, 330), Vector2(1100, 250), Vector2(180, 620), Vector2(400, 170)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.8,  # TUNING (not in GDD) Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "greenwood_default",
	"weak_order": "greenwood_weak",
	"waves": [
		{"banner": "Thornlings swarm out of the glade", "groups": [{"kind": "wild_thornling", "count": 13, "spacing": 1.12}, {"kind": "wild_fae_knight", "count": 3, "spacing": 3.2, "delay": 8.0}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 5, "spacing": 2.88}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8, "road": "trail"}]},
		{"banner": "Hounds of the Hunt run the trail", "groups": [{"kind": "wild_hunt_hound", "count": 8, "spacing": 1.6, "road": "trail"}, {"kind": "wild_fae_knight", "count": 4, "spacing": 2.4, "delay": 4.8}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_hunt_hound", "count": 13, "spacing": 1.28}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "trail"}]},
		{"banner": "Corpse-Blooms: each buds Thornlings as it creeps", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 8.0}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}]},
		{"banner": "Will-o'-Wisps drift over the posts and gutter out of sight", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44, "road": "trail"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "Great Stags: a charge carries them through the posts", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 8.0}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 3.2, "road": "trail"}]},
		{"banner": "", "groups": [{"kind": "wild_fae_knight", "count": 10, "spacing": 1.6}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "trail"}, {"kind": "wild_hunt_hound", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 5, "spacing": 1.6, "delay": 6.4, "road": "trail"}]},
		{"banner": "Riders of the Wild Hunt: each horn calls hounds", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "The Huntsman of the Wild Hunt sounds his horn: the pack is loose!", "groups": [{"kind": "wild_huntsman", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 6.4}, {"kind": "wild_hunt_hound", "count": 8, "spacing": 1.28, "delay": 12.8, "road": "trail"}]},
		{"banner": "Treants: the walking oaks root the posts they strike", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 3.2, "road": "trail"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "trail"}, {"kind": "wild_hunt_hound", "count": 16, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_wild_rider", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "trail"}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 8.0, "road": "trail"}, {"kind": "wild_thornling", "count": 21, "spacing": 0.64, "delay": 3.2}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "The Stag's Hollow: the herd runs", "groups": [{"kind": "wild_great_stag", "count": 3, "spacing": 5.6}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "trail"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_wild_rider", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "trail"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_treant", "count": 2, "spacing": 6.4}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "trail"}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 6.4}]},
		{"banner": "The whole wood rises against you", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "trail"}, {"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_hunt_hound", "count": 13, "spacing": 0.8, "delay": 9.6, "road": "trail"}]},
		{"banner": "The Stag King leads the Wild Hunt!", "groups": [{"kind": "wild_stag_king", "count": 1, "spacing": 1.6}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 8.0}, {"kind": "wild_hunt_hound", "count": 10, "spacing": 1.28, "delay": 16.0, "road": "trail"}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 25.6}]},
	],
}
