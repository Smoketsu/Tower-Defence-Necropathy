## The Desecrated Graveyard (GDD §7.2): the teaching map. One winding road,
## one entrance, 14 grave plots and 4 road posts on Necropathy's graveyard
## floor, 22 back-to-back waves, the Inquisitor miniboss on wave 11 and Sir
## Alaric on the final wave. The road runs mostly left to right (GDD §13
## sprite facing: units have side views only and are mirrored).
## Data only, no logic. This file documents every MAP key for all maps.
extends RefCounted

## The map. Keys:
##   id, name        — registry id and UI name.
##   floor           — SpriteData-style key of the floor tile, repeated over the map.
##   decals          — floor decal keys scattered by MapView (a pure position hash).
##   obstacles       — [sprite key, position] pairs: decoration only, nothing collides.
##   roads           — road id -> {points: Array of Vector2 (map px, start to end),
##                     next: road id it joins at its end ("" = ends at the gate),
##                     next_at: px along `next` where it joins, entrance: true when
##                     enemies may spawn at its start (an entrance arch is drawn)}.
##                     Two roads that merge = one road with next set (Crimson March).
##   gate            — map px of the Ossuary gate (drawn there; the final road ends at it).
##   plots           — map px of each grave plot (ranged / support towers).
##   posts           — map px of each road post (blockers); snapped to the nearest road.
##   lives / souls   — optional overrides of TdRulesData.START_LIVES / EconomyData.START_SOULS (0 = default).
##   rule            — "" or scripts/maps/rules/<id>.gd (extends MapRule): the map's own rule.
##   build_order     — BuildOrderData id the autotest plays by default.
##   waves           — wave rows, in order. Each wave: {groups: [...], banner: "" or a
##                     line shown when it starts}. Each group: kind (TdEnemyData id),
##                     count, spacing (s between two spawns, default
##                     TdRulesData.DEFAULT_SPACING), delay (s after the wave start of
##                     the first spawn, default 0), road (default the first entrance road).
##                     The final wave must hold the map's boss (GDD §3).
const MAP: Dictionary = {
	"id": "graveyard",
	"name": "The Desecrated Graveyard",
	"floor": "tiles/graveyard",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_grass_3",
		"decals/graveyard_grave", "decals/graveyard_grave_2", "decals/graveyard_fog"],
	"obstacles": [
		["obstacles/dead_tree_l", Vector2(70, 300)], ["obstacles/gravestone_l", Vector2(140, 230)],
		["obstacles/gravestone_s", Vector2(330, 60)], ["obstacles/crypt_wall_m", Vector2(420, 80)],
		["obstacles/dead_tree_m", Vector2(800, 70)], ["obstacles/gravestone_s", Vector2(1000, 90)],
		["obstacles/dead_tree_s", Vector2(1150, 160)], ["obstacles/gravestone_l", Vector2(1150, 330)],
		["obstacles/crypt_wall_s", Vector2(520, 255)], ["obstacles/gravestone_s", Vector2(720, 255)],
		["obstacles/gravestone_l", Vector2(510, 440)], ["obstacles/dead_tree_m", Vector2(940, 425)],
		["obstacles/gravestone_s", Vector2(60, 560)], ["obstacles/crypt_wall_l", Vector2(300, 630)],
		["obstacles/dead_tree_s", Vector2(760, 650)], ["obstacles/gravestone_l", Vector2(1100, 640)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 150), Vector2(880, 150), Vector2(940, 210),
				Vector2(940, 290), Vector2(880, 350), Vector2(300, 350), Vector2(240, 410),
				Vector2(240, 470), Vector2(300, 530), Vector2(1190, 530)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(1218, 500),
	"plots": [
		Vector2(240, 80), Vector2(600, 80),
		Vector2(200, 250), Vector2(420, 250), Vector2(620, 250), Vector2(800, 250), Vector2(1030, 250),
		Vector2(140, 440), Vector2(400, 440), Vector2(620, 440), Vector2(840, 440), Vector2(1040, 440),
		Vector2(560, 612), Vector2(940, 612),
	],
	"posts": [Vector2(700, 150), Vector2(560, 350), Vector2(640, 530), Vector2(1060, 530)],
	"lives": 0,
	"souls": 0,
	"rule": "",
	"build_order": "graveyard_default",
	"waves": [
		{"banner": "The Covenant marches on the crypt", "groups": [{"kind": "recruit", "count": 8, "spacing": 1.0}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 12, "spacing": 0.8}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 8}, {"kind": "archer", "count": 6, "delay": 4.0}]},
		{"banner": "Footmen: armoured", "groups": [{"kind": "footman", "count": 6, "spacing": 1.1}, {"kind": "recruit", "count": 8, "delay": 3.0}]},
		{"banner": "Purifiers: fast", "groups": [{"kind": "purifier", "count": 8, "spacing": 0.6}, {"kind": "recruit", "count": 10, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 10, "spacing": 0.9}, {"kind": "archer", "count": 8, "delay": 2.0}]},
		{"banner": "Chaplains heal those around them", "groups": [{"kind": "footman", "count": 8}, {"kind": "chaplain", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "recruit", "count": 10, "delay": 5.0}]},
		{"banner": "Templars charge when struck", "groups": [{"kind": "templar", "count": 2, "spacing": 4.0}, {"kind": "recruit", "count": 14, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 14, "spacing": 0.5}, {"kind": "archer", "count": 10, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 14, "spacing": 0.8}, {"kind": "chaplain", "count": 3, "spacing": 3.0, "delay": 3.0}, {"kind": "templar", "count": 2, "spacing": 3.0, "delay": 6.0}]},
		{"banner": "The Inquisitor comes for the crypt", "groups": [{"kind": "inquisitor", "count": 1}, {"kind": "recruit", "count": 16, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 4, "spacing": 2.0}, {"kind": "purifier", "count": 12, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 18, "spacing": 0.7}, {"kind": "chaplain", "count": 4, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "archer", "count": 24, "spacing": 0.4}, {"kind": "purifier", "count": 10, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 1.6}, {"kind": "footman", "count": 12, "delay": 2.0}]},
		{"banner": "A swarm of recruits", "groups": [{"kind": "recruit", "count": 30, "spacing": 0.35}, {"kind": "chaplain", "count": 4, "spacing": 2.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 1.5}, {"kind": "chaplain", "count": 4, "spacing": 2.0, "delay": 2.0}, {"kind": "footman", "count": 14, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 20, "spacing": 0.4}, {"kind": "templar", "count": 4, "spacing": 2.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 22, "spacing": 0.6}, {"kind": "archer", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 10, "spacing": 1.2}, {"kind": "chaplain", "count": 6, "spacing": 1.8, "delay": 2.0}]},
		{"banner": "The Covenant's full muster", "groups": [{"kind": "footman", "count": 16, "spacing": 0.6}, {"kind": "templar", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "purifier", "count": 16, "spacing": 0.4, "delay": 5.0}, {"kind": "chaplain", "count": 5, "spacing": 2.0, "delay": 6.0}]},
		{"banner": "Sir Alaric, the Gravebreaker, has arrived!", "groups": [{"kind": "alaric", "count": 1}, {"kind": "templar", "count": 4, "spacing": 2.0, "delay": 3.0}, {"kind": "footman", "count": 10, "spacing": 0.8, "delay": 6.0}]},
	],
}
