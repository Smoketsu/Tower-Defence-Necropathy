## Banshee kit (GDD §4.1, Necropathy's Dirge): when an enemy is in range and
## the cooldown is up it draws breath for `windup` s (a closing violet ring:
## the telegraph), then wails: every enemy within range takes the small wail
## damage and is slowed (`slow`, `slow_time`) and weakened (its hits x
## `weaken` for `weaken_time` s) through TdCombat. Evolved into the Keening
## Lady (EvolutionData "keening_lady", keys in its "set"): `waves` wails roll
## out `wave_interval` s apart, each `wave_growth` wider than the last, and
## they silence what they hit for `silence_time` s (TdCombat.silence_enemy():
## healers cannot heal).
## Tower.vars: "waves" — pending [game s, radius mult]; "rings" — drawn [start game s, radius px].
extends "res://scripts/towers/aura.gd"


func step(t: Tower, _dt: float) -> void:
	var waves: Array = t.vars.get("waves", [])  # Wails still to come.
	while not waves.is_empty() and t.game.time >= float(waves[0][0]):
		_wail(t, float(t.stats["range"]) * float(waves.pop_front()[1]))
	t.vars["waves"] = waves
	var rings: Array = t.vars.get("rings", [])  # Rings being drawn.
	while not rings.is_empty() and t.game.time - float(rings[0][0]) > TowerData.WAIL_RING_TIME:
		rings.pop_front()
	if not waves.is_empty() or not (t.vars.get("rings", []) as Array).is_empty():
		t.queue_redraw()
	if not waves.is_empty() or t.game.time < t.next_fire or t.game.foes_near(t.position, float(t.stats["range"])).is_empty():
		return
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.vars["wind_from"] = t.game.time
	for i in int(t.stats.get("waves", 1)):
		waves.append([t.game.time + float(t.stats["windup"]) + float(i) * float(t.stats.get("wave_interval", 0.0)),
				1.0 + float(i) * float(t.stats.get("wave_growth", 0.0))])


## One wail of radius `r` px (see the header).
func _wail(t: Tower, r: float) -> void:
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	t.game.sound_fire(t.tower_id)
	var silence := float(t.stats.get("silence_time", 0.0))  # Keening Lady silence (0 = none).
	for e: TdEnemy in t.game.foes_near(t.position, r):
		TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t})
		if e.alive:
			TdCombat.slow_enemy(t.game, e, float(t.stats["slow"]), float(t.stats["slow_time"]))
			TdCombat.weaken_enemy(t.game, e, float(t.stats["weaken"]), float(t.stats["weaken_time"]))
			if silence > 0.0:
				TdCombat.silence_enemy(t.game, e, silence)
	var rings: Array = t.vars.get("rings", [])  # Rings being drawn.
	rings.append([t.game.time, r])
	t.vars["rings"] = rings
	t.game.fx.spawn("frost_nova" if t.level >= 3 else "volley_hit", t.position, r * 2.0, 0.5, Color(0.8, 0.7, 1.0, 0.5))


func draw_overlay(t: Tower) -> void:
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	if ring == null:
		return
	var r := float(t.stats["range"])  # Range (px).
	if not (t.vars.get("waves", []) as Array).is_empty():
		var p := clampf((t.game.time - float(t.vars.get("wind_from", 0.0))) / maxf(float(t.stats["windup"]), 0.01), 0.0, 1.0)  # Wind-up progress.
		var rr := r * (1.0 - 0.6 * p)  # Closing telegraph radius (px).
		t.draw_texture_rect(ring, Rect2(-Vector2(rr, rr), Vector2(rr, rr) * 2.0), false, Color(0.75, 0.55, 1.0, 0.3 + 0.5 * p))
	var rings: Array = t.vars.get("rings", [])  # Expanding wail rings.
	for rg: Array in rings:
		var age := clampf((t.game.time - float(rg[0])) / TowerData.WAIL_RING_TIME, 0.0, 1.0)  # 0..1 since the wail.
		var rr := float(rg[1]) * (0.6 + age * 0.4)  # Expanding radius (px).
		t.draw_texture_rect(ring, Rect2(-Vector2(rr, rr), Vector2(rr, rr) * 2.0), false, Color(0.85, 0.7, 1.0, 0.8 * (1.0 - age)))
