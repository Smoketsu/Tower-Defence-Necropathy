## The Proving Grounds: the hidden test act's only map (ActData "test",
## --test-act; never in CI or shown to players). A small map that exercises
## every act-framework hook: a road with two posts, an off-road exit trail
## crossing the map (herds trample the plot beside it), flyers, ranged gunners,
## claimers whose felled blockers rise as thralls, and an act rule
## (rules/test/proving.gd: wave tiers, heal on kill, night visibility,
## telegraphed shelling). Keys as graveyard_map.gd. Data only, no logic.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "test_grounds",
	"name": "The Proving Grounds",
	"floor": "tiles/graveyard",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2"],
	"obstacles": [["obstacles/dead_tree_m", Vector2(120, 600)], ["obstacles/gravestone_l", Vector2(700, 640)]],
	"roads": {
		"main": {
			"points": [Vector2(-40, 200), Vector2(1000, 200), Vector2(1000, 520), Vector2(1190, 520)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"trail": {
			"points": [Vector2(600, -40), Vector2(600, 380), Vector2(460, 560), Vector2(460, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"gate": Vector2(1218, 490),
	"plots": [Vector2(560, 120), Vector2(800, 290), Vector2(900, 120), Vector2(420, 300), Vector2(1090, 420), Vector2(200, 300)],
	"posts": [Vector2(650, 200), Vector2(1000, 400)],
	"lives": 0,
	"souls": 0,
	"wave_hp_end": 1.2,  # TUNING (not in GDD) a short test map
	"rule": "",
	"build_order": "test_default",
	"weak_order": "test_weak",
	"waves": [
		{"banner": "Test: plain walkers", "groups": [{"kind": "recruit", "count": 6, "spacing": 1.2}]},
		{"banner": "Test: flyers over the road", "groups": [{"kind": "test_bat", "count": 6, "spacing": 0.9}, {"kind": "recruit", "count": 4, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "Test: gunners and a herd", "groups": [{"kind": "test_gunner", "count": 3, "spacing": 2.5}, {"kind": "test_herd", "count": 4, "spacing": 1.0, "road": "trail"}]},
		{"banner": "Test: claimers", "groups": [{"kind": "test_claimer", "count": 3, "spacing": 1.5}, {"kind": "footman", "count": 4, "spacing": 1.0, "delay": 1.0}]},
		{"banner": "Test: the boss", "groups": [{"kind": "alaric", "count": 1, "spacing": 1.0, "hp_mult": 0.1}, {"kind": "test_bat", "count": 4, "spacing": 1.0, "delay": 2.0}]},
	],
}
