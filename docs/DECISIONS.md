# Design decisions not covered by the GDD

Every decision made while building that `docs/GDD.md` does not settle. Owner
decisions given with the foundation brief are listed first. Append new rows.

| # | Area | Decision |
|---|---|---|
| O1 | Pacing (owner) | Back-to-back waves: the next wave starts `AUTO_GAP` = 5 s after the previous wave's last spawn, not after it is dead; no 15 s build phase. The first wave waits for Call. Overrides GDD §3 "Build phase". |
| O2 | Scope (owner) | Fixed roads with authored spots, road-post blockers kept, working name kept, saves separate, speed x1/x2/x3 + pause. |
| 1 | Call | Call is available before wave 1 and during a gap (after the current wave's last spawn). Bonus = whole seconds of the gap skipped x `CALL_PER_SECOND`. Wave 1's Call pays nothing. |
| 2 | Lives | A miniboss leak costs 5 lives (GDD lists fodder / elite / boss only). |
| 3 | Souls | A boss kill pays 0 souls (the map ends). Kill souls are by rank only, no per-kind override. |
| 4 | Chest | The miniboss chest is a free-upgrade credit (`free_upgrades`): the next Upgrade or Evolve costs nothing. Collected automatically at the miniboss's death (no tap needed). |
| 5 | Armour | Armour is flat damage off each hit (GDD §6.1 "flat armour 6"), never below 20% of the hit (`ARMOUR_MIN_FRACTION`); damage over time ignores armour. Mage and Catapult have `armour_pierce`. |
| 6 | Freeze | Freezes on minibosses / bosses last 60% / 40% as long (`FREEZE_MULT`). Slows never drop below 30% speed. The strongest slow / weaken wins; durations extend. |
| 7 | Blocking | A blocker body holds `hold` enemies; when every body of a post is full or dead the rest walk past. Held enemies attack their body; a dead body releases them and returns free after `respawn` s. Warrior: 2 bodies x 1 hold at Lv1 (3 at Lv3, 4 at Lv5); Abomination: 1 body x 4, hits all held (stomp). Blockers can hold bosses; Bone Wall cannot (`ignores_walls`). |
| 8 | Blocking limit | A block only catches enemies on its own road (a block right at a merge point does not catch enemies still on the joining road). |
| 9 | Targeting | First = least road distance left to the gate (through merges); Strongest = highest current HP; Nearest = to the tower. Default mode per class row (Catapult: Strongest). |
| 10 | Volley (Lv3) | From level 3, every `every` shots a tower fires `count` extra shots at other enemies in range at a fraction of its damage, drawn with Necropathy's grey volley masks tinted per class. Volley shots never freeze. Auras show a bigger pulse strip from Lv3 instead. |
| 11 | Evolution recipes | First pass: Gravebow 150 kills; Lich: a Frost Wraith within 180 px; Winter Revenant: a Catapult within 220 px; Ossuary Engine 120 kills; Keening Lady: a Mage within 180 px; Profane Bishop: a Crypt Warder within 150 px (GDD; the Warder is a later tower, so not reachable yet); Death Knight: a Mender Lv3+ within 160 px; Bone Colossus: a Warrior within 200 px. Evolution = level-5 stats x the row's multipliers + replaced keys; specials come later. |
| 12 | Synergies | Shatterfall = Catapult damage x1.25 (flat until a behaviour reads frozen targets), Flesh Rampart = +1 hold on both blockers, Killing Field = Catapult rate x1.15, Requiem = Banshee range x1.1 and Mage damage x1.15. Radius-based (px), not plot-count based. The spot menu names the synergies a build would form there (soul-teal button) and lists all of a class's synergies in the tooltip. |
| 13 | Sell | Refund = 70% of all souls spent on the tower (build + upgrades + evolution); chest-paid levels count as 0 spent. |
| 14 | Spells | Spells target by row `target`: Shadow Bolt = enemy nearest the tap within 90 px (no target = no cast, no cooldown), flying from the necromancer drawn beside the gate; Bone Wall = road point nearest the tap within 60 px, 5 s, holds unlimited non-boss enemies. Default loadout Shadow Bolt / Bone Wall / Corpse Explosion until a pre-map pick exists. Tap the spell, then the target; tapping it again disarms. |
| 15 | Ultimate | Dread Rally meter: 100 points; +1 fodder, +4 elite, +20 miniboss per kill. Cast anywhere (Space / button). |
| 16 | Difficulty | Initiate HP x0.75 count x0.85; Lich HP x1.35 count x1.15; Deathlord HP x1.8 count x1.3 (counts rounded, at least 1 per group). |
| 17 | Skulls | 3 skulls at >= 90% of start lives kept, 2 at >= 50%, else 1; 0 on a loss. |
| 18 | Graveyard | 22 waves, Inquisitor (Necropathy's elite Inquisitor sprite) as the wave-11 miniboss, Sir Alaric on wave 22 with a Templar / Footman escort. Alaric: held by blockers, 9 s after he is first held he winds up 0.9 s then charges through the post (160 to each body), running x4 for 1.2 s unholdable. |
| 19 | Sprite facing (GDD §13 risk) | Every unit sprite is a single right-facing 3/4 side view (walk strips too, no up / down views). Enemies mirror by the horizontal part of their road direction and keep their last facing on vertical stretches; plot towers face their target; blockers face the oncoming column. Act I roads should run mostly left to right with short vertical links, as the Graveyard does. |
| 20 | Map fit | The 1280 x 720 map is scaled to fit and centred in the window (`canvas_items` / `expand` stretch can make the viewport wider); taps convert through the world transform. |
| 21 | Enemy traits | Chaplain: heals others within 90 px by 14 every 3 s. Templar: one 1.6 s x2.4 speed burst after its first hit. Banner Bearer (ready for map 2): x1.3 speed aura in 90 px. |
| 22 | Fallback art | Every Gravewatch art role falls back to a plain code rect when its PNG is missing; the final art from the art pipeline is in `assets/sprites/td/`. |
| 23 | Sounds | The five new GDD §11 sounds are stand-ins mapped to existing Necropathy sounds in `TdSoundData` until synthesized. |
| 24 | Spot menu | Building closes the menu; tapping a built spot opens Upgrade / Target / Sell / Evolve. Blockers have no Target button. |
| 25 | Stuck check | An enemy that is not held or frozen and has not moved for 5 s counts as stuck in the autotest summary. |
