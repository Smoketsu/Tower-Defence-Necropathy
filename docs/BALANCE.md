# Balance (integration pass, Nov 2026)

Numbers from the autotest bot (`--autotest`, default build order of each map,
Necromancer unless noted). "Lives" = lives kept of 20; a boss leak ends the map.
Seeds 1-8 for the default difficulty, 1-4 for Lich, 1-2 for Initiate /
Deathlord. Commands: see README "Autotest".

## Levers (all data)

- Wave HP ramp: non-boss HP x lerp(0.75, end, wave / last wave)
  (`TdRulesData.WAVE_HP_START` / `WAVE_HP_END`, map key `wave_hp_end`:
  Graveyard 2.6, Crimson March 2.4, Sanctum 3.0). Before it, every default run
  kept 20/20 lives while Lich collapsed in the first 4-6 minutes.
- Difficulty: Initiate HP x0.75 / count x0.85, Lich x1.1 / x1.1, Deathlord
  x1.5 / x1.3.
- Against the towers branch's stronger blocker hits (x4): Halberdier 10
  damage, Alaric 9000 HP; Frost Wraith 8 and Abomination 22 damage; Gravebow
  recipe 60 kills.

## Results

| Map | Difficulty | Seeds | Wins | Lives kept (wins) | Map time | Evolutions (default bot) |
|---|---|---|---|---|---|---|
| Graveyard | Initiate | 1-2 | 2/2 | 20 | 6.9 min | - |
| Graveyard | Necromancer | 1-8 | 8/8 | 20 (45-60 blocker bodies lost) | 7.6-8.2 min | Gravebow |
| Graveyard | Lich | 1-4 | 4/4 | 9-20 | 8.2-8.6 min | Gravebow |
| Graveyard | Deathlord | 1-2 | 0/2 | - (wave 7 / Alaric) | | |
| Crimson March | Initiate | 1-2 | 2/2 | 20 | 9.9 min | |
| Crimson March | Necromancer | 1-8 | 8/8 | 14-20 (4 of 8 lose lives) | 10.3-11.1 min | Gravebow x1-2 |
| Crimson March | Lich | 1-4 | 3/4 | 2-3 | 11.5 min | Gravebow |
| Crimson March | Deathlord | 1-2 | 0/2 | - (wave 7) | | |
| Sanctum | Initiate | 1-2 | 2/2 | 20 | 10.6 min | |
| Sanctum | Necromancer | 1-8 | 8/8 | 5-20 (5 of 8 lose lives) | 11.3-11.9 min | Gravebow x1-2 |
| Sanctum | Lich | 1-4 | 1/4 | 11 | 12 min | |
| Sanctum | Deathlord | 1-2 | 0/2 | - (wave 3) | | |

Losing orders: `weak`, `march_weak`, `sanctum_weak` lose on every seed tried
(waves 1-3, under 2 minutes). Reckoning (`--reckoning`, seed 1): ends at
Reckoning wave 13 (Graveyard), 11 (March), 8 (Sanctum).

Test orders: `towers_a` (four shooters + Lich / Winter Revenant) wins the
Graveyard; `evolve_all` reaches six evolutions with its bonus souls;
`towers_b` (support + blockers, little damage) loses on every map: support
towers multiply a damage core, they do not replace it.

## Tower contribution (default runs, typical damage share)

Archer / Gravebow and Mage carry (60-70%), Catapult 10-25% (more on the
Sanctum), spells ~15% (Shadow Bolt, Corpse Explosion), blockers mostly hold.
Frost Wraith, Banshee and Mender are utility: slow / freeze uptime, weaken,
healing (towers_b: ~5000 HP healed, Death Knight and Profane Bishop reached).

## Known weak spots

- The bot's default orders are fixed scripts; Lich on the Sanctum is won by
  1 seed in 4. A human who adapts placement should do better.
- Graveyard on Necromancer is the gentlest map: the bot loses blockers but no
  lives.
- The tipping point is sharp: once leaks start, a run can lose all 20 lives in
  two waves.

## Meta and Soul Ash

- `--meta=max` (every Ossuary level and mastery): seed 1 keeps 26/26 lives on
  all three maps and loses 10-22 blocker bodies instead of 50-100: clearly
  easier, still a fight on Lich / Deathlord.
- Soul Ash (I8): a 3-skull Necromancer clear pays 300 / 375 / 450 (Graveyard /
  March / Sanctum), Lich x1.5, Deathlord x2; a defeat pays 6 per wave cleared.
  The whole Ossuary (7,380) takes ~20 good clears.
- Gravecaller with no meta gives the same summaries as before the menus merge
  (checked on all three maps, seed 1).
