# The road styles' prompts (gw_road_art.py gen) and palette recipes (build). Exec'd into STYLES by gw_road_art.py.
# Each entry: fill_desc, edge_desc, fill {colors, shares, patches?}, edge {colors, shares}. Palette names: tools/palette.json.
STYLES.update({
    "deck": {
        "fill_desc": "a wooden ship deck: parallel horizontal planks of weathered oak, each plank about 12 pixels tall, black tarred caulking seams between planks, staggered plank ends, a few nail heads and knots.",
        "edge_desc": "a coiled ship's rope laid along the gunwale: thick twisted hemp rope with diagonal twist lines, tan and brown.",
    },
    "cobble": {
        "fill_desc": "dark wet round cobblestones of a gothic old-town street, tightly packed, irregular rounded stones with dark narrow gaps, a faint damp sheen, a few moss specks.",
        "edge_desc": "a row of dark rectangular kerbstones with a thin crimson-red stain line along the top edge.",
    },
    "carpet": {
        "fill_desc": "a deep blood-red velvet runner carpet seen from above, subtle woven diamond pattern, tiny darker thread lines, no fringe.",
        "edge_desc": "the gold braided trim of a red carpet: a band of twisted gold braid with small diamond motifs on dark crimson.",
    },
    "earth": {
        "fill_desc": "packed pale brown earth of a Japanese village road with flat grey stepping stones set in it, rounded stones of mixed size separated by bare earth, tiny pebbles.",
        "edge_desc": "a low wooden plank border: a row of dark brown wooden boards side by side with square nail heads, lighter top edge.",
    },
    "frost": {
        "fill_desc": "snow-trodden frozen stone paving of a Norse road: grey flagstones dusted with packed snow in the gaps, icy bluish highlights, a few cracks.",
        "edge_desc": "a border of rough grey stones capped with white snow, with small icicle shadows below.",
    },
    "timber": {
        "fill_desc": "the worn timber floor of a Norse longhall: wide dark brown planks running horizontally, deep grain lines, scuffs, a few iron nails.",
        "edge_desc": "a heavy carved wooden beam with a repeating interlace knotwork pattern of Norse carving, dark brown with lighter carved lines.",
    },
    "sandstone": {
        "fill_desc": "big sandstone slabs of an Egyptian temple causeway, warm tan blocks with thin dark joints, sand blown into the cracks, a few worn spots.",
        "edge_desc": "a row of sandstone blocks carved with repeating Egyptian hieroglyph symbols (eyes, ankhs, birds, wavy lines) in dark outline, tan stone.",
    },
    "marble": {
        "fill_desc": "white and cream marble paving of an ancient Roman road, rectangular slabs with thin grey veins and narrow dark joints, slightly worn.",
        "edge_desc": "a row of white marble kerb blocks with a darker Greek key meander pattern engraved along the middle.",
    },
    "ash_stone": {
        "fill_desc": "grey ash-covered slate flagstones of the underworld, dull cold grey, powdery ash in the cracks, no colour.",
        "edge_desc": "a row of dark grey bone-white-flecked stones, like stacked rough tombstones, dull and cold.",
    },
    "basalt": {
        "fill_desc": "cracked black volcanic basalt paving of hell: dark irregular plates with glowing orange-red lava seams between them, a few ember specks.",
        "edge_desc": "a row of jagged black obsidian spikes and rock chunks with thin glowing orange cracks.",
    },
    "cloud": {
        "fill_desc": "pale cream-white heavenly marble with fine golden veins, soft rectangular slabs with thin gold inlay lines at the joints, faint sky-blue tint in the shadows.",
        "edge_desc": "a band of polished gold trim on white marble with a repeating small leaf-and-bead pattern.",
    },
    "harbour": {
        "fill_desc": "wet slimy teal-green harbour paving stones, uneven slabs coated in algae, puddles, barnacle clusters and small shells, dark gaps.",
        "edge_desc": "a row of rough dark teal stones encrusted with white barnacles and strands of seaweed.",
    },
    "steel": {
        "fill_desc": "riveted steel deck plating of a futuristic machine fortress: grey-blue metal panels with thin dark seams and rows of small rivets, subtle scratches, diamond-tread pattern patches.",
        "edge_desc": "a hazard stripe band of diagonal yellow and black warning stripes on a metal edge plate.",
    },
    "hex": {
        "fill_desc": "alien hexagonal plating: tightly tiled medium-light lavender-grey hexagon panels, each about 28 pixels across, separated by clear dark seams about 3 pixels wide, each panel slightly different in shade, a few panels with a tiny glowing green dot in the centre, smooth ceramic-like material.",
        "edge_desc": "a band of alien metal ribbing with a row of small glowing green-teal lights between dark segments.",
    },
    "mud": {
        "fill_desc": "trampled prehistoric mud: churned brown earth with huge reptile three-toed footprints pressed in, small puddles, pebbles and a few broken leaves.",
        "edge_desc": "a ragged border of churned mud clods and tufts of fern leaves and grass, brown and olive green.",
    },
    "moss_path": {
        "fill_desc": "a mossy forest path: packed earth and flat stones overgrown with soft green moss patches, a few fallen leaves and tiny mushrooms.",
        "edge_desc": "a border of gnarled tree roots, twisting brown roots with green moss tufts, running along the edge.",
    },
})


