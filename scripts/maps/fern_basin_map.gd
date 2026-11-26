## The Fern Basin (Act XIV map 1, the Age of Titans; Necropathy's "fern_basin"
## stage, GDD §7.3): a steaming basin of tree ferns, tar seeps and bleached
## fossils. The hunters' path enters from the west, winds down through a tar
## seep and back up to the necromancer's gate in the east; a second path comes
## up from the river ford in the south and joins it. A herd trail runs north to
## south across the eastern basin (off-road, an exit): herds trample the plots
## beside it unless they are hurt enough to turn back. Tar seeps slow every
## walker (Bog Crocs sink out of sight in them). Act rule: the Stampedes
## (rules/primeval/stampedes.gd). 16 plots, 5 posts, 22 waves; Ironjaw, the
## Nest Mother (miniboss) on wave 11, Scarmaw on wave 22. Keys as
## graveyard_map.gd plus "herd_trails", "tar" (the act rule). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and stampedes.gd).
const MAP: Dictionary = {
	"id": "fern_basin",
	"name": "The Fern Basin",
	"floor": "tiles/fern_basin_fern_floor",
	"decals": [],
	"obstacles": [
		["obstacles/primeval_tree_fern_m", Vector2(60, 420)], ["obstacles/primeval_tree_fern_m", Vector2(250, 120)],
		["obstacles/primeval_fossil_m", Vector2(520, 300)], ["obstacles/primeval_tree_fern_m", Vector2(700, 110)],
		["obstacles/primeval_rock_m", Vector2(1210, 140)], ["obstacles/primeval_tree_fern_m", Vector2(1240, 620)],
		["obstacles/primeval_fossil_m_v", Vector2(80, 620)], ["obstacles/primeval_tree_fern_m", Vector2(820, 640)],
		["obstacles/primeval_rock_m", Vector2(400, 680)], ["obstacles/primeval_tree_fern_m", Vector2(1040, 420)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 240), Vector2(260, 240), Vector2(320, 300), Vector2(320, 470), Vector2(380, 530),
				Vector2(700, 530), Vector2(760, 470), Vector2(760, 250), Vector2(820, 190), Vector2(1060, 190),
				Vector2(1120, 250), Vector2(1120, 420), Vector2(1180, 480), Vector2(1190, 480)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ford": {
			"points": [Vector2(560, 760), Vector2(560, 600), Vector2(600, 530)],
			"next": "main", "next_at": 859.7, "entrance": true,
		},
		"fern_trail": {
			"points": [Vector2(980, -40), Vector2(980, 110), Vector2(930, 300), Vector2(900, 420), Vector2(940, 620), Vector2(940, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"fern_trail_back": {
			"points": [Vector2(940, 780), Vector2(940, 620), Vector2(900, 420), Vector2(930, 300), Vector2(980, 110), Vector2(980, -40)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"fern_trail": "fern_trail_back"},  # The herd trail and the road a turned herd runs back along.
	"tar": [[Vector2(320, 385), 52.0], [Vector2(905, 370), 48.0], [Vector2(560, 660), 40.0]],  # TUNING (not in GDD) tar seeps: [centre px, radius px]
	"gate": Vector2(1218, 450),
	"plots": [
		Vector2(130, 170), Vector2(130, 320), Vector2(230, 390), Vector2(420, 420), Vector2(470, 620), Vector2(660, 620),
		Vector2(620, 420), Vector2(660, 300), Vector2(520, 440), Vector2(860, 320), Vector2(860, 100), Vector2(1015, 300),
		Vector2(1015, 560), Vector2(1200, 330), Vector2(1065, 100), Vector2(440, 300),
	],
	"posts": [Vector2(170, 240), Vector2(520, 530), Vector2(760, 360), Vector2(940, 190), Vector2(1120, 330)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.8,  # TUNING (not in GDD) Part Three: its roster carries the step up (DECISIONS T14.7)
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "fern_basin_default",
	"weak_order": "fern_basin_weak",
	"waves": [
		{"banner": "The Fern Floor: scuttlers stream through the ferns", "groups": [{"kind": "prim_scuttler", "count": 14, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 8, "spacing": 1.1}, {"kind": "prim_scuttler", "count": 10, "spacing": 0.5, "delay": 2.0, "road": "ford"}]},
		{"banner": "Frill-Spitters lob venom over your posts", "groups": [{"kind": "prim_frill_spitter", "count": 3, "spacing": 1.4}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "A herd on the fern trail: hurt it before it reaches your plots and it turns back", "groups": [{"kind": "prim_duckbill", "count": 4, "spacing": 1.2, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_scuttler", "count": 10, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 3, "spacing": 1.2, "delay": 3.0, "road": "ford"}]},
		{"banner": "Razorclaws leap over the first post that holds them", "groups": [{"kind": "prim_razorclaw", "count": 10, "spacing": 0.9}, {"kind": "prim_frill_spitter", "count": 4, "spacing": 1.4, "delay": 4.0, "road": "ford"}]},
		{"banner": "Bog Crocs sink out of sight in the tar seeps", "groups": [{"kind": "prim_bog_croc", "count": 3, "spacing": 2.0}, {"kind": "prim_scuttler", "count": 14, "spacing": 0.4, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 4, "spacing": 1.3, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 4, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "ford"}, {"kind": "prim_duckbill", "count": 3, "spacing": 1.2, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "An alpha leads the pack: kill her first", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.8, "delay": 1.0}, {"kind": "prim_bog_croc", "count": 3, "spacing": 2.0, "delay": 5.0, "road": "ford"}]},
		{"banner": "Longnecks: slow, huge, and they flatten what they pass", "groups": [{"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_bog_croc", "count": 5, "spacing": 1.8}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 8, "spacing": 0.9, "delay": 5.0, "road": "ford"}]},
		{"banner": "IRONJAW, THE NEST MOTHER! Break her nest, then bring her down", "groups": [{"kind": "prim_ironjaw", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.5, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 6.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "ford"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 4.0}, {"kind": "prim_duckbill", "count": 4, "spacing": 1.1, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "The Tar Seep", "groups": [{"kind": "prim_bog_croc", "count": 6, "spacing": 1.5}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "ford"}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "A Tyrant walks the basin: its roar stuns your towers", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 2.0, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 4.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 3.0}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_bog_croc", "count": 6, "spacing": 1.4, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_scuttler", "count": 20, "spacing": 0.35, "delay": 4.0}]},
		{"banner": "The River Ford", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "ford"}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 4.0}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 8.0, "road": "fern_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 12, "spacing": 0.6}, {"kind": "prim_bog_croc", "count": 6, "spacing": 1.4, "delay": 2.0, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Nesting Hollow", "groups": [{"kind": "prim_tyrant", "count": 2, "spacing": 7.0}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "ford"}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 3.0, "road": "ford"}, {"kind": "prim_bog_croc", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "prim_scuttler", "count": 24, "spacing": 0.3, "delay": 4.0, "road": "ford"}]},
		{"banner": "The whole basin wakes", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_frill_spitter", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "ford"}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 4.0}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 6.0}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 8.0, "road": "fern_trail"}]},
		{"banner": "SCARMAW, THE GREAT RAPTOR, comes for the hunt!", "groups": [{"kind": "prim_scarmaw", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 1.0, "delay": 6.0, "road": "ford"}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 10.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.2, "delay": 12.0}]},
	],
}
