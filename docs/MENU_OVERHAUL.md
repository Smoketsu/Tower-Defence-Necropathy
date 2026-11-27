# Menu overhaul (owner request, Nov 2026: "Let's overhaul the menus and make them look better")

Bar: Necropathy's owner-approved menu modernization (same kit, fonts, rules).
Before shots: `/home/user/gw_shots/menus/before_*_{desktop,phone}.png` (base 73700b0;
1280x720 mouse and 844x390 touch). Decisions: `docs/DECISIONS.md` rows M1-M*.

## What the audit found (all screens)

- Every screen is one ornate box floating in the middle of a static backdrop, with
  its title inside the box and Back as one more button at the bottom. Nothing
  says where you are (no header), no hint strip, so keys / pad buttons are never shown.
- The backdrop never moves: the front door feels dead.
- Lots of empty panel area (map select, codex, settings) while the art that
  would explain a choice (maps, bosses, characters) is never shown.
- Phone (844x390): the NAME / HEADER tier text on buttons is drawn with wide
  letter gaps ("R e s u m e"): the pixel font's fixed raster is scaled while
  the canvas is oversampled. Body text is fine.

## Per screen: wrong -> becomes

| Screen | Wrong today | Becomes |
|---|---|---|
| Shared (`MenuScreen`) | title inside the box, Back at the bottom, no hints | full-screen frame: a header band with the Jacquard title, Back top-left (with its key chip), an optional Soul Ash pill top-right, the content panel below, a bottom hint strip from the current bindings; the living backdrop behind every front-door screen |
| Backdrop | static | drifting clouds and fog, rising soul wisps, a bat now and then, flickering candles (textures only, real time, still under Reduce motion / Reduced effects / autotest) |
| Title | plain button column | logo with a slow glow, the Gravecaller and his dead on the hill, an icon on every item, Play first and bigger in gold, Soul Ash pill |
| Map select | 3 bordered boxes with a name and a line; 15 bare numerals | Part I / II / III tabs, then the part's five acts as named tabs (numeral + name); each map an illustrated vignette card: a pre-rendered thumbnail of the real map (bot at wave 3, 384x216, lossy WebP in the pack), the boss standing on it, name, best skulls, Reckoning, boss line; locked = dark picture, padlock and the crimson lock line |
| Pre-run | everything in one column, the hero is a small tile | the chosen character as the hero (big portrait, name, innate, its own spell) on the left; strips (kept: drag / wheel / arrows / focus follow) and the ultimate / difficulty rows on the right; totals beside Start |
| Results | text lines | title + skulls, stat tiles with icons (waves, lives, Soul Ash count-up), unlock plates in teal, buttons with Next in gold |
| Pause | 4 buttons | map name, wave and lives, buttons with icons, hint strip |
| Ossuary | flat tiles, grey cost boxes | badge tiles with level pips, teal Buy with the Ash icon when affordable, gold at max, a detail panel for the focused upgrade, masteries row with a count |
| Codex | bare grid, empty detail box | found count per tab, tiles with names, a detail panel with a big picture, rank / stats, lock line |
| Settings | tabs + rows in a big empty box | the same rows in framed groups, tabs on top, smaller panel |
| Credits | text only | logo on top, framed scroll |
| Spot menu (in run) | cramped 92x58 tiles, "<" ">" paging | bigger tiles (icon, name, cost; teal / dim), page dots, a tower panel with stat changes of the next level; Sell asks first |
