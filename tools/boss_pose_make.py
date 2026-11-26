"""boss_pose_make.py KEY [--n N] [--h H]: turn art_source/boss_poses/<KEY>_raw<N>.png into assets/sprites/<still>_strike.png.

The model keeps the still's size only roughly, so the pose's scale is estimated from the opaque-area ratio against the
enlarged reference (f = sqrt(area_pose / area_ref)); the art height is then bbox_height / (enlarge * f) unless --h
forces it. tools/prepare_sprite.py does the grid conversion (palette, outline, feet on the bottom row, body centred).
Prints the height and adds / updates the HEIGHTS row in scripts/data/sprite_data.gd. Also writes a 3x sheet
(still | strike) to /home/user/gw_shots/boss_poses/<KEY>.png.
"""
import re, subprocess, sys
from pathlib import Path
import numpy as np
from PIL import Image
sys.path.insert(0, "art_source/boss_poses")
from bosses import B
ROOT = Path(__file__).resolve().parent.parent
def main() -> None:
    a = sys.argv[1:]; k = a[0]; n = int(a[a.index("--n") + 1]) if "--n" in a else 1
    still, name, pose = B[k]
    ref = np.array(Image.open(ROOT / f"art_source/boss_poses/{k}_ref.png").convert("RGBA"))[..., 3] > 128
    raw = Image.open(ROOT / f"art_source/boss_poses/{k}_raw{n}.png").convert("RGBA")
    m = np.array(raw)[..., 3] > 128
    ys, xs = np.where(m); bh = ys.max() - ys.min() + 1
    still_img = Image.open(ROOT / f"assets/sprites/{still}.png")
    enlarge = 860 // max(still_img.size)
    f = (m.sum() / ref.sum()) ** 0.5
    h = int(a[a.index("--h") + 1]) if "--h" in a else int(round(bh / (enlarge * f)))
    key = still + "_strike"
    # the HEIGHTS row must exist before prepare_sprite reads it
    sd = ROOT / "scripts/data/sprite_data.gd"; t = sd.read_text()
    row = f'\t"{key}": {h}.0,  # TUNING (not in GDD) boss attack pose (strike: {pose.split(",")[0]}; BossPoseData 3): body as tall as the still; the pose sets the height\n'
    t = re.sub(r'\t"' + re.escape(key) + r'": .*\n', "", t)
    anchor = f'\t"{still}": '
    i = t.index(anchor); j = t.index("\n", i) + 1
    sd.write_text(t[:j] + row + t[j:])
    # allowed ramps = the ramps the still itself uses (>= 0.8% of its pixels, outline inks aside)
    import json
    pal = {c["hex"].lstrip("#").upper(): c for c in json.load(open(ROOT / "tools/palette.json"))["colors"]}
    px = np.array(still_img.convert("RGBA")).reshape(-1, 4); px = px[px[:, 3] > 128]
    cnt: dict = {}
    for r_, g_, b_, _ in px:
        c = pal.get("%02X%02X%02X" % (r_, g_, b_))
        if c and c["group"] != "ink": cnt[c["ramp"]] = cnt.get(c["ramp"], 0) + 1
    ramps = ",".join(sorted(r for r, v in cnt.items() if v >= 0.008 * len(px)))
    r = subprocess.run([sys.executable, "tools/prepare_sprite.py", str(ROOT / f"art_source/boss_poses/{k}_raw{n}.png"), key, "--art-height", str(h), "--ramps", ramps], cwd=ROOT, capture_output=True, text=True)
    print(k, "H", h, ramps, "f %.2f" % f, (r.stdout.strip().splitlines() or r.stderr.splitlines())[-1][:150])
    # sheet
    a1 = Image.open(ROOT / f"assets/sprites/{still}.png").convert("RGBA"); a2 = Image.open(ROOT / f"assets/sprites/{key}.png").convert("RGBA")
    S = 3; W = (a1.width + a2.width) * S + 30; H = max(a1.height, a2.height) * S + 10
    sh = Image.new("RGBA", (W, H), (40, 40, 48, 255))
    sh.alpha_composite(a1.resize((a1.width * S, a1.height * S), Image.NEAREST), (5, H - 5 - a1.height * S))
    sh.alpha_composite(a2.resize((a2.width * S, a2.height * S), Image.NEAREST), (a1.width * S + 25, H - 5 - a2.height * S))
    sh.convert("RGB").save(f"/home/user/gw_shots/boss_poses/{k}.png")
main()