def _r(colors, shares=None, **kw):
    """A recipe: palette `colors`; `shares` (colour -> fraction, lightness rank) or hue-aware snapping (chroma_w)."""
    rec = {"colors": colors, **kw}
    if shares:
        rec["shares"] = shares
    return rec


def _sh(*pairs):
    return {pairs[i]: pairs[i + 1] for i in range(0, len(pairs), 2)}


STYLES["deck"].update(
    fill=_r(["ink_warm", "corsair_tan_dark", "corsair_tan", "corsair_tan_light"], _sh("ink_warm", .12, "corsair_tan_dark", .2, "corsair_tan", .42, "corsair_tan_light", .26)),
    edge=_r(["corsair_oak_dark", "corsair_tan", "corsair_sail_shade", "corsair_sail"], _sh("corsair_oak_dark", .2, "corsair_tan", .3, "corsair_sail_shade", .3, "corsair_sail", .2)))
STYLES["cobble"].update(
    fill=_r(["ink_cold", "grey_dark", "grey", "grey_light"], _sh("ink_cold", .14, "grey_dark", .4, "grey", .36, "grey_light", .1)),
    edge=_r(["ink_cold", "grey_dark", "grey", "crimson"], chroma_w=1.0))
STYLES["carpet"].update(
    fill=_r(["blood_dark", "blood", "blood_light"], _sh("blood_dark", .3, "blood", .5, "blood_light", .2)),
    edge=_r(["ink_red", "blood_dark", "blood", "gold", "brown_light"], chroma_w=1.0))
STYLES["earth"].update(
    fill=_r(["brown_light", "corsair_tan", "corsair_tan_light", "steel_dark", "steel"], chroma_w=1.0),
    edge=_r(["ink_warm", "brown", "brown_light"], _sh("ink_warm", .25, "brown", .5, "brown_light", .25)))
STYLES["frost"].update(
    fill=_r(["norse_iron_dark", "norse_iron", "norse_iron_light", "norse_frost_shade", "norse_frost"], _sh("norse_iron_dark", .15, "norse_iron", .3, "norse_iron_light", .25, "norse_frost_shade", .15, "norse_frost", .15)),
    edge=_r(["norse_iron_dark", "norse_iron", "norse_frost_shade", "norse_frost"], chroma_w=0.5))
