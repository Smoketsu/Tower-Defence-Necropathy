## Mount Olympus, the Pantheon Trial (Act VIII map 2; Necropathy stage
## "olympus"): three terraces of the god's mountain. The main road climbs the
## mountain in switchbacks that narrow toward the summit: east along the wide
## foot, back west, east again and a last short run to the gate at the top, so
## the plots between the terraces see one run coming and the next going (shield
## fronts on one side, backs on the other); the grove road comes in from the
## eastern slope onto the second switchback. 15 plots, 6 posts, 23 waves. Wrath
## of the Gods: Zeus's lightning from wave 3. Ares (miniboss, chest) on wave 12;
## Zeus on wave 23. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "olympus",
	"name": "Mount Olympus",
	"floor": "tiles/olympus_terrace",
	"decals": [],
	"obstacles": [
		["obstacles/marble_column_l", Vector2(737, 265)], ["obstacles/war_trophy_l", Vector2(885, 110)],
		["obstacles/chariot_wreck_l", Vector2(202, 543)], ["obstacles/cypress_l", Vector2(255, 390)],
		["obstacles/cypress_m", Vector2(1155, 670)], ["obstacles/moon_shrine_l", Vector2(1120, 180)],
		["obstacles/fountain_l", Vector2(40, 320)], ["obstacles/balustrade_l", Vector2(75, 670)],
		["obstacles/marble_column_s", Vector2(440, 679)], ["obstacles/war_trophy_s", Vector2(255, 110)],
		["obstacles/cypress_s", Vector2(130, 460)], ["obstacles/moon_shrine_s", Vector2(435, 250)],
		["obstacles/broken_column_l", Vector2(1245, 390)], ["obstacles/fountain_s", Vector2(1065, 390)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 610), Vector2(1000, 610), Vector2(900, 470), Vector2(300, 470), Vector2(400, 330),
				Vector2(860, 330), Vector2(770, 200), Vector2(650, 200)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"grove": {
			"points": [Vector2(1320, 470), Vector2(902, 470)],
			"next": "main", "next_at": 1210.9,  # joins main at (901, 471)
			"entrance": true,
		},
	},
	"gate": Vector2(630, 170),
	"plots": [
		Vector2(820, 390), Vector2(840, 550), Vector2(1060, 530), Vector2(360, 530), Vector2(1140, 540), Vector2(440, 530),
		Vector2(720, 390), Vector2(460, 410), Vector2(540, 390), Vector2(560, 550), Vector2(690, 270), Vector2(830, 170),
		Vector2(150, 550), Vector2(740, 550), Vector2(150, 670),
	],
	"posts": [Vector2(361, 610), Vector2(864, 470), Vector2(583, 470), Vector2(326, 433), Vector2(758, 330), Vector2(1151, 470)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.2,  # TUNING (not in GDD) B4: 3.9 before the balance pass; L4: 3.4 before the road redraw; S3: 3.6 before the spot fix; the act's shields and wrath make its kinds tougher than their row HP: tuned to the loss pattern (BALANCE.md)
	"rule": "",
	"act_rule": "pantheon/pantheon_rules",
	"build_order": "olympus_default",
	"weak_order": "olympus_weak",
	"waves": [
		{"banner": "The Pantheon Trial begins on the slopes of Olympus", "groups": [{"kind": "moon_hound", "count": 8, "spacing": 0.7}, {"kind": "shade_of_dead", "count": 4, "spacing": 0.8, "delay": 2.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 5, "spacing": 1.3}, {"kind": "moon_hound", "count": 6, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "Centaur archers fire as they gallop", "groups": [{"kind": "centaur_archer", "count": 3, "spacing": 1.4}, {"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "delay": 2.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 1, "spacing": 4.0}, {"kind": "hoplite", "count": 6, "spacing": 1.3, "delay": 3.0}, {"kind": "moon_hound", "count": 8, "spacing": 0.7, "delay": 5.0, "road": "grove"}]},
		{"banner": "Amazons leap over the first post in their way", "groups": [{"kind": "amazon", "count": 1, "spacing": 3.5}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 3.0}, {"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "delay": 5.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "centaur_archer", "count": 4, "spacing": 1.4}, {"kind": "moon_hound", "count": 10, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "A Gorgon: her gaze turns a tower to stone", "groups": [{"kind": "gorgon", "count": 1, "spacing": 4.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 3.0, "road": "grove"}, {"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "moon_hound", "count": 12, "spacing": 0.7, "delay": 3.0}, {"kind": "centaur_archer", "count": 3, "spacing": 1.4, "delay": 5.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "amazon", "count": 2, "spacing": 3.5}, {"kind": "legionary", "count": 8, "spacing": 1.3, "delay": 3.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "gorgon", "count": 1, "spacing": 4.0}, {"kind": "hoplite", "count": 10, "spacing": 1.3, "delay": 3.0}, {"kind": "shade_of_dead", "count": 10, "spacing": 0.8, "delay": 5.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 14, "spacing": 1.3}, {"kind": "centaur_archer", "count": 4, "spacing": 1.4, "delay": 2.0, "road": "grove"}]},
		{"banner": "ARES, GOD OF WAR, takes the field!", "groups": [{"kind": "ares", "count": 1, "spacing": 1.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 2.0}, {"kind": "moon_hound", "count": 10, "spacing": 0.7, "delay": 4.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "amazon", "count": 2, "spacing": 3.5}, {"kind": "gorgon", "count": 1, "spacing": 4.0, "delay": 3.0}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 6.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "centaur_archer", "count": 6, "spacing": 1.4, "road": "grove"}, {"kind": "hoplite", "count": 10, "spacing": 1.3, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "legionary", "count": 12, "spacing": 1.3, "delay": 3.0}, {"kind": "moon_hound", "count": 10, "spacing": 0.7, "delay": 5.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "cyclops", "count": 2, "spacing": 5.0}, {"kind": "amazon", "count": 2, "spacing": 3.5, "delay": 3.0, "road": "grove"}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "gorgon", "count": 2, "spacing": 4.0}, {"kind": "hoplite", "count": 14, "spacing": 1.3, "delay": 3.0}, {"kind": "centaur_archer", "count": 5, "spacing": 1.4, "delay": 5.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "moon_hound", "count": 16, "spacing": 0.7, "delay": 3.0, "road": "grove"}, {"kind": "amazon", "count": 2, "spacing": 3.5, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "legionary", "count": 14, "spacing": 1.3}, {"kind": "gorgon", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "grove"}, {"kind": "centaur_archer", "count": 5, "spacing": 1.4, "delay": 5.0}]},
		{"banner": "A Bronze Titan steps out of the mountain", "groups": [{"kind": "bronze_titan", "count": 1, "spacing": 6.0}, {"kind": "hoplite", "count": 14, "spacing": 1.3, "delay": 3.0, "road": "grove"}, {"kind": "shade_of_dead", "count": 14, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "amazon", "count": 3, "spacing": 3.5}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "centaur_archer", "count": 6, "spacing": 1.4, "delay": 6.0, "road": "grove"}]},
		{"banner": "", "groups": [{"kind": "gorgon", "count": 2, "spacing": 4.0}, {"kind": "legionary", "count": 14, "spacing": 1.3, "delay": 3.0}, {"kind": "moon_hound", "count": 16, "spacing": 0.7, "delay": 5.0, "road": "grove"}]},
		{"banner": "ZEUS, KING OF THE GODS, descends to judge you!", "groups": [{"kind": "zeus", "count": 1, "spacing": 1.0}, {"kind": "hoplite", "count": 10, "spacing": 1.3, "delay": 2.0}, {"kind": "centaur_archer", "count": 5, "spacing": 1.4, "delay": 4.0, "road": "grove"}, {"kind": "amazon", "count": 2, "spacing": 3.5, "delay": 6.0}]},
	],
}
