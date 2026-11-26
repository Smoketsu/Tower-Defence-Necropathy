## The Hollow Archive (Act XI map 2; Necropathy stage "archive"): a library
## buried under the town where the Eye keeps what must not be read. One long
## road snakes down three aisles between the shelves (left to right, back
## along the middle, left to right again) to the gate; a rift tears open on
## the right and its short road joins the first bend. 15 plots, 6 posts, 22
## waves. Claims (act rule eye/claims): the Scribes' curses make any cultist
## a claimer. The Librarian (miniboss, chest) on wave 12; the Archivist on
## wave 22. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "archive",
	"name": "The Hollow Archive",
	"floor": "tiles/archive_halls",
	"decals": ["decals/ink_pool", "decals/ink_well"],
	"obstacles": [
		["obstacles/bookshelf_l", Vector2(450, 250)], ["obstacles/bookshelf_l", Vector2(680, 250)],
		["obstacles/bookshelf_m", Vector2(890, 250)], ["obstacles/bookshelf_l", Vector2(450, 470)],
		["obstacles/bookshelf_l", Vector2(680, 470)], ["obstacles/reading_desk_l", Vector2(900, 470)],
		["obstacles/book_pile_l", Vector2(240, 250)], ["obstacles/brass_globe_l", Vector2(1210, 470)],
		["obstacles/chart_table_l", Vector2(60, 650)], ["obstacles/page_heap_l", Vector2(1240, 660)],
		["obstacles/toppled_shelf_m", Vector2(400, 670)], ["obstacles/blank_shelf_m", Vector2(800, 670)],
		["obstacles/book_pile_s", Vector2(40, 330)], ["obstacles/page_heap_s", Vector2(1240, 80)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 140), Vector2(1060, 140), Vector2(1120, 200), Vector2(1120, 300), Vector2(1060, 360), Vector2(220, 360), Vector2(160, 420), Vector2(160, 520), Vector2(220, 580), Vector2(1190, 580)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"rift": {
			"points": [Vector2(1320, 250), Vector2(1120, 250)],
			"next": "main", "next_at": 1234.9,  # joins main at (1120, 250)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 580),
	"plots": [
		Vector2(120, 250), Vector2(330, 250), Vector2(560, 250), Vector2(790, 250), Vector2(990, 250),
		Vector2(330, 470), Vector2(560, 470), Vector2(790, 470), Vector2(1010, 470), Vector2(1210, 430),
		Vector2(70, 470), Vector2(1215, 170), Vector2(240, 470), Vector2(670, 250), Vector2(1200, 330),
	],
	"posts": [Vector2(600, 140), Vector2(800, 360), Vector2(300, 360), Vector2(160, 470), Vector2(700, 580), Vector2(1050, 580)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 4.0,  # TUNING (not in GDD) Part Three: above the Harbour
	"rule": "",
	"act_rule": "eye/claims",
	"build_order": "archive_default",
	"weak_order": "archive_weak",
	"waves": [
		{"banner": "Initiates shuffle between the shelves", "groups": [{"kind": "eye_initiate", "count": 16, "spacing": 0.6}, {"kind": "eye_deep_kin", "count": 3, "spacing": 2.0, "delay": 4.0}]},
		{"banner": "Scribes of the Unwritten: their curse makes any cultist a claimer", "groups": [{"kind": "eye_scribe", "count": 3, "spacing": 3.0}, {"kind": "eye_initiate", "count": 14, "spacing": 0.6, "delay": 1.0}]},
		{"banner": "Ink Wraiths dive into the ink: unseen, through your posts", "groups": [{"kind": "eye_ink_wraith", "count": 5, "spacing": 1.4}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "Pilgrims of the Spore: their clouds choke your blockers", "groups": [{"kind": "eye_spore_pilgrim", "count": 4, "spacing": 2.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 2.0}, {"kind": "eye_scribe", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.5, "road": "rift"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "eye_ink_wraith", "count": 4, "spacing": 1.4, "delay": 4.0}]},
		{"banner": "A Gibbering Mass: kill it and it splits", "groups": [{"kind": "eye_gibbering_mass", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 2.0}, {"kind": "eye_scribe", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_spore_pilgrim", "count": 5, "spacing": 1.8}, {"kind": "eye_ink_wraith", "count": 4, "spacing": 1.4, "delay": 2.0, "road": "rift"}, {"kind": "eye_initiate", "count": 10, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_scribe", "count": 3, "spacing": 2.5}, {"kind": "eye_initiate", "count": 16, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "The rift tears open behind the stacks", "groups": [{"kind": "eye_ink_wraith", "count": 6, "spacing": 1.0, "road": "rift"}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 2.0, "road": "rift"}, {"kind": "eye_gibbering_mass", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_spore_pilgrim", "count": 5, "spacing": 1.6}, {"kind": "eye_scribe", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 4.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.5, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "eye_gibbering_mass", "count": 2, "spacing": 4.0}, {"kind": "eye_ink_wraith", "count": 5, "spacing": 1.2, "delay": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0, "road": "rift"}]},
		{"banner": "The Librarian opens its eye: the Index burns down the aisle!", "groups": [{"kind": "eye_librarian", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 4.0}, {"kind": "eye_scribe", "count": 2, "spacing": 3.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "eye_scribe", "count": 3, "spacing": 2.5, "road": "rift"}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_spore_pilgrim", "count": 4, "spacing": 1.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_ink_wraith", "count": 8, "spacing": 1.0}, {"kind": "eye_gibbering_mass", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0, "road": "rift"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0}, {"kind": "eye_spore_pilgrim", "count": 5, "spacing": 1.6, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.1, "delay": 3.0, "road": "rift"}]},
		{"banner": "Every Scribe writes at once", "groups": [{"kind": "eye_scribe", "count": 5, "spacing": 1.8}, {"kind": "eye_initiate", "count": 18, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_ink_wraith", "count": 4, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_gibbering_mass", "count": 2, "spacing": 3.5}, {"kind": "eye_spore_pilgrim", "count": 5, "spacing": 1.6, "delay": 2.0, "road": "rift"}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_ink_wraith", "count": 8, "spacing": 0.9, "road": "rift"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 2.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 22, "spacing": 0.3}, {"kind": "eye_gibbering_mass", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "The Unwritten Stacks: blank pages walk", "groups": [{"kind": "eye_spore_pilgrim", "count": 6, "spacing": 1.4}, {"kind": "eye_ink_wraith", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "rift"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_gibbering_mass", "count": 3, "spacing": 3.0}, {"kind": "eye_initiate", "count": 18, "spacing": 0.3, "delay": 1.0, "road": "rift"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 3.0}, {"kind": "eye_ink_wraith", "count": 5, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Archivist, Keeper of the Unwritten, reads you out of the book!", "groups": [{"kind": "eye_archivist", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 5.0}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 10.0, "road": "rift"}, {"kind": "eye_ink_wraith", "count": 4, "spacing": 1.2, "delay": 16.0}]},
	],
}
