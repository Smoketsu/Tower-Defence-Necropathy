## The test act's rule (ActData "test" "rule": "test/proving"): one tiny use of
## every act hook, as the worked example for act agents (docs/ACT_TEMPLATE.md).
## Numbers in the act data file's RULE (Acts.data("test")["RULE"]).
##   wave tier     — on_wave_start(): every `tier_every` waves the tier rises;
##                   on_spawn(): TdCombat.empower_enemy() by the tier.
##   heal on kill  — on_kill(): on the blood wave a kill heals enemies around it
##                   (TdCombat.heal_enemy, a heal sparkle).
##   claims        — on_body_fallen(): a blocker felled by a blow near a claimer
##                   rises as a hostile thrall (game.spawn_from_body()).
##   visibility    — can_target(): from `night_from` towers see only within `sight` px.
##   shelling      — step(): every `shell_every` s a telegraphed shell on a built
##                   tower (game.hostile.shell() -> TdCombat.disable_tower()).
extends MapRule

## Current wave tier (0 = none).
var tier: int = 0
## Current wave number (1-based; 0 before the first).
var wave: int = 0
## Game time (s) of the next shell.
var next_shell: float = INF
## Index into game.towers of the next shelled tower (round robin).
var shell_i: int = 0
## Counters for the summary: tiered spawns, kill heals, thralls raised, shells sent, targets hidden.
var counts: Dictionary = {"tiered": 0, "kill_heals": 0, "thralls": 0, "shells": 0, "hidden": 0}


## The RULE numbers.
func _r() -> Dictionary:
	return Acts.data("test")["RULE"]


func on_wave_start(n: int) -> void:
	wave = n
	tier = (n - 1) / int(_r()["tier_every"])
	if next_shell == INF:
		next_shell = game.time + float(_r()["shell_every"])


func on_spawn(e: TdEnemy) -> void:
	if tier > 0 and String(e.row["rank"]) != "boss":
		TdCombat.empower_enemy(game, e, 1.0 + float(_r()["tier_hp"]) * float(tier))
		counts["tiered"] = int(counts["tiered"]) + 1


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	if wave != int(_r()["blood_wave"]):
		return
	for o: TdEnemy in game.foes_near(e.position, float(_r()["kill_heal_radius"])):
		if o != e and o.hp < o.max_hp:
			TdCombat.heal_enemy(game, o, float(_r()["kill_heal"]))
			counts["kill_heals"] = int(counts["kill_heals"]) + 1
			game.fx.spawn("level_up", o.position, 48.0, 0.4)


func on_body_fallen(b: BlockBody, by: TdEnemy) -> void:
	if by == null:
		return
	for o: TdEnemy in game.foes_near(b.pos, float(_r()["claim_radius"])):
		if o.kind == String(_r()["claim_kind"]):
			game.spawn_from_body(String(_r()["thrall_kind"]), b)
			counts["thralls"] = int(counts["thralls"]) + 1
			return


func can_target(t: Tower, e: TdEnemy) -> bool:
	if wave < int(_r()["night_from"]) or t.position.distance_to(e.position) <= float(_r()["sight"]):
		return true
	counts["hidden"] = int(counts["hidden"]) + 1
	return false


func step(_dt: float) -> void:
	if game.time < next_shell or game.towers.is_empty():
		return
	next_shell = game.time + float(_r()["shell_every"])
	var t: Tower = game.towers[shell_i % game.towers.size()]  # The shelled tower.
	shell_i += 1
	game.hostile.shell(t.position, float(_r()["shell_radius"]), float(_r()["shell_delay"]), float(_r()["shell_disable"]))
	counts["shells"] = int(counts["shells"]) + 1


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = []  # k:v entries.
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)
