## The Empyrean (Act X map 3, the act's finale and the end of Part Two;
## Necropathy stage "empyrean"): the highest heaven, a white rose of light,
## endless and silent. Two roads come in from the west and the east along the
## rose's edge, wind back and forth up its petals and meet below its heart,
## then rise together to the gate at the top. 16 plots, 5 posts, 24 waves. The Hallowed Light:
## diagonal shafts cross the rose, and every live Choir Angel widens them (the
## Choir). Three cloud banks drift over the petals. The Herald of the Seventh
## Trumpet (miniboss, chest) on wave 12; the Voice on wave 24: it never moves,
## Be Not Afraid stuns every tower out of the shade and the Last Word sends the
## run's sins back as Judges. Beating it unlocks the Bound Ophan. Keys as
## graveyard_map.gd plus "clouds" (rules/host/hallowed_light.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and hallowed_light.gd).
const MAP: Dictionary = {
	"id": "empyrean",
	"name": "The Empyrean",
	"floor": "tiles/empyrean_petals",
	"decals": [],
	"obstacles": [
		["obstacles/host_petal_m", Vector2(40, 250)], ["obstacles/host_petal_m", Vector2(1240, 250)],
		["obstacles/host_pillar_m", Vector2(480, 100)], ["obstacles/host_pillar_m", Vector2(800, 100)],
		["obstacles/host_petal_m_v", Vector2(640, 690)], ["obstacles/host_cloudstone_m", Vector2(290, 420)],
		["obstacles/host_cloudstone_m", Vector2(990, 420)], ["obstacles/host_petal_m", Vector2(560, 480)],
		["obstacles/host_petal_m", Vector2(720, 480)], ["obstacles/host_pillar_m", Vector2(40, 560)],
		["obstacles/host_pillar_m", Vector2(1240, 560)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 650), Vector2(420, 650), Vector2(480, 590), Vector2(480, 530),
				Vector2(420, 470), Vector2(160, 470), Vector2(100, 410), Vector2(100, 330),
				Vector2(160, 270), Vector2(580, 270), Vector2(640, 210), Vector2(640, 120)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 650), Vector2(860, 650), Vector2(800, 590), Vector2(800, 530),
				Vector2(860, 470), Vector2(1120, 470), Vector2(1180, 410), Vector2(1180, 330),
				Vector2(1120, 270), Vector2(700, 270), Vector2(640, 210)],
			"next": "main", "next_at": 1704.3,  # joins main at (640, 210)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 98),
	"plots": [
		Vector2(200, 560), Vector2(360, 560), Vector2(920, 560), Vector2(1080, 560), Vector2(640, 560),
		Vector2(240, 370), Vector2(420, 370), Vector2(860, 370), Vector2(1040, 370), Vector2(640, 400),
		Vector2(300, 190), Vector2(480, 190), Vector2(800, 190), Vector2(980, 190), Vector2(560, 130),
		Vector2(720, 130),
	],
	"posts": [Vector2(260, 650), Vector2(1020, 650), Vector2(100, 370), Vector2(1180, 370), Vector2(640, 165)],
	"clouds": [[Vector2(640, 400), 84.0], [Vector2(330, 370), 70.0], [Vector2(950, 370), 70.0]], [Vector2(280, 300), 70.0], [Vector2(1000, 300), 70.0]],  # TUNING (not in GDD) the rose's shadowed petals
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 5.0,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "host/hallowed_light",
	"build_order": "empyrean_default",
	"weak_order": "empyrean_weak",
	"waves": [
		{"banner": "The Rose's Edge: lights from either side", "groups": [{"kind": "host_lesser_light", "count": 10, "spacing": 0.7}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 4, "spacing": 1.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 6, "spacing": 1.3}, {"kind": "host_power", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "east"}]},
		{"banner": "The Choir: every Choir Angel alive widens the Light", "groups": [{"kind": "host_choir_angel", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "east"}, {"kind": "host_power", "count": 6, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_herald", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 1.0}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 1, "spacing": 1.0}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "host_power", "count": 10, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_herald", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Petals", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_ophan", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "east"}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "host_ophan", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "The Herald of the Seventh Trumpet: each blast calls an earlier host!", "groups": [{"kind": "host_seventh_herald", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 4.0, "road": "east"}, {"kind": "host_power", "count": 6, "spacing": 1.2, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The Choir: the hymn of the whole Host", "groups": [{"kind": "host_choir_angel", "count": 3, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 3.0, "delay": 1.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.5, "road": "east"}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 1.0, "road": "east"}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_ophan", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0}, {"kind": "host_herald", "count": 3, "spacing": 3.5, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The Heart of the Rose", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 4, "spacing": 3.0}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_lesser_light", "count": 18, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 3.0, "road": "east"}]},
		{"banner": "The whole Host stands before the Voice", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "host_ophan", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "The Voice speaks at the heart of the rose. Be not afraid.", "groups": [{"kind": "host_voice", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.1, "delay": 6.0, "road": "east"}, {"kind": "host_power", "count": 10, "spacing": 1.1, "delay": 12.0}]},
	],
}
