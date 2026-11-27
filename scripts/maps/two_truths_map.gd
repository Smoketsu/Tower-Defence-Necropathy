## The Hall of Two Truths (Act VII map 3, the finale; Necropathy stage
## "two_truths"): the judgment hall of the dead. One road spirals inward past
## the same plots three times to the gate in the hall's heart, before the
## throne. Five Canopic Jars beside the road (JARS), and the Scales (HUD,
## top-right): every return tips them to the Dynasty (tougher spawns, faster
## Names), every smashed Name and broken jar to the necromancer. 16 plots, 6
## posts, 24 waves. The Sandstorm from wave 10. The Devourer's Whelp (miniboss,
## chest; it eats Names) on wave 13; Osiris and Ammit on wave 24. Beating them
## unlocks the Ushabti Sentinel tower. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "two_truths",
	"name": "The Hall of Two Truths",
	"floor": "tiles/two_truths_scales",
	"decals": [],
	"obstacles": [
		["obstacles/dyn_colonnade_s_v", Vector2(1210, 200)], ["obstacles/dyn_colonnade_s_v", Vector2(1210, 620)],
		["obstacles/dyn_obelisk_l", Vector2(60, 200)], ["obstacles/dyn_brazier", Vector2(820, 350)],
		["obstacles/dyn_great_scales", Vector2(560, 350)], ["obstacles/dyn_brazier", Vector2(300, 350)],
		["obstacles/dyn_obelisk_s", Vector2(60, 640)], ["obstacles/dyn_statue_row_s", Vector2(1030, 650)],
		["obstacles/dyn_sphinx_head_m", Vector2(800, 495)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 130), Vector2(1100, 130), Vector2(1100, 560), Vector2(180, 560),
				Vector2(180, 280), Vector2(940, 280), Vector2(940, 420), Vector2(460, 420)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(432, 390),
	"plots": [
		Vector2(300, 205), Vector2(520, 205), Vector2(740, 205), Vector2(960, 205), Vector2(300, 380),
		Vector2(680, 350), Vector2(1020, 350), Vector2(300, 490), Vector2(560, 490), Vector2(1020, 490),
		Vector2(1180, 300), Vector2(1180, 470), Vector2(400, 650), Vector2(700, 650), Vector2(90, 420),
		Vector2(180, 650),
	],
	"posts": [Vector2(600, 130), Vector2(1100, 340), Vector2(640, 560), Vector2(180, 420), Vector2(600, 280), Vector2(700, 420)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.55,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "dynasty/rebirth",
	"build_order": "two_truths_default",
	"weak_order": "two_truths_weak",
	"waves": [
		{"banner": "The dead come to be weighed: the Scales hang over the hall", "groups": [{"kind": "dyn_mummy", "count": 14, "spacing": 1.0}]},
		{"banner": "", "groups": [{"kind": "dyn_mummy_runner", "count": 12, "spacing": 0.8}, {"kind": "nile_archer", "count": 5, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "Crocodile Wardens seize the bodies that hold them", "groups": [{"kind": "crocodile_warden", "count": 2, "spacing": 4.0}, {"kind": "dyn_mummy", "count": 12, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 7, "spacing": 1.4}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 18, "spacing": 0.45}, {"kind": "heka_priest", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 3, "spacing": 2.6}, {"kind": "dyn_mummy_runner", "count": 14, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 3, "spacing": 3.0}, {"kind": "nile_archer", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "crocodile_warden", "count": 3, "spacing": 3.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 2.0}, {"kind": "dyn_mummy", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 3, "spacing": 2.6}, {"kind": "khopesh_guard", "count": 8, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 22, "spacing": 0.4}, {"kind": "heka_priest", "count": 3, "spacing": 2.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 4, "spacing": 2.4}, {"kind": "dyn_mummy_runner", "count": 16, "spacing": 0.6, "delay": 2.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.6}, {"kind": "nile_archer", "count": 10, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "The Devourer's Whelp is loose: it eats the Names!", "groups": [{"kind": "devourers_whelp", "count": 1, "spacing": 1.0}, {"kind": "dyn_mummy", "count": 16, "spacing": 0.7, "delay": 3.0}, {"kind": "khopesh_guard", "count": 4, "spacing": 1.6, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "crocodile_warden", "count": 3, "spacing": 3.0}, {"kind": "bastet_hunter", "count": 3, "spacing": 2.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 12, "spacing": 1.0}, {"kind": "heka_priest", "count": 3, "spacing": 2.6, "delay": 3.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "scarab_swarm", "count": 24, "spacing": 0.38}, {"kind": "jackal_warrior", "count": 4, "spacing": 2.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 4, "spacing": 2.4}, {"kind": "dyn_mummy", "count": 18, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "crocodile_warden", "count": 4, "spacing": 2.6}, {"kind": "nile_archer", "count": 12, "spacing": 0.7, "delay": 2.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bastet_hunter", "count": 4, "spacing": 2.0}, {"kind": "khopesh_guard", "count": 10, "spacing": 1.0, "delay": 2.0}, {"kind": "heka_priest", "count": 3, "spacing": 2.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "jackal_warrior", "count": 5, "spacing": 2.0}, {"kind": "dyn_mummy_runner", "count": 18, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "awakening_statue", "count": 5, "spacing": 2.2}, {"kind": "crocodile_warden", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "embalmer", "count": 4, "spacing": 2.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "khopesh_guard", "count": 12, "spacing": 0.9}, {"kind": "bastet_hunter", "count": 4, "spacing": 2.2, "delay": 2.0}, {"kind": "nile_archer", "count": 10, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "The whole court of the dead comes before the throne", "groups": [{"kind": "jackal_warrior", "count": 6, "spacing": 1.8}, {"kind": "crocodile_warden", "count": 4, "spacing": 2.6, "delay": 2.0}, {"kind": "dyn_mummy", "count": 16, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "Osiris, Lord of the Dead, takes his throne: the Weighing begins!", "groups": [{"kind": "osiris", "count": 1, "spacing": 1.0}, {"kind": "khopesh_guard", "count": 6, "spacing": 1.4, "delay": 4.0}, {"kind": "embalmer", "count": 3, "spacing": 2.5, "delay": 9.0}]},
	],
}
