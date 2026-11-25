## The Desecrated Graveyard (GDD §7.2): the teaching map. One winding road,
## one entrance, 14 grave plots and 4 road posts on Necropathy's graveyard
## floor, 22 back-to-back waves, the Inquisitor miniboss on wave 11 and Sir
## Alaric on the final wave. The road runs mostly left to right (GDD §13
## sprite facing: units have side views only and are mirrored).
## Data only, no logic. This file documents every MAP key for all maps.
extends RefCounted

## The map. Keys:
##   id, name        — registry id and UI name.
##   unlock_after    — map id whose boss must be beaten to open this map ("" = open
##                     from the start; GDD §3 "Beating a map's boss opens the next map").
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
##   wave_hp_end     — optional override of TdRulesData.WAVE_HP_END (the last waves' HP multiplier; 0 = default).
##   rule            — "" or scripts/maps/rules/<id>.gd (extends MapRule): the map's own rule.
##   build_order     — build order id (BuildOrderData / the act's ORDERS) the autotest plays by default.
##   weak_order      — build order id of a deliberately weak build (must load and end cleanly;
##                     CI and tools/run_all_maps.sh run both). MapLoader.validate() checks both.
##   act_rule        — optional act rule id (scripts/maps/rules/<id>.gd, extends MapRule), run
##                     beside "rule"; absent = the act's ActData "rule" ("" = none).
##   music / mood    — optional: run loop (SoundData.SCORES id, "" = Act I loop) and mood row id;
##                     absent = the act's ActData defaults (floor too).
##   roads keys      — also: off_road (true: a trail across the map, not a road; nothing holds
##                     on it, no post or spell uses it) and exit (true: reaching its end leaves
##                     the map with no lives lost, a crossing herd).
##   waves           — wave rows, in order. Each wave: {groups: [...], banner: "" or a
##                     line shown when it starts}. Each group: kind (TdEnemyData id),
##                     count, spacing (s between two spawns, default
##                     TdRulesData.DEFAULT_SPACING), delay (s after the wave start of
##                     the first spawn, default 0), road (default the first entrance road).
##                     The final wave must hold the map's boss (GDD §3).
const MAP: Dictionary = {
	"id": "graveyard",
	"name": "The Desecrated Graveyard",
	"unlock_after": "",
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
	"wave_hp_end": 2.6,  # TUNING (not in GDD) integration balance: the first map is the gentlest
	"rule": "",
	"build_order": "graveyard_default",
	"weak_order": "weak",
	"waves": [
		{"banner": "The Covenant marches on the crypt", "groups": [{"kind": "recruit", "count": 8, "spacing": 1.35}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 12, "spacing": 1.08}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 8, "spacing": 0.95}, {"kind": "archer", "count": 6, "spacing": 0.95, "delay": 5.4}]},
		{"banner": "Footmen: armoured", "groups": [{"kind": "footman", "count": 6, "spacing": 1.49}, {"kind": "recruit", "count": 8, "spacing": 0.95, "delay": 4.1}]},
		{"banner": "Purifiers: fast", "groups": [{"kind": "purifier", "count": 8, "spacing": 0.81}, {"kind": "recruit", "count": 10, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 10, "spacing": 1.22}, {"kind": "archer", "count": 8, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "Chaplains heal those around them", "groups": [{"kind": "footman", "count": 8, "spacing": 0.95}, {"kind": "chaplain", "count": 2, "spacing": 4.05, "delay": 2.7}, {"kind": "recruit", "count": 10, "spacing": 0.95, "delay": 6.8}]},
		{"banner": "Templars charge when struck", "groups": [{"kind": "templar", "count": 2, "spacing": 5.40}, {"kind": "recruit", "count": 14, "spacing": 0.95, "delay": 1.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 14, "spacing": 0.68}, {"kind": "archer", "count": 10, "spacing": 0.95, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 14, "spacing": 1.08}, {"kind": "chaplain", "count": 3, "spacing": 4.05, "delay": 4.1}, {"kind": "templar", "count": 2, "spacing": 4.05, "delay": 8.1}]},
		{"banner": "The Inquisitor comes for the crypt", "groups": [{"kind": "inquisitor", "count": 1, "spacing": 0.95}, {"kind": "recruit", "count": 16, "spacing": 0.81, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 4, "spacing": 2.70}, {"kind": "purifier", "count": 12, "spacing": 0.68, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 18, "spacing": 0.94}, {"kind": "chaplain", "count": 4, "spacing": 3.38, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "archer", "count": 24, "spacing": 0.54}, {"kind": "purifier", "count": 10, "spacing": 0.68, "delay": 5.4}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 2.16}, {"kind": "footman", "count": 12, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "A swarm of recruits", "groups": [{"kind": "recruit", "count": 30, "spacing": 0.47}, {"kind": "chaplain", "count": 4, "spacing": 2.70, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 2.03}, {"kind": "chaplain", "count": 4, "spacing": 2.70, "delay": 2.7}, {"kind": "footman", "count": 14, "spacing": 0.95, "delay": 5.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 20, "spacing": 0.54}, {"kind": "templar", "count": 4, "spacing": 2.70, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 22, "spacing": 0.81}, {"kind": "archer", "count": 16, "spacing": 0.54, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 10, "spacing": 1.62}, {"kind": "chaplain", "count": 6, "spacing": 2.43, "delay": 2.7}]},
		{"banner": "The Covenant's full muster", "groups": [{"kind": "footman", "count": 16, "spacing": 0.81}, {"kind": "templar", "count": 8, "spacing": 1.62, "delay": 2.7}, {"kind": "purifier", "count": 16, "spacing": 0.54, "delay": 6.8}, {"kind": "chaplain", "count": 5, "spacing": 2.70, "delay": 8.1}]},
		{"banner": "Sir Alaric, the Gravebreaker, has arrived!", "groups": [{"kind": "alaric", "count": 1, "spacing": 0.95}, {"kind": "templar", "count": 4, "spacing": 2.70, "delay": 4.1}, {"kind": "footman", "count": 10, "spacing": 1.08, "delay": 8.1}]},
	],
}
