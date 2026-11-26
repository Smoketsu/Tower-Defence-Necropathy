## Bound Succubus kit (Act IX's first unlockable summon class, opened by
## Lilith; Necropathy's Bound Succubus, "a flying charm support"): it shoots
## charm-pink kisses (projectile.gd; hits flyers) that WEAKEN what they hit
## (x`weaken` damage for `weaken_time` s, TdCombat.weaken_enemy), and every
## `charm_every` s it CHARMS the `charm_count` foes with the most HP in range
## it may target (never a boss, miniboss or structure): each stands
## `charm_time` s and strikes the foes beside it (`charm_reach` px) for
## `charm_mult` x this tower's damage, credited to it (TdCombat.charm_enemy).
## A disabled tower charms nobody (its step is not called). Evolved into the
## Lilim Matriarch (EvolutionData "lilim_matriarch": more charms, longer,
## sooner, a deeper weaken). Tower.vars: "next_charm" (game s), "charms" (count).
extends "res://scripts/towers/projectile.gd"


func step(t: Tower, dt: float) -> void:
	super(t, dt)
	var g := t.game  # The run.
	if g.time < float(t.vars.get("next_charm", 0.0)):
		return
	var foes := g.foes_near(t.position, float(t.stats["range"])).filter(func(e: TdEnemy) -> bool: return t.can_hit(e) and String(e.row["rank"]) in ["fodder", "elite"])
	if foes.is_empty():
		return
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := 0  # Foes charmed.
	for e: TdEnemy in foes:
		if n >= int(t.stats["charm_count"]):
			break
		if TdCombat.charm_enemy(g, e, float(t.stats["charm_time"]), float(t.stats["damage"]) * float(t.stats["charm_mult"]), float(t.stats["charm_reach"]), t.tower_id, t):
			n += 1
			if g.vfx.on:
				var lk: Dictionary = Acts.data("inferno")["LOOK"]
				var f := g.vfx.add(TdVfx.Kind.THREAD, t.position + Vector2(0, -26), float(lk["thread_w"]) * TdVfx.loud(t), 0.4, lk["charm_tint"])
				if f != null:
					f.to = e.position + Vector2(0, -14)
				g.vfx.add(TdVfx.Kind.ANIM, e.position + Vector2(0, -14), float(lk["kiss_d"]) * TdVfx.loud(t), 0.45, lk["charm_tint"], "volley_flash")
	if n == 0:
		return
	t.vars["next_charm"] = g.time + float(t.stats["charm_every"])
	t.vars["charms"] = int(t.vars.get("charms", 0)) + n
	Sfx.play("charm_kiss")


func impact(t: Tower, shot: TdProjectiles.Shot, victims: Array[TdEnemy]) -> void:
	if shot.is_volley:
		return
	for e: TdEnemy in victims:
		if e.alive:
			TdCombat.weaken_enemy(t.game, e, float(t.stats["weaken"]), float(t.stats["weaken_time"]))
