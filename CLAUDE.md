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
Run at most 2 Godot processes at once (shared 4-core machine).

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
`near` {class, radius}, `near_level` {class, level, radius}; a new type is one
`match` branch. The base tower row's `evolution` names it. Never hint recipes.

**Synergy** — a row in `SynergyData.SYNERGIES`: name, icon, a, b, radius,
effects {"a"|"b": {damage|rate|range|hp: mult, hold_bonus: +n}}, hint.
`Synergies.evaluate()` runs on build / sell / upgrade / evolve; behaviours can
test `t.synergies` ([id, partner] pairs) for conditional effects.

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

## Status (foundation, Nov 2026)

Built: core loop, Graveyard (22 waves, Inquisitor miniboss + chest, Sir Alaric),
8 tower rows (Archer / Mage / Warrior fully working; Frost Wraith, Catapult,
Banshee, Mender, Abomination on the generic behaviours), 8 evolution rows and 4
synergy rows (stat effects only), Shadow Bolt, Bone Wall, Dread Rally, 3 traits,
difficulty levels, minimal title / map select / HUD / pause / results, autotest, Web build.
Missing vs Act I: Crimson March and Sanctum maps (+ their rules, Vael,
Seraphine, Cathedral Guardian), Corpse Explosion and Plague Cloud, class
specials (Catapult landing telegraph, Wraith shatter, Gravebow split, Lich,
Colossus taunt...), conditional synergy effects, Shieldbearer / Halberdier /
Sister / Sentinel / Inquisitor zone / Confessor / Paladin traits, the pre-map
setup (spell / character / ultimate pick), Ossuary + meta save, Codex,
Settings / Credits screens, Reckoning endless mode, skull records, the five new
sounds (stand-ins in `TdSoundData`), gamepad spot cursor, CI.
