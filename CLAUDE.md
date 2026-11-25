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
for balance changes, several seeds; the Web build boots and plays.

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

**Enemy kind** — a row in `TdEnemyData.KINDS`: name, sprite, rank
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
waves [{banner, groups [{kind, count, spacing, delay, road}]}]) and one row in
`MapRegistry.MAPS`. Merging roads: a side road with `next` = the main road and
`next_at` = the join distance on it. Add its default build order to
`BuildOrderData.ORDERS` and its music id in `Sfx.run_mode_for()` if not the Act I loop.

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
`SpellCaster.charge(rank)` per kill.

**Art** — Gravewatch-only roles in `TdArtData.ROLES` (drawn with `TdArt.draw /
texture`); Necropathy sprites by their `SpriteData` key via `SpriteBank`.

## Status (phase 1 integrated, Nov 2026)

Built: Act I complete. Three maps (Graveyard, Crimson March, Sanctum) with
their rules, minibosses and bosses (Sir Alaric, Marshal Vael, Grand Inquisitor
Seraphine), all ten Covenant traits, 8 towers with class kits, 8 evolutions, 4
conditional synergies, 4 spells (Shadow Bolt, Bone Wall, Corpse Explosion,
Plague Cloud) + Dread Rally, difficulty levels, the Reckoning endless mode,
menus (title, map select with records, pre-map setup, Ossuary, Codex,
Settings, Credits, results with Soul Ash), meta save + backup codes,
characters, masteries, gamepad cursor, touch layout, the five synthesized
sounds, CI (`.github/workflows/ci.yml`), Web build. Balance: `docs/BALANCE.md`.
Not built: new hand-drawn art regenerated by the image pipeline (the API key
expired; the new pieces are Pillow-drawn), an auto-publish CI job (needs the
owner's `PAGES_TOKEN`), real-phone and real-gamepad tests. Owner report:
`docs/MORNING_REPORT.md`.

Integration rules to keep (docs/DECISIONS.md I1-I13): the damage order in
`TdCombat.damage_enemy()`; one structure rule (`Tower.pick_target()` puts
structures last; area effects use `TdGame.foes_near()`); one silence test
(`EnemyTrait.can_heal()`); the wave HP ramp (`TdRulesData.WAVE_HP_*`, map key
`wave_hp_end`). The Web build reads `?gw_autotest=--map=sanctum,--speed=8` to run
the bot on screen (for looking at late waves and bosses).

## Combat effects (Nov 2026)

`TdVfx` (`game.vfx`) + `TdVfxData`: every shot, melee blow, hit, death, status,
leak and tower shot gets its look there (DECISIONS V1-V8). Gameplay code only
calls `game.vfx.<event>()` after resolving the event; visual state on units is
the `vis_*` fields (TdEnemy, BlockBody), never read by the simulation. Off
headless; never use `game.rng` for visuals. Same-seed summaries must stay identical.
Battlefield moods: `MapMood` (`scripts/td/map_mood.gd`) + `TdMoodData` (props,
glows, fog, light pools, vignette, road wear, spot looks); a new map adds a
`TdMoodData.MOODS` row. Damage numbers: `game.vfx.number()` from
`TdCombat.damage_enemy()`, off by default (Settings > Video).

## Tower kits (gw-towers, Nov 2026)

All 8 towers have their class kit in `scripts/towers/<class>.gd`; the 8
evolutions are tier-6 kits whose numbers live in `EvolutionData` "set"; the 4
synergies have conditional effects; Corpse Explosion and Plague Cloud are built;
the five GDD §11 sounds are synthesized (`TdSoundData.SOUNDS`, Sfx pack "td").
Hooks added: `TowerBehavior.impact(t, shot, victims)`, `TdProjectiles.fire_at()`
(lobbed, telegraphed) and `add_field()` (ground damage fields),
`TdGame.enemy_killed(e, tower)` signal, `TdCombat.curse_enemy / silence_enemy /
stagger_enemy`. **Healer traits must skip their heal unless
`EnemyTrait.can_heal(e, game)`** (the one silence test). `TdRulesData.BLOCKER_HIT_MULT`
scales held enemies' hits on blockers. Self-check: `tools/towers_check.tscn`.

## Status (gw-maps branch)

Built: Crimson March and Sanctum maps with their rules (Holy Ward Generators,
sanctified chambers), all ten Act I enemy traits, the Templar Commander and
Cathedral Guardian minibosses, Marshal Vael, Grand Inquisitor Seraphine,
Alaric's interval charge, map unlock data (`unlock_after`), the Reckoning
endless mode (`--reckoning`), build orders `march_default` / `march_weak` /
`sanctum_default` / `sanctum_weak`. New one-path helpers: `TdCombat.ward_enemy`,
`silence_enemy`, `suppress_tower`; EnemyTrait `on_attack` hook and `note()`;
`TdGame.spawn_at()`, `WaveDirector.spawn_extra()`; `MapRule.summary()` /
`finish_structures()`; enemy row key `structure`.

## Menus, meta and saves (gw-menus)

- Screens extend `MenuScreen` (`scripts/ui/td/menu_screen.gd`: backdrop, ornate
  panel, title, `_build(box)`, Back / ui_cancel, UiMotion, fit_to_screen); Main
  hosts each on a CanvasLayer. Layout numbers and words in `MenuData`.
- Meta: `Meta` (static, `scripts/core/meta.gd`) owns the save; it hands the
  Ossuary and Masteries to `MetaModifiers` (the one path into a run:
  `apply_tower()` in `Tower.recompute()`, start souls / lives / refund /
  cooldowns / respawn / `spell_slots()`). New Ossuary row: `MetaData.UPGRADES` +
  `ORDER`, then read its key in `MetaModifiers`.
- Characters: `CharacterData` rows, applied only through `CharacterModifiers`
  (`loadout()`, `spell_row()` in SpellCaster, `cooldown_mult()`, `start_souls()`,
  `apply_tower()`). The Gravecaller changes nothing.
- Codex / masteries are recorded by `RunWatch` from TdGame's signals; screens
  read lists from the data tables, so new towers / spells / kinds / maps /
  evolutions appear by themselves.
- Reckoning hooks read defensively: `game.get("reckoning_wave")` (int) and
  `game.has_method("start_reckoning")` for the results' offer.
