#!/usr/bin/env python3
"""Draws the Olympian Republic's (Act VIII, w2c-pantheon) Gravewatch-only art
in Necropathy's pixel style, with Pillow, into assets/sprites/td/:

  shield_arc.png  12 x 30: a hoplite's bronze shield seen edge-on as an arc
                  bulging toward +x (the side it faces), dark outline, a lit
                  rim and a teal-free bronze body; drawn rotated in front of
                  every phalanx body by PantheonLayer (tinted white = as is).

Deterministic. Run: python3 tools/pantheon_art.py
"""
import math
import os

from PIL import Image

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "sprites", "td")

OUTLINE = (34, 22, 12, 255)
BRONZE_DARK = (122, 74, 28, 255)
BRONZE = (184, 120, 48, 255)
BRONZE_LIT = (240, 196, 110, 255)


def shield_arc() -> Image.Image:
    w, h = 12, 30
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    cy = (h - 1) / 2.0
    for y in range(h):
        t = (y - cy) / cy  # -1..1 along the shield
        bulge = math.sqrt(max(0.0, 1.0 - t * t))
        x_out = 2.0 + 7.5 * bulge  # outer face
        x_in = x_out - 3.2  # inner face (thickness)
        for x in range(w):
            if x_in - 0.5 <= x <= x_out + 0.5:
                if x >= x_out - 0.6:
                    c = BRONZE_LIT
                elif x <= x_in + 0.6:
                    c = BRONZE_DARK
                else:
                    c = BRONZE
                img.putpixel((x, y), c)
    # One-pixel dark outline around the opaque pixels.
    src = img.copy()
    for y in range(h):
        for x in range(w):
            if src.getpixel((x, y))[3] == 0:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and src.getpixel((nx, ny))[3] > 0:
                        img.putpixel((x, y), OUTLINE)
                        break
    return img


if __name__ == "__main__":
    shield_arc().save(os.path.join(OUT, "shield_arc.png"))
    print("wrote shield_arc.png")
