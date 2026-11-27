# Phone readiness of the Web build (Nov 2026, DECISIONS P1-P3)

## What changed

The 45 per-map songs no longer sit in `index.pck`. They ship beside the page as
`music/<map>.ogg` and a run fetches its one song when it starts; the synth loop plays
until it arrives (and keeps playing if the fetch fails). Desktop builds and the headless
autotest are unchanged (same-seed summaries byte-identical: graveyard seeds 1-2,
pandemonium 1, world_tree 1).

Build: export, `python3 tools/patch_web_audio.py build/web/index.js`, then
`sh tools/web_music.sh build/web`. **Publish `index.*` and the `music/` folder.**

## Numbers

Headless Chromium (Playwright), software GL, phone landscape 844 x 390, touch, DPR 2,
`tools/gw_phone.js`, served from localhost. Another agent was running Godot balance
batches on the same 4-core machine during both runs, so the frame times are noisy and
only the before / after pair (same conditions) means anything; they are not
comparable with DECISIONS V15 (1280 x 720, DPR 1, quiet machine: Sanctum 105 / 129 ms).

| | before (all songs packed) | after (songs fetched) |
|---|---|---|
| `index.pck` | 42.4 MB | 13.0 MB |
| Download to the Play gate | 74.5 MB | 46.5 MB (+0.5-1 MB per run for its song) |
| Play -> title screen | 21.9 s | 20.5 s |
| Title: array buffers (wasm + pack) / renderer RSS | 82 MB / 447 MB | 26 MB / 404 MB |
| Sanctum wave 20: mean / p90 frame, renderer RSS | 311 / 383 ms, 443 MB | 263 / 300 ms, 374 MB |
| Pandemonium wave 20 | 297 / 333 ms, 428 MB | 242 / 300 ms, 368 MB |
| World-Tree wave 20 | 362 / 433 ms, 424 MB | 295 / 367 ms, 382 MB |
| Song (Graveyard, through the menus) | in the pack | 200, 709 KB, on the player and playing |
| Song file missing (404) | - | one browser 404 line + one `[audio] song ... not fetched` line; synth loop plays |

The pack is copied into the engine's memory file system, so every MB left out of it is
about a MB less held by the tab for the whole session; renderer memory fell by about
45-70 MB. The frame-time gain is probably mostly noise and less memory pressure; do
not count on it.

## Other findings (not fixed)

- **Play -> title is ~20 s here** in both builds: the startup sound synthesis runs in
  6 ms slices per frame on the Web (`SoundData.WEB_SYNTH_BUDGET_MS`) and software GL
  frames are slow, so it takes many frames. A real phone at 30-60 fps should be far
  quicker; measure it there before changing anything.
- The fetched song arrives in ~3.7 s here (HTTPRequest reads 64 KB per frame and the
  frames are slow); at phone frame rates that is well under a second.
- `index.wasm` (35 MB uncompressed, the stock Godot 4.3 no-threads template) is now the
  biggest download; GitHub Pages serves it compressed.
- No console errors in any run; no growing memory between the title and wave 20.

Shots: `/home/user/gw_shots/phone/` (`before/`, `after/`: title, wave 20 of each map,
the menu path into a run with and without the songs; `desktop_graveyard.png`).

## A real iPhone should check first

1. A run starts with music: the synth loop, then the song fading in within a second or
   two (Safari only plays audio after the Play tap; the song player is created after it).
2. Page memory over a full late run (no reload), and the time from Play to the title.
3. A second run on another map swaps the song (the first one is dropped).
