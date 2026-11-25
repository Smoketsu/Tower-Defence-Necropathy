# Morning report: Gravewatch phase 1 (Nov 25, 2026)

## What is in

Act I is complete and playable on the Web:

- **Three maps**: the Desecrated Graveyard (Sir Alaric charges through posts),
  the Crimson March (two roads into a trunk, Holy Ward Generators, Marshal Vael's
  side-lane squads and Shieldwall), the Sanctum of Judgment (one long road, two
  warded chambers, Cathedral Guardian, Grand Inquisitor Seraphine blinking down
  the road with healing attendants). Each opens after the previous boss falls.
- **8 towers** with their class kits, **8 evolutions** (hidden recipes),
  **4 synergies**, **4 spells** + Dread Rally, all ten Covenant enemy traits,
  difficulty levels, the **Reckoning** endless mode after a clear.
- **Menus and meta**: title, map select with skull records, pre-map setup
  (character, spells, difficulty), Ossuary (Soul Ash upgrades + masteries),
  Codex, Settings (audio, video, rebindable keys, save backup codes), Credits,
  results with Soul Ash. Saves persist in the browser (checked across a reload).
- Mouse, touch (phone landscape layout: spells in a left column, the map below
  the top bar) and gamepad.

## How to play

Open the GitHub Pages build of Gravewatch-Play (pushed from this commit), press
Play, pick the Graveyard, Start. Tap a grave plot or road post to build, tap a
tower to upgrade / retarget / sell / evolve. Enter calls the next wave, Tab
changes speed (x1/x2/x3), 1-4 arm spells, Space is Dread Rally, Esc pauses.

## How it was tested

- Headless autotest bot (fixed build orders): every map x default / losing
  order / 2 seeds / same seed at two speeds (identical) / `--reckoning` /
  `--meta=max` / all four difficulties / each character: zero script errors or
  warnings, no stuck enemies. Towers and meta self-check scenes pass.
- Balance: 8-seed batches per map and difficulty (`docs/BALANCE.md`).
- Web build in headless Chromium (Playwright): desktop 1280 x 720 and Pixel 7
  landscape with real taps; title, map select, setup, building, upgrading, every
  spell, the ultimate, pause, a defeat and a victory results screen, Ossuary,
  Codex, Settings, backup-code restore, reload (save kept); the bot played all
  three maps to their bosses on screen (`?gw_autotest=` query). Screenshots in
  /home/user/gw_shots/final_*.png.

## Known weak spots

- Balance is tuned against the bot's scripted orders. Lich on the Sanctum is
  won by 1 seed in 4 with the default order; the Graveyard on Necromancer loses
  blockers but rarely lives. Once leaks start a run can collapse in two waves.
- Support-heavy builds (Banshee, Mender, two blockers) lack damage on their own.
- The spot menu can cover a neighbouring spot; banners sit over the top road.
- Gamepad cursor untested on a real pad; phones only tested in emulation.

## Needs you

1. **Art**: every new piece (Gravewatch-only roles, ward generator / crystal,
   three character portraits) was hand-drawn with Pillow because the image key
   expired. Regenerate when the key is renewed.
2. **A real phone test** (iPhone Safari first: sound unlock, frame rate late in
   the Sanctum, tap sizes of the top bar).
3. **`PAGES_TOKEN`** secret if you want CI to publish the Web build itself; CI
   already builds it as an artifact.
