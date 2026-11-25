# CLAUDE.md: Necropathy: Gravewatch

Guidance for Claude Code (and any agent) in this repo. Read this, then
`README.md` (how it plays, the tree, the autotest) and `docs/GDD.md` (the
design). `docs/DECISIONS.md` lists every decision the GDD does not cover:
**append a row when you make one.**

## What this is

A fixed-path tower defense built from Necropathy's art, audio and UI, in
Godot 4.3 / GDScript / GL Compatibility, 1280 x 720, one screen per map. The
source game lives in `/home/user/Vampire-Survivors-Clone-Lol`: **read only**
(copy files out with `cp`; never edit it, never run Godot or git in it).

## Owner decisions (override the GDD)

- Act I first (3 maps, 8 towers, 4 spells, 3 bosses, meta). Fixed roads with
  authored spots; road-post blockers kept; name stays "Necropathy: Gravewatch";
  saves separate from Necropathy (the project name gives its own `user://`).
- **Back-to-back waves:** tightly spaced enemies; the next wave starts by itself
  `TdRulesData.AUTO_GAP` s after the previous wave's LAST SPAWN; the first wave
  waits for Call; Call skips the gap for 1 soul per second. No build phase.
- Speed x1 / x2 / x3 and pause.

## Non-negotiable conventions (same as Necropathy)

1. Every script starts with a header comment; **every** member variable,
   constant, exported field and data row key is commented with units / ranges.
