## The Ark of the Concord (Act XIII map 3, the act's finale; Necropathy stage
## "ark"): the Harvesters' mothership, its hangars, vaults and reactor. Two
## gangways come in from the upper corners, run down either side of the hangar
## and meet at the bottom, then climb the central spine to the gate (the
## bridge) in the middle of the deck, so the central plots cover three roads.
## Two sky lanes cross the deck (map road key "sky"). 16 plots, 6 posts, 25
## waves. Abduction (act rule concord/abduction): the Ark sends saucers most
## often. The Luminous Archon (miniboss, chest) on wave 13; the Harvester on
## wave 25. Keys as graveyard_map.gd. Data only.
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
		["obstacles/ark_crate_s_v", Vector2(1140, 400)], ["obstacles/ark_pillar_s", Vector2(400, 700)],
		["obstacles/ark_pillar_s", Vector2(880, 700)], ["obstacles/ark_console_s", Vector2(640, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 200), Vector2(300, 200), Vector2(360, 260), Vector2(360, 560), Vector2(420, 620),
				Vector2(580, 620), Vector2(640, 560), Vector2(640, 330)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 200), Vector2(980, 200), Vector2(920, 260), Vector2(920, 560), Vector2(860, 620),
				Vector2(700, 620), Vector2(640, 560)],
			"next": "main", "next_at": 1054.6,  # joins main at (640, 560)
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
	"gate": Vector2(640, 310),
	"plots": [
		Vector2(260, 320), Vector2(260, 480), Vector2(460, 300), Vector2(460, 470), Vector2(820, 300),
		Vector2(820, 470), Vector2(1020, 320), Vector2(1020, 480), Vector2(180, 130), Vector2(360, 130),
		Vector2(920, 130), Vector2(1100, 130), Vector2(500, 690), Vector2(780, 690), Vector2(560, 420),
		Vector2(720, 420),
	],
	"posts": [Vector2(200, 200), Vector2(360, 420), Vector2(1080, 200), Vector2(920, 420), Vector2(640, 460), Vector2(500, 620)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.4,  # TUNING (not in GDD) DECISIONS Z4: 2.2 -> 2.4 with the Z4 roster changes; the act's finale presses hardest
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
