#!/usr/bin/env python3
"""gw_road_art.py: the themed road tiles (DECISIONS R1-R3): one 48x48 seamless fill and one 48x8 kerb strip per style.

Usage (repo root):
    python3 tools/gw_road_art.py gen [style ...]     AI sources -> art_source/td_roads/<style>_fill_a.png / _edge_a.png
                                                     (tools/gen_image.py; cost rows land in docs/art/generation_ledger.csv)
    python3 tools/gw_road_art.py build [style ...]   sources -> assets/sprites/td/roads/<style>_fill.png / _edge.png
                                                     (tools/make_tile.py pipeline: quilt seamless, snap to the locked palette)
Raw sources stay in art_source/ (it has a .gdignore: never imported). TUNING (not in GDD): art choices.
"""
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "art_source" / "td_roads"  # Raw AI sources (not imported).
DST = ROOT / "assets" / "sprites" / "td" / "roads"  # Installed tiles.

COMMON = (" Top-down view, pixel art for a tower defense game, chunky low-resolution pixel look, flat colours, "
          "no gradients, no strong light or shadow, even lighting across the whole image, narrow value range, "
          "readable but not noisy. No text, no frame, no objects, no characters.")


def fill_prompt(desc: str) -> str:
    return "Seamless square ground texture of " + desc + COMMON + " Fills the entire square edge to edge."


def edge_prompt(desc: str) -> str:
    return ("A horizontal strip seen from above, the edge border of a road: " + desc + " One single repeating band running across the "
            "whole width, filling the vertical middle fifth of the image; above and below it plain flat dark ground." + COMMON)


# style id -> (fill description, kerb description, fill recipe, kerb recipe).
# Recipes: palette colour names dark -> light with shares (make_tile "shares", lightness rank), optional "patches" (hue patches).
STYLES: dict = {}


def load_styles() -> None:
    exec((ROOT / "tools" / "gw_road_styles.py").read_text(), {"STYLES": STYLES})


def gen(style: str) -> None:
    desc_fill, desc_edge = STYLES[style]["fill_desc"], STYLES[style]["edge_desc"]
    env = dict(os.environ, OPENAI_API_KEY=os.environ.get("OPENAI_API_KEY", "proxy-injected"),
               GEN_LEDGER=str(ROOT / "docs" / "art" / "generation_ledger.csv"))
    for part, prompt in (("fill", fill_prompt(desc_fill)), ("edge", edge_prompt(desc_edge))):
        out = SRC / f"{style}_{part}_a.png"
        if out.exists():
            continue
        pf = SRC / f"{style}_{part}.txt"
        pf.write_text(prompt + "\n")
        r = subprocess.run([sys.executable, str(ROOT / "tools" / "gen_image.py"), str(pf), str(out), "--key", f"road_{style}_{part}",
                            "--quality", "medium"], env=env, capture_output=True, text=True, cwd=ROOT)
        print(style, part, (r.stdout.strip().splitlines() or [r.stderr[-200:]])[-1])


def build(style: str) -> None:
    sys.path.insert(0, str(ROOT / "tools"))
    import make_tile as mt
    from PIL import Image
    from pixel_palette import Palette
    mt.SOURCE_DIR = SRC
    mt.TILE = 48
    pal = Palette()
    DST.mkdir(parents=True, exist_ok=True)
    for part in ("fill", "edge"):
        rec = dict(STYLES[style][part])
        rec.setdefault("source", f"{style}_{part}_a.png")
        rec["method"] = "quilt"
        if part == "edge":
            rec["road"] = (48, 8)
            rec.setdefault("overlap", 12)
            rec.setdefault("box", (0.0, 0.40, 0.5, 0.59))
            rec.setdefault("flatten", 0)
            rec["flatten_axis"] = "x"
        else:
            rec.setdefault("overlap", 16)
            rec.setdefault("box", (0.25, 0.25, 0.75, 0.75))
            rec.setdefault("flatten", 5)
        rec.setdefault("chroma_w", 0.0)
        rec.setdefault("despeck", 2 if part == "fill" else 1)
        w, h = rec.get("road", (48, 48))
        idx = mt.render_tile(rec, pal, rec["source"], rec["box"], periodic=True)
        mt.save(idx, pal, DST / f"{style}_{part}.png", None)
        t = Image.open(DST / f"{style}_{part}.png").convert("RGBA")
        sheet = Image.new("RGBA", (t.width * 4, t.height * 4))
        for y in range(4):
            for x in range(4):
                sheet.paste(t, (x * t.width, y * t.height))
        (SRC / "check").mkdir(exist_ok=True)
        sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST).save(SRC / "check" / f"{style}_{part}_repeat.png")
    print("built", style)


if __name__ == "__main__":
    load_styles()
    cmd, names = sys.argv[1], sys.argv[2:] or list(STYLES)
    SRC.mkdir(parents=True, exist_ok=True)
    for n in names:
        (gen if cmd == "gen" else build)(n)
