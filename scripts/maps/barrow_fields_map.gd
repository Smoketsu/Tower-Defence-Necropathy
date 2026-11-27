## The Barrow Fields (Act VI map 1; Necropathy stage "barrow_fields"): snow over
## the burial mounds of the north. Two entrances: the west road and the east
## road wind down between the barrows and meet on the upper trunk, which runs
## east, loops down and comes back west along the bottom to the gate, so the
## middle plots cover three runs. 14 plots, 4 posts, 22 waves. The Long Winter
## (act rule norse/long_winter): cold from wave 4, deeper from waves 10 and 17;
## six braziers beside the roads keep the towers near them warm; one Rune-Stone
## stands on the trunk. The Barrow-Wight (miniboss, chest) on wave 11; Hrimgar
## the Draugr-King on wave 22 (he rises three times). Beating him unlocks
## Barrow Grasp and the Rune-Seer.
## Keys as graveyard_map.gd plus the Long Winter keys (documented in
## rules/norse/long_winter.gd): braziers (map px of each brazier) and
## rune_stones (map px of each Rune-Stone). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and long_winter.gd).
const MAP: Dictionary = {
	"id": "barrow_fields",
	"name": "The Barrow Fields",
	"floor": "tiles/norse_snow",
	"decals": ["decals/corpse", "decals/corpse_2"],
	"obstacles": [
		["obstacles/mound_l", Vector2(110, 300)], ["obstacles/mound_s", Vector2(640, 200)],
		["obstacles/snow_pine_l", Vector2(40, 100)], ["obstacles/snow_pine_s", Vector2(1240, 300)],
		["obstacles/barrow_closed", Vector2(1180, 100)], ["obstacles/mound_l_v", Vector2(1240, 640)],
		["obstacles/snow_pine_l", Vector2(60, 660)], ["obstacles/mound_s", Vector2(640, 660)],
		["obstacles/snow_pine_s", Vector2(900, 660)], ["obstacles/barrow_closed", Vector2(360, 660)],
	],
	"roads": {
		"west": {
			"points": [Vector2(-40, 170), Vector2(300, 170), Vector2(360, 230), Vector2(360, 320), Vector2(420, 380)],
			"next": "trunk", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 170), Vector2(980, 170), Vector2(920, 230), Vector2(920, 320), Vector2(860, 380)],
			"next": "trunk", "next_at": 440.0, "entrance": true,
		},
		"trunk": {
			"points": [Vector2(420, 380), Vector2(1080, 380), Vector2(1140, 440), Vector2(1140, 520), Vector2(1080, 580),
				Vector2(160, 580), Vector2(100, 520)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(80, 490),
	"plots": [
		Vector2(200, 100), Vector2(500, 280), Vector2(640, 280), Vector2(780, 280), Vector2(1060, 270),
		Vector2(200, 280), Vector2(300, 480), Vector2(480, 480), Vector2(640, 480), Vector2(820, 480),
		Vector2(980, 480), Vector2(1230, 470), Vector2(1100, 100), Vector2(295, 375),
	],
	"posts": [Vector2(420, 580), Vector2(1140, 480), Vector2(640, 380), Vector2(920, 280)],
	"braziers": [Vector2(520, 425), Vector2(880, 535), Vector2(300, 215), Vector2(1095, 480), Vector2(965, 280), Vector2(240, 535)],
	"rune_stones": [Vector2(760, 425)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.5,  # TUNING (not in GDD) Part Two: a step above the Road to the Sun
	"rule": "",
	"act_rule": "norse/long_winter",
	"build_order": "barrow_fields_default",
	"weak_order": "barrow_fields_weak",
	"waves": [
		{"banner": "Raiders come down from the barrows", "groups": [{"kind": "norse_raider", "count": 8, "spacing": 1.2, "road": "west"}, {"kind": "norse_raider", "count": 5, "spacing": 1.2, "delay": 6.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 4, "spacing": 1.8, "road": "west"}, {"kind": "norse_raider", "count": 7, "spacing": 1.1, "delay": 3.0, "road": "east"}]},
		{"banner": "Wolves of the wastes: they lunge past the posts", "groups": [{"kind": "norse_wolf", "count": 8, "spacing": 0.7, "road": "east"}, {"kind": "norse_draugr_female", "count": 4, "spacing": 1.7, "delay": 3.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_shield_maiden", "count": 3, "spacing": 2.2, "road": "west"}, {"kind": "norse_raider", "count": 9, "spacing": 0.9, "delay": 2.0, "road": "east"}]},
		{"banner": "Seers douse the braziers: tap a cold one to relight it", "groups": [{"kind": "norse_seer", "count": 3, "spacing": 2.5, "road": "west"}, {"kind": "norse_draugr", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 1, "spacing": 4.0, "road": "east"}, {"kind": "norse_raider", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_skald", "count": 2, "spacing": 3.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 4, "spacing": 1.8, "delay": 1.0, "road": "west"}, {"kind": "norse_wolf", "count": 8, "spacing": 0.7, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 6, "spacing": 1.3, "road": "east"}, {"kind": "norse_draugr_female", "count": 6, "spacing": 1.3, "delay": 1.0, "road": "west"}]},
		{"banner": "A frost giant: its boulders freeze the towers", "groups": [{"kind": "norse_frost_giant", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_raider", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 4, "spacing": 2.2, "road": "east"}, {"kind": "norse_berserker", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 4.0, "road": "west"}]},
		{"banner": "The Barrow-Wight howls: the mounds crack open!", "groups": [{"kind": "barrow_wight", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_draugr", "count": 8, "spacing": 1.3, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_wolf", "count": 14, "spacing": 0.5, "road": "west"}, {"kind": "norse_skald", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "east"}, {"kind": "norse_raider", "count": 12, "spacing": 0.7, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.3, "delay": 2.0, "road": "west"}]},
		{"banner": "Valkyries fly over the posts", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "road": "west"}, {"kind": "norse_draugr_female", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_berserker", "count": 3, "spacing": 3.0, "road": "west"}, {"kind": "norse_seer", "count": 4, "spacing": 2.0, "delay": 2.0, "road": "east"}, {"kind": "norse_raider", "count": 14, "spacing": 0.6, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_draugr", "count": 12, "spacing": 0.9, "road": "west"}, {"kind": "norse_wolf", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "norse_frost_giant", "count": 2, "spacing": 6.0, "delay": 2.0, "road": "west"}, {"kind": "norse_shield_maiden", "count": 8, "spacing": 1.2, "delay": 3.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_skald", "count": 3, "spacing": 2.5, "road": "east"}, {"kind": "norse_berserker", "count": 3, "spacing": 3.0, "delay": 1.0, "road": "east"}, {"kind": "norse_raider", "count": 16, "spacing": 0.6, "delay": 2.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_seer", "count": 5, "spacing": 1.8, "road": "west"}, {"kind": "norse_draugr_female", "count": 12, "spacing": 0.9, "delay": 2.0, "road": "east"}, {"kind": "norse_valkyrie", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "west"}]},
		{"banner": "", "groups": [{"kind": "norse_frost_giant", "count": 3, "spacing": 5.0, "road": "west"}, {"kind": "norse_wolf", "count": 14, "spacing": 0.5, "delay": 2.0, "road": "east"}]},
		{"banner": "The whole host of the barrows", "groups": [{"kind": "norse_berserker", "count": 4, "spacing": 3.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "west"}, {"kind": "norse_valkyrie", "count": 3, "spacing": 3.0, "delay": 4.0, "road": "east"}]},
		{"banner": "Hrimgar the Draugr-King rises from his barrow!", "groups": [{"kind": "hrimgar", "count": 1, "spacing": 1.0, "road": "west"}, {"kind": "norse_draugr", "count": 10, "spacing": 1.1, "delay": 4.0, "road": "east"}, {"kind": "norse_shield_maiden", "count": 6, "spacing": 1.5, "delay": 10.0, "road": "west"}]},
	],
}
