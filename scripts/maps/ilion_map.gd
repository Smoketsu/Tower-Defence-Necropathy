## The Shores of Ilion (Act VIII map 1; Necropathy stage "ilion"): the Achaean
## beachhead before Troy. The main road runs east along the surf, swings round a
## hairpin at the end of the beach and climbs west across the siege camp, then
## turns up to the Scaean Gate in the wall at the top; a second landing
## ("shore") comes in from the eastern beach and joins it at the hairpin, so
## both landing lanes converge on the gate. Each turn lets the plots between two
## runs shoot the shield fronts in the back as the column comes round (the
## Phalanx, GDD §7.3). 15 plots, 6 posts, 22 waves. Wrath of the Gods:
## Poseidon's waves from wave 4. Polyphemus (miniboss, chest) on wave 13;
## Achilles on wave 22 (his heel: strike him from behind). Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "ilion",
	"name": "The Shores of Ilion",
	"floor": "tiles/ilion_beach",
	"decals": [],
	"obstacles": [
		["obstacles/beached_warship_l", Vector2(517, 244)], ["obstacles/sea_rock_l", Vector2(332, 270)],
		["obstacles/sea_rock_s", Vector2(1245, 530)], ["obstacles/beached_warship_s", Vector2(220, 460)],
		["obstacles/siege_tent_l", Vector2(40, 460)], ["obstacles/siege_tent_s", Vector2(270, 696)],
		["obstacles/palisade_l", Vector2(1080, 696)], ["obstacles/troy_wall_l", Vector2(760, 320)],
		["obstacles/troy_wall_s", Vector2(1245, 670)], ["obstacles/fallen_column_l", Vector2(705, 530)],
		["obstacles/fallen_column_s", Vector2(75, 250)], ["obstacles/sea_rock_s", Vector2(580, 320)],
		["obstacles/siege_tent_s", Vector2(940, 180)], ["obstacles/palisade_s", Vector2(400, 320)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 630), Vector2(1080, 630), Vector2(1105, 626), Vector2(1127, 615), Vector2(1145, 597),
				Vector2(1156, 575), Vector2(1160, 550), Vector2(1156, 525), Vector2(1145, 503), Vector2(1127, 485),
				Vector2(1105, 474), Vector2(1080, 470), Vector2(380, 355), Vector2(356, 350), Vector2(321, 342),
				Vector2(285, 333), Vector2(260, 320), Vector2(245, 295), Vector2(242, 265), Vector2(250, 240),
				Vector2(276, 222), Vector2(313, 209), Vector2(340, 200), Vector2(622, 165)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"shore": {
			"points": [Vector2(1320, 420), Vector2(1090, 470)],
			"next": "main", "next_at": 1360.4,  # joins main at (1090, 472)
			"entrance": true,
		},
	},
	"gate": Vector2(632, 140),
	"plots": [
		Vector2(550, 540), Vector2(420, 570), Vector2(500, 280), Vector2(630, 540), Vector2(160, 570), Vector2(400, 260),
		Vector2(1000, 520), Vector2(1220, 560), Vector2(580, 260), Vector2(830, 530), Vector2(1080, 540), Vector2(910, 530),
		Vector2(750, 520), Vector2(260, 570), Vector2(190, 320),
	],
	"posts": [Vector2(339, 630), Vector2(736, 630), Vector2(1035, 630), Vector2(1036, 463), Vector2(457, 368), Vector2(1191, 448)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.08,  # TUNING (not in GDD) L7: 2.75 before the break fixes; L4: 2.5 before the road redraw; the act's shields and wrath make its kinds tougher than their row HP: tuned to the loss pattern (BALANCE.md)
	"rule": "",
	"act_rule": "pantheon/pantheon_rules",
	"build_order": "ilion_default",
	"weak_order": "ilion_weak",
	"waves": [
		{"banner": "The Achaeans land on the beach of Troy", "groups": [{"kind": "wolf_of_rome", "count": 8, "spacing": 0.7}, {"kind": "shade_of_dead", "count": 4, "spacing": 0.8, "delay": 2.0, "road": "shore"}]},
		{"banner": "Hoplites: their shields face the gate, strike them from the side or behind", "groups": [{"kind": "hoplite", "count": 4, "spacing": 1.3}, {"kind": "wolf_of_rome", "count": 6, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "road": "shore"}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "Heroes: every blocker they fell makes them stronger", "groups": [{"kind": "hoplite", "count": 6, "spacing": 1.3}, {"kind": "pan_hero", "count": 1, "spacing": 4.0, "delay": 2.0}]},
		{"banner": "Legionaries lock the testudo: shields even above their heads", "groups": [{"kind": "legionary", "count": 5, "spacing": 1.3}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 2.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 8, "spacing": 1.3}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 2.0, "road": "shore"}]},
		{"banner": "A Cyclops hurls boulders at your towers", "groups": [{"kind": "cyclops", "count": 1, "spacing": 5.0}, {"kind": "legionary", "count": 6, "spacing": 1.3, "delay": 3.0}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "wolf_of_rome", "count": 12, "spacing": 0.7, "delay": 3.0}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 5.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "legionary", "count": 10, "spacing": 1.3}, {"kind": "hoplite", "count": 4, "spacing": 1.3, "delay": 2.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 10, "spacing": 1.3}, {"kind": "cyclops", "count": 1, "spacing": 5.0, "delay": 2.0}, {"kind": "pan_hero", "count": 1, "spacing": 4.0, "delay": 5.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "wolf_of_rome", "count": 16, "spacing": 0.7}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "legionary", "count": 10, "spacing": 1.3}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 2.0, "road": "shore"}, {"kind": "pan_hero", "count": 1, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "Polyphemus the Cyclops wades out of the sea!", "groups": [{"kind": "polyphemus", "count": 1, "spacing": 1.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 2.0}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 4.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "cyclops", "count": 2, "spacing": 5.0}, {"kind": "legionary", "count": 10, "spacing": 1.3, "delay": 3.0}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 5.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "wolf_of_rome", "count": 14, "spacing": 0.7, "delay": 3.0}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 5.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 14, "spacing": 1.3}, {"kind": "legionary", "count": 8, "spacing": 1.3, "delay": 2.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "cyclops", "count": 2, "spacing": 5.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "wolf_of_rome", "count": 10, "spacing": 0.7, "delay": 6.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "legionary", "count": 14, "spacing": 1.3}, {"kind": "shade_of_dead", "count": 14, "spacing": 0.8, "delay": 2.0, "road": "shore"}]},
		{"banner": "A Bronze Titan rises from the sand", "groups": [{"kind": "bronze_titan", "count": 1, "spacing": 6.0}, {"kind": "hoplite", "count": 12, "spacing": 1.3, "delay": 3.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "legionary", "count": 12, "spacing": 1.3}, {"kind": "cyclops", "count": 2, "spacing": 5.0, "delay": 2.0}, {"kind": "wolf_of_rome", "count": 14, "spacing": 0.7, "delay": 5.0, "road": "shore"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "hoplite", "count": 14, "spacing": 1.3, "delay": 3.0}, {"kind": "shade_of_dead", "count": 14, "spacing": 0.8, "delay": 5.0, "road": "shore"}]},
		{"banner": "Achilles, the Unkillable: only his heel can be hurt!", "groups": [{"kind": "achilles", "count": 1, "spacing": 1.0}, {"kind": "legionary", "count": 8, "spacing": 1.3, "delay": 2.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 4.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 6.0, "road": "shore"}]},
	],
}