STYLES["hall"] = {  # Valgard's indoor floor: slab stone (the ash_stone source) in norse slab colours, the carved timber beam as kerb.
    "fill": _r(["norse_slab_dark", "norse_slab", "norse_slab_light", "norse_iron"], _sh("norse_slab_dark", .2, "norse_slab", .35, "norse_slab_light", .3, "norse_iron", .15), source="ash_stone_fill_a.png"),
    "edge": _r(["norse_plank_dark", "brown", "brown_light"], _sh("norse_plank_dark", .3, "brown", .45, "brown_light", .25), source="timber_edge_a.png")}
STYLES["sandstone"].update(
    fill=_r(["dyn_skin_dark", "dyn_sand_dark", "dyn_sand", "dyn_sand_light"], _sh("dyn_skin_dark", .15, "dyn_sand_dark", .3, "dyn_sand", .4, "dyn_sand_light", .15)),
    edge=_r(["dyn_skin_dark", "dyn_sand_dark", "dyn_sand"], _sh("dyn_skin_dark", .2, "dyn_sand_dark", .35, "dyn_sand", .45)))
STYLES["marble"].update(
    fill=_r(["marble_dark", "marble", "marble_light"], _sh("marble_dark", .2, "marble", .5, "marble_light", .3)),
    edge=_r(["marble_dark", "marble", "marble_light"], _sh("marble_dark", .25, "marble", .45, "marble_light", .3)))
STYLES["ash_stone"].update(
    fill=_r(["grey_dark", "steel_dark", "marble_dark"], _sh("grey_dark", .25, "steel_dark", .4, "marble_dark", .35)),
    edge=_r(["grey_dark", "steel_dark", "steel", "bone_mid"], _sh("grey_dark", .3, "steel_dark", .35, "steel", .25, "bone_mid", .1)))
STYLES["basalt"].update(
    fill=_r(["obsidian", "obsidian_light", "lava_dark", "lava", "lava_light"], chroma_w=1.0),
    edge=_r(["obsidian_dark", "obsidian_light", "lava", "lava_light"], chroma_w=1.0))
STYLES["cloud"].update(
    fill=_r(["host_silver", "host_cloud", "host_starlight", "gold", "gold_light"], chroma_w=1.0),
    edge=_r(["host_silver", "host_starlight", "gold", "gold_light", "brown_light"], chroma_w=1.0))
STYLES["harbour"].update(
    fill=_r(["ink_drowned", "drowned_dark", "drowned", "drowned_light", "moss_dark", "bone_mid"], chroma_w=1.0),
    edge=_r(["ink_drowned", "drowned_dark", "drowned", "drowned_light", "moss", "bone_mid"], chroma_w=1.0))
STYLES["steel"].update(
    fill=_r(["ink_chrome", "chrome_dark", "chrome", "chrome_light"], _sh("ink_chrome", .1, "chrome_dark", .35, "chrome", .4, "chrome_light", .15)),
    edge=_r(["city_ink", "city_hazard", "chrome", "chrome_dark"], chroma_w=1.0))
STYLES["hex"].update(
    fill=_r(["concord_gunmetal_dark", "concord_gunmetal", "grey_dark", "concord_lav_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"]),
    edge=_r(["concord_gunmetal_dark", "concord_gunmetal", "grey_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"]))
STYLES["mud"].update(
    fill=_r(["primeval_tar", "primeval_tar_mid", "primeval_tar_light", "primeval_ochre_dark", "primeval_fern_dark"], chroma_w=1.0),
    edge=_r(["primeval_tar", "primeval_ochre_dark", "primeval_fern_dark", "primeval_fern"], chroma_w=1.0))
STYLES["moss_path"].update(
    fill=_r(["wild_bark_dark", "wild_bark", "wild_bark_light", "wild_moss_dark", "wild_moss"], chroma_w=1.0),
    edge=_r(["wild_bark_dark", "wild_bark", "wild_bark_light", "wild_moss"], chroma_w=1.0))

