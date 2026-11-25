## Super (Act IV, the Last Line; GDD §7.3 "Supers have one power and one
## weakness each"; Necropathy's SuperKit parody heroes). One script, the power
## and the weakness picked by the row's args:
## Powers ("power"; every `every` s, not while frozen or staggered):
##   dash  — Blitz: a sprint, TdCombat.haste_enemy(dash_mult, dash_time), and no
##           blocker can hold him meanwhile (he lets go of one that does).
##   ward  — Aurora: every living enemy within `radius` px (herself too) is
##           warded to `ward_mult` (TdCombat.ward_enemy) for a little over a tick.
##   throw — Atlas: hurls a car at the nearest tower within `range` px that is
##           not disabled (game.hostile.shell: `radius`, `delay`, `disable`,
##           `body_damage`).
##   smoke — Nightjar: a smoke bomb blinds every tower within `radius` px for
##           `disable` s (TdCombat.disable_tower, cause "blinded").
## Weaknesses ("weakness"; the hit takes x `weak_mult`, applied in
## incoming_damage, the first step of TdCombat.damage_enemy()):
##   held  — while a blocker body holds it (Blitz exposed).
##   cold  — while slowed or frozen (Aurora).
##   shred — while its armour is shredded (TdCombat.shred_of() > 0: Wither, the Fallen Hero).
##   loud  — hits whose source is listed in `loud` (Nightjar: splash and blasts).
## vars: "next_power" (game s), "exposed_noted" (bool). Events: super_<power>,
## super_exposed (first time a Super's weakness bites), super_weak_hits.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_power"] = game.time + float(e.row["args"]["every"])
	game.sound("city_super")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_power"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var power := String(a["power"])  # Its one power.
	e.vars["next_power"] = game.time + float(a["every"])
	match power:
		"dash":
			TdCombat.haste_enemy(game, e, float(a["dash_mult"]), float(a["dash_time"]))
			e.unholdable_until = game.time + float(a["dash_time"])
			if e.holder != null:
				e.holder.held.erase(e)
				e.holder = null
			if game.vfx.on:
				game.fx.spawn("volley_flash", e.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME, TdVfxData.CITY_HERO_TINT)
		"ward":
			for o: TdEnemy in game.foes_near(e.position, float(a["radius"])):
				TdCombat.ward_enemy(game, o, float(a["ward_mult"]), float(a["every"]) * 1.5)
			return  # Every tick: no event, no burst.
		"throw":
			var best: Tower = null  # Its target.
			var best_d := float(a["range"])  # Nearest distance so far (px).
			for t: Tower in game.towers:
				var d := e.position.distance_to(t.position)  # Distance (px).
				if d <= best_d and game.time >= t.disabled_until:
					best_d = d
					best = t
			if best == null:
				return
			game.hostile.shell(best.position, float(a["radius"]), float(a["delay"]), float(a["disable"]), "shelled", float(a["body_damage"]))
			e.vis_strike_at = game.time  # His throw (drawn only).
			e.vis_strike_dir = (best.position - e.position).normalized()
		"smoke":
			var hit := 0  # Towers blinded.
			for t: Tower in game.towers:
				if t.position.distance_to(e.position) <= float(a["radius"]):
					TdCombat.disable_tower(game, t, float(a["disable"]), "blinded")
					hit += 1
			if hit == 0:
				return
			if game.vfx.on:
				game.fx.spawn("spore_cloud", e.position, float(a["radius"]) * 2.0, TdVfxData.CITY_SMOKE_TIME, TdVfxData.CITY_SMOKE_TINT)
	EnemyTrait.note(game, "super_" + power)


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var weak := false  # The weakness bites this hit.
	match String(a["weakness"]):
		"held": weak = e.holder != null
		"cold": weak = game.time < e.freeze_until or (game.time < e.slow_until and e.slow_mult < 1.0)
		"shred": weak = TdCombat.shred_of(game, e) > 0.0
		"loud": weak = (a["loud"] as Array).has(String(hit.get("source", "")))
	if not weak:
		return amount
	EnemyTrait.note(game, "super_weak_hits")
	if not bool(e.vars.get("exposed_noted", false)):
		e.vars["exposed_noted"] = true
		EnemyTrait.note(game, "super_exposed")
		game.sound("city_weak")
		if game.vfx.on:
			game.fx.spawn("doom_burst", e.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME)
	return amount * float(a["weak_mult"])
