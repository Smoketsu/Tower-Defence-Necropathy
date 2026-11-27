## Pandemonium (Act IX map 3, the act's finale; Necropathy stage "pandemonium"):
## the capital of hell, an obsidian cathedral city of chains and lava rivers
## climbing to the throne. The road draws a five-pointed star round the pit: the
## iron city road enters from the east onto the star's east point and traces
## eight of its sharp-pointed edges, then drops from the north point to the gate
## at the centre; the chain bridges come in from the south-west onto the star's
## south-west point. 18 plots, 6 posts, 25 waves. The Portals: waves 7 (on post
## 1), 11 (on post 2), 15 (on post 3) and 20 (the cathedral's west stair, no
## post); Hell Pits from wave 6; fallen angels dive on towers and posts. The
## Fallen Seraph General (miniboss, chest) on wave 13, the Morning Star on wave
## 25 (the Angel, then the Beast who opens portals behind him): beating him
## unlocks the Archfiend tower, Fall from Grace and the Fallen Saint. Keys as
## graveyard_map.gd plus the Portals keys (the act data's RULE). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and the Inferno's RULE).
const MAP: Dictionary = {
	"id": "pandemonium",
	"name": "Pandemonium",
	"floor": "tiles/pandemonium_iron",
	"decals": [],
	"obstacles": [
		["obstacles/skull_pillar_l", Vector2(60, 100)], ["obstacles/iron_wall_l", Vector2(180, 420)],
		["obstacles/ash_column_l", Vector2(567, 318)], ["obstacles/ash_pew_l", Vector2(710, 259)],
		["obstacles/chain_post_l", Vector2(120, 330)], ["obstacles/obsidian_shard_l", Vector2(1240, 120)],
		["obstacles/iron_brazier_l", Vector2(1240, 440)], ["obstacles/bridge_rail_l", Vector2(128, 574)],
		["obstacles/burning_censer_l", Vector2(960, 460)], ["obstacles/skull_pillar_s", Vector2(1080, 60)],
		["obstacles/iron_wall_s", Vector2(620, 690)], ["obstacles/ash_column_s", Vector2(200, 160)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 273), Vector2(1013, 273), Vector2(806, 399), Vector2(870, 587), Vector2(640, 485),
				Vector2(410, 587), Vector2(474, 399), Vector2(267, 273), Vector2(537, 259), Vector2(640, 80),
				Vector2(640, 320)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"bridges": {
			"points": [Vector2(-40, 640), Vector2(250, 640), Vector2(410, 587)],
			"next": "main", "next_at": 1250.6,  # joins main at (410, 587)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 338),
	"plots": [
		Vector2(750, 380), Vector2(710, 590), Vector2(700, 150), Vector2(330, 390), Vector2(550, 100), Vector2(180, 580),
		Vector2(1050, 330), Vector2(520, 460), Vector2(760, 460), Vector2(530, 380), Vector2(70, 580), Vector2(360, 470),
		Vector2(280, 560), Vector2(500, 170), Vector2(410, 210), Vector2(890, 450), Vector2(1130, 330), Vector2(1130, 210),
	],
	"posts": [Vector2(949, 312), Vector2(870, 584), Vector2(313, 619), Vector2(540, 529), Vector2(369, 268), Vector2(640, 210)],
	"portals": [
		{"at": Vector2(870, 584), "wave": 7, "squad": [["damned_soul", 3], ["hell_imp", 2]], "every": 7.0, "squads": 4},  # TUNING (not in GDD) on post 1
		{"at": Vector2(313, 619), "wave": 11, "squad": [["hell_knight", 1], ["lava_hound", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 2
		{"at": Vector2(540, 529), "wave": 15, "squad": [["hell_knight", 2], ["damned_soul", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 3
		{"at": Vector2(425, 542), "wave": 20, "squad": [["demon_brute", 1], ["hell_imp", 3]], "every": 10.0, "squads": 3},  # TUNING (not in GDD) no post
	],
	"pits": [Vector2(665, 547), Vector2(264, 228), Vector2(700, 195)],
	"pits_from": 6,  # TUNING (not in GDD)
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.9,  # TUNING (not in GDD) L4: 3.4 before the road redraw; the act's finale presses hardest
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
