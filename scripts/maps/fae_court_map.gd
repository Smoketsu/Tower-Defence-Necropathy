## The Fae Court (Act XV map 2; Necropathy stage "fae_court"): the revel of
## the Summer Queen in an endless summer. Two roads come in from the left, the
## north road through the rose maze and the south road past the revel; they
## meet below the mirror lake and wind north round it, along the top of the
## court and down its east side to the Throne of Blossoms. 17 plots, 5 posts,
## 23 waves. The Turning Year (act rule wild/turning_year) holds Summer all run
## (every enemy faster) until the Winter Prince (miniboss, chest, wave 12)
## brings a minute of winter; the Summer Queen on wave 23. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "fae_court",
	"name": "The Fae Court",
	"floor": "tiles/fae_court_revel",
	"decals": ["decals/sanctum_cloisters_flowers", "decals/sanctum_cloisters_flowers_2", "decals/sanctum_courtyard_petals", "decals/sanctum_courtyard_petals_2", "decals/graveyard_grass"],
	"obstacles": [
		["obstacles/wild_rose_hedge_m_v", Vector2(70, 370)], ["obstacles/wild_rose_hedge_m", Vector2(630, 590)],
		["obstacles/wild_oak_s", Vector2(1230, 160)], ["obstacles/wild_stone_l", Vector2(870, 640)],
		["obstacles/wild_rose_hedge_m", Vector2(420, 690)], ["obstacles/wild_oak_l", Vector2(1240, 680)],
		["obstacles/wild_stone_s", Vector2(640, 120)], ["obstacles/wild_rose_hedge_m_v", Vector2(890, 380)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 130), Vector2(380, 130), Vector2(440, 190), Vector2(440, 330), Vector2(500, 390),
				Vector2(760, 390), Vector2(820, 330), Vector2(820, 190), Vector2(880, 130), Vector2(1080, 130),
				Vector2(1140, 190), Vector2(1140, 500), Vector2(1190, 550)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(-40, 600), Vector2(380, 600), Vector2(440, 540), Vector2(440, 450), Vector2(500, 390)],
			"next": "main", "next_at": 729.7,  # joins main at (500, 390)
			"entrance": true,
		},
	},
	"gate": Vector2(1212, 572),
	"plots": [
		Vector2(620, 250), Vector2(1020, 500), Vector2(340, 490), Vector2(330, 370), Vector2(1060, 220), Vector2(960, 240),
		Vector2(700, 300), Vector2(560, 300), Vector2(560, 480), Vector2(340, 240), Vector2(700, 480), Vector2(1220, 300),
		Vector2(1060, 420), Vector2(200, 240), Vector2(200, 490), Vector2(960, 370), Vector2(1040, 610),
	],
	"posts": [Vector2(220, 130), Vector2(220, 600), Vector2(620, 390), Vector2(820, 260), Vector2(1140, 330)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.4,  # TUNING (not in GDD) Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "wild/turning_year",
	"build_order": "fae_court_default",
	"weak_order": "fae_court_weak",
	"waves": [
		{"banner": "The revel spills onto the roads", "groups": [{"kind": "wild_thornling", "count": 16, "spacing": 0.96}, {"kind": "wild_fae_knight", "count": 4, "spacing": 3.2, "delay": 6.4, "road": "south"}]},
		{"banner": "Fae Knights: a blink carries them through a post", "groups": [{"kind": "wild_fae_knight", "count": 6, "spacing": 2.4, "road": "south"}, {"kind": "wild_thornling", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "Masked Courtiers dance in from the rose maze", "groups": [{"kind": "wild_masked_courtier", "count": 6, "spacing": 2.4}, {"kind": "wild_fae_knight", "count": 5, "spacing": 2.4, "delay": 4.8, "road": "south"}]},
		{"banner": "A Dryad sings the Wild whole: kill her first", "groups": [{"kind": "wild_dryad", "count": 1, "spacing": 1.6, "road": "south"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 1.6}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 4.8, "road": "south"}]},
		{"banner": "Will-o'-Wisps drift over the posts and gutter out of sight", "groups": [{"kind": "wild_will_o_wisp", "count": 10, "spacing": 1.44}, {"kind": "wild_masked_courtier", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "south"}]},
		{"banner": "Winter Fae: their frost bolts freeze a tower", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 3.2, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_masked_courtier", "count": 10, "spacing": 1.6, "road": "south"}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 16, "spacing": 0.8, "delay": 4.8}]},
		{"banner": "Spore Mothers: their spores rot your blockers", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.6, "delay": 1.6, "road": "south"}]},
		{"banner": "Corpse-Blooms creep through the revel", "groups": [{"kind": "wild_corpse_bloom", "count": 2, "spacing": 8.0, "road": "south"}, {"kind": "wild_masked_courtier", "count": 8, "spacing": 1.92, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 5, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4, "road": "south"}]},
		{"banner": "Great Stags break from the rose maze", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 8.0}, {"kind": "wild_masked_courtier", "count": 10, "spacing": 1.6, "delay": 3.2, "road": "south"}, {"kind": "wild_thornling", "count": 13, "spacing": 0.8, "delay": 6.4}]},
		{"banner": "The Winter Prince rides in from the cold!", "groups": [{"kind": "wild_winter_prince", "count": 1, "spacing": 1.6}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 6.4, "road": "south"}, {"kind": "wild_fae_knight", "count": 8, "spacing": 1.92, "delay": 12.8}]},
		{"banner": "", "groups": [{"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_masked_courtier", "count": 13, "spacing": 1.44, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 1.28, "delay": 4.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 1.6, "road": "south"}, {"kind": "wild_winter_fae", "count": 1, "spacing": 1.6, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_corpse_bloom", "count": 1, "spacing": 1.6, "delay": 3.2}, {"kind": "wild_thornling", "count": 18, "spacing": 0.64, "delay": 4.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_masked_courtier", "count": 13, "spacing": 1.44}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 4.8, "road": "south"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 6.4}]},
		{"banner": "", "groups": [{"kind": "wild_fae_knight", "count": 16, "spacing": 1.28, "road": "south"}, {"kind": "wild_dryad", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_will_o_wisp", "count": 10, "spacing": 0.96, "delay": 4.8}]},
		{"banner": "The Throne of Blossoms: the whole court dances", "groups": [{"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28}, {"kind": "wild_great_stag", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_spore_mother", "count": 1, "spacing": 1.6, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "wild_winter_fae", "count": 2, "spacing": 6.4}, {"kind": "wild_corpse_bloom", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "", "groups": [{"kind": "wild_dryad", "count": 2, "spacing": 6.4, "road": "south"}, {"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28, "delay": 1.6}, {"kind": "wild_will_o_wisp", "count": 8, "spacing": 0.96, "delay": 6.4, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "wild_great_stag", "count": 2, "spacing": 6.4}, {"kind": "wild_spore_mother", "count": 2, "spacing": 6.4, "delay": 3.2, "road": "south"}, {"kind": "wild_fae_knight", "count": 13, "spacing": 1.44, "delay": 4.8}]},
		{"banner": "The court's last dance before the Queen", "groups": [{"kind": "wild_masked_courtier", "count": 16, "spacing": 1.28, "road": "south"}, {"kind": "wild_winter_fae", "count": 2, "spacing": 6.4, "delay": 3.2}, {"kind": "wild_dryad", "count": 1, "spacing": 1.6, "delay": 6.4}, {"kind": "wild_thornling", "count": 16, "spacing": 0.64, "delay": 9.6, "road": "south"}]},
		{"banner": "The Summer Queen holds court!", "groups": [{"kind": "wild_summer_queen", "count": 1, "spacing": 1.6}, {"kind": "wild_masked_courtier", "count": 10, "spacing": 1.92, "delay": 8.0, "road": "south"}, {"kind": "wild_fae_knight", "count": 10, "spacing": 1.92, "delay": 16.0}, {"kind": "wild_great_stag", "count": 1, "spacing": 1.6, "delay": 25.6, "road": "south"}]},
	],
}
