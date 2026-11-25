## The Sanctum of Judgment (GDD §7.2): one long road that winds four times
## across the cloisters through two sanctified chambers. 15 grave plots (8 of
## them inside a chamber), 5 road posts on Necropathy's cloister floor. Rule:
## towers inside a chamber deal 25% less until its two ward crystals are
## broken (sanctified_chambers). 25 back-to-back waves: Sentinels, Radiant
## Inquisitors, High Confessors and Sun Paladins; the Cathedral Guardian
## (miniboss, chest) on wave 13 and Grand Inquisitor Seraphine on wave 25.
## The road enters top right and its runs alternate direction (GDD §13: units
## are mirrored side views). Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "sanctum",
	"name": "The Sanctum of Judgment",
	"unlock_after": "crimson_march",
	"floor": "tiles/sanctum_cloisters",
	"decals": ["decals/sanctum_cloisters_flowers", "decals/sanctum_cloisters_flowers_2", "decals/sanctum_cloisters_leaves",
		"decals/sanctum_cloisters_leaves_2", "decals/sanctum_cloisters_sundial", "decals/sanctum_courtyard_moss"],
	"obstacles": [
		["obstacles/fountain_m", Vector2(1160, 190)], ["obstacles/saint_statue_m", Vector2(120, 345)],
		["obstacles/marble_column_m", Vector2(1190, 260)], ["obstacles/marble_column_m", Vector2(1200, 430)],
		["obstacles/cypress_m", Vector2(60, 660)], ["obstacles/pew_m", Vector2(1040, 685)],
		["obstacles/stone_bench_m", Vector2(260, 680)], ["obstacles/cypress_s", Vector2(60, 250)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 105), Vector2(280, 105), Vector2(225, 160), Vector2(225, 195),
				Vector2(280, 250), Vector2(1000, 250), Vector2(1060, 310), Vector2(1060, 350),
				Vector2(1000, 410), Vector2(280, 410), Vector2(220, 470), Vector2(220, 510),
				Vector2(280, 570), Vector2(1190, 570)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(1218, 540),
	"plots": [
		Vector2(120, 178), Vector2(400, 178), Vector2(640, 178), Vector2(880, 178),
		Vector2(400, 330), Vector2(640, 330), Vector2(880, 330), Vector2(1160, 330),
		Vector2(120, 490), Vector2(400, 490), Vector2(640, 490), Vector2(880, 490), Vector2(1140, 490),
		Vector2(440, 648), Vector2(880, 648),
	],
	"posts": [Vector2(700, 105), Vector2(960, 250), Vector2(640, 410), Vector2(960, 570), Vector2(1120, 570)],
	"lives": 0,
	"souls": 250,
	"wave_hp_end": 3.0,  # TUNING (not in GDD) integration balance: the last map presses hardest
	"rule": "sanctified_chambers",
	"build_order": "sanctum_default",
	"weak_order": "sanctum_weak",
	"waves": [
		{"banner": "The Sanctum's doors open", "groups": [{"kind": "recruit", "count": 10, "spacing": 1.4}, {"kind": "footman", "count": 4, "spacing": 1.2, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 8, "spacing": 1.2}, {"kind": "archer", "count": 8, "spacing": 0.8, "delay": 5.1}]},
		{"banner": "Sanctified Sentinels: flat armour 6", "groups": [{"kind": "sanctified_sentinel", "count": 2, "spacing": 6.8}, {"kind": "recruit", "count": 12, "spacing": 0.8, "delay": 3.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 12, "spacing": 0.8}, {"kind": "footman", "count": 8, "spacing": 1.2, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 3, "spacing": 5.1}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 8.5}, {"kind": "footman", "count": 8, "spacing": 1.2, "delay": 3.4}]},
		{"banner": "Radiant Inquisitors suppress the undead near them", "groups": [{"kind": "radiant_inquisitor", "count": 2, "spacing": 6.8}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 8, "spacing": 1.2}, {"kind": "banner_bearer", "count": 1, "spacing": 1.2, "delay": 10.2}, {"kind": "purifier", "count": 10, "spacing": 0.8, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 3, "spacing": 5.1}, {"kind": "sanctified_sentinel", "count": 2, "spacing": 5.1, "delay": 6.8}, {"kind": "recruit", "count": 14, "spacing": 0.7, "delay": 3.4}]},
		{"banner": "High Confessors heal and raise the fallen", "groups": [{"kind": "footman", "count": 12, "spacing": 1.2}, {"kind": "high_confessor", "count": 2, "spacing": 6.8, "delay": 6.8}, {"kind": "sanctified_sentinel", "count": 2, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "", "groups": [{"kind": "radiant_inquisitor", "count": 3, "spacing": 5.1}, {"kind": "purifier", "count": 16, "spacing": 0.7}]},
		{"banner": "", "groups": [{"kind": "halberdier", "count": 3, "spacing": 5.1}, {"kind": "shieldbearer", "count": 10, "spacing": 1.2, "delay": 3.4}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2}, {"kind": "high_confessor", "count": 2, "spacing": 5.1, "delay": 10.2}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 5.1}]},
		{"banner": "The Cathedral Guardian wakes", "groups": [{"kind": "cathedral_guardian", "count": 1, "spacing": 1.2}, {"kind": "footman", "count": 15, "spacing": 1.2, "delay": 5.1}, {"kind": "radiant_inquisitor", "count": 2, "spacing": 5.1, "delay": 10.2}]},
		{"banner": "Sun Paladins ward their brothers", "groups": [{"kind": "sun_paladin", "count": 2, "spacing": 6.8}, {"kind": "footman", "count": 17, "spacing": 1.0, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "battle_sister", "count": 5, "spacing": 3.4}, {"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2, "delay": 6.8}, {"kind": "high_confessor", "count": 2, "spacing": 5.1, "delay": 11.9}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 24, "spacing": 0.6}, {"kind": "radiant_inquisitor", "count": 4, "spacing": 5.1, "delay": 6.8}]},
		{"banner": "", "groups": [{"kind": "sun_paladin", "count": 2, "spacing": 5.1}, {"kind": "shieldbearer", "count": 15, "spacing": 1.2, "delay": 3.4}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 11.9}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 6, "spacing": 3.4}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 8.5}, {"kind": "halberdier", "count": 4, "spacing": 4.2, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 8, "spacing": 2.5}, {"kind": "sun_paladin", "count": 2, "spacing": 5.1, "delay": 6.8}, {"kind": "footman", "count": 15, "spacing": 1.2, "delay": 3.4}]},
		{"banner": "", "groups": [{"kind": "radiant_inquisitor", "count": 5, "spacing": 4.2}, {"kind": "battle_sister", "count": 8, "spacing": 2.5, "delay": 5.1}, {"kind": "recruit", "count": 24, "spacing": 0.6, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 8, "spacing": 3.4}, {"kind": "sun_paladin", "count": 4, "spacing": 5.1, "delay": 5.1}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "halberdier", "count": 6, "spacing": 3.4}, {"kind": "shieldbearer", "count": 17, "spacing": 1.2, "delay": 3.4}, {"kind": "banner_bearer", "count": 4, "spacing": 4.2, "delay": 10.2}, {"kind": "radiant_inquisitor", "count": 2, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 29, "spacing": 0.5}, {"kind": "templar", "count": 8, "spacing": 2.5, "delay": 6.8}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 10.2}]},
		{"banner": "The Covenant's final judgment", "groups": [{"kind": "sanctified_sentinel", "count": 8, "spacing": 3.4}, {"kind": "sun_paladin", "count": 5, "spacing": 4.2, "delay": 5.1}, {"kind": "high_confessor", "count": 5, "spacing": 4.2, "delay": 8.5}, {"kind": "battle_sister", "count": 8, "spacing": 2.5, "delay": 10.2}, {"kind": "radiant_inquisitor", "count": 4, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "Grand Inquisitor Seraphine descends!", "groups": [{"kind": "seraphine", "count": 1, "spacing": 1.2}, {"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2, "delay": 6.8}, {"kind": "sun_paladin", "count": 2, "spacing": 5.1, "delay": 13.6}, {"kind": "footman", "count": 12, "spacing": 1.2, "delay": 3.4}]},
	],
}
