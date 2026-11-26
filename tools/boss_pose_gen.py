"""boss_pose_gen.py KEY [KEY...]: one gpt-image edit call per boss for its strike pose (DECISIONS Z10).

Reads art_source/boss_poses/bosses.py (still key, name, pose text), builds the reference (the still,
nearest-neighbour enlarged on a transparent 1024 canvas, feet on a fixed baseline), writes the prompt to
art_source/boss_poses/<key>.txt, the raw generation to <key>_raw<N>.png and logs the call in
docs/art/generation_ledger.csv through tools/gen_image.py. Option --n N picks the attempt number.
"""
import subprocess, sys, os
from pathlib import Path
from PIL import Image
sys.path.insert(0, "art_source/boss_poses")
from bosses import B
ROOT = Path(__file__).resolve().parent.parent
CANVAS = 1024  # px, square generation canvas
FIT = 860      # px, the still's longest side after enlargement
STYLE = ("Low-resolution pixel art game sprite for a dark-gothic fantasy tower defense game (three-quarter top-down view), shown enlarged on a coarse pixel grid: "
         "every pixel a big crisp square block, chunky simple readable shapes, flat colours, at most 3 shades per material, no gradients, no dithering, no anti-aliasing, no soft glow haze. "
         "A clean 1-pixel dark outline in the darkest shade of each part's own colour, light from the top-left. ")
def main() -> None:
    args = sys.argv[1:]; n = 1
    if "--n" in args:
        i = args.index("--n"); n = int(args[i + 1]); del args[i:i + 2]
    for k in args:
        still, name, pose = B[k]
        im = Image.open(ROOT / f"assets/sprites/{still}.png").convert("RGBA")
        s = max(1, FIT // max(im.size))
        im = im.resize((im.width * s, im.height * s), Image.NEAREST)
        ref = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
        ref.alpha_composite(im, ((CANVAS - im.width) // 2, (CANVAS - im.height) // 2))
        rp = ROOT / f"art_source/boss_poses/{k}_ref.png"; ref.save(rp)
        extra = (ROOT / f"art_source/boss_poses/{k}_extra.txt").read_text() if (ROOT / f"art_source/boss_poses/{k}_extra.txt").exists() else ""
        prompt = (f"The attached image is the pixel-art sprite of {name}, a boss. Draw the SAME character (identical costume, colours, face, proportions, body size, pixel size and outline weight, same facing direction) "
                  f"in a STRIKE POSE: the moment a blow lands, {pose}. Keep the whole figure at the same scale as the attached sprite and the feet (lowest point) on the same baseline; keep the same camera angle and the same facing side. "
                  f"The pose must be a clear, dynamic attack silhouette reaching toward the side the character faces, with no limb or weapon cut off by the image edge. {extra}\n\n" + STYLE +
                  "Fully transparent background (real alpha), no ground, no cast shadow, no text, no frame, one figure only.")
        tp = ROOT / f"art_source/boss_poses/{k}.txt"; tp.write_text(prompt)
        out = ROOT / f"art_source/boss_poses/{k}_raw{n}.png"
        env = dict(os.environ, OPENAI_API_KEY=os.environ.get("OPENAI_API_KEY", "proxy-injected"))
        r = subprocess.run([sys.executable, "tools/gen_image.py", str(tp), str(out), "--ref", str(rp), "--key", f"pose_{k}_{n}", "--quality", "medium"], cwd=ROOT, env=env, capture_output=True, text=True)
        print(k, (r.stdout.strip().splitlines() or [r.stderr[-200:]])[-1], flush=True)
main()
