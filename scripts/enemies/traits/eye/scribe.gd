## The Scribe of the Unwritten (Necropathy's ScribeKit): every `every` s
## (first `first` s after it arrives), when a cultist without a curse stands
## within `range` px, it stops and writes for `cast` s (a ring telegraph), then
## inks a CURSE on the `count` nearest uncursed ones (never a boss, a miniboss
## or a Thrall): each is a CLAIMER for `time` s (vars "claimer_until", read by
## the act rule: a body falling within RULE curse_radius of it rises as a
## Thrall; the sigil over it is EyeLayer's). Args: first, every, cast (s),
## range (px), count, time (s). vars: "next", "at" (game s the ink lands; 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		Kit.walk(e)
		var n := 0  # Cultists cursed.
		for o: TdEnemy in _uncursed(e, game, float(a["range"])):
			if n >= int(a["count"]):
				break
			o.vars["claimer_until"] = game.time + float(a["time"])
			Kit.line(game, e.position, o.position, 0.0, true, Acts.data("eye")["RULE"]["curse_tint"])
			n += 1
		EnemyTrait.note(game, "eye_curses", float(n))
		Sfx.play("plague_cast")
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or _uncursed(e, game, float(a["range"])).is_empty():
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["at"] = game.time + float(a["cast"])
	Kit.stand(e)
	Kit.ring(game, e.position, float(a["range"]), float(a["cast"]), false, "", Acts.data("eye")["RULE"]["curse_tint"])


## Cultists within `r` px of `e` that may be cursed, nearest first.
func _uncursed(e: TdEnemy, game: TdGame, r: float) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []  # Candidates.
	for o: TdEnemy in game.foes_near(e.position, r):
		var rank := String(o.row["rank"])  # Its rank.
		if o != e and rank != "boss" and rank != "miniboss" and o.kind != "eye_thrall" and game.time >= float(o.vars.get("claimer_until", 0.0)):
			out.append(o)
	out.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	return out