2. All tunable numbers in `scripts/data/*.gd` (no logic there), tagged `# GDD §N`
   or `# TUNING (not in GDD)`. No balance numbers in logic scripts (trait / boss /
   spell numbers live in their data rows' args).
3. Static typing everywhere.
4. One path per concern: damage / slows / freeze / weaken / haste / DoT / heals /
   kills / leaks -> `TdCombat`; souls -> `SoulEconomy` (`game.economy`); tower
   stats -> `Tower.recompute()`; difficulty -> `DifficultyModifiers`; meta ->
   `MetaModifiers`; holding enemies -> `RoadBlock` / `BlockBody`.
5. Deterministic per seed: only `game.rng`, only `game.time` (fixed steps), no
   wall clock or instance ids in gameplay. Enemies and shots are pooled; a stored
   enemy reference is checked with `TdEnemy.valid(e, saved_generation)`.
6. No physics engine for units. Prefer textures over draw_circle / polygons in
   anything redrawn every frame. No shader that reads the screen. Never call
   `AudioServer.add_bus()`. A CanvasTexture used in `_draw()` must be cached (a
   draw command keeps only its RID). `SpriteBank.draw()` resets the draw
   transform: mirror / squash by node scale (UnitLayer), never draw_set_transform.
7. Autotest friendly: new systems work headless, never touch `user://` under
   `--autotest`, add a summary line for anything new.
8. Commits: no model names; end with the `Claude-Session:` line you were given.

## Commands

```bash
G=/home/user/tools/godot/Godot_v4.3-stable_linux.x86_64
$G --headless --import                                  # must print no errors
$G --headless --fixed-fps 60 --quit-after 40000 -- --autotest --seed=1          # default build (~4 s wall)
$G --headless --fixed-fps 60 --quit-after 40000 -- --autotest --seed=1 --build=weak
# Web: mkdir -p build/web && touch build/.gdignore; $G --headless --export-release "Web" build/web/index.html;
#      python3 tools/patch_web_audio.py build/web/index.js   (always; it also runs the GL patch)
```
Run at most 4 Godot processes at once (4-core machine).

**Done means:** `--import` clean; the autotests you touched (at least default
and `--build=weak`, two seeds) show zero `SCRIPT ERROR` / `ERROR:` / `WARNING:`
lines and `stuck_enemies=0`; the same seed twice gives an identical summary;
for balance changes, several seeds; the Web build boots and plays. Act I
must reproduce the baseline summaries in `docs/BALANCE.md` unless the change
is meant to rebalance it (then record the new ones there).

## Extension points (add content in NEW files; shared edits stay small and additive)

**Tower class** — a row in `TowerData.TOWERS` (keys documented there: name,
sprite, icon, spot "plot"|"post", cost, behavior, range, damage, interval,
target, + projectile / aura / blocker keys, volley, evolution), 5 rows in
`TowerData.LEVELS`, its id in `TowerData.ORDER`. Behaviour = `scripts/towers/<behavior>.gd`
loaded by name; reuse `projectile` / `aura` / `blocker`, or write a new file
`extends "res://scripts/towers/projectile.gd"` (or `TowerBehavior`) overriding:
`setup(t: Tower)`, `on_recompute(t: Tower)`, `step(t: Tower, dt: float)`,
`volley(t: Tower, target: TdEnemy)`, `on_removed(t: Tower)`,
`draw_body(t: Tower, ci: CanvasItem, index: int)`, `draw_overlay(t: Tower)`.
Fire shots with `t.game.projectiles.fire(t, target, damage, sprite, tint, is_volley)`;
per-tower state in `t.vars`; stats only from `t.stats`. Add its sound to `TdSoundData.FIRE`.

**Evolution (tier 6)** — a row in `EvolutionData.EVOLUTIONS`: from, name, sprite,
icon, stats {damage|rate|range|hp: mult}, set {row key: value}, recipe. Recipe
types in `Evolutions.recipe_met(t: Tower, game: TdGame) -> bool`: `kills` {n},
`damage` {n}, `healed` {n}, `near` {class, radius}, `near_level` {class, level,
radius}; a new type is one
`match` branch. The base tower row's `evolution` names it. Never hint recipes.

**Synergy** — a row in `SynergyData.SYNERGIES`: name, icon, a, b, radius,
effects {"a"|"b": {damage|rate|range|hp: mult, hold_bonus: +n}}, hint.
`Synergies.evaluate()` runs on build / sell / upgrade / evolve; behaviours can
test `t.synergies` ([id, partner] pairs) for conditional effects. Optional keys:
`hit` {side, vs frozen|staggered|weakened, mult} (applied once per hit by
`Synergies.hit_mult()` from `TdCombat.damage_enemy()`), `extend_weaken`, `aim`
(read by the class kits through `Synergies.value()`).

**Act** — see `docs/ACT_TEMPLATE.md` (the checklist) and the section "Act
framework" below. Later acts put enemy kinds, build orders and moods in their
own data file, not in the Act I tables.

**Enemy kind** — a row in `TdEnemyData.KINDS` (Act I; later acts: their act data file's `KINDS`; read every row through `Acts.kinds()`): name, sprite, rank
(fodder|elite|miniboss|boss), hp, speed, armour (flat), radius, damage,
attack_interval, flying, ignores_walls, trait, args. Trait = `scripts/enemies/traits/<trait>.gd`
`extends EnemyTrait`, one shared instance, per-enemy state in `e.vars`, hooks:
`on_spawn(e: TdEnemy, game: TdGame)`, `step(e, game, dt: float)` (auras: query
`game.enemies_near(pos, r)` and call `TdCombat.haste_enemy / heal_enemy`),
`incoming_damage(e, game, amount: float, hit: Dictionary) -> float` (hit keys:
source, tower, origin, dot, armour_pierce), `on_hit(e, game, amount, hit)`,
`on_death(e, game)`. Other enemy hooks: `e.unholdable_until`, `e.pose` (boss pose).

**Boss** — a kind of rank "boss" whose trait is `scripts/bosses/<id>.gd`
(`extends EnemyTrait`, same hooks, numbers in its row's args; see `alaric.gd`).
Put it in the map's final wave (MapLoader.validate() requires a boss there).
Minibosses are rank "miniboss" kinds (their death grants the chest).

**Map** — `scripts/maps/<id>_map.gd` with `const MAP` (every key documented in
`graveyard_map.gd`: id, name, floor, decals, obstacles, roads {id: {points,
next, next_at, entrance}}, gate, plots, posts, lives, souls, rule, build_order,
waves [{banner, groups [{kind, count, spacing, delay, road}]}], weak_order) —
Act I maps are preloaded in `MapRegistry.MAPS`; a later act's map is found by
its file name once its ActData row lists the id. Merging roads: a side road with `next` = the main road and
`next_at` = the join distance on it. Its build orders go in its act data file's `ORDERS` (Act I: `BuildOrderData`); its music comes from its act row.

**Map rule** — `scripts/maps/rules/<id>.gd` `extends MapRule` (MAP "rule": id):
`setup()`, `step(dt: float)`, `tower_damage_mult(t: Tower) -> float` (read by
`Tower.recompute()`); numbers in a new data file. Add nodes under `game.world`.

**Spell** — a row in `SpellData.SPELLS` (name, icon, cooldown, target
"enemy"|"road"|"point", ready, own numbers) and `scripts/spells/<id>.gd`
`extends TdSpell`: `cast(pos: Vector2) -> bool` (false = nothing targeted, no
cooldown), `step(dt: float)`, `draw(ci: CanvasItem)` (map coords), `busy() -> bool`.
Fields `game`, `id`, `row`. Road helpers: `game.nearest_road(pos, max_d)`,
`Road.project(p)`, `Road.point_at(d)`; blocking: `game.add_block(RoadBlock)`.

**Ultimate** — `SpellData.ULTIMATE` + a TdSpell script (Dread Rally); the meter is
`SpellCaster.charge(rank)` per kill. Later ultimates: a row in `SpellData.ULTIMATES`
(name, icon, desc, unlock, sound, own numbers), its id in `CharacterData.ULTIMATES`,
`scripts/spells/<id>.gd`, a `TdVfxData.SPELLS` row; the run's pick is `SpellCaster.ultimate_id`.

**Act tower (later acts, gw2-kit)** — each act's unlockable summon class is one
`TowerData.TOWERS` row with `"unlock": {"map": "<the act's finale map>"}` (one
reader: `Unlocks`; rows may also use `{"map", "skulls"}`), 5 `LEVELS` rows, its id
appended to `ORDER`, `scripts/towers/<id>.gd`, an `EvolutionData` row, a
`SynergyData` pair, a `TdVfxData.SHOTS` row and a `TdSoundData.FIRE` sound. The
build menu pages (`TdUiData.MENU_PAGE`), the Codex scrolls and the mastery badges
wrap, so ~30 towers fit; masteries need nothing (any class at Lv 5). A tower
that cannot hit flyers says `"ground_only": true`. Spells use the same `unlock` key.

**Art** (regenerated with the image API for roads and candles, DECISIONS V17; `tools/gw_gen.sh`, `gw_tile.py`, `gw_art.py`, originals in `art_source/td_pillow/`) — Gravewatch-only roles in `TdArtData.ROLES` (drawn with `TdArt.draw /
texture`); Necropathy sprites by their `SpriteData` key via `SpriteBank`.

## Status (wave 2a integrated, Nov 2026)

Built and live: **Act I** (Graveyard, Crimson March, Sanctum; Sir Alaric, Marshal
Vael, Grand Inquisitor Seraphine; ten Covenant traits; the Templar Commander and
Cathedral Guardian minibosses; the Reckoning endless mode), **the act framework**
(all fifteen acts listed, Acts II-XV "Coming soon"; act tabs; act rules; hostile
fire, tower disable, flyers, off-road trails; hidden test act), **14 towers** (8
Act I + Crypt Warder, Grave Rogue, Crypt Gargoyle, Bone Hounds, Fallen Seraph,
Bone Golem) with class kits and 14 hidden evolutions, 11 synergies, **8 spells**
(Shadow Bolt, Bone Wall, Corpse Explosion, Plague Cloud, Death Mark, Soul Chains,
Wither, Raise Dead), **4 ultimates** (Dread Rally, Sovereign's Decree, Eclipse,
Grave Tide), **8 characters**, unlocks (save version 2 + migration), difficulty
levels, menus (title, map select with act tabs, pre-map setup, Ossuary,
Codex, Settings, Credits, results), meta save + backup codes, masteries, gamepad
cursor, touch layout, synthesized sounds, CI with a map matrix, Web build.

Balance: `docs/BALANCE.md` (the blocker HP fix and Act I rebalance of wave 2a
are its first section, with the **Act I baseline summaries**: any change that
must not touch Act I reproduces them byte for byte). Decisions: `docs/DECISIONS.md`
(I, V, A, K, W rows). Next: wave 2b, one agent per act through
`docs/ACT_TEMPLATE.md` (the one checklist).

Not built / not verified: art regenerated by the image API for the kit (Pillow
and Necropathy art), an auto-publish CI job (needs the owner's `PAGES_TOKEN`),
real-phone and real-gamepad tests. Known: the default build orders lean on
Dread Rally; with any other ultimate they often lose (the bot casts every
ultimate as soon as it is ready).

Rules to keep (DECISIONS I1-I13, W1): the damage order in
`TdCombat.damage_enemy()`; one structure rule (`Tower.pick_target()` puts
structures last; area effects use `TdGame.foes_near()`); one silence test
(`EnemyTrait.can_heal()`); one target test (`Tower.can_hit(e)`: `ground_only`
and `TdGame.can_target()`, asked by every pick, kits too); the wave HP ramp
(`TdRulesData.WAVE_HP_*`, map key `wave_hp_end`). The Web build reads
`?gw_autotest=--map=sanctum,--speed=8` to run the bot on screen and
`?gw_flags=--unlock-all` to open every later tower / spell / ultimate /
character in the menus.

## Visual conventions (owner-approved look, Nov 2026)

The owner approved this look ("runs smoothly and looks good"); it is the bar for
all new content. Proposal: <https://claude.ai/artifact/A89UtBCRguk6NSUCD7qQkS>;
decisions `docs/DECISIONS.md` V1-V15. **A fight must read in one still frame.**

1. **Nothing happens silently.** Every shot, blow, hit, death, heal, status,
   cast and leak has a visible effect. New content is not done without its look:
   - new tower: a row in `TdVfxData.SHOTS` (its own tint; shot 40+ px on screen,
     trail 60-90 px, muzzle flash, impact burst; an area hit shows its REAL
     radius); a blocker goes through `game.vfx.melee()` (lunge + slash);
   - new evolution: nothing to add, `EVOLVED_MULT` makes it louder (give it its
     own slash / shot tint if it has a theme);
   - new enemy / boss: hit flash and death burst come by rank; its attack on a
     blocker calls `game.vfx.enemy_blow()`; a boss has a strike pose;
   - new status: one body tint and one icon (`TdVfxData.STATUS_ORDER` / `STATUS_TINT` / `STATUS_ICON`, art `td/vfx_status.png`);
   - new spell: `game.vfx.cast(id, pos)` plus its own burst colour;
   - new map: a `TdMoodData.MOODS` row (props with glows, ambient layer).
2. **One colour per tower class**, used for its trail, flash and impact, so the
   player sees who did what. Gold-white = friendly melee, red = enemy blows.
3. **Visuals never touch the simulation.** Gameplay calls `game.vfx.<event>()`
   AFTER resolving the event; lunges, nudges and shakes are drawn offsets
   (`vis_*` fields, never read by gameplay); never `game.rng` (hash or a visual
   RNG); nothing runs headless. Gate: the same-seed summaries stay byte-identical.
4. **All visual numbers in `TdVfxData` / `TdMoodData`** (tagged, commented), new
   art made by `tools/vfx_art.py` or reused from Necropathy's `effects/` strips.
5. **Cheap drawing.** Textures only (no per-frame polygons or circles), glows and
   trails on the additive layers, no screen-reading shaders, no full-screen
   overlays (edge bands instead), effects pooled under the cap (160 Full / 70
   Reduced).
6. **Three settings must keep working:** Effects Full / Reduced (Reduced keeps
   shots, slashes, impacts, deaths; drops trails, wisps, fog, glows, breathing),
   Reduce motion (no lunges, shake, recoil), Screen shake. Damage numbers stay
   off by default.
7. **The interface stays off the fight:** banners inside the top bar, menus open
   away from neighbouring spots, nothing covers a road.
8. **Check by eye.** Build the Web export, run `?gw_autotest=--map=<id>,--speed=1`
   in Playwright at 1280x720 and phone landscape, look at the screenshots, and
   compare the late-Sanctum frame time with DECISIONS V15 before publishing.

### How it is built

`TdVfx` (`game.vfx`) + `TdVfxData`: every shot, melee blow, hit, death, status,
leak and tower shot gets its look there (DECISIONS V1-V8). Gameplay code only
calls `game.vfx.<event>()` after resolving the event; visual state on units is
the `vis_*` fields (TdEnemy, BlockBody), never read by the simulation. Off
headless; never use `game.rng` for visuals. Same-seed summaries must stay identical.
Battlefield moods: `MapMood` (`scripts/td/map_mood.gd`) + `TdMoodData` (props,
glows, fog, light pools, vignette, road wear, spot looks); a new map adds a
`TdMoodData.MOODS` row. Damage numbers: `game.vfx.number()` from
`TdCombat.damage_enemy()`, off by default (Settings > Video).

## Systems reference (one path each)

- **Tower kits** (`scripts/towers/<class>.gd`): evolution numbers in
  `EvolutionData` "set"; hooks `TowerBehavior.impact(t, shot, victims)`,
  `TdProjectiles.fire_at()` (lobbed, telegraphed), `add_field()` (ground damage
  fields), `TdGame.enemy_killed(e, tower)`. Status helpers in `TdCombat`:
  `curse_enemy / silence_enemy / stagger_enemy / ward_enemy / suppress_tower /
  barrier_body / shred_enemy / swoop_enemy / disable_tower / empower_enemy`.
  **Healer traits skip their heal unless `EnemyTrait.can_heal(e, game)`.**
  Blockers: `BlockBody` (`barrier`, `damage_cut`, `temporary`), held enemies'
  hits x `TdRulesData.BLOCKER_HIT_MULT`; every temporary Risen through
  `TempBlockers.raise()` (never on an off-road trail). Recipe types also `any`
  {of} and `elite_kills` {n}; synergy statuses also `slowed` / `swooped`.
- **Enemies and maps**: EnemyTrait hooks also `on_attack` and `note()`;
  `TdGame.spawn_at()`, `spawn_from_body()` (claims), `WaveDirector.spawn_extra()`;
  `MapRule.summary()` / `finish_structures()`; enemy row key `structure`; map
  unlocks follow the campaign order (`Meta.unlock_after()`, a map's
  `unlock_after` overrides).
- **Acts** (`ActData.ACTS`, the one ordered list; lookups in `Acts`: map order,
  act of a map, position in act, prev / next map, merged `kinds()` / `orders()` /
  `moods()`, `data(act)`): MapRegistry fills act defaults (floor, mood, music,
  act_rule). Act rule hooks `on_wave_start / on_spawn / on_kill / on_body_fallen /
  can_target`. `game.hostile.fire() / shell()` (shots stopped by blockers,
  Bone Walls and Risen; telegraphed shelling). Flyers: row `flying`; a tower
  skips them only with row `ground_only`. Off-road trails: road keys `off_road`
  / `exit`. Generic traits `shooter`, `trampler`. Maps need `build_order` +
  `weak_order` (validated). Soul Ash x1 / x1.25 / x1.5 by position in act.
- **Menus, meta, saves**: screens extend `MenuScreen` (layout in `MenuData`);
  `Meta` owns the save (version 2, `Meta.migrate()` on load), the Ossuary and
  masteries reach a run only through `MetaModifiers`; characters only through
  `CharacterModifiers` (the Gravecaller changes nothing); later towers / spells /
  ultimates open through `Unlocks` (menus only; a run never asks); Codex and
  masteries are recorded by `RunWatch`; screens read lists from the data
  tables, so new content appears by itself. The build menu pages
  (`TdUiData.MENU_PAGE`); tiles take an optional `short` name.
- **Autotest and tools**: `--build=` any order (Act I: `graveyard_default`,
  `weak`, `march_*`, `sanctum_*`, `towers_a|b`, `evolve_all`, `kit_a|kit_b`
  (every Act I map), `kit_evolve`; test act `test_default|test_kit|test_weak`),
  `--ultimate=`, `--swap=from:to`, `--character=`, `--meta=`, `--reckoning`,
  `--test-act`. Every run prints `leak_curve=`; kit runs add `tower_value=` /
  `kit=`, act runs `act_rule=` / `hostile=`. Tools: `tools/run_all_maps.sh`
  (`WEAK=1`, `SEED=`), `tools/map_list.tscn` (the CI matrix),
  `tools/towers_check.tscn`, `tools/meta_check.tscn`, `tools/acts_check.tscn`.
