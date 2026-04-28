extends Node2D

signal player_exit

const SOURCE_ID := 0
const BARRIER_TILE := Vector2i(7,3)
const EXIT_TILE := Vector2i(1,2)

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var exit_collision: CollisionShape2D = $Exit/CollisionShape2D

var data : RoomData

func setup(room_size: Vector2i, compartment_num: int, enemies: Array = [], has_entrance: bool = true) -> void:
	data = RoomData.new(room_size, compartment_num, enemies, has_entrance)
	
	_construct_tiles()
	_configure_exit_trigger()

func _construct_tiles() -> void:
	for tile_pos in data.barrier_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, BARRIER_TILE)
	
	for tile_pos in data.exit_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, EXIT_TILE)

func _configure_exit_trigger() -> void:
	if data.exit_tiles.is_empty():
		exit_collision.shape = null
		return
	
	var min_tile: Vector2i = data.exit_tiles[0]
	var max_tile: Vector2i = data.exit_tiles[0]
	
	for tile_pos in data.exit_tiles:
		min_tile.x = mini(min_tile.x, tile_pos.x)
		min_tile.y = mini(min_tile.y, tile_pos.y)
		max_tile.x = maxi(max_tile.x, tile_pos.x)
		max_tile.y = maxi(max_tile.y, tile_pos.y)
	
	var tile_size := tile_map_layer.tile_set.tile_size
	var top_left := tile_map_layer.map_to_local(min_tile) - Vector2(tile_size) / 2.0
	var bottom_right := tile_map_layer.map_to_local(max_tile) + Vector2(tile_size) / 2.0
	var shape := RectangleShape2D.new()
	
	shape.size = bottom_right - top_left
	exit_collision.position = top_left + shape.size / 2.0
	exit_collision.shape = shape
	exit_collision.disabled = true

func summon_enemies():
	for enemy in data.enemies:
		var enemy_scene = enemy.instantiate()
		add_child(enemy_scene)

func open() -> void:
	exit_collision.disabled = false
	for tile_pos in data.exit_tiles:
		tile_map_layer.erase_cell(tile_pos)

func close() -> void:
	for tile_pos in data.entrance_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, BARRIER_TILE)

func _on_exit_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_exit.emit()
		queue_free()
