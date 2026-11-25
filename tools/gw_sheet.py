#!/usr/bin/env python3
"""gw_sheet.py: before / after contact sheet of the Gravewatch art (old Pillow piece | new piece, 3x nearest, labelled).

Usage: python3 tools/gw_sheet.py <out.png> [dir_new=assets/sprites/td] [name ...]
Old pieces come from art_source/td_pillow/, new ones from dir_new (default: the installed game art).
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
S = 3  # Zoom (nearest neighbour).
out = Path(sys.argv[1])
new_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "assets" / "sprites" / "td"
names = sys.argv[3:] or sorted(p.stem for p in (ROOT / "art_source" / "td_pillow").glob("*.png"))
W, BG = 1700, (34, 40, 36, 255)
rows, x, y, rh = [], 6, 6, 0
cells = []
for n in names:
    po, pn = ROOT / "art_source" / "td_pillow" / f"{n}.png", new_dir / f"{n}.png"
    if not po.exists() or not pn.exists():
        continue
    a, b = Image.open(po).convert("RGBA"), Image.open(pn).convert("RGBA")
    if a.tobytes() == b.tobytes() and a.size == b.size:
        continue  # Unchanged pieces are left off.
    a, b = (i.resize((i.width * S, i.height * S), Image.NEAREST) for i in (a, b))
    w, h = a.width + b.width + 24, max(a.height, b.height) + 22
    if x + w > W:
        x, y, rh = 6, y + rh + 8, 0
    cells.append((n, x, y, a, b))
    x += w + 10
    rh = max(rh, h)
sheet = Image.new("RGBA", (W, y + rh + 8), BG)
d = ImageDraw.Draw(sheet)
for n, x, y, a, b in cells:
    d.text((x, y), f"{n}: old | new", fill=(230, 226, 210, 255))
    sheet.alpha_composite(a, (x, y + 14))
    d.line([(x + a.width + 6, y + 14), (x + a.width + 6, y + 14 + max(a.height, b.height))], fill=(90, 90, 80, 255))
    sheet.alpha_composite(b, (x + a.width + 12, y + 14))
sheet.save(out)
print(f"{len(cells)} changed pieces -> {out}")
