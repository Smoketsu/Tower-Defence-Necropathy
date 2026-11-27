## The Ark of the Concord (Act XIII map 3, the act's finale; Necropathy stage
## "ark"): the Harvesters' mothership, its hangars, vaults and reactor. A ring
## corridor round the core: the main gangway comes in from the upper left onto
## the ring and runs most of the way round it (over the top, down the east side,
## along the bottom), then up the spoke to the gate (the bridge) at the core;
## the east gangway comes straight in onto the ring's east side. Two sky lanes
## cross the deck (map road key "sky"). 16 plots, 6 posts, 25 waves. Abduction
## (act rule concord/abduction): the Ark sends saucers most often. The Luminous
## Archon (miniboss, chest) on wave 13; the Harvester on wave 25. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "ark",
	"name": "The Ark of the Concord",
	"floor": "tiles/ark_hangar",
	"decals": [],
	"obstacles": [
		["obstacles/ark_pillar_l", Vector2(560, 120)], ["obstacles/ark_pillar_l", Vector2(720, 120)],
		["obstacles/ark_crate_l", Vector2(80, 620)], ["obstacles/ark_crate_l", Vector2(1200, 620)],
		["obstacles/ark_console_l", Vector2(640, 220)], ["obstacles/ark_crate_s_v", Vector2(140, 400)],
		["obstacles/ark_crate_s_v", Vector2(1152, 438)], ["obstacles/ark_pillar_s", Vector2(400, 700)],
		["obstacles/ark_pillar_s", Vector2(880, 700)], ["obstacles/ark_console_s", Vector2(640, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 120), Vector2(110, 120), Vector2(428, 225), Vector2(445, 214), Vector2(464, 204),
				Vector2(483, 195), Vector2(504, 187), Vector2(525, 181), Vector2(547, 175), Vector2(570, 171),
				Vector2(593, 168), Vector2(616, 166), Vector2(640, 165), Vector2(664, 166), Vector2(687, 168),
				Vector2(710, 171), Vector2(733, 175), Vector2(755, 181), Vector2(776, 187), Vector2(797, 195),
				Vector2(816, 204), Vector2(835, 214), Vector2(852, 225), Vector2(868, 237), Vector2(883, 250),
				Vector2(896, 263), Vector2(907, 277), Vector2(917, 292), Vector2(925, 307), Vector2(932, 322),
				Vector2(936, 338), Vector2(939, 354), Vector2(940, 370), Vector2(939, 386), Vector2(936, 402),
				Vector2(932, 418), Vector2(925, 433), Vector2(917, 448), Vector2(907, 463), Vector2(896, 477),
				Vector2(883, 490), Vector2(868, 503), Vector2(852, 515), Vector2(835, 526), Vector2(816, 536),
				Vector2(797, 545), Vector2(776, 553), Vector2(755, 559), Vector2(733, 565), Vector2(710, 569),
				Vector2(687, 572), Vector2(664, 574), Vector2(640, 575), Vector2(640, 410)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 370), Vector2(942, 370)],
			"next": "main", "next_at": 1108.5,  # joins main at (940, 370)
			"entrance": true,
		},
		"sky_a": {
			"points": [Vector2(-60, 400), Vector2(1340, 400)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
		"sky_b": {
			"points": [Vector2(1340, 110), Vector2(-60, 110)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
	},
	"gate": Vector2(640, 380),
	"plots": [
		Vector2(760, 290), Vector2(1140, 310), Vector2(840, 300), Vector2(1000, 440), Vector2(700, 440), Vector2(1060, 310),
		Vector2(580, 230), Vector2(700, 230), Vector2(140, 200), Vector2(760, 620), Vector2(500, 120), Vector2(280, 110),
		Vector2(420, 150), Vector2(60, 180), Vector2(770, 480), Vector2(880, 370),
	],
	"posts": [Vector2(207, 152), Vector2(547, 175), Vector2(1228, 370), Vector2(1110, 370), Vector2(791, 547), Vector2(855, 227)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.2,  # TUNING (not in GDD) DECISIONS Z4: kept with the Z4 roster changes (2.4 lost lives on 4 seeds); the act's finale presses hardest
	"rule": "",
	"act_rule": "concord/abduction",
	"build_order": "ark_default",
	"weak_order": "ark_weak",
	"waves": [
		{"banner": "Vault Beasts break loose from the specimen tanks", "groups": [{"kind": "concord_vault_beast", "count": 4, "spacing": 1.2}, {"kind": "concord_broodling", "count": 8, "spacing": 0.6, "delay": 3.0, "road": "east"}]},
		{"banner": "Grey Drones on the gangways: their probes stun a tower", "groups": [{"kind": "concord_grey_drone", "count": 3, "spacing": 1.5, "road": "east"}, {"kind": "concord_vault_beast", "count": 4, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "The Ark sends its saucers: shoot them down while they beam", "groups": [{"kind": "concord_broodling", "count": 12, "spacing": 0.5}, {"kind": "concord_grey_drone", "count": 3, "spacing": 1.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_vault_beast", "count": 6, "spacing": 1.0, "road": "east"}, {"kind": "concord_acid_spitter", "count": 3, "spacing": 1.3, "delay": 2.0}]},
		{"banner": "A Grey Overseer: its crown mends the Concord. Kill it first", "groups": [{"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0}, {"kind": "concord_vault_beast", "count": 8, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_broodling", "count": 10, "spacing": 0.5, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 6, "spacing": 1.2, "road": "east"}, {"kind": "concord_grey_drone", "count": 5, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "A Lumen Sentinel: its shield of light soaks the first hits", "groups": [{"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "concord_vault_beast", "count": 8, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "concord_acid_spitter", "count": 5, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_prism", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 7, "spacing": 1.1, "delay": 1.0}, {"kind": "concord_broodling", "count": 14, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "concord_grey_drone", "count": 7, "spacing": 1.1, "delay": 1.0}, {"kind": "concord_vault_beast", "count": 8, "spacing": 0.9, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_burrower", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "east"}]},
		{"banner": "The vaults open", "groups": [{"kind": "concord_vault_beast", "count": 12, "spacing": 0.7}, {"kind": "concord_vault_beast", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_acid_spitter", "count": 8, "spacing": 1.0, "road": "east"}, {"kind": "concord_grey_drone", "count": 7, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Luminous Archon descends: his beam blinds every tower in its line!", "groups": [{"kind": "concord_luminous_archon", "count": 1, "spacing": 1.0}, {"kind": "concord_vault_beast", "count": 8, "spacing": 1.0, "delay": 4.0, "road": "east"}, {"kind": "concord_grey_drone", "count": 5, "spacing": 1.2, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "concord_burrower", "count": 9, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 18, "spacing": 0.35}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "concord_vault_beast", "count": 10, "spacing": 0.8, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 4.0}, {"kind": "concord_grey_drone", "count": 9, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "concord_acid_spitter", "count": 7, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The reactor deck: the Luminous guard it", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0}, {"kind": "concord_burrower", "count": 10, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_vault_beast", "count": 14, "spacing": 0.6, "road": "east"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_grey_drone", "count": 8, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "concord_acid_spitter", "count": 9, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 16, "spacing": 0.35, "road": "east"}, {"kind": "concord_burrower", "count": 10, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "east"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9}, {"kind": "concord_vault_beast", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "east"}]},
		{"banner": "The bridge: every race of the Concord", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 10, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "east"}, {"kind": "concord_acid_spitter", "count": 8, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "concord_vault_beast", "count": 14, "spacing": 0.6, "delay": 1.0}, {"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Harvester's guard", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9, "road": "east"}, {"kind": "concord_burrower", "count": 10, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "east"}]},
		{"banner": "The Harvester descends from its throne of rings!", "groups": [{"kind": "concord_harvester", "count": 1, "spacing": 1.0}, {"kind": "concord_vault_beast", "count": 10, "spacing": 1.0, "delay": 5.0, "road": "east"}, {"kind": "concord_grey_drone", "count": 6, "spacing": 1.2, "delay": 10.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 16.0, "road": "east"}, {"kind": "concord_grey_overseer", "count": 1, "spacing": 1.0, "delay": 20.0}]},
	],
}
