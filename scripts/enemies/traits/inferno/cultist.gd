## Pit Cultist (Necropathy PitCultistKit: "living humans who open new
## portals; priority target"): `chant_after` s after it steps on the road it
## starts a rite (a charm-pink circle follows it); `chant_time` s later, if it
## still lives, it tears a demon portal open where it stands (the act rule's
## open_portal(), the one portal entry: `squad`, `every`, `squads`; a body on
## the spot seals it at once). Kill it during the chant and nothing opens.
## Once per cultist. Args: chant_after, chant_time (s), squad ([[kind, n]]),
## every (s), squads. vars: "chant" (game s the rite ends, 0 = not yet, -1 = done).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["start"] = game.time + float(e.row["args"]["chant_after"])
	e.vars["chant"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var c := float(e.vars["chant"])  # Rite state.
	if c < 0.0 or Kit.rule(game) == null:
		return
	if c == 0.0:
		if game.time >= float(e.vars["start"]):
			e.vars["chant"] = game.time + float(a["chant_time"])
			CovenantField.of(game).add_zone(e.position, float(Acts.data("inferno")["LOOK"]["chant_r"]), game.time + float(a["chant_time"]), Acts.data("inferno")["LOOK"]["charm_tint"], e)
			Sfx.play("cultist_chant")
			EnemyTrait.note(game, "cultist_chants")
		return
	if game.time < c:
		return
	e.vars["chant"] = -1.0
	if bool(Kit.rule(game).call("open_portal", e.position, a["squad"], float(a["every"]), int(a["squads"]))):
		EnemyTrait.note(game, "cultist_portals")
		game.banner("A Pit Cultist tore a portal open!")
