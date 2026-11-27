## The Asphodel Underworld (Act VIII map 3, the finale; Necropathy stage
## "underworld"): the grey fields of asphodel by the Styx. The main road
## meanders up, across, down and up again (two U-turns: the plots inside each
## see the column's backs on the way out); the ferry road comes off the Styx
## from the east and joins the bottom run. 16 plots, 6 posts, 24 waves. Wrath
## of the Gods: Hades' fissures from wave 3. Cerberus (miniboss, chest) on
## wave 13; Hades on wave 24: he cloaks, claims fallen blockers as his shades
## and raises a ring of wardens. Beating him unlocks the Myrmidon Shades.
## Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "underworld",
	"name": "The Asphodel Underworld",
	"floor": "tiles/underworld_asphodel",
	"decals": [],
	"obstacles": [
		["obstacles/styx_rock_l", Vector2(850, 320)],
		["obstacles/styx_rock_m", Vector2(75, 250)],
		["obstacles/styx_rock_s", Vector2(670, 600)],
		["obstacles/judges_column_l", Vector2(975, 110)],
		["obstacles/judgement_bench_l", Vector2(345, 390)],
		["obstacles/judges_column_s", Vector2(310, 600)],
		["obstacles/cypress_l", Vector2(1245, 390)],
		["obstacles/styx_rock_m", Vector2(975, 390)],
		["obstacles/judges_column_m", Vector2(75, 530)],
		["obstacles/cypress_s", Vector2(975, 250)],
		["obstacles/styx_rock_s", Vector2(1245, 250)],
		["obstacles/judgement_bench_s", Vector2(1245, 110)],
		["obstacles/cypress_m", Vector2(490, 600)],
		["obstacles/styx_rock_l", Vector2(435, 250)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(200, 620), Vector2(240, 580), Vector2(240, 200), Vector2(280, 160), Vector2(620, 160), Vector2(660, 200), Vector2(660, 500), Vector2(700, 540), Vector2(1000, 540), Vector2(1040, 500), Vector2(1040, 200), Vector2(1080, 160), Vector2(1190, 160)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ferry": {
			"points": [Vector2(1320, 640), Vector2(900, 640), Vector2(860, 600), Vector2(860, 540)],
			"next": "main", "next_at": 1646.3, "entrance": true,
		},
	},
	"gate": Vector2(1222, 160),
	"plots": [Vector2(340, 300), Vector2(560, 300), Vector2(340, 450), Vector2(560, 450), Vector2(760, 330), Vector2(940, 330), Vector2(760, 250), Vector2(850, 440), Vector2(140, 420), Vector2(140, 300), Vector2(1140, 320), Vector2(1135, 470), Vector2(450, 90), Vector2(1210, 560), Vector2(340, 530), Vector2(610, 570)],
	"posts": [Vector2(240, 400), Vector2(450, 160), Vector2(660, 350), Vector2(1040, 350), Vector2(1125, 160), Vector2(1100, 640)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.2,  # TUNING (not in GDD) the act's shields and wrath make its kinds tougher than their row HP: tuned to the loss pattern (BALANCE.md)
	"rule": "",
	"act_rule": "pantheon/pantheon_rules",
	"build_order": "underworld_default",
	"weak_order": "underworld_weak",
	"waves": [
		{"banner": "The shades of Asphodel drift toward the gate", "groups": [{"kind": "shade_of_dead", "count": 6, "spacing": 0.8}, {"kind": "shade_hoplite", "count": 4, "spacing": 1.2, "delay": 2.0, "road": "ferry"}]},
		{"banner": "Shade hoplites: the dead still hold the phalanx", "groups": [{"kind": "shade_hoplite", "count": 6, "spacing": 1.2}, {"kind": "wolf_of_rome", "count": 6, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 1, "spacing": 4.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 3.0}, {"kind": "shade_of_dead", "count": 4, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "Shade archers loose ghost arrows", "groups": [{"kind": "shade_hoplite", "count": 8, "spacing": 1.2}, {"kind": "shade_archer", "count": 3, "spacing": 1.2, "delay": 2.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "wolf_of_rome", "count": 10, "spacing": 0.7}, {"kind": "shade_hoplite", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 1, "spacing": 4.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 3.0}, {"kind": "shade_archer", "count": 4, "spacing": 1.2, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "road": "ferry"}, {"kind": "shade_archer", "count": 5, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "wolf_of_rome", "count": 14, "spacing": 0.7}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 2.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 10, "spacing": 1.2}, {"kind": "hoplite", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "ferry"}, {"kind": "pan_hero", "count": 1, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "A Bronze Titan climbs out of Tartarus", "groups": [{"kind": "bronze_titan", "count": 1, "spacing": 6.0}, {"kind": "hoplite", "count": 10, "spacing": 1.3, "delay": 3.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 12, "spacing": 1.2}, {"kind": "shade_archer", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "gorgon", "count": 1, "spacing": 4.0, "delay": 3.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 14, "spacing": 0.7, "delay": 6.0}]},
		{"banner": "CERBERUS, the hound of the gates, breaks his chain!", "groups": [{"kind": "cerberus", "count": 1, "spacing": 1.0}, {"kind": "shade_hoplite", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 4.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 12, "spacing": 1.3}, {"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "centaur_archer", "count": 4, "spacing": 1.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 3.0}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0, "road": "ferry"}, {"kind": "shade_hoplite", "count": 12, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 14, "spacing": 1.2}, {"kind": "gorgon", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "ferry"}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "hoplite", "count": 14, "spacing": 1.3, "delay": 3.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 12, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "shade_of_dead", "count": 16, "spacing": 0.8, "road": "ferry"}, {"kind": "shade_hoplite", "count": 12, "spacing": 1.2, "delay": 2.0}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 3.0, "road": "ferry"}, {"kind": "centaur_archer", "count": 6, "spacing": 1.4, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 16, "spacing": 1.2}, {"kind": "gorgon", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "shade_of_dead", "count": 14, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "hoplite", "count": 16, "spacing": 1.3, "delay": 3.0, "road": "ferry"}, {"kind": "shade_archer", "count": 10, "spacing": 1.2, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0}, {"kind": "shade_hoplite", "count": 16, "spacing": 1.2, "delay": 3.0}, {"kind": "shade_of_dead", "count": 16, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "HADES, LORD OF THE DEAD, claims what is his!", "groups": [{"kind": "hades", "count": 1, "spacing": 1.0}, {"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "delay": 2.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 7.0, "road": "ferry"}]},
	],
}
