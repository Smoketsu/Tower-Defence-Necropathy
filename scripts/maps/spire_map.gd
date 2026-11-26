## Ul-Thalos, the Risen Spire (Act XI map 3, the act's finale; Necropathy
## stage "spire"): the god's drowned city risen from the sea, sliding back
## under it. The west road spirals in from the breakwater round the island's
## rim to the gate at the foot of the spire in the middle; the east road comes
## along the southern shore and joins the last stretch. 15 plots, 6 posts, 23
## waves. Claims (act rule eye/claims): Chanters and the Hierophants claim the
## dead. The Grand Hierophant (miniboss, chest) on wave 12; Vhal'Neth, the
## Dreaming Mother, on wave 23 (her face off the shore of the west road, her
## arms rising beside it). Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "spire",
	"name": "Ul-Thalos, the Risen Spire",
	"floor": "tiles/spire_breakwater",
	"decals": [],
	"obstacles": [
		["obstacles/cyclopean_block_l", Vector2(90, 120)], ["obstacles/barnacle_pillar_l", Vector2(60, 520)],
		["obstacles/fallen_idol_l", Vector2(330, 680)], ["obstacles/step_ruin_m", Vector2(1180, 90)],
		["obstacles/sunken_idol_l", Vector2(1230, 400)], ["obstacles/gate_pylon_l", Vector2(520, 360)],
		["obstacles/gate_pylon_l", Vector2(760, 360)], ["obstacles/toppled_arch_l", Vector2(640, 260)],
		["obstacles/spire_shard_l", Vector2(940, 300)], ["obstacles/spire_shard_l", Vector2(330, 300)],
		["obstacles/barnacle_pillar_s", Vector2(1240, 700)], ["obstacles/spire_shard_s", Vector2(700, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(180, 600), Vector2(240, 540), Vector2(240, 220), Vector2(300, 160), Vector2(980, 160), Vector2(1040, 220), Vector2(1040, 440), Vector2(980, 500), Vector2(700, 500), Vector2(640, 440), Vector2(640, 360)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 620), Vector2(780, 620), Vector2(720, 560), Vector2(700, 500)],
			"next": "main", "next_at": 2059.4,  # joins main at (700, 500)
			"entrance": true,
		},
	},
	"gate": Vector2(640, 330),
	"plots": [
		Vector2(400, 300), Vector2(560, 270), Vector2(800, 270), Vector2(900, 390), Vector2(420, 420), Vector2(800, 410),
		Vector2(120, 420), Vector2(120, 250), Vector2(420, 600), Vector2(1150, 300), Vector2(1150, 480), Vector2(880, 570),
		Vector2(560, 600), Vector2(320, 440), Vector2(1200, 200),
	],
	"posts": [Vector2(240, 400), Vector2(640, 160), Vector2(1040, 330), Vector2(840, 500), Vector2(1000, 620), Vector2(640, 420)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.4,  # TUNING (not in GDD) Part Three: the act's finale presses hardest
	"rule": "",
	"act_rule": "eye/claims",
	"build_order": "spire_default",
	"weak_order": "spire_weak",
	"waves": [
		{"banner": "The faithful climb the drowned steps of Ul-Thalos", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.6}, {"kind": "eye_deep_kin", "count": 3, "spacing": 1.8, "delay": 4.0}]},
		{"banner": "Sirens of the Eye: their song turns your blockers on their own post", "groups": [{"kind": "eye_siren", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.6, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 2, "spacing": 2.0, "delay": 5.0, "road": "east"}]},
		{"banner": "Spawns of the Deep: a tentacle grabs and squeezes a body", "groups": [{"kind": "eye_spawn", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_tide_caller", "count": 2, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.5, "road": "east"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "Hierophants: they claim the dead, and ASCEND unless you break them", "groups": [{"kind": "eye_hierophant", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_scribe", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 2, "spacing": 4.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 4.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 1.0, "road": "east"}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 2.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 5.0}]},
		{"banner": "The sea rises: the outer ring sinks", "groups": [{"kind": "eye_siren", "count": 2, "spacing": 3.5}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 1.0}, {"kind": "eye_initiate", "count": 14, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 1.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0}, {"kind": "eye_initiate", "count": 18, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_siren", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "east"}]},
		{"banner": "The Grand Hierophant raises his staff over the drowned city!", "groups": [{"kind": "eye_grand_hierophant", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.4, "delay": 8.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 1.0}, {"kind": "eye_initiate", "count": 14, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 1.0, "road": "east"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_tide_caller", "count": 4, "spacing": 2.0, "delay": 1.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "The Dream Gate: the god's light pours through", "groups": [{"kind": "eye_spawn", "count": 3, "spacing": 3.0}, {"kind": "eye_siren", "count": 2, "spacing": 3.5, "delay": 2.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 10, "spacing": 0.9, "delay": 1.0}, {"kind": "eye_hierophant", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "eye_scribe", "count": 4, "spacing": 2.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 22, "spacing": 0.3}, {"kind": "eye_hierophant", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "eye_tide_caller", "count": 4, "spacing": 2.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "eye_siren", "count": 2, "spacing": 3.5, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The last stone above the sea: the island holds its breath", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 1.0, "road": "east"}, {"kind": "eye_initiate", "count": 18, "spacing": 0.3, "delay": 2.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "eye_spawn", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 4.0, "road": "east"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 6.0}]},
		{"banner": "Vhal'Neth, the Dreaming Mother, rises beside the spire!", "groups": [{"kind": "eye_vhalneth", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 6.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 12.0}, {"kind": "eye_siren", "count": 1, "spacing": 1.0, "delay": 18.0, "road": "east"}]},
	],
}
