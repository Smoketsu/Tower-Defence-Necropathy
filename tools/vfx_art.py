#!/usr/bin/env python3
"""Draws Gravewatch's combat-effect art (the visual-only pass, DECISIONS V1-V6)
in Necropathy's pixel style, with Pillow, into assets/sprites/td/:

  vfx_slash.png   6 frames of 48 x 48: a sword crescent sweeping over its target
                  (grey / white mask, tinted in code: bone-white for the
                  Warrior, red for an enemy's blow). The arc faces +x.
  vfx_streak.png  32 x 8 white streak, transparent at x = 0, opaque at x = 31:
                  stretched and tinted behind a shot as its trail.
  vfx_status.png  6 icons of 9 x 9 side by side (burning, rot, cursed, slowed,
                  frozen, weakened), in colour with a dark outline.
  vfx_crack.png   44 x 20 ground crack (the Abomination's smash), in colour.

Deterministic (fixed seed). Run: python3 tools/vfx_art.py
"""
import math
import os
import random

from PIL import Image

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "sprites", "td")


def slash() -> Image.Image:
    fw = 48
    frames = 6
    img = Image.new("RGBA", (fw * frames, fw), (0, 0, 0, 0))
    cx, cy, rad = 14.0, 24.0, 21.0  # Arc centre and outer radius (px in a frame).
    a0, a1 = math.radians(-78), math.radians(78)  # Arc start (tail) and end (head).
    for f in range(frames):
        # Head sweeps over frames 0-2; the tail catches up over 3-5.
        head = a0 + (a1 - a0) * min(1.0, (f + 1) / 3.0)
        tail = a0 + (a1 - a0) * max(0.0, (f - 2) / 3.2)
        fade = 1.0 if f < 4 else (0.7 if f == 4 else 0.4)
        for y in range(fw):
            for x in range(fw):
                dx, dy = x + 0.5 - cx, y + 0.5 - cy
                r = math.hypot(dx, dy)
                a = math.atan2(dy, dx)
                if a < tail or a > head:
                    continue
                t = (a - tail) / max(head - tail, 1e-3)  # 0 at the tail, 1 at the head.
                thick = 1.5 + 6.5 * t ** 0.7  # Thicker toward the head (px).
                if r > rad or r < rad - thick:
                    continue
                edge = rad - r  # Depth from the outer edge (px).
                if edge < 2.0:
                    v, al = 255, 255
                elif edge < thick * 0.6:
                    v, al = 225, 220
                else:
                    v, al = 170, 150
                img.putpixel((f * fw + x, y), (v, v, v, int(al * fade)))
    return img


def streak() -> Image.Image:
    w, h = 32, 8
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    rows = [0.15, 0.45, 0.8, 1.0, 1.0, 0.8, 0.45, 0.15]
    for y in range(h):
        for x in range(w):
            a = (x / (w - 1)) ** 1.6 * rows[y]
            img.putpixel((x, y), (255, 255, 255, int(255 * a)))
    return img


# 9 x 9 status icons: '.' clear, 'o' outline, then colour letters per icon.
ICONS = [
    # burning: a flame
    ("....o....", "...oyo...", "...oyyo..", "..oyrryo.", ".oyrrrryo", ".oyrwwryo", ".oyrwwryo", "..oyrryo.", "...oooo.."),
    # rot: a green drop with a dark spot
    ("....o....", "...ogo...", "...ogo...", "..oggGo..", ".oggggGo.", ".ogkgggo.", ".oggkggo.", "..ogggo..", "...ooo..."),
    # cursed: a violet eye
    (".........", "..ooooo..", ".ovvvvvo.", "ovvwkwvvo", "ovwkkkwvo", "ovvwkwvvo", ".ovvvvvo.", "..ooooo..", "........."),
    # slowed: two blue down chevrons
    ("ob.....bo", ".ob...bo.", "..ob.bo..", "...obo...", "ob..o..bo", ".ob...bo.", "..ob.bo..", "...obo...", "....o...."),
    # frozen: a snowflake
    ("....o....", ".o.oco.o.", "..ocwco..", ".ocwwwco.", "ocwwcwwco", ".ocwwwco.", "..ocwco..", ".o.oco.o.", "....o...."),
    # weakened: a broken purple blade
    ("......oo.", ".....opo.", "....opo..", "...opo...", "..o.o....", ".opo.....", "oppo.....", "oyo......", ".o......."),
]
COLOURS = {
    "o": (24, 14, 28, 255), "y": (255, 214, 90, 255), "r": (236, 96, 40, 255), "w": (255, 255, 240, 255),
    "g": (120, 200, 70, 255), "G": (180, 240, 120, 255), "k": (40, 70, 30, 255), "v": (170, 90, 230, 255),
    "b": (120, 190, 255, 255), "c": (150, 215, 255, 255), "p": (200, 140, 255, 255),
}


def status() -> Image.Image:
    img = Image.new("RGBA", (9 * len(ICONS), 9), (0, 0, 0, 0))
    for i, rows in enumerate(ICONS):
        for y, row in enumerate(rows):
            for x, ch in enumerate(row):
                if ch in COLOURS:
                    c = COLOURS[ch]
                    if ch == "k" and i == 2:
                        c = (30, 10, 40, 255)
                    img.putpixel((i * 9 + x, y), c)
    return img


def crack() -> Image.Image:
    w, h = 44, 20
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    rng = random.Random(7)
    dark, lip = (38, 26, 22, 235), (120, 96, 70, 200)
    for k in range(7):
        ang = k / 7.0 * math.tau + rng.uniform(-0.3, 0.3)
        x, y = w / 2.0, h / 2.0
        length = rng.uniform(9, 20)
        for s in range(int(length)):
            ang += rng.uniform(-0.45, 0.45)
            x += math.cos(ang)
            y += math.sin(ang) * 0.5  # Flattened: the ground in perspective.
            ix, iy = int(x), int(y)
            if 0 <= ix < w and 0 <= iy < h:
                img.putpixel((ix, iy), dark)
                if s < length * 0.6 and ix + 1 < w:
                    img.putpixel((ix + 1, iy), dark)  # Wider near the centre.
                if s < length * 0.5 and 0 <= iy + 1 < h and img.getpixel((ix, iy + 1))[3] == 0:
                    img.putpixel((ix, iy + 1), lip)
    return img


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    slash().save(os.path.join(OUT, "vfx_slash.png"))
    streak().save(os.path.join(OUT, "vfx_streak.png"))
    status().save(os.path.join(OUT, "vfx_status.png"))
    crack().save(os.path.join(OUT, "vfx_crack.png"))


if __name__ == "__main__":
    main()
