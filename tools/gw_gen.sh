#!/bin/bash
# gw_gen.sh NAME SUFFIX QUALITY "prompt" ref1 [ref2 ...]: one gpt-image call for a Gravewatch piece (docs/art/generation_ledger.csv).
cd "$(dirname "$0")/.." || exit 1
export OPENAI_API_KEY=${OPENAI_API_KEY:-proxy-injected} GEN_LEDGER=$PWD/docs/art/generation_ledger.csv
n=$1; s=$2; q=$3; p=$4; shift 4
STYLE="Low-resolution pixel art for a dark-gothic tower defense game: the whole piece is drawn on a coarse pixel grid and shown enlarged, every pixel a big crisp square block (nearest-neighbour). Chunky simple readable shapes, no detail smaller than 2 pixels except tiny glints, flat colours only, at most 3 shades per material, no gradients, no dithering, no anti-aliasing, no soft glow haze. A clean 1-pixel dark outline in the darkest shade of each part's own colour (never pure black), light from the top-left. Palette: cold slate greys, warm bone ivory, dark browns, crimson and gold accents, teal-green soul fire. Match the attached reference sprites exactly in pixel size, outline weight and palette. Fully transparent background (real alpha), no ground, no cast shadow, no text, no frame."
printf '%s\n\n%s\n' "$p" "$STYLE" > art_source/td_gen/${n}.txt
args=(); for r in "$@"; do args+=(--ref "$r"); done
python3 tools/gen_image.py art_source/td_gen/${n}.txt art_source/td_gen/${n}_${s}.png "${args[@]}" --key "$n" --quality "$q" ${SIZE:+--size $SIZE} 2>&1 | tail -1
