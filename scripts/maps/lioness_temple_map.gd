## The Temple of the Lioness (Act VII map 2; Necropathy stage "lioness_temple"):
## an avenue of statues to a sun temple. Two entrances, west and east, meet at
## the temple's top court; the joined road loops east round the hypostyle hall
## and runs the whole bottom avenue west to the gate. Five Canopic Jars beside
## the road (JARS). 16 plots, 5 posts, 23 waves. The Sandstorm from wave 5 (the
## temple's storms come often). The Lion Warden (miniboss, chest) on wave 12;
## Sekhmet on wave 23 (she calls the Red Wind and sets down wine jars).
## Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "lioness_temple",
	"name": "The Temple of the Lioness",
	"floor": "tiles/lioness_temple_avenue",
	"decals": [],
	"obstacles": [
		["obstacles/dyn_statue_row_l", Vector2(150, 110)], ["obstacles/dyn_statue_row_l", Vector2(1130, 110)],
		["obstacles/dyn_colonnade_l_v", Vector2(560, 320)], ["obstacles/dyn_colonnade_l_v", Vector2(720, 320)],
		["obstacles/dyn_brazier", Vector2(640, 110)], ["obstacles/dyn_sphinx_head_m", Vector2(1210, 420)],
		["obstacles/dyn_statue_row_s", Vector2(80, 300)], ["obstacles/dyn_obelisk_l", Vector2(1210, 600)],
		["obstacles/dyn_brazier", Vector2(400, 410)], ["obstacles/dyn_colonnade_s", Vector2(870, 680)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 190), Vector2(560, 190), Vector2(640, 270), Vector2(640, 360),
				Vector2(700, 420), Vector2(1000, 420), Vector2(1060, 480), Vector2(1060, 540),
				Vector2(1000, 600), Vector2(90, 600)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 190), Vector2(720, 190), Vector2(640, 270)],
			"next": "main", "next_at": 713.1, "entrance": true,
		},
	},
	"gate": Vector2(62, 570),
	"plots": [
		Vector2(250, 115), Vector2(1030, 135), Vector2(470, 265), Vector2(810, 265), Vector2(550, 350),
		Vector2(780, 340), Vector2(960, 330), Vector2(1150, 290), Vector2(1150, 520), Vector2(880, 510),
		Vector2(700, 510), Vector2(500, 510), Vector2(300, 510), Vector2(180, 500), Vector2(825, 680),
		Vector2(640, 680),
	],
	"posts": [Vector2(300, 190), Vector2(1000, 190), Vector2(640, 320), Vector2(850, 420), Vector2(500, 600)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.0,  # TUNING (not in GDD) S3: 2.8 before the spot fix
	"rule": "",
	"act_rule": "dynasty/rebirth",
	"build_order": "lioness_temple_default",
	"weak_order": "lioness_temple_weak",
	"waves": [
		{"banner": "Pilgrims of the dead climb the avenue of statues", "groups": [{"kind": "dyn_mummy", "count": 8, "spacing": 1.1}, {"kind": "dyn_mummy", "count": 6, "spacing": 1.1, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy_runner", "count": 8, "spacing": 1.0, "road": "east"}, {"kind": "nile_archer", "count": 4, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 4, "spacing": 1.8}, {"kind": "scarab_swarm", "count": 10, "spacing": 0.5, "delay": 2.0, "road": "east"}]},
		{"banner": "Bastet Hunters dive into the sand and slip past the posts", "groups": [{"kind": "bastet_hunter", "count": 2, "spacing": 3.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.8, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "embalmer", "count": 3, "spacing": 2.5}, {"kind": "dyn_mummy_runner", "count": 14, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "Awakening Statues: stone servants, flat armour", "groups": [{"kind": "awakening_statue", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "nile_archer", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "heka_priest", "count": 3, "spacing": 3.0}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 20, "spacing": 0.45}, {"kind": "bastet_hunter", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 3, "spacing": 2.6, "road": "east"}, {"kind": "dyn_mummy", "count": 16, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 3, "spacing": 3.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 2.0, "road": "east"}, {"kind": "dyn_mummy_runner", "count": 12, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "nile_archer", "count": 12, "spacing": 0.8, "road": "east"}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "The Lion Warden leaves his doorway!", "groups": [{"kind": "lion_warden", "count": 1, "spacing": 1.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.8, "delay": 3.0, "road": "east"}, {"kind": "heka_priest", "count": 2, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 3, "spacing": 2.6}, {"kind": "scarab_swarm", "count": 20, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.6, "road": "east"}, {"kind": "embalmer", "count": 4, "spacing": 2.2, "delay": 2.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 4, "spacing": 2.4}, {"kind": "nile_archer", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 12, "spacing": 1.0, "road": "east"}, {"kind": "heka_priest", "count": 3, "spacing": 2.6, "delay": 3.0}, {"kind": "dyn_mummy_runner", "count": 12, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 4, "spacing": 2.2}, {"kind": "awakening_statue", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 22, "spacing": 0.55, "road": "east"}, {"kind": "embalmer", "count": 4, "spacing": 2.0, "delay": 2.0}, {"kind": "scarab_swarm", "count": 14, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 5, "spacing": 2.0, "road": "east"}, {"kind": "khopesh_guard", "count": 10, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.4}, {"kind": "nile_archer", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "heka_priest", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 4, "spacing": 2.0, "road": "east"}, {"kind": "dyn_mummy_runner", "count": 18, "spacing": 0.5, "delay": 2.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "The temple's whole guard turns out", "groups": [{"kind": "jackal_warrior", "count": 5, "spacing": 2.0}, {"kind": "awakening_statue", "count": 4, "spacing": 2.4, "delay": 2.0, "road": "east"}, {"kind": "khopesh_guard", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "Sekhmet, the Lioness of Retribution, descends!", "groups": [{"kind": "sekhmet", "count": 1, "spacing": 1.0}, {"kind": "bastet_hunter", "count": 3, "spacing": 2.5, "delay": 4.0, "road": "east"}, {"kind": "dyn_mummy", "count": 12, "spacing": 0.8, "delay": 8.0}]},
	],
}
