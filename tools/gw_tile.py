#!/usr/bin/env python3
"""gw_tile.py: builds Gravewatch's seamless road tiles with Necropathy's tools/make_tile.py pipeline.

Usage: python3 tools/gw_tile.py <recipe> [<recipe> ...]   (recipes below; sources in art_source/td_gen/)
Reuses make_tile.render_tile() (flatten, normalise, quilt to a seamless tile, snap to the locked palette,
despeck) at Gravewatch's 48 px tile size and writes to art_source/td_gen/out/<recipe>.png; a separate
step (tools/gw_art.py install) copies chosen pieces into assets/sprites/td/. TUNING (not in GDD): art choices.
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image

import make_tile as mt
from pixel_palette import Palette

ROOT = Path(__file__).resolve().parent.parent
mt.SOURCE_DIR = ROOT / "art_source" / "td_gen"  # AI sources of the Gravewatch art.
OUT = ROOT / "art_source" / "td_gen" / "out"  # Built pieces (not yet installed).
mt.TILE = 48  # Gravewatch's road tile side (px), TdArtData.ROAD_WIDTH.

# Recipe keys are documented in make_tile.py ("Recipes").
RECIPES = {
    "road_fill": {  # 48x48 seamless flagstone road under every road (the AI stone texture, quilted seamless, 3 tones).
        "source": "road_fill_a.png", "method": "quilt", "overlap": 16, "box": (0.25, 0.25, 0.75, 0.75),
        "flatten": 5, "chroma_w": 0.0,
        "colors": ["ink_warm", "grey_dark", "steel_dark"],
        "shares": {"ink_warm": 0.17, "grey_dark": 0.28, "steel_dark": 0.55},
        "despeck": 3,
    },
    "road_edge": {  # 48x8 kerb strip, seamless along x (kerbstones, lit top row, dark foot).
        "source": "road_edge_a.png", "method": "quilt", "road": (48, 8), "overlap": 12, "fray": 0,
        "box": (0.0, 0.40, 0.5, 0.39 + 0.20), "flatten": 0, "flatten_axis": "x", "chroma_w": 0.0,
        "colors": ["ink_warm", "grey_dark", "steel_dark", "bone_shade"],
        "shares": {"ink_warm": 0.22, "grey_dark": 0.33, "steel_dark": 0.35, "bone_shade": 0.10},
        "despeck": 1,
    },
}

if __name__ == "__main__":
    pal = Palette()
    OUT.mkdir(parents=True, exist_ok=True)
    for name in sys.argv[1:]:
        rec = RECIPES[name]
        w, h = rec.get("road", (mt.TILE, mt.TILE))
        idx = mt.render_tile(rec, pal, rec["source"], rec.get("box", mt.default_box()), periodic=True)
        mt.save(idx, pal, OUT / f"{name}.png", mt.fray_alpha(w, h, 0, 7) if rec.get("road") and rec.get("fray") else None)
        print(mt.report(name, idx, pal, None, "" if rec["method"] == "layout" else "xy"))
        # 3x3 repeat preview at x3.
        t = Image.open(OUT / f"{name}.png").convert("RGBA")
        sheet = Image.new("RGBA", (t.width * 4, t.height * 4))
        for y in range(4):
            for x in range(4):
                sheet.paste(t, (x * t.width, y * t.height))
        sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST).save(OUT / f"{name}_repeat.png")
