## The Necropolis of Sand (Act VII map 1; Necropathy stage "necropolis"): a tomb
## road through the dunes. Two entrances: the main road comes along the avenue
## of sphinxes from the west, climbs the pyramid's west face in five right-angle
## steps, descends its east face in five more, and returns west along the
## causeway at its foot to the gate; the tomb road drops straight down a shaft
## from the north onto the east face. Five Canopic Jars stand beside the road
## (JARS): the dead near them rise again (Rebirth and the Names). 16 plots, 5
## posts, 22 waves. The Sandstorm from wave 8. The Sand Colossus (miniboss,
## chest) on wave 12; Anubis on wave 22, who sets new jars down. Keys as
## graveyard_map.gd. Data only.
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
			"points": [Vector2(-40, 520), Vector2(230, 520), Vector2(312, 520), Vector2(312, 440), Vector2(394, 440),
				Vector2(394, 360), Vector2(476, 360), Vector2(476, 280), Vector2(558, 280), Vector2(558, 200),
				Vector2(640, 200), Vector2(640, 120), Vector2(722, 120), Vector2(722, 200), Vector2(804, 200),
				Vector2(804, 280), Vector2(886, 280), Vector2(886, 360), Vector2(968, 360), Vector2(968, 440),
				Vector2(1050, 440), Vector2(1050, 520), Vector2(1150, 520), Vector2(1150, 630), Vector2(330, 630)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"tomb": {
			"points": [Vector2(886, -40), Vector2(886, 358)],
			"next": "main", "next_at": 1564.0,  # joins main at (886, 358)
			"entrance": true,
		},
	},
	"gate": Vector2(302, 600),
	"plots": [
		Vector2(160, 460), Vector2(420, 510), Vector2(490, 550), Vector2(780, 140), Vector2(1000, 560), Vector2(940, 290),
		Vector2(690, 570), Vector2(930, 520), Vector2(940, 210), Vector2(820, 340), Vector2(620, 260), Vector2(240, 440),
		Vector2(530, 340), Vector2(1210, 580), Vector2(580, 140), Vector2(770, 560),
	],
	"posts": [Vector2(403, 360), Vector2(886, 117), Vector2(886, 339), Vector2(773, 630), Vector2(434, 630)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.1,  # TUNING (not in GDD) L4: 4.3 before the road redraw; S3: 4.65 before the spot fix; Part Two: a step above the Road to the Sun
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
