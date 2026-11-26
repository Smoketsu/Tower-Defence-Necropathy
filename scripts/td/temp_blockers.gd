## TempBlockers: the temporary Risen blockers raised by the later spells and
## ultimates (Death Mark's risen, Raise Dead, Grave Tide; DECISIONS K11). Each
## raise is one RoadBlock of `n` temporary BlockBodies side by side on a road
## that holds and strikes for a while, then crumbles. Its owner (a TdSpell)
## calls step() and draw() from its own hooks. Lifetimes go through
## CharacterModifiers.temp_time_mult() (the Grave Herald's Restless).
## All damage through TdCombat; holding through RoadBlock / BlockBody.
class_name TempBlockers
extends RefCounted

## The run.
var game: TdGame = null
## Standing raises: [RoadBlock, end game s, damage per hit, s between hits, stats source id].
var raised: Array = []
## Raises made so far (summary).
var count: int = 0
## SpriteData key every Risen of this owner is drawn with (w2d-eye: Call of the Drowned's Thralls).
var sprite: String = "summons/risen"


func _init(p_game: TdGame) -> void:
	game = p_game


## Raises `n` Risen on road `road_id` at `dist` px: `hp` each, holding `hold`,
## hitting for `damage` every `interval` s, for `time` s (x Restless);
## credited to stats source `source`. Returns the block (null on an off-road trail).
func raise(road_id: String, dist: float, n: int, hp: float, hold: int, damage: float, interval: float, time: float, source: String) -> RoadBlock:
	var road: Road = game.roads[road_id]
	if road.off_road:
		return null  # Off-road trails hold nothing (DECISIONS A10).
	var blk := RoadBlock.new()  # The raise's block.
	blk.road_id = road_id
	blk.dist = clampf(dist, 0.0, road.length)
	var dir := road.dir_at(blk.dist)  # Road direction there.
	var nrm := Vector2(dir.y, -dir.x)  # Across the road.
	for i in n:
		var b := BlockBody.new()  # One Risen.
		b.block = blk
		b.temporary = true
		b.max_hp = hp
		b.hp = hp
		b.capacity = hold
		b.pos = road.point_at(blk.dist) + nrm * (float(i) - float(n - 1) * 0.5) * TowerData.BODY_SPACING
		b.vis_rise_at = game.time
		blk.bodies.append(b)
		game.fx.spawn("summon_rise", b.pos, 64.0, 0.4)
	game.add_block(blk)
	raised.append([blk, game.time + time * CharacterModifiers.temp_time_mult(), damage, interval, source])
	count += n
	game.stats["risen"] = int(game.stats.get("risen", 0)) + n
	return blk


## Standing Risen bodies now.
func standing() -> int:
	var n := 0  # Living bodies.
	for r: Array in raised:
		for b: BlockBody in (r[0] as RoadBlock).bodies:
			n += 1 if b.alive else 0
	return n


## One fixed step: strikes, expiries.
func step() -> void:
	for i in range(raised.size() - 1, -1, -1):
		var r: Array = raised[i]
		var blk: RoadBlock = r[0]
		var any := false  # Any body still standing.
		for b: BlockBody in blk.bodies:
			if not b.alive:
				continue
			any = true
			if not b.held.is_empty() and game.time >= b.next_attack:
				b.next_attack = game.time + float(r[3])
				var e: TdEnemy = b.held[0]  # What it strikes.
				TdCombat.damage_enemy(game, e, float(r[2]), {"source": String(r[4]), "origin": b.pos})
				b.vis_strike_at = game.time
				b.vis_dir = (e.position - b.pos).normalized() if e.position != b.pos else Vector2.RIGHT
				if game.vfx.on:
					var f := game.vfx.add(TdVfx.Kind.SLASH, e.position - b.vis_dir * 4.0, TdVfxData.KIT_RISEN_SLASH_D, TdVfxData.SLASH_TIME, TdVfxData.KIT_RISEN_TINT, "evolved")
					if f != null:
						f.ang = b.vis_dir.angle()
		if not any or game.time >= float(r[1]):
			for b: BlockBody in blk.bodies:
				if b.alive:
					game.fx.spawn("undead_death", b.pos, 48.0, 0.4)
			blk.release_all()
			game.remove_block(blk)
			raised.remove_at(i)


## Draws every standing Risen on `ci` (map coords; called from the owner's draw()).
func draw(ci: CanvasItem) -> void:
	for r: Array in raised:
		for b: BlockBody in (r[0] as RoadBlock).bodies:
			if not b.alive:
				continue
			var off := Vector2.ZERO  # Lunge offset (drawn only).
			var lf := (game.time - b.vis_strike_at) / TdVfxData.LUNGE_TIME  # 0..1 through its lunge.
			if TdVfx.motion() and lf >= 0.0 and lf < 1.0:
				off = (b.vis_dir * TdVfxData.LUNGE_PX * TdVfx.lunge_curve(lf)).round()
			var rise := (game.time - b.vis_rise_at) / TdVfxData.RISE_TIME  # 0..1 climbing out.
			if rise >= 0.0 and rise < 1.0 and SpriteBank.draw_rising(ci, sprite, b.pos + off, rise, false, Color.WHITE, TdVfxData.UNIT_SCALE_TOWER):
				continue
			if not SpriteBank.draw(ci, sprite, b.pos + off, game.time < b.flash_until, TdVfxData.KIT_RISEN_BODY, TdVfxData.UNIT_SCALE_TOWER):
				ci.draw_rect(Rect2(b.pos - Vector2(6, 14), Vector2(12, 20)), Color(0.8, 0.8, 0.7))


## Lets every Risen go (the run ends; nothing else to free).
func busy() -> bool:
	return not raised.is_empty()
