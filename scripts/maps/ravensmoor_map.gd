## Ravensmoor (the Sanguine Court, map 1; Necropathy Stage 19, GDD §7.3): the
## moor, the village and the old church under a cold moon. Two entrances: the
## moor road from the west winds right, down and back left past the church, and
## the village lane comes down from the north and joins it in the middle, so the
## middle plots see both columns. 16 plots, 5 posts. Rule: four sleeping coffins
## beside the road (court/court_structures: a Vampire Noble climbs out of each
## unbroken coffin at the Blood Moon's rise). Act rule: the Blood Moon. 22
## back-to-back waves: thralls, ghoul packs, bats, Blood Knights, werewolves and
## Vampire Nobles; Old Greymane (miniboss, chest) on wave 11 and Vargr, the
## Moon-Eater on wave 22. Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "ravensmoor",
	"name": "Ravensmoor",
	"floor": "tiles/ravensmoor_moor",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_fog", "decals/graveyard_fog_2", "decals/graveyard_grave", "decals/corpse"],
	"obstacles": [
		["obstacles/moor_pine_l", Vector2(60, 230)], ["obstacles/moor_cairn_m", Vector2(160, 70)],
		["obstacles/thatch_cottage_l", Vector2(600, 64)], ["obstacles/village_fence_l", Vector2(390, 66)],
		["obstacles/moor_pine_s", Vector2(1210, 120)], ["obstacles/moor_cairn_l", Vector2(1200, 260)],
		["obstacles/church_ruin_l", Vector2(110, 640)], ["obstacles/grave_cross_l", Vector2(250, 650)],
		["obstacles/grave_cross_s", Vector2(700, 660)], ["obstacles/moor_cairn_s", Vector2(1150, 680)],
		["obstacles/moor_pine_l", Vector2(60, 400)], ["obstacles/grave_cross_s", Vector2(700, 470)],
	],
	"roads": {
		"west": {
			"points": [Vector2(-40, 140), Vector2(900, 140), Vector2(960, 200), Vector2(960, 320), Vector2(900, 380),
				Vector2(300, 380), Vector2(240, 440), Vector2(240, 520), Vector2(300, 580), Vector2(1190, 580)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		# The village lane: joins the moor road at (480, 380), 1649.7 px along it.
		"north": {
			"points": [Vector2(480, -40), Vector2(480, 380)],
			"next": "west", "next_at": 1649.7, "entrance": true,
		},
	},
	"gate": Vector2(1218, 550),
	"plots": [
		Vector2(200, 260), Vector2(370, 260), Vector2(600, 260), Vector2(790, 260), Vector2(1090, 270),
		Vector2(300, 66), Vector2(800, 66), Vector2(1060, 66),
		Vector2(110, 480), Vector2(380, 480), Vector2(600, 480), Vector2(820, 480), Vector2(1040, 480),
		Vector2(440, 660), Vector2(900, 660), Vector2(1100, 400),
	],
	"posts": [Vector2(700, 140), Vector2(480, 240), Vector2(700, 380), Vector2(560, 580), Vector2(1000, 580)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.2,  # TUNING (not in GDD) a step above the Sanctum's late waves (two columns share them)
	"rule": "court/court_structures",
	"act_rule": "court/blood_moon",
	"build_order": "ravensmoor_default",
	"weak_order": "ravensmoor_weak",
	"waves": [
		{"banner": "The moor road and the village lane", "groups": [{"kind": "blood_thrall", "count": 10, "spacing": 1.3}, {"kind": "ghoul", "count": 4, "spacing": 1.0, "delay": 8.0, "road": "north"}]},
		{"banner": "Ghouls stop to eat the fallen and heal", "groups": [{"kind": "ghoul", "count": 10, "spacing": 0.8}, {"kind": "blood_thrall", "count": 6, "spacing": 1.1, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 1, "spacing": 6.0}, {"kind": "blood_thrall", "count": 10, "spacing": 1.0, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_thrall", "count": 12, "spacing": 0.9}, {"kind": "ghoul", "count": 8, "spacing": 0.8, "delay": 3.0, "road": "north"}, {"kind": "vampire_bat", "count": 6, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "Werewolves shoot until the moon turns them", "groups": [{"kind": "werewolf", "count": 1, "spacing": 6.0}, {"kind": "ghoul", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 8, "spacing": 0.6}, {"kind": "blood_knight", "count": 2, "spacing": 5.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_thrall", "count": 14, "spacing": 0.8}, {"kind": "werewolf", "count": 2, "spacing": 5.0, "delay": 5.0, "road": "north"}]},
		{"banner": "Vampire Nobles drain the blockers", "groups": [{"kind": "vampire_noble", "count": 2, "spacing": 7.0}, {"kind": "ghoul", "count": 12, "spacing": 0.7, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 3, "spacing": 5.0}, {"kind": "blood_thrall", "count": 16, "spacing": 0.7, "delay": 2.0, "road": "north"}, {"kind": "vampire_bat", "count": 8, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 4, "spacing": 4.0}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0, "road": "north"}]},
		{"banner": "Old Greymane howls the pack into beasts", "groups": [{"kind": "old_greymane", "count": 1, "spacing": 1.0}, {"kind": "werewolf", "count": 3, "spacing": 5.0, "delay": 5.0, "road": "north"}, {"kind": "ghoul", "count": 10, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 14, "spacing": 0.5}, {"kind": "vampire_noble", "count": 2, "spacing": 6.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 5, "spacing": 4.0}, {"kind": "werewolf", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "blood_thrall", "count": 14, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 18, "spacing": 0.5}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "road": "north"}, {"kind": "vampire_bat", "count": 10, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 5, "spacing": 4.0}, {"kind": "blood_thrall", "count": 18, "spacing": 0.6, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 6, "spacing": 3.5, "road": "north"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 3.0}, {"kind": "vampire_noble", "count": 2, "spacing": 5.0, "delay": 10.0}]},
		{"banner": "", "groups": [{"kind": "ghoul", "count": 20, "spacing": 0.5}, {"kind": "werewolf", "count": 5, "spacing": 4.0, "delay": 4.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 4, "spacing": 5.0}, {"kind": "blood_knight", "count": 5, "spacing": 4.0, "delay": 3.0, "road": "north"}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "ghoul", "count": 18, "spacing": 0.5, "road": "north"}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 8, "spacing": 3.0}, {"kind": "vampire_noble", "count": 4, "spacing": 5.0, "road": "north"}, {"kind": "blood_thrall", "count": 20, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "The whole Court rides out", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "blood_knight", "count": 6, "spacing": 3.5, "road": "north"}, {"kind": "vampire_bat", "count": 16, "spacing": 0.5, "delay": 6.0}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "delay": 12.0}]},
		{"banner": "Vargr, the Moon-Eater, comes for the moon", "groups": [{"kind": "vargr", "count": 1, "spacing": 1.0}, {"kind": "werewolf", "count": 4, "spacing": 5.0, "delay": 6.0, "road": "north"}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}, {"kind": "blood_knight", "count": 4, "spacing": 4.0, "delay": 14.0, "road": "north"}]},
	],
}
