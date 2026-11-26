## The Burning Gate (Act IX map 1; Necropathy stage "burning_gate"): a plain
## of ash and obsidian before the gate of hell, the cages of the damned and
## the river of fire. Two entrances: the main road winds in from the west
## past the cages; the river lane climbs from the south and joins it in the
## middle. 16 plots, 5 posts, 22 waves. The Portals (act rule
## inferno/portals): three hell portals tear open on the road (waves 6, 11,
## 16); posts 1 and 3 stand on the first two marks (build there before they
## open and they never do: the forward positions), the third needs a Bone
## Wall, Brimstone or the towers. Hell Pits burn on the posts from wave 8. The
## Gatekeeper (miniboss, chest) on wave 14, Moloch, the Furnace King, on wave
## 22: beating him unlocks Brimstone and the Furnace Priest.
## Keys as graveyard_map.gd plus the Portals keys (portals, pits, pits_from:
## documented in the act data's RULE). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and the Inferno's RULE).
const MAP: Dictionary = {
	"id": "burning_gate",
	"name": "The Burning Gate",
	"floor": "tiles/burning_gate_ash_plain",
	"decals": [],
	"obstacles": [
		["obstacles/damned_cage_l", Vector2(90, 90)], ["obstacles/ember_rock_l", Vector2(80, 420)],
		["obstacles/obsidian_spire_l", Vector2(170, 560)], ["obstacles/damned_cage_s", Vector2(280, 680)],
		["obstacles/ember_rock_m", Vector2(960, 560)], ["obstacles/gate_pillar_l_v", Vector2(1200, 420)],
		["obstacles/obsidian_shard_m", Vector2(1150, 620)], ["obstacles/chain_post_l", Vector2(980, 440)],
		["obstacles/damned_cage_l", Vector2(560, 320)], ["obstacles/ember_rock_s", Vector2(640, 100)],
		["obstacles/obsidian_spire_s", Vector2(760, 110)], ["obstacles/gate_pillar_s", Vector2(1180, 80)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 160), Vector2(300, 160), Vector2(360, 220), Vector2(360, 420),
				Vector2(420, 480), Vector2(760, 480), Vector2(820, 420), Vector2(820, 260),
				Vector2(880, 200), Vector2(1190, 200)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"river": {
			"points": [Vector2(600, 770), Vector2(600, 480)],
			"next": "main", "next_at": 889.7, "entrance": true,  # joins main at (600, 480)
		},
	},
	"gate": Vector2(1218, 170),
	"plots": [
		Vector2(240, 92), Vector2(170, 235), Vector2(290, 300), Vector2(430, 300), Vector2(500, 410),
		Vector2(520, 550), Vector2(680, 550), Vector2(700, 410), Vector2(890, 330), Vector2(750, 330),
		Vector2(960, 130), Vector2(1080, 270), Vector2(530, 680), Vector2(670, 680), Vector2(1100, 130),
		Vector2(440, 150),
	],
	"posts": [Vector2(200, 160), Vector2(360, 330), Vector2(680, 480), Vector2(600, 640), Vector2(1000, 200)],
	"portals": [
		{"at": Vector2(360, 330), "wave": 6, "squad": [["damned_soul", 3], ["hell_imp", 1]], "every": 7.0, "squads": 4},  # TUNING (not in GDD) on post 1
		{"at": Vector2(600, 640), "wave": 11, "squad": [["hell_knight", 1], ["damned_soul", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 3
		{"at": Vector2(480, 480), "wave": 16, "squad": [["lava_hound", 3], ["hell_imp", 2]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) no post: wall, Brimstone or towers
	],
	"pits": [Vector2(680, 480), Vector2(1000, 200), Vector2(360, 240)],
	"pits_from": 8,  # TUNING (not in GDD)
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.0,  # TUNING (not in GDD) Part Two map 1: a step above the Road to the Sun's roster
	"rule": "",
	"act_rule": "inferno/portals",
	"build_order": "burning_gate_default",
	"weak_order": "burning_gate_weak",
	"waves": [
		{"banner": "The damned are dragged to the gate", "groups": [{"kind": "damned_soul", "count": 12, "spacing": 1.1}]},
		{"banner": "", "groups": [{"kind": "damned_soul", "count": 10, "spacing": 0.9}, {"kind": "damned_soul", "count": 6, "spacing": 1.0, "delay": 3.0, "road": "river"}]},
		{"banner": "Imps fly over your posts", "groups": [{"kind": "hell_imp", "count": 8, "spacing": 1.0}, {"kind": "damned_soul", "count": 10, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "Hell Knights: their sweep cuts every body of a post", "groups": [{"kind": "hell_knight", "count": 4, "spacing": 2.4}, {"kind": "damned_soul", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 8, "spacing": 0.8}, {"kind": "damned_soul", "count": 10, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 5, "spacing": 1.8}, {"kind": "hell_imp", "count": 8, "spacing": 0.8, "delay": 3.0, "road": "river"}]},
		{"banner": "Pit Cultists: kill them before their rite opens a portal", "groups": [{"kind": "pit_cultist", "count": 3, "spacing": 3.0}, {"kind": "damned_soul", "count": 14, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 8, "spacing": 0.7, "road": "river"}, {"kind": "hell_knight", "count": 5, "spacing": 1.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_imp", "count": 12, "spacing": 0.6}, {"kind": "damned_soul", "count": 14, "spacing": 0.7, "delay": 3.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 7, "spacing": 1.4}, {"kind": "pit_cultist", "count": 3, "spacing": 2.5, "delay": 4.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 10, "spacing": 0.6}, {"kind": "hell_knight", "count": 5, "spacing": 1.5, "delay": 3.0, "road": "river"}]},
		{"banner": "A Demon Brute: its slam shakes the whole post", "groups": [{"kind": "demon_brute", "count": 1, "spacing": 1.0}, {"kind": "damned_soul", "count": 14, "spacing": 0.6, "delay": 2.0}, {"kind": "hell_imp", "count": 8, "spacing": 0.7, "delay": 4.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 8, "spacing": 1.2}, {"kind": "pit_cultist", "count": 3, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "The Gatekeeper drags his chains to the gate!", "groups": [{"kind": "gatekeeper", "count": 1, "spacing": 1.0}, {"kind": "damned_soul", "count": 12, "spacing": 0.7, "delay": 3.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5}, {"kind": "hell_imp", "count": 10, "spacing": 0.6, "delay": 3.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 8, "spacing": 1.1, "road": "river"}, {"kind": "demon_brute", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "pit_cultist", "count": 4, "spacing": 2.0}, {"kind": "damned_soul", "count": 16, "spacing": 0.5, "delay": 2.0, "road": "river"}, {"kind": "hell_imp", "count": 8, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 4.0}, {"kind": "lava_hound", "count": 10, "spacing": 0.6, "delay": 3.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 10, "spacing": 1.0}, {"kind": "hell_imp", "count": 10, "spacing": 0.6, "delay": 3.0, "road": "river"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5}, {"kind": "pit_cultist", "count": 3, "spacing": 2.5, "delay": 3.0, "road": "river"}, {"kind": "hell_knight", "count": 6, "spacing": 1.2, "delay": 5.0}]},
		{"banner": "The furnace roars beyond the gate", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 3.0}, {"kind": "hell_knight", "count": 8, "spacing": 1.0, "delay": 2.0, "road": "river"}, {"kind": "damned_soul", "count": 14, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "Moloch, the Furnace King! He swallows your blockers whole", "groups": [{"kind": "moloch", "count": 1, "spacing": 1.0}, {"kind": "lava_hound", "count": 8, "spacing": 0.8, "delay": 4.0, "road": "river"}, {"kind": "hell_knight", "count": 6, "spacing": 1.2, "delay": 6.0}]},
	],
}
