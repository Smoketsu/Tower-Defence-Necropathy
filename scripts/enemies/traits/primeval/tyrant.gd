## The Tyrant (Necropathy's TyrantKit: the swallow and the roar): every
## `roar_every` s (first after `roar_first`) it rears for `roar_windup` s (a
## ring of the real reach) and ROARS: every tower within `roar_radius` px is
## stunned `roar_stun` s. Held, every `swallow_every` s it lowers its head for
## `swallow_windup` s (a line to the body) and SWALLOWS the body holding it
## whole (Kit.swallow(): it returns on its post's respawn). Not while frozen.
## Args: roar_first, roar_every, roar_windup (s), roar_radius (px), roar_stun (s),
## swallow_every, swallow_windup (s). vars: "next_roar", "roar_at", "next_swallow", "swallow_at".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	e.vars["next_roar"] = game.time + float(a["roar_first"])
	e.vars["roar_at"] = 0.0
	e.vars["next_swallow"] = 0.0
	e.vars["swallow_at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	jaws(e, game, e.row["args"])


## The roar and the swallow on the numbers `a` (Old Gravejaw calls it with his own row).
static func jaws(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ra := float(e.vars["roar_at"])
	if ra > 0.0 and game.time >= ra:
		e.vars["roar_at"] = 0.0
		Kit.roar(e, game, float(a["roar_radius"]), float(a["roar_stun"]))
	var sa := float(e.vars["swallow_at"])
	if sa > 0.0 and game.time >= sa:
		e.vars["swallow_at"] = 0.0
		if game.time >= e.freeze_until:
			Kit.swallow(e, game)
	if game.time < e.freeze_until or ra > 0.0 or sa > 0.0:
		return
	if game.time >= float(e.vars["next_roar"]):
		e.vars["next_roar"] = game.time + float(a["roar_every"])
		e.vars["roar_at"] = game.time + float(a["roar_windup"])
		Kit.ring(game, e.position, float(a["roar_radius"]), float(a["roar_windup"]), Color.WHITE, false)
		Sfx.play("boss_telegraph")
	elif e.holder != null and game.time >= float(e.vars["next_swallow"]):
		e.vars["next_swallow"] = game.time + float(a["swallow_every"])
		e.vars["swallow_at"] = game.time + float(a["swallow_windup"])
		Kit.line(game, e.position, e.holder.pos, float(a["swallow_windup"]), false)
