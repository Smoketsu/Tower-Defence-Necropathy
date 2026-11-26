## The Iron Citadel (Act XII map 3; Necropathy stage "citadel"), the Empire's
## fortress and the act's finale. Two roads come in from the west through the
## two outer gates, run east along the top and the bottom, turn back through
## the courts and meet in the middle; the last stretch runs west to the
## Citadel's core gate (2000 px from either entrance), past every plot. 14
## plots, 6 posts. 25 waves. Line of Fire (act rule empire/line_of_fire).
## Sentry Turrets are carried in and plant on the long stretches; Valkyrie 2.0
## (miniboss, chest) on wave 13; Deus Ex Machina with Varn on wave 25. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "citadel",
	"name": "The Iron Citadel",
	"floor": "tiles/citadel_courts",
	"decals": [],
	"obstacles": [
		["obstacles/citadel_crate_l", Vector2(480, 220)], ["obstacles/citadel_crate_l", Vector2(480, 520)],
		["obstacles/gate_pylon_m", Vector2(1210, 140)], ["obstacles/gate_pylon_m", Vector2(1210, 600)],
		["obstacles/citadel_crate_m_v", Vector2(1245, 370)], ["obstacles/emitter_pylon_m", Vector2(30, 220)],
		["obstacles/emitter_pylon_m", Vector2(30, 520)], ["obstacles/citadel_crate_s", Vector2(680, 220)],
		["obstacles/citadel_crate_s", Vector2(680, 520)], ["obstacles/gate_pylon_s", Vector2(330, 300)],
		["obstacles/citadel_crate_s_v", Vector2(1040, 680)],
	],
	"roads": {
		"north": {
			"points": [Vector2(-40, 130), Vector2(900, 130), Vector2(960, 190), Vector2(960, 250),
				Vector2(900, 310), Vector2(680, 310), Vector2(620, 370)],
			"next": "main", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(-40, 610), Vector2(900, 610), Vector2(960, 550), Vector2(960, 490),
				Vector2(900, 430), Vector2(680, 430), Vector2(620, 370)],
			"next": "main", "next_at": 0.0, "entrance": true,
		},
		"main": {
			"points": [Vector2(620, 370), Vector2(90, 370)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
	},
	"gate": Vector2(62, 370),
	"plots": [
		Vector2(180, 220), Vector2(380, 220), Vector2(580, 220), Vector2(780, 220),
		Vector2(180, 520), Vector2(380, 520), Vector2(580, 520), Vector2(780, 520),
		Vector2(1090, 170), Vector2(1090, 370), Vector2(1090, 570), Vector2(790, 370),
		Vector2(1200, 270), Vector2(1200, 470),
	],
	"posts": [Vector2(600, 130), Vector2(600, 610), Vector2(960, 220), Vector2(960, 520), Vector2(450, 370), Vector2(220, 370)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.4,  # TUNING (not in GDD) Part Three: the act's hardest
	"rule": "",
	"act_rule": "empire/line_of_fire",
	"build_order": "citadel_default",
	"weak_order": "citadel_weak",
	"waves": [
		{"banner": "The Citadel's outer guard: two gates, two columns", "groups": [{"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "road": "north"}, {"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2, "road": "north"}, {"kind": "empire_scout_drone", "count": 10, "spacing": 0.6, "delay": 2.0, "road": "south"}]},
		{"banner": "Valkyrie Duelists: their jets burst through a post", "groups": [{"kind": "empire_valkyrie_duelist", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "south"}, {"kind": "empire_aegis_bot", "count": 4, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_spotter", "count": 1, "spacing": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "north"}, {"kind": "empire_scout_drone", "count": 8, "spacing": 0.6, "delay": 3.0, "road": "south"}]},
		{"banner": "Sentry Turrets: carried in, they plant and keep firing", "groups": [{"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_juggernaut", "count": 1, "spacing": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "north"}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 1.0, "road": "south"}, {"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "road": "south"}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 1.0, "road": "north"}, {"kind": "empire_scout_drone", "count": 12, "spacing": 0.6, "delay": 3.0, "road": "south"}]},
		{"banner": "The Shield Gates", "groups": [{"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "road": "south"}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 1.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_fabricator", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 1.0, "road": "south"}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "road": "south"}, {"kind": "empire_juggernaut", "count": 1, "spacing": 1.0, "delay": 1.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0, "road": "south"}, {"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "delay": 3.0, "road": "north"}]},
		{"banner": "Valkyrie 2.0: jet dash, tower shield, blade storm!", "groups": [{"kind": "empire_valkyrie_prime", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "south"}, {"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "delay": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 2.0, "road": "north"}]},
		{"banner": "The Laser Courts", "groups": [{"kind": "empire_juggernaut", "count": 2, "spacing": 5.0, "road": "south"}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 1.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "road": "north"}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "road": "north"}, {"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "delay": 1.0, "road": "south"}, {"kind": "empire_scout_drone", "count": 14, "spacing": 0.6, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "road": "south"}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 1.0, "road": "north"}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "south"}]},
		{"banner": "The Lifts", "groups": [{"kind": "empire_juggernaut", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "delay": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 3, "spacing": 3.5, "road": "south"}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "delay": 1.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 14, "spacing": 1.1, "delay": 2.0, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "empire_valkyrie_duelist", "count": 3, "spacing": 3.0, "road": "south"}, {"kind": "empire_juggernaut", "count": 2, "spacing": 5.0, "delay": 2.0, "road": "north"}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "south"}]},
		{"banner": "The Core: the last guard of the Empire", "groups": [{"kind": "empire_spotter", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "empire_kill_drone", "count": 3, "spacing": 3.5, "delay": 1.0, "road": "south"}, {"kind": "empire_aegis_bot", "count": 14, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "empire_valkyrie_duelist", "count": 3, "spacing": 3.0, "road": "north"}, {"kind": "empire_sentry_turret", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "south"}, {"kind": "empire_line_trooper", "count": 14, "spacing": 1.1, "delay": 3.0, "road": "north"}]},
		{"banner": "Deus Ex Machina walks. Varn, the Root User, is wired into its core", "groups": [{"kind": "empire_deus", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0, "road": "south"}, {"kind": "empire_valkyrie_duelist", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "north"}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 4.0, "road": "south"}]},
	],
}