# Tuning pass after the first contact sheet (calmer carpet / marble / cloud / harbour / moss path / steel / hex).
STYLES["carpet"]["fill"] = _r(["blood_dark", "blood", "blood_light"], _sh("blood_dark", .5, "blood", .42, "blood_light", .08), despeck=3)
STYLES["marble"]["fill"] = _r(["steel", "marble_dark", "marble"], _sh("steel", .15, "marble_dark", .4, "marble", .45), despeck=3)
STYLES["cloud"]["fill"] = _r(["host_silver", "host_cloud", "host_starlight", "gold", "gold_light"], chroma_w=1.0, l_range=(0.62, 0.9), despeck=3)
STYLES["harbour"]["fill"] = _r(["ink_drowned", "drowned_dark", "drowned", "drowned_light"], _sh("ink_drowned", .12, "drowned_dark", .38, "drowned", .38, "drowned_light", .12),
                              patches={"moss_dark": .08}, despeck=3)
STYLES["moss_path"]["fill"] = _r(["wild_bark_dark", "wild_bark", "wild_bark_light", "wild_moss_dark"], _sh("wild_bark_dark", .2, "wild_bark", .4, "wild_bark_light", .25, "wild_moss_dark", .15),
                                patches={"wild_moss": .15}, despeck=3)
STYLES["steel"]["fill"] = _r(["ink_chrome", "chrome_dark", "chrome", "chrome_light"], _sh("ink_chrome", .1, "chrome_dark", .38, "chrome", .4, "chrome_light", .12), despeck=3, flatten=8)
STYLES["hex"]["fill"] = _r(["concord_gunmetal", "grey_dark", "grey", "concord_lav_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"], l_range=(0.30, 0.55))
STYLES["ash_stone"]["fill"] = _r(["grey_dark", "steel_dark", "marble_dark"], _sh("grey_dark", .25, "steel_dark", .4, "marble_dark", .35), despeck=3)
STYLES["carpet"]["fill"] = _r(["blood_ink", "blood_dark", "blood"], _sh("blood_ink", .15, "blood_dark", .6, "blood", .25), despeck=3)
STYLES["marble"]["fill"] = _r(["marble_dark", "marble", "marble_light"], _sh("marble_dark", .2, "marble", .55, "marble_light", .25), l_range=(0.70, 0.92))
STYLES["hex"]["fill"] = _r(["concord_gunmetal_dark", "concord_gunmetal", "grey_dark", "concord_lav_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"], l_range=(0.25, 0.5))
STYLES["moss_path"]["fill"] = _r(["wild_bark_dark", "wild_bark", "wild_bark_light", "wild_moss_dark"], _sh("wild_bark_dark", .25, "wild_bark", .45, "wild_bark_light", .22, "wild_moss_dark", .08),
                                patches={"wild_moss": .1}, despeck=4, flatten=8)
STYLES["carpet"]["fill"] = _r(["blood_ink", "blood_dark", "blood"], _sh("blood_ink", .1, "blood_dark", .78, "blood", .12), despeck=3)
STYLES["hex"]["fill"] = _r(["concord_gunmetal_dark", "concord_gunmetal", "grey_dark", "concord_lav_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"])
STYLES["hex"]["fill"] = _r(["grey_dark", "grey", "concord_lav_dark", "concord_plasma"], chroma_w=1.0, keep=["concord_plasma"], l_range=(0.42, 0.66))
STYLES["hex"]["fill"] = _r(["concord_gunmetal_dark", "concord_gunmetal", "concord_lav_dark", "concord_lav"], _sh("concord_gunmetal_dark", .18, "concord_gunmetal", .32, "concord_lav_dark", .3, "concord_lav", .2), despeck=2)
STYLES["hex"]["fill"] = _r(["concord_gunmetal_dark", "concord_gunmetal", "concord_lav_dark"], _sh("concord_gunmetal_dark", .2, "concord_gunmetal", .12, "concord_lav_dark", .68), despeck=2)
