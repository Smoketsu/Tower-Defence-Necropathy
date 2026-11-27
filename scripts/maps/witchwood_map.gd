## The Witchwood (the Sanguine Court, map 2; Necropathy Stage 20, GDD §7.3): the
## fen, the hanging wood, the standing stones and the cauldron. Two entrances on
## the west edge, a north fen path and a south fen path, mirror each other round
## the stone circle and merge into one trunk that winds down to the gate, so the
## circle's plots see both paths and the trunk's posts take everything. 15
## plots, 5 posts. Rule: three hex stones beside the paths (court/court_structures:
## a Crimson Witch near a standing stone casts twice as fast and heals the
## Court). Act rule: the Blood Moon. 23 back-to-back waves: covens of Crimson
## Witches, Bloated Thralls, ghouls, bats, knights, werewolves and nobles; the
## Bog Mother (miniboss, chest) on wave 12 and Isolde Vane, the Witch of the Red
## Moon on wave 23. Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "witchwood",
	"name": "The Witchwood",
	"floor": "tiles/witchwood_fen",
	"decals": ["decals/graveyard_fog", "decals/graveyard_fog_2", "decals/graveyard_fog_3", "decals/graveyard_grass_3", "decals/corpse_2"],
	"obstacles": [
		["obstacles/fen_snag_l", Vector2(260, 80)], ["obstacles/fen_snag_m", Vector2(470, 90)],
		["obstacles/charm_fence_l", Vector2(760, 110)], ["obstacles/witch_cauldron_l", Vector2(950, 200)],
		["obstacles/standing_stone_l", Vector2(240, 360)], ["obstacles/standing_stone_m", Vector2(600, 360)],
		["obstacles/fen_snag_l", Vector2(1210, 160)], ["obstacles/charm_fence_l_v", Vector2(1230, 300)],
		["obstacles/fen_snag_m", Vector2(260, 660)], ["obstacles/charm_fence_l", Vector2(470, 650)],
		["obstacles/witch_cauldron_m", Vector2(880, 680)], ["obstacles/standing_stone_s", Vector2(1150, 500)],
	],
	"roads": {
		"north": {
			"points": [Vector2(150, -40), Vector2(150, 200), Vector2(210, 260), Vector2(600, 260), Vector2(660, 320), Vector2(660, 360)],
			"next": "trunk", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(150, 760), Vector2(150, 520), Vector2(210, 460), Vector2(600, 460), Vector2(660, 400), Vector2(660, 360)],
			"next": "trunk", "next_at": 0.0, "entrance": true,
		},
		"trunk": {
			"points": [Vector2(660, 360), Vector2(860, 360), Vector2(920, 420), Vector2(920, 560), Vector2(980, 620), Vector2(1190, 620)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(1218, 590),
	"plots": [
		Vector2(330, 360), Vector2(500, 360), Vector2(780, 460), Vector2(350, 150), Vector2(580, 160),
		Vector2(350, 570), Vector2(580, 560), Vector2(1020, 470), Vector2(780, 250), Vector2(970, 340),
		Vector2(60, 90), Vector2(60, 620), Vector2(1060, 690), Vector2(860, 625), Vector2(1150, 530),
	],
	"posts": [Vector2(400, 260), Vector2(400, 460), Vector2(760, 360), Vector2(920, 490), Vector2(1080, 620)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.8,  # TUNING (not in GDD) the act's middle map presses a little harder than Ravensmoor
	"rule": "court/court_structures",
	"act_rule": "court/blood_moon",
	"build_order": "witchwood_default",
	"weak_order": "witchwood_weak",
	"waves": [
		{"banner": "Two fen paths through the Witchwood", "groups": [{"kind": "blood_thrall", "count": 8, "spacing": 1.3}, {"kind": "blood_thrall", "count": 8, "spacing": 1.3, "delay": 4.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.8, "road": "south"}, {"kind": "vampire_bat", "count": 6, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "Crimson Witches hex the towers", "groups": [{"kind": "crimson_witch", "count": 1, "spacing": 5.0}, {"kind": "blood_thrall", "count": 12, "spacing": 0.9, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.7}, {"kind": "blood_thrall", "count": 10, "spacing": 0.8, "road": "south"}, {"kind": "vampire_bat", "count": 8, "spacing": 0.6, "delay": 6.0, "road": "south"}]},
		{"banner": "Bloated Thralls burst into healing blood", "groups": [{"kind": "bloated_thrall", "count": 1, "spacing": 6.0, "road": "south"}, {"kind": "ghoul", "count": 10, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "blood_knight", "count": 2, "spacing": 5.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 12, "spacing": 0.5}, {"kind": "werewolf", "count": 2, "spacing": 5.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 1, "spacing": 6.0}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 12, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 16, "spacing": 0.6, "road": "south"}, {"kind": "vampire_noble", "count": 2, "spacing": 6.0, "delay": 3.0}, {"kind": "vampire_bat", "count": 8, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 3, "spacing": 4.0}, {"kind": "blood_knight", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "crimson_witch", "count": 2, "spacing": 5.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "bloated_thrall", "count": 2, "spacing": 5.0, "delay": 3.0}, {"kind": "ghoul", "count": 12, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "The Bog Mother rises from the fen", "groups": [{"kind": "bog_mother", "count": 1, "spacing": 1.0}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 14, "spacing": 0.7, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 16, "spacing": 0.45}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 2, "spacing": 5.0}, {"kind": "werewolf", "count": 3, "spacing": 4.0, "road": "south"}, {"kind": "ghoul", "count": 16, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 3, "spacing": 3.5}, {"kind": "blood_knight", "count": 4, "spacing": 4.0, "road": "south"}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 18, "spacing": 0.5, "road": "south"}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0}, {"kind": "vampire_bat", "count": 12, "spacing": 0.5, "delay": 7.0}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 3, "spacing": 4.5}, {"kind": "crimson_witch", "count": 3, "spacing": 3.5, "road": "south"}, {"kind": "werewolf", "count": 3, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 4, "spacing": 3.5}, {"kind": "blood_knight", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "ghoul", "count": 20, "spacing": 0.5}, {"kind": "crimson_witch", "count": 2, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 3, "spacing": 4.5}, {"kind": "bloated_thrall", "count": 3, "spacing": 4.5, "road": "south"}, {"kind": "blood_thrall", "count": 18, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 4, "spacing": 3.0}, {"kind": "werewolf", "count": 4, "spacing": 3.5, "road": "south"}, {"kind": "vampire_bat", "count": 16, "spacing": 0.45, "delay": 6.0, "road": "south"}]},
		{"banner": "The covens gather at the cauldron", "groups": [{"kind": "blood_knight", "count": 5, "spacing": 3.0, "road": "south"}, {"kind": "vampire_noble", "count": 3, "spacing": 4.5}, {"kind": "bloated_thrall", "count": 3, "spacing": 4.5, "delay": 8.0}, {"kind": "crimson_witch", "count": 3, "spacing": 3.5, "delay": 12.0, "road": "south"}]},
		{"banner": "Isolde Vane calls the Red Moon", "groups": [{"kind": "isolde", "count": 1, "spacing": 1.0}, {"kind": "crimson_witch", "count": 3, "spacing": 4.0, "delay": 5.0, "road": "south"}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}, {"kind": "bloated_thrall", "count": 3, "spacing": 5.0, "delay": 12.0, "road": "south"}]},
	],
}
