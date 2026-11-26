#!/usr/bin/env python3
"""gw_map_thumbs.py: the map select's map pictures (DECISIONS M6).

Usage: python3 tools/gw_map_thumbs.py <raw_dir>
<raw_dir> holds 1280x720 Web screenshots named <map>.png, taken by
  node tools/gw_wave_shot.js build/web <raw_dir> 1280x720 <map>:<map>:4:1200 ...
(the bot at wave 4). Each is cropped below the HUD top bar and above the
spell bar, scaled to THUMB_W wide and written to assets/thumbs/<map>.jpg (JPEG source).
Godot imports them with lossy compression (their .import files set
compress/mode=1), so the pack carries small WebP pictures (run the import once, then set compress/mode=1 in any new .import file).
"""
import os
import sys
from PIL import Image

CROP = (0, 54, 1280, 642)  # Map area of a 1280x720 shot (under the top bar, over the spell bar).
THUMB_W = 448  # Output width (px); the card shows it ~344 layout px wide.

raw = sys.argv[1]
out = os.path.join(os.path.dirname(__file__), "..", "assets", "thumbs")
os.makedirs(out, exist_ok=True)
for f in sorted(os.listdir(raw)):
    if not f.endswith(".png"):
        continue
    im = Image.open(os.path.join(raw, f)).convert("RGB").crop(CROP)
    h = round(im.height * THUMB_W / im.width)
    im.resize((THUMB_W, h), Image.LANCZOS).save(os.path.join(out, f[:-4] + ".jpg"), quality=88)
    print("thumb", f)
