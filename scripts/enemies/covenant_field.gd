## CovenantField: the run's shared Covenant ground state that no single
## enemy owns: the holy zones on the map (Radiant Inquisitor zones,
## Seraphine's beams, the rings of Holy Ward Generators) and a short buffer
## of recent Covenant deaths (High Confessor revivals). One node per run,
## made on first use under game.world (`of(game)`); maps without these kinds
## never make it. Draws its zones with textures only (no polygons), on the
## game clock. Holds no balance numbers: callers pass them from their rows.
class_name CovenantField
extends Node2D

## Node name under game.world (one per run).
const NODE_NAME: String = "CovenantField"
## Texture key (SpriteData folder) of a zone's disc.
const ZONE_TEX: String = "holy/zone_85"
## Recent deaths kept (the oldest is dropped beyond it).
const DEATH_CAP: int = 32  # TUNING (not in GDD) Necropathy's DEATH_BUFFER_SIZE

## The run.
var game: TdGame = null
## Zones: [map px, radius px, end game s (INF = while its owner lives), tint, owner TdEnemy or null, owner generation].
var zones: Array = []
## Recent deaths: [kind, road id, distance px, lane px, game s].
var deaths: Array = []


## The run's field, made on first use.
static func of(game: TdGame) -> CovenantField:
	var f := game.world.get_node_or_null(NODE_NAME) as CovenantField  # Existing field.
	if f == null:
		f = CovenantField.new()
		f.name = NODE_NAME
		f.game = game
		f.z_index = -2  # On the floor, under the units.
		game.world.add_child(f)
	return f


## Records the death of `e` when the run has a field (only maps with revivers need it).
static func record_death(game: TdGame, e: TdEnemy) -> void:
	if game.world == null:
		return
	var f := game.world.get_node_or_null(NODE_NAME) as CovenantField  # The field, if any.
	if f == null or bool(e.row.get("structure", false)):
		return
	if f.deaths.size() >= DEATH_CAP:
		f.deaths.pop_front()
	f.deaths.append([e.kind, e.follower.road.id, e.follower.dist, e.follower.lane, game.time])


## Adds a zone at `pos` of `radius` px until game s `until`, drawn with `tint`.
## With `owner` it follows that enemy and lasts while it lives.
func add_zone(pos: Vector2, radius: float, until: float, tint: Color, owner: TdEnemy = null) -> void:
	zones.append([pos, radius, until, tint, owner, owner.generation if owner != null else 0])


## Towers whose spot lies within `radius` px of `pos`.
func towers_near(pos: Vector2, radius: float) -> Array[Tower]:
	var out: Array[Tower] = []  # Matching towers.
	for t: Tower in game.towers:
		if t.position.distance_squared_to(pos) <= radius * radius:
			out.append(t)
	return out


func _process(_delta: float) -> void:
	for i in range(zones.size() - 1, -1, -1):
		var z: Array = zones[i]
		var owner: TdEnemy = z[4]
		if game.time >= float(z[2]) or (owner != null and not TdEnemy.valid(owner, int(z[5]))):
			zones.remove_at(i)
		elif owner != null:
			z[0] = owner.position
	queue_redraw()


func _draw() -> void:
	var tex := MapView.grid_texture(ZONE_TEX)  # The disc art (cached wrapper).
	for z: Array in zones:
		var r := float(z[1])  # Radius (px).
		if tex != null:
			draw_texture_rect(tex, Rect2(Vector2(z[0]) - Vector2(r, r), Vector2(r, r) * 2.0), false, z[3])
		else:
			draw_rect(Rect2(Vector2(z[0]) - Vector2(r, r), Vector2(r, r) * 2.0), Color(z[3], 0.15))
