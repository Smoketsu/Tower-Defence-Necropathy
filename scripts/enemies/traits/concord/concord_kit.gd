## Concord kit: the act's shared helpers (drawing and spawning), used by its
## traits, bosses and spells so each look and each spawn has one path:
##   warn()   — a telegraph ring of the act's plasma green (eggs, eruptions, leaps).
##   burst()  — the act's burst where a blow lands (an effect strip + a ring at the real radius).
##   hatch()  — `n` foes of `kind` hatch on road `rd` at `d` px (lanes fanned),
##              extras of the latest wave at its HP (WaveDirector.hp_ramp()).
##   line()   — a straight beam / telegraph line from `a` to `b` (drawn only).
## Static only; drawing never writes run state.
extends RefCounted


## A telegraph ring of `radius` px at `pos` lasting `dur` s (drawn only).
static func warn(game: TdGame, pos: Vector2, radius: float, dur: float) -> void:
	var lk: Dictionary = Acts.data("concord")["LOOK"]
	var ring := game.vfx.add(TdVfx.Kind.RING, pos, radius, maxf(dur, 0.2), lk["warn_tint"])
	if ring != null:
		ring.size0 = radius * 0.95


## A burst at `pos` of `radius` px (its real reach) in `tint` (drawn only).
static func burst(game: TdGame, pos: Vector2, radius: float, tint: Color, strip: String = "golem_slam") -> void:
	game.fx.spawn(strip, pos, radius * 2.0, 0.45, tint)
	var ring := game.vfx.add(TdVfx.Kind.RING, pos, radius, TdVfxData.RING_TIME, tint)
	if ring != null:
		ring.size0 = radius * TdVfxData.RING_FROM
	game.vfx.shake(1.5)


## `n` foes of kind `kind` hatch on road `rd` at `d` px (see the header); returns them.
static func hatch(game: TdGame, kind: String, rd: Road, d: float, n: int) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []
	game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
	for i in n:
		out.append(game.waves.spawn_extra(kind, rd.id, clampf(d + float(i) * 6.0, 0.0, rd.length - 1.0), float(i % 3 - 1) * 9.0))
	game.extra_hp_mult = 1.0
	game.fx.spawn("spore_cloud", rd.point_at(d), 70.0, 0.5, Acts.data("concord")["LOOK"]["plasma"])
	Sfx.play("egg_hatch")
	return out


## A beam line from `a` to `b`: the faint telegraph (`dur` s) or the bright beam (`bright`; drawn only).
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool) -> void:
	var lk: Dictionary = Acts.data("concord")["LOOK"]
	var f := game.vfx.add(TdVfx.Kind.STREAK, b, float(lk["beam_w"] if bright else lk["line_w"]),
			float(lk["beam_time"]) if bright else maxf(dur, 0.1), lk["beam_tint"] if bright else lk["line_tint"])
	if f != null:
		f.ang = (b - a).angle()
		f.size0 = a.distance_to(b)
