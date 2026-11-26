## The Necropolis of Sand (Act VII map 1; Necropathy stage "necropolis"): a
## tomb road through the dunes. Two entrances: the main road from the west
## winds down in three runs to the gate in the south-east; the tomb road from
## the west joins it on its middle run. Five Canopic Jars stand beside the
## road (JARS): the dead near them rise again (Rebirth and the Names). 16
## plots, 5 posts, 22 waves. The Sandstorm from wave 8. The Sand Colossus
## (miniboss, chest) on wave 12; Anubis on wave 22, who sets new jars down.
## Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "necropolis",
	"name": "The Necropolis of Sand",
	"floor": "tiles/necropolis_dunes",
	"decals": [],
	"obstacles": [
		["obstacles/dyn_obelisk_l", Vector2(60, 90)], ["obstacles/dyn_tomb_l", Vector2(840, 80)],
		["obstacles/dyn_sphinx_head_m", Vector2(1210, 120)], ["obstacles/dyn_sandstone_blocks_m", Vector2(720, 270)],
		["obstacles/dyn_obelisk_s", Vector2(1220, 330)], ["obstacles/dyn_tomb_s", Vector2(80, 420)],
		["obstacles/dyn_statue_row_s", Vector2(720, 495)], ["obstacles/dyn_tomb_l", Vector2(1210, 660)],
		["obstacles/dyn_obelisk_s", Vector2(160, 670)], ["obstacles/dyn_sandstone_blocks_m", Vector2(1100, 380)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 150), Vector2(980, 150), Vector2(1040, 210), Vector2(1040, 330),
				Vector2(980, 390), Vector2(320, 390), Vector2(260, 450), Vector2(260, 540),
				Vector2(320, 600), Vector2(1190, 600)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"tomb": {
			"points": [Vector2(-40, 290), Vector2(230, 290), Vector2(320, 390)],
			"next": "main", "next_at": 1969.7, "entrance": true,
		},
	},
	"gate": Vector2(1218, 570),
	"plots": [
		Vector2(300, 90), Vector2(700, 90), Vector2(1110, 90), Vector2(420, 270), Vector2(600, 270),
		Vector2(860, 270), Vector2(1140, 260), Vector2(420, 495), Vector2(600, 495), Vector2(860, 495),
		Vector2(1040, 495), Vector2(150, 500), Vector2(1140, 440), Vector2(520, 680), Vector2(900, 680),
		Vector2(110, 210),
	],
	"posts": [Vector2(600, 150), Vector2(120, 290), Vector2(650, 390), Vector2(720, 600), Vector2(1080, 600)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.65,  # TUNING (not in GDD) Part Two: a step above the Road to the Sun
	"rule": "",
	"act_rule": "dynasty/rebirth",
	"build_order": "necropolis_default",
	"weak_order": "necropolis_weak",
	"waves": [
		{"banner": "The dead of the Dynasty walk: they rise again near their jars", "groups": [{"kind": "dyn_mummy", "count": 12, "spacing": 1.2}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 10, "spacing": 1.0}, {"kind": "scarab_swarm", "count": 8, "spacing": 0.6, "delay": 3.0, "road": "tomb"}]},
		{"banner": "Nile Archers shoot from the column", "groups": [{"kind": "dyn_mummy_runner", "count": 10, "spacing": 0.9}, {"kind": "nile_archer", "count": 6, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 6, "spacing": 1.6}, {"kind": "dyn_mummy", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "tomb"}]},
		{"banner": "Embalmers: they heal, and hasten the Names near them", "groups": [{"kind": "dyn_mummy", "count": 14, "spacing": 0.8}, {"kind": "embalmer", "count": 3, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 16, "spacing": 0.5}, {"kind": "nile_archer", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "tomb"}]},
		{"banner": "Jackal Warriors lunge through the posts", "groups": [{"kind": "jackal_warrior", "count": 2, "spacing": 3.0}, {"kind": "khopesh_guard", "count": 6, "spacing": 1.4, "delay": 2.0}, {"kind": "dyn_mummy_runner", "count": 10, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 18, "spacing": 0.7}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 3.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "nile_archer", "count": 10, "spacing": 0.9}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "Heka Priests write glyphs that weaken your towers", "groups": [{"kind": "heka_priest", "count": 3, "spacing": 3.0}, {"kind": "dyn_mummy_runner", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 4, "spacing": 2.6}, {"kind": "scarab_swarm", "count": 18, "spacing": 0.45, "delay": 3.0}]},
		{"banner": "The Sand Colossus strides out of the dunes!", "groups": [{"kind": "sand_colossus", "count": 1, "spacing": 1.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.8, "delay": 3.0}, {"kind": "embalmer", "count": 2, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 10, "spacing": 1.1}, {"kind": "nile_archer", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 20, "spacing": 0.6}, {"kind": "heka_priest", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 4, "spacing": 2.4}, {"kind": "dyn_mummy_runner", "count": 16, "spacing": 0.6, "delay": 2.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 22, "spacing": 0.4}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "nile_archer", "count": 12, "spacing": 0.8}, {"kind": "embalmer", "count": 4, "spacing": 2.2, "delay": 2.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.7, "delay": 4.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 6, "spacing": 2.0}, {"kind": "heka_priest", "count": 4, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 14, "spacing": 0.9}, {"kind": "dyn_mummy_runner", "count": 16, "spacing": 0.6, "delay": 3.0, "road": "tomb"}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy", "count": 22, "spacing": 0.55}, {"kind": "embalmer", "count": 4, "spacing": 2.2, "delay": 2.0}, {"kind": "nile_archer", "count": 10, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "The tomb road fills: the whole Procession", "groups": [{"kind": "jackal_warrior", "count": 6, "spacing": 2.0}, {"kind": "khopesh_guard", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "tomb"}, {"kind": "scarab_swarm", "count": 18, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "Anubis, Opener of the Way, leads the dead home!", "groups": [{"kind": "anubis", "count": 1, "spacing": 1.0}, {"kind": "dyn_mummy", "count": 12, "spacing": 0.9, "delay": 4.0}, {"kind": "jackal_warrior", "count": 3, "spacing": 2.5, "delay": 10.0}]},
	],
}
