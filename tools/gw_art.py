#!/usr/bin/env python3
"""gw_art.py: assembles and installs Gravewatch's generated art.

  python3 tools/gw_art.py roads     builds the 9 road piece tiles (straights, bends, tee, cross, end) from
                                    art_source/td_gen/out/road_fill.png + road_edge.png: kerbs on the closed sides,
                                    chamfered corners where two closed sides meet. (TdArtData uses only road_fill and
                                    road_edge; the piece tiles are kept in the same style for future use.)
  python3 tools/gw_art.py install <name> ...   copies art_source/td_gen/out/<name>.png into assets/sprites/td/.
Old Pillow pieces stay in art_source/td_pillow/ (copy one back to revert it). TUNING (not in GDD): art choices.
"""
import shutil
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "art_source" / "td_gen" / "out"
GAME = ROOT / "assets" / "sprites" / "td"
# piece -> open sides (N, E, S, W); the rest get a kerb.
PIECES = {
    "road_straight_h": "EW", "road_straight_v": "NS",
    "road_bend_ne": "NE", "road_bend_nw": "NW", "road_bend_se": "SE", "road_bend_sw": "SW",
    "road_tee": "EWS", "road_cross": "NESW", "road_end": "S",
}


def build_piece(fill: Image.Image, kerb: Image.Image, opened: str) -> Image.Image:
    img = fill.convert("RGBA").copy()
    n = img.width
    k = kerb.height  # Kerb thickness (px).
    top = kerb.convert("RGBA")
    strips = {"N": (top, (0, 0)), "S": (top.transpose(Image.FLIP_TOP_BOTTOM), (0, n - k)),
              "W": (top.transpose(Image.ROTATE_90), (0, 0)), "E": (top.transpose(Image.ROTATE_270), (n - k, 0))}
    for side, (strip, pos) in strips.items():
        if side not in opened:
            img.alpha_composite(strip, pos)
    for a, b, (cx, cy) in (("N", "W", (0, 0)), ("N", "E", (n - 1, 0)), ("S", "W", (0, n - 1)), ("S", "E", (n - 1, n - 1))):
        if a not in opened and b not in opened:  # Chamfer the outer corner (3 px staircase).
            sx, sy = (1 if cx == 0 else -1), (1 if cy == 0 else -1)
            for i, w in enumerate((3, 2, 1)):
                for j in range(w):
                    img.putpixel((cx + sx * j, cy + sy * i), (0, 0, 0, 0))
    return img


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "roads":
        fill, kerb = Image.open(OUT / "road_fill.png"), Image.open(OUT / "road_edge.png")
        for name, o in PIECES.items():
            build_piece(fill, kerb, o).save(OUT / f"{name}.png")
        print(f"built {len(PIECES)} road pieces in {OUT}")
    elif cmd == "install":
        for name in sys.argv[2:]:
            shutil.copy(OUT / f"{name}.png", GAME / f"{name}.png")
            print("installed", name)
