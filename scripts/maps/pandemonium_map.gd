## Pandemonium (Act IX map 3, the act's finale; Necropathy stage
## "pandemonium"): the capital of hell, an obsidian cathedral city of chains
## and lava rivers climbing to the throne. Two entrances at the bottom (the
## iron city from the east, the chain bridges from the west) merge under the
## cathedral; the joined road climbs past it and along the throne terrace to
## the gate. 18 plots, 6 posts, 25 waves. The Portals: waves 7 (on post 1),
## 11 (on post 2), 15 (on post 3) and 20 (the cathedral's west stair, no post);
## Hell Pits from wave 6; fallen angels dive on towers and posts. The Fallen
## Seraph General (miniboss, chest) on wave 13, the Morning Star on wave 25
## (the Angel, then the Beast who opens portals behind him): beating him
## unlocks the Archfiend tower, Fall from Grace and the Fallen Saint.
## Keys as graveyard_map.gd plus the Portals keys (the act data's RULE). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and the Inferno's RULE).
const MAP: Dictionary = {
	"id": "pandemonium",
	"name": "Pandemonium",
	"floor": "tiles/pandemonium_iron",
	"decals": [],
	"obstacles": [
		["obstacles/skull_pillar_l", Vector2(60, 100)], ["obstacles/iron_wall_l", Vector2(180, 420)],
		["obstacles/ash_column_l", Vector2(580, 270)], ["obstacles/ash_pew_l", Vector2(640, 220)],
		["obstacles/chain_post_l", Vector2(120, 330)], ["obstacles/obsidian_shard_l", Vector2(1240, 120)],
		["obstacles/iron_brazier_l", Vector2(1240, 440)], ["obstacles/bridge_rail_l", Vector2(160, 690)],
		["obstacles/burning_censer_l", Vector2(960, 460)], ["obstacles/skull_pillar_s", Vector2(1080, 60)],
		["obstacles/iron_wall_s", Vector2(620, 690)], ["obstacles/ash_column_s", Vector2(200, 160)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 620), Vector2(840, 620), Vector2(780, 560), Vector2(780, 440),
				Vector2(720, 380), Vector2(400, 380), Vector2(340, 320), Vector2(340, 180),
				Vector2(400, 120), Vector2(860, 120), Vector2(920, 180), Vector2(920, 260),
				Vector2(980, 320), Vector2(1180, 320)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"bridges": {
			"points": [Vector2(-40, 620), Vector2(320, 620), Vector2(380, 560), Vector2(380, 440), Vector2(440, 380)],
			"next": "main", "next_at": 1049.7, "entrance": true,  # joins main at (440, 380)
		},
	},
	"gate": Vector2(1218, 290),
	"plots": [
		Vector2(1000, 550), Vector2(1160, 550), Vector2(850, 500), Vector2(710, 500), Vector2(240, 550),
		Vector2(450, 500), Vector2(300, 480), Vector2(560, 450), Vector2(640, 310), Vector2(470, 310),
		Vector2(270, 250), Vector2(410, 240), Vector2(520, 190), Vector2(760, 190), Vector2(860, 250),
		Vector2(1000, 250), Vector2(1100, 390), Vector2(1100, 250),
	],
	"posts": [Vector2(1000, 620), Vector2(780, 500), Vector2(380, 500), Vector2(560, 380), Vector2(640, 120), Vector2(1060, 320)],
	"portals": [
		{"at": Vector2(780, 500), "wave": 7, "squad": [["damned_soul", 3], ["hell_imp", 2]], "every": 7.0, "squads": 4},  # TUNING (not in GDD) on post 1
		{"at": Vector2(380, 500), "wave": 11, "squad": [["hell_knight", 1], ["lava_hound", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 2
		{"at": Vector2(560, 380), "wave": 15, "squad": [["hell_knight", 2], ["damned_soul", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 3
		{"at": Vector2(340, 250), "wave": 20, "squad": [["demon_brute", 1], ["hell_imp", 3]], "every": 10.0, "squads": 3},  # TUNING (not in GDD) no post
	],
	"pits": [Vector2(560, 380), Vector2(640, 120), Vector2(1060, 320)],
	"pits_from": 6,  # TUNING (not in GDD)
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.0,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "inferno/portals",
	"build_order": "pandemonium_default",
	"weak_order": "pandemonium_weak",
	"waves": [
		{"banner": "The iron city's damned march on the throne", "groups": [{"kind": "damned_soul", "count": 14, "spacing": 1.0}]},
		{"banner": "", "groups": [{"kind": "damned_soul", "count": 10, "spacing": 0.9, "road": "bridges"}, {"kind": "hell_imp", "count": 8, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 4, "spacing": 2.2, "road": "bridges"}, {"kind": "damned_soul", "count": 10, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 8, "spacing": 0.8}, {"kind": "succubus", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 6, "spacing": 1.6}, {"kind": "pit_cultist", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bridges"}]},
		{"banner": "Fallen Angels dive on your towers with burning spears", "groups": [{"kind": "fallen_angel", "count": 2, "spacing": 4.0}, {"kind": "damned_soul", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "lilim_witch", "count": 2, "spacing": 3.5, "road": "bridges"}, {"kind": "hell_knight", "count": 6, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 1, "spacing": 1.0}, {"kind": "hell_imp", "count": 12, "spacing": 0.6, "delay": 2.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "succubus", "count": 2, "spacing": 3.0, "road": "bridges"}, {"kind": "lava_hound", "count": 10, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "fallen_angel", "count": 2, "spacing": 3.0}, {"kind": "hell_knight", "count": 7, "spacing": 1.3, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "pit_cultist", "count": 3, "spacing": 2.5}, {"kind": "damned_soul", "count": 16, "spacing": 0.5, "delay": 2.0, "road": "bridges"}, {"kind": "lilim_witch", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 4.0, "road": "bridges"}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "The Fallen Seraph General marches with the host of heaven's traitors!", "groups": [{"kind": "seraph_general", "count": 1, "spacing": 1.0}, {"kind": "hell_knight", "count": 6, "spacing": 1.3, "delay": 4.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5, "road": "bridges"}, {"kind": "fallen_angel", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 9, "spacing": 1.1}, {"kind": "lilim_witch", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 3.5}, {"kind": "hell_imp", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "succubus", "count": 3, "spacing": 2.5, "road": "bridges"}, {"kind": "damned_soul", "count": 16, "spacing": 0.5, "delay": 2.0}, {"kind": "pit_cultist", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "fallen_angel", "count": 3, "spacing": 2.5}, {"kind": "hell_knight", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5}, {"kind": "demon_brute", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "lilim_witch", "count": 3, "spacing": 2.5, "road": "bridges"}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 3.0}, {"kind": "hell_knight", "count": 6, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "fallen_angel", "count": 3, "spacing": 2.5, "road": "bridges"}, {"kind": "demon_brute", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 10, "spacing": 0.9}, {"kind": "lava_hound", "count": 10, "spacing": 0.5, "delay": 3.0, "road": "bridges"}]},
		{"banner": "", "groups": [{"kind": "succubus", "count": 3, "spacing": 2.5}, {"kind": "demon_brute", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "bridges"}, {"kind": "hell_imp", "count": 10, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "The throne room trembles", "groups": [{"kind": "fallen_angel", "count": 3, "spacing": 2.5, "road": "bridges"}, {"kind": "hell_knight", "count": 8, "spacing": 1.0, "delay": 2.0}, {"kind": "demon_brute", "count": 2, "spacing": 3.0, "delay": 5.0}]},
		{"banner": "The Morning Star rises from the throne!", "groups": [{"kind": "morning_star", "count": 1, "spacing": 1.0}, {"kind": "hell_knight", "count": 6, "spacing": 1.2, "delay": 5.0, "road": "bridges"}, {"kind": "fallen_angel", "count": 2, "spacing": 3.0, "delay": 8.0}]},
	],
}
