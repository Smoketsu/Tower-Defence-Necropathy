## The Hollow Archive (Act XI map 2; Necropathy stage "archive"): a library
## buried under the town where the Eye keeps what must not be read. One long
## road walks the stacks: up and down five tall aisles between the bookshelves,
## left to right, to the gate in the north-east; a rift tears open on the right
## and its road cuts straight across the last aisle (a deliberate crossing) into
## the fourth. 15 plots, 6 posts, 22 waves. Claims (act rule eye/claims): the
## Scribes' curses make any cultist a claimer. The Librarian (miniboss, chest)
## on wave 12; the Archivist on wave 22. Keys as graveyard_map.gd. Data only.
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
		["obstacles/book_pile_l", Vector2(240, 250)], ["obstacles/brass_globe_l", Vector2(1215, 500)],
		["obstacles/chart_table_l", Vector2(70, 667)], ["obstacles/page_heap_l", Vector2(1240, 660)],
		["obstacles/toppled_shelf_m", Vector2(400, 670)], ["obstacles/blank_shelf_m", Vector2(800, 670)],
		["obstacles/book_pile_s", Vector2(40, 330)], ["obstacles/page_heap_s", Vector2(1240, 170)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(150, 600), Vector2(150, 595), Vector2(150, 130), Vector2(360, 130),
				Vector2(360, 595), Vector2(570, 595), Vector2(570, 130), Vector2(780, 130), Vector2(780, 595),
				Vector2(990, 595), Vector2(990, 130), Vector2(1190, 130)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"rift": {
			"points": [Vector2(1320, 470), Vector2(1160, 410), Vector2(782, 330)],
			"next": "main", "next_at": 2420.0,  # joins main at (780, 330)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 100),
	"plots": [
		Vector2(510, 240), Vector2(280, 240), Vector2(850, 460), Vector2(1080, 270), Vector2(270, 470), Vector2(480, 500),
		Vector2(920, 500), Vector2(690, 280), Vector2(210, 200), Vector2(640, 540), Vector2(80, 460), Vector2(840, 170),
		Vector2(1120, 490), Vector2(880, 280), Vector2(1060, 190),
	],
	"posts": [Vector2(360, 514), Vector2(780, 533), Vector2(976, 595), Vector2(990, 499), Vector2(990, 182), Vector2(1118, 130)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 5.2,  # TUNING (not in GDD) L4: 5.6 before the road redraw; DECISIONS Z4: 5.5 -> 5.6 with slower splits; Part Three: above the Harbour
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
