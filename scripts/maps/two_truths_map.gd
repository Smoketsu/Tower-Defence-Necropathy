## The Hall of Two Truths (Act VII map 3, the finale; Necropathy stage
## "two_truths"): the judgment hall of the dead. The road draws the scales: it
## comes in along the beam from the east and hangs down in three U-bends, the
## right pan, the narrow central post and the left pan (the two pans mirror each
## other), to the gate at the beam's west end. Five Canopic Jars beside the road
## (JARS), and the Scales (HUD, top-right): every return tips them to the
## Dynasty (tougher spawns, faster Names), every smashed Name and broken jar to
## the necromancer. 16 plots, 6 posts, 24 waves. The Sandstorm from wave 10. The
## Devourer's Whelp (miniboss, chest; it eats Names) on wave 13; Osiris and
## Ammit on wave 24. Beating them unlocks the Ushabti Sentinel tower. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "two_truths",
	"name": "The Hall of Two Truths",
	"floor": "tiles/two_truths_scales",
	"decals": [],
	"obstacles": [
		["obstacles/dyn_colonnade_s_v", Vector2(1233, 219)], ["obstacles/dyn_colonnade_s_v", Vector2(1210, 620)],
		["obstacles/dyn_obelisk_l", Vector2(50, 217)], ["obstacles/dyn_brazier", Vector2(890, 350)],
		["obstacles/dyn_great_scales", Vector2(640, 350)], ["obstacles/dyn_brazier", Vector2(300, 350)],
		["obstacles/dyn_obelisk_s", Vector2(60, 640)], ["obstacles/dyn_statue_row_s", Vector2(1051, 684)],
		["obstacles/dyn_sphinx_head_m", Vector2(769, 535)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 150), Vector2(1160, 150), Vector2(1160, 455), Vector2(1158, 480), Vector2(1152, 505),
				Vector2(1143, 529), Vector2(1130, 551), Vector2(1115, 571), Vector2(1096, 588), Vector2(1075, 602),
				Vector2(1052, 613), Vector2(1028, 621), Vector2(1003, 625), Vector2(977, 625), Vector2(952, 621),
				Vector2(928, 613), Vector2(905, 602), Vector2(884, 588), Vector2(865, 571), Vector2(850, 551),
				Vector2(837, 529), Vector2(828, 505), Vector2(822, 480), Vector2(820, 455), Vector2(820, 150),
				Vector2(705, 150), Vector2(705, 495), Vector2(700, 520), Vector2(686, 541), Vector2(665, 555),
				Vector2(640, 560), Vector2(615, 555), Vector2(594, 541), Vector2(580, 520), Vector2(575, 495),
				Vector2(575, 150), Vector2(460, 150), Vector2(460, 455), Vector2(458, 480), Vector2(452, 505),
				Vector2(443, 529), Vector2(430, 551), Vector2(415, 571), Vector2(396, 588), Vector2(375, 602),
				Vector2(352, 613), Vector2(328, 621), Vector2(303, 625), Vector2(277, 625), Vector2(252, 621),
				Vector2(228, 613), Vector2(205, 602), Vector2(184, 588), Vector2(165, 571), Vector2(150, 551),
				Vector2(137, 529), Vector2(128, 505), Vector2(122, 480), Vector2(120, 455), Vector2(120, 150),
				Vector2(70, 150)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(42, 120),
	"plots": [
		Vector2(640, 190), Vector2(520, 300), Vector2(640, 400), Vector2(990, 520), Vector2(520, 440), Vector2(760, 250),
		Vector2(760, 450), Vector2(520, 220), Vector2(760, 370), Vector2(510, 540), Vector2(1220, 300), Vector2(1070, 520),
		Vector2(200, 500), Vector2(280, 520), Vector2(50, 300), Vector2(1100, 230),
	],
	"posts": [Vector2(1135, 544), Vector2(820, 276), Vector2(704, 502), Vector2(575, 167), Vector2(452, 505), Vector2(120, 309)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 4.0,  # TUNING (not in GDD) L4: 3.55 before the road redraw; the act's finale presses hardest
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
