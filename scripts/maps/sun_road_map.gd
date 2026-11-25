## The Road to the Sun (Act V map 3, the finale; Necropathy stage "sun_road"):
## a pilgrim road of torii gates climbing to the sun goddess's shrine. One
## long switchback road (four runs, bottom to top), so each row of plots
## covers two runs. 14 plots, 6 posts, 24 waves. The Sun's Course: dusk from
## wave 8, night from wave 14. The Kirin (miniboss, chest) on wave 12;
## Amaterasu on wave 24: she forces day at dawn and noon and the eclipse
## (night) at sunset. Beating her unlocks the Bound Oni tower.
## Keys as graveyard_map.gd plus lanterns / ambush (rules/shogunate/sun_course.gd).
## Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and sun_course.gd).
const MAP: Dictionary = {
	"id": "sun_road",
	"name": "The Road to the Sun",
	"floor": "tiles/sun_road_torii",
	"decals": [],
	"obstacles": [
		["obstacles/torii_post_l", Vector2(60, 610)], ["obstacles/torii_post_l", Vector2(110, 610)],
		["obstacles/cloud_rock_l", Vector2(1220, 690)], ["obstacles/black_pine_l", Vector2(640, 570)],
		["obstacles/torii_post_s", Vector2(1150, 380)], ["obstacles/sun_mirror_s", Vector2(700, 410)],
		["obstacles/cloud_rock_m", Vector2(60, 250)], ["obstacles/black_pine_s", Vector2(300, 250)],
		["obstacles/torii_post_l", Vector2(1100, 110)], ["obstacles/sun_mirror_l", Vector2(600, 120)],
		["obstacles/cloud_rock_s", Vector2(260, 110)], ["obstacles/burning_censer_s", Vector2(840, 110)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 650), Vector2(1000, 650), Vector2(1060, 590), Vector2(1060, 550),
				Vector2(1000, 490), Vector2(300, 490), Vector2(240, 430), Vector2(240, 390),
				Vector2(300, 330), Vector2(1000, 330), Vector2(1060, 270), Vector2(1060, 230),
				Vector2(1120, 170), Vector2(1190, 170)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(1218, 140),
	"plots": [
		Vector2(200, 580), Vector2(480, 580), Vector2(760, 580), Vector2(1140, 600), Vector2(560, 410),
		Vector2(820, 410), Vector2(160, 330), Vector2(1150, 480), Vector2(440, 250), Vector2(700, 250),
		Vector2(950, 250), Vector2(1150, 250), Vector2(1000, 410), Vector2(380, 410),
	],
	"posts": [Vector2(600, 650), Vector2(1060, 570), Vector2(500, 490), Vector2(240, 410), Vector2(800, 330), Vector2(1150, 170)],
	"lanterns": [Vector2(320, 700), Vector2(880, 700), Vector2(1130, 520), Vector2(660, 440), Vector2(170, 450), Vector2(520, 280), Vector2(900, 280), Vector2(1120, 110)],
	"ambush": [["main", 700.0], ["main", 1500.0], ["main", 2200.0]],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD)
	"wave_hp_end": 3.4,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "shogunate/sun_course",
	"build_order": "sun_road_default",
	"weak_order": "sun_road_weak",
	"waves": [
		{"banner": "Pilgrims' guards on the torii road", "groups": [{"kind": "ashigaru", "count": 14, "spacing": 1.0}]},
		{"banner": "Sohei: their naginata strike the post from reach", "groups": [{"kind": "sohei", "count": 3, "spacing": 3.0}, {"kind": "ashigaru", "count": 12, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 6, "spacing": 1.8}, {"kind": "teppo_gunner", "count": 6, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "sohei", "count": 4, "spacing": 2.5}, {"kind": "ashigaru", "count": 16, "spacing": 0.7, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 10, "spacing": 1.0}, {"kind": "samurai", "count": 6, "spacing": 1.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 3, "spacing": 3.0}, {"kind": "hatamoto", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "ashigaru", "count": 16, "spacing": 0.6, "delay": 2.5}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 10, "spacing": 1.2}, {"kind": "sohei", "count": 4, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "Dusk in the sacred forest: ninja on the steps!", "groups": [{"kind": "ninja", "count": 10, "spacing": 1.1}, {"kind": "teppo_gunner", "count": 8, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kunoichi", "count": 2, "spacing": 4.0}, {"kind": "samurai", "count": 10, "spacing": 1.1, "delay": 2.0}, {"kind": "ninja", "count": 6, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 5, "spacing": 2.4}, {"kind": "sohei", "count": 5, "spacing": 2.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "ashigaru", "count": 26, "spacing": 0.5}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 4.0}, {"kind": "ninja", "count": 8, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "The Kirin, a holy beast of light, gallops down the steps!", "groups": [{"kind": "kirin", "count": 1, "spacing": 1.0}, {"kind": "sohei", "count": 5, "spacing": 2.2, "delay": 3.0}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 14, "spacing": 0.8}, {"kind": "hatamoto", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "ninja", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "Night on the shrine steps: kitsune conjure fox-fire", "groups": [{"kind": "kitsune", "count": 2, "spacing": 4.0}, {"kind": "onryo", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "samurai", "count": 8, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 2, "spacing": 5.0}, {"kind": "kappa", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kitsune", "count": 3, "spacing": 3.5}, {"kind": "sohei", "count": 6, "spacing": 2.0, "delay": 2.0}, {"kind": "onryo", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 6, "spacing": 2.0}, {"kind": "oni", "count": 2, "spacing": 5.0, "delay": 3.0}, {"kind": "ninja", "count": 12, "spacing": 0.9, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 14, "spacing": 0.9}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "kappa", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 3, "spacing": 4.0}, {"kind": "kunoichi", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "teppo_gunner", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "sohei", "count": 8, "spacing": 1.6}, {"kind": "onryo", "count": 18, "spacing": 0.6, "delay": 2.0}, {"kind": "hatamoto", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "kiba_musha", "count": 8, "spacing": 1.8}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 3.0}, {"kind": "ninja", "count": 14, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 4, "spacing": 3.5}, {"kind": "samurai", "count": 14, "spacing": 0.9, "delay": 2.0}, {"kind": "kappa", "count": 12, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "The high plain of heaven: the whole night host", "groups": [{"kind": "oni", "count": 3, "spacing": 4.0}, {"kind": "kitsune", "count": 3, "spacing": 3.5, "delay": 2.0}, {"kind": "sohei", "count": 8, "spacing": 1.6, "delay": 3.0}, {"kind": "onryo", "count": 16, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "Amaterasu rises in the east: the night breaks!", "groups": [{"kind": "amaterasu", "count": 1, "spacing": 1.0}, {"kind": "sohei", "count": 6, "spacing": 2.0, "delay": 4.0}, {"kind": "samurai", "count": 10, "spacing": 1.1, "delay": 8.0}, {"kind": "kiba_musha", "count": 4, "spacing": 2.5, "delay": 14.0}]},
	],
}
