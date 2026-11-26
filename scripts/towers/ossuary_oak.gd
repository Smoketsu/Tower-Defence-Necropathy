## Ossuary Oak kit (Act XV tower, unlocked by the Green Mother; Necropathy's
## OssuaryOakBehavior "root_lash": an oak grown from a grave whose roots lash
## out of the ground). The Corpse Catapult's aim (corpse_catapult.gd: the
## densest pack in range, led; a landing telegraph) with its own landing, the
## root lash: every foe hit that walks (not a flyer, not a structure) is ROOTED
## `root_time` s (TdCombat.freeze_enemy, the one hold-in-place path: rank
## multipliers apply) and a living root field stays `field_time` s
## (`field_radius` px, `field_fraction` of the lash's damage every
## `field_tick` s; TdProjectiles.add_field). Ground only: roots never reach a
## flyer (row "ground_only"). From level 3 its volley lobs bone seeds on other
## foes (the Catapult's volley). Evolved into the World-Root Warden
## (EvolutionData "world_root_warden"): a wider lash, longer roots and a
## field that lasts. Tower.vars: "roots" (foes rooted; the kit summary's
## "slams" counter).
extends "res://scripts/towers/corpse_catapult.gd"


func impact(t: Tower, shot: TdProjectiles.Shot, victims: Array[TdEnemy]) -> void:
	if shot.is_volley:
		return
	var g := t.game  # The run.
	var n := 0  # Rooted by this lash.
	for e: TdEnemy in victims:
		if e.alive and not bool(e.row.get("flying", false)) and not bool(e.row.get("structure", false)):
			TdCombat.freeze_enemy(g, e, float(t.stats["root_time"]))
			n += 1
	t.vars["roots"] = int(t.vars.get("roots", 0)) + n
	t.vars["slams"] = int(t.vars["roots"])
	if float(t.stats["field_time"]) > 0.0:
		g.projectiles.add_field(shot.pos, float(t.stats["field_radius"]), float(t.stats["field_time"]), float(t.stats["field_tick"]),
				shot.damage * float(t.stats["field_fraction"]), t.tower_id, t, "plague")
	g.fx.spawn("wild_bury", shot.pos, float(t.stats["splash"]) * 2.2 * TdVfx.loud(t), 0.5, TdVfxData.SHOTS["ossuary_oak"]["tint"])
	if n > 0:
		Sfx.play("roots_grab", shot.pos)
