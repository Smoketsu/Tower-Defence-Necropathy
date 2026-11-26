## The Wheel of Thrones (Act X map 2; Necropathy stage "wheel_of_thrones"): the
## turning spheres of heaven. One road coils inward like a wheel within a wheel:
## in from the west along the bottom, up the east side, back along the top, down
## the west side and round the inner ring to the gate at the hub, so every plot
## between two turns covers both. 16 plots, 6 posts, 23 waves. The Hallowed
## Light: shafts sweep from every side in turn. Two cloud banks drift over the
## inner ring. The Dominion of the Spheres (miniboss, chest) on wave 12; the
## Throne on wave 23. Keys as graveyard_map.gd plus "clouds"
## (rules/host/hallowed_light.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and hallowed_light.gd).
const MAP: Dictionary = {
	"id": "wheel_of_thrones",
	"name": "The Wheel of Thrones",
	"floor": "tiles/wheel_stars",
	"decals": [],
	"obstacles": [
		["obstacles/host_crystal_m", Vector2(60, 110)], ["obstacles/host_crystal_m_v", Vector2(1220, 110)],
		["obstacles/host_crystal_m", Vector2(1220, 690)], ["obstacles/host_pillar_m", Vector2(640, 690)],
		["obstacles/host_crystal_m", Vector2(300, 690)], ["obstacles/host_pillar_m", Vector2(700, 350)],
		["obstacles/host_crystal_m_v", Vector2(60, 400)], ["obstacles/host_pillar_m", Vector2(1020, 520)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 590), Vector2(1060, 590), Vector2(1120, 530), Vector2(1120, 170),
				Vector2(1060, 110), Vector2(240, 110), Vector2(180, 170), Vector2(180, 380),
				Vector2(240, 440), Vector2(860, 440), Vector2(920, 380), Vector2(920, 320),
				Vector2(860, 260), Vector2(500, 260)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(472, 262),
	"plots": [
		Vector2(300, 515), Vector2(520, 515), Vector2(740, 515), Vector2(960, 515), Vector2(1020, 250),
		Vector2(1020, 400), Vector2(380, 185), Vector2(600, 185), Vector2(820, 185), Vector2(560, 350),
		Vector2(780, 350), Vector2(90, 280), Vector2(300, 330), Vector2(1200, 350), Vector2(1200, 610),
		Vector2(70, 520),
	],
	"posts": [Vector2(420, 590), Vector2(1120, 350), Vector2(700, 110), Vector2(180, 300), Vector2(560, 440), Vector2(920, 350)],
	"clouds": [[Vector2(640, 350), 84.0], [Vector2(300, 330), 70.0]],  # TUNING (not in GDD) shade over the hub
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 4.7,  # TUNING (not in GDD) rising through the act
	"rule": "",
	"act_rule": "host/hallowed_light",
	"build_order": "wheel_of_thrones_default",
	"weak_order": "wheel_of_thrones_weak",
	"waves": [
		{"banner": "The spheres turn: lights and Virtues", "groups": [{"kind": "host_lesser_light", "count": 12, "spacing": 0.7}, {"kind": "host_virtue", "count": 6, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 10, "spacing": 1.1}, {"kind": "host_power", "count": 4, "spacing": 1.5, "delay": 3.0}]},
		{"banner": "An Ophan rolls: no post holds it unless it is staggered or frozen", "groups": [{"kind": "host_ophan", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_power", "count": 8, "spacing": 1.2}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_herald", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 5.0}, {"kind": "host_power", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.5, "delay": 2.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_power", "count": 6, "spacing": 1.1, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 14, "spacing": 0.8}, {"kind": "host_ophan", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Dominion of the Spheres: every angel near him stays quick and whole!", "groups": [{"kind": "host_dominion_of_the_spheres", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 3.0}, {"kind": "host_power", "count": 6, "spacing": 1.1, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.5}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 2.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_cherub", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Sphere of the Stars: wheels within wheels", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 4, "spacing": 3.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0}, {"kind": "host_dominion", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_ophan", "count": 3, "spacing": 3.0}, {"kind": "host_herald", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "The Wheel itself turns toward you", "groups": [{"kind": "host_ophan", "count": 4, "spacing": 3.0}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "host_power", "count": 12, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "The Throne rolls into the Wheel: strike its Core when the wheels part!", "groups": [{"kind": "host_throne", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.1, "delay": 5.0}, {"kind": "host_ophan", "count": 2, "spacing": 4.0, "delay": 10.0}, {"kind": "host_power", "count": 8, "spacing": 1.2, "delay": 16.0}]},
	],
}
