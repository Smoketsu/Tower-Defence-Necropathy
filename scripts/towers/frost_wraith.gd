## Frost Wraith kit (GDD §4.1 "slows, then freezes packs"): its frost bolts
## chill (slow) what they splash; every `freeze_every`-th bolt is a Deep
## Freeze that freezes every enemy within `freeze_radius` px of the impact.
## Evolved into the Winter Revenant (EvolutionData "winter_revenant", keys in
## its "set"): any enemy that dies while frozen (whoever kills it; not a boss)
## shatters, dealing `shatter_fraction` of its max HP to every enemy within
## `shatter_radius` px and chilling them (`shatter_slow`, `shatter_slow_time`).
## Shatters never chain (a shatter kill does not shatter again) and each death
## shatters once however many Revenants stand.
## Tower.vars: "kill_cb" — its TdGame.enemy_killed connection (Revenant only).
extends "res://scripts/towers/projectile.gd"

## True while a shatter resolves (its kills do not shatter again).
var _busy: bool = false
## The last shattered enemy and its generation (one shatter per death).
var _last: TdEnemy = null
## See _last.
var _last_gen: int = -1


func impact(t: Tower, shot: TdProjectiles.Shot, _victims: Array[TdEnemy]) -> void:
	if shot.freeze_time <= 0.0:
		return
	for e: TdEnemy in t.game.enemies_near(shot.pos, float(t.stats["freeze_radius"])):
		TdCombat.freeze_enemy(t.game, e, shot.freeze_time)
	t.game.fx.spawn("frost_nova", shot.pos, float(t.stats["freeze_radius"]) * 2.0, 0.4)
	t.game.stats["deep_freezes"] = int(t.game.stats.get("deep_freezes", 0)) + 1


func on_recompute(t: Tower) -> void:
	if float(t.stats.get("shatter_radius", 0.0)) > 0.0 and not t.vars.has("kill_cb"):
		var cb := _on_kill.bind(t)  # Bound to this Revenant.
		t.vars["kill_cb"] = cb
		t.game.enemy_killed.connect(cb)


func on_removed(t: Tower) -> void:
	if t.vars.has("kill_cb"):
		t.game.enemy_killed.disconnect(t.vars["kill_cb"])


## TdGame.enemy_killed: a frozen enemy shatters (see the header).
func _on_kill(e: TdEnemy, _killer: Tower, t: Tower) -> void:
	if _busy or t.game.time >= e.freeze_until or String(e.row["rank"]) == "boss" or (e == _last and e.generation == _last_gen):
		return
	_last = e
	_last_gen = e.generation
	_busy = true
	var dmg := e.max_hp * float(t.stats["shatter_fraction"])  # Damage to each neighbour.
	for o: TdEnemy in t.game.enemies_near(e.position, float(t.stats["shatter_radius"])):
		if o == e:
			continue
		TdCombat.damage_enemy(t.game, o, dmg, {"source": "shatter", "tower": t, "origin": e.position})
		if o.alive:
			TdCombat.slow_enemy(t.game, o, float(t.stats["shatter_slow"]), float(t.stats["shatter_slow_time"]))
	_busy = false
	t.game.fx.spawn("frost_shatter", e.position, float(t.stats["shatter_radius"]) * 2.0, 0.4)
	t.game.stats["shatters"] = int(t.game.stats.get("shatters", 0)) + 1
