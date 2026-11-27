#!/usr/bin/env python3
"""spot_overlay.py: overlay pictures of the spot audit (DECISIONS S1).

Usage: python3 tools/spot_overlay.py <audit.json> <out_dir> [<before.json>] [map ...]
<audit.json> comes from `godot --headless tools/spot_audit.tscn -- --autotest --json=<path>`.
Draws each map at 1280x720 (or only the maps named): roads (48 px), off-road trails
(thin), HUD-covered rects (red), obstacle rects (brown), act objects (yellow), posts
(blue), plots coloured by flag (green ok, red dead, orange weak, magenta other) with the
shortest-range tower's level 1 ring (white) on flagged plots. With <before.json>, a plot
that moved is drawn with a grey ghost at its old place and an arrow to the new one.
Writes <out_dir>/<map>.png and <out_dir>/overview.png (every map, a 5-wide grid).
"""
import json
import os
import sys
from PIL import Image, ImageDraw

W, H = 1280, 720
COL = {"dead": (230, 40, 40), "weak": (255, 150, 30), "ok": (60, 200, 90), "other": (220, 60, 220)}


def colour(flags):
    if "dead" in flags:
        return COL["dead"]
    if "weak" in flags:
        return COL["weak"]
    return COL["other"] if flags else COL["ok"]


def draw_map(m, r1, old):
    im = Image.new("RGB", (W, H), (28, 26, 34))
    d = ImageDraw.Draw(im, "RGBA")
    for c in m["covers"]:
        d.rectangle([c[0], c[1], c[0] + c[2], c[1] + c[3]], fill=(200, 30, 30, 70))
    for c in m["obstacles"]:
        d.rectangle([c[0], c[1], c[0] + c[2], c[1] + c[3]], fill=(120, 80, 40, 120))
    for rd in m["roads"]:
        if rd["sky"]:
            continue
        pts = [tuple(p) for p in rd["points"]]
        if rd["off_road"]:
            d.line(pts, fill=(150, 110, 60), width=6)
        else:
            d.line(pts, fill=(110, 105, 95), width=48, joint="curve")
    gx, gy = m["gate"]
    d.rectangle([gx - 30, gy - 30, gx + 30, gy + 30], outline=(230, 220, 200), width=3)
    for p in m["points"]:
        d.ellipse([p[0] - 8, p[1] - 8, p[0] + 8, p[1] + 8], fill=(240, 220, 60))
    for p in m["posts"]:
        c = (240, 60, 60) if p["flags"] else (70, 140, 255)
        d.rectangle([p["x"] - 14, p["y"] - 8, p["x"] + 14, p["y"] + 8], fill=c)
        d.text((p["x"] - 4, p["y"] - 6), str(p["i"]), fill=(255, 255, 255))
    for p in m["plots"]:
        x, y, f = p["x"], p["y"], p["flags"]
        o = old.get(p["i"]) if old else None
        if o and (abs(o[0] - x) > 0.5 or abs(o[1] - y) > 0.5):
            d.ellipse([o[0] - 28, o[1] - 28, o[0] + 28, o[1] + 28], outline=(160, 160, 160), width=2)
            d.line([o[0], o[1], x, y], fill=(255, 255, 255), width=3)
        if f:
            d.ellipse([x - r1, y - r1, x + r1, y + r1], outline=(255, 255, 255, 140), width=2)
        d.ellipse([x - 28, y - 28, x + 28, y + 28], fill=colour(f) + (200,), outline=(0, 0, 0))
        d.text((x - 10, y - 12), str(p["i"]), fill=(0, 0, 0))
        d.text((x - 16, y + 2), "%d" % p["short_px"], fill=(0, 0, 0))
    d.text((8, 50), m["name"], fill=(255, 255, 255))
    return im


def main():
    data = json.load(open(sys.argv[1]))
    out = sys.argv[2]
    rest = sys.argv[3:]
    before = None
    if rest and rest[0].endswith(".json"):
        before = json.load(open(rest[0]))
        rest = rest[1:]
    os.makedirs(out, exist_ok=True)
    ids = rest or list(data["maps"].keys())
    tiles = []
    for mid in ids:
        m = data["maps"][mid]
        old = {p["i"]: (p["x"], p["y"]) for p in before["maps"][mid]["plots"]} if before else None
        im = draw_map(m, data["r1"], old)
        im.save(os.path.join(out, mid + ".png"))
        tiles.append(im.resize((W // 4, H // 4)))
    cols = 5
    rows = (len(tiles) + cols - 1) // cols
    ov = Image.new("RGB", (cols * W // 4, rows * H // 4), (0, 0, 0))
    for i, t in enumerate(tiles):
        ov.paste(t, ((i % cols) * W // 4, (i // cols) * H // 4))
    ov.save(os.path.join(out, "overview.png"))


main()
