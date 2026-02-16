extends Node2D

signal next_level_ready(_move_offset: Vector2)

const BITS = preload("uid://gbnv60og4kua")
const ROOM = preload("uid://c3xuv3iytwkw")
const SOURCE_ID := 0

const BARRIER_TILE := Vector2i(7,3)
const EXIT_TILE := Vector2i(1,2)

var running = true
var room_size := Vector2i(22, 12)
var compartment_num := 3
var current_room_scene: Node2D
var next_room_scene: Node2D
var current_room: Room
var next_room: Room
var is_transitioning := false

func _ready() -> void:
	randomize()
	
	current_room = Room.new(room_size, 1, false)
	current_room_scene = _construct_room_scene(current_room)
	current_room_scene.position = (GameConfig.SCREEN_SIZE - (room_size as Vector2) * GameConfig.TILE_SIZE) / 2
	
	_create_new_room()

func _process(delta: float) -> void:
	if not running:
		return
	
	if get_tree().get_nodes_in_group("bits").size() == 0:
		_generate_coins_inside_next_room(5)
		_open_room()

func _create_new_room() -> void:
	next_room = Room.new(room_size, compartment_num)
	next_room_scene = _construct_room_scene(next_room)
	next_room_scene.position.x = (GameConfig.SCREEN_SIZE.x - room_size.x * GameConfig.TILE_SIZE) / 2
	next_room_scene.position.y = current_room_scene.position.y - (room_size.y - 1) * GameConfig.TILE_SIZE

func _generate_coins_inside_next_room(num: int) -> void:
	var count := 0
	while count < num:
		var x = randi_range(1, room_size.x-1)
		var y = randi_range(1, room_size.y-1)
		
		var candidate = Vector2i(x,y)
		if candidate not in next_room.barrier_tiles:
			var bit = BITS.instantiate()
			add_child(bit)
			bit.position = (candidate as Vector2) * GameConfig.TILE_SIZE + next_room_scene.position
			count += 1

func _construct_room_scene(room: Room) -> Node:
	var room_scene = ROOM.instantiate()
	add_child(room_scene)
	
	room_scene.get_node("Exit").player_exit.connect(_on_player_exit)
	
	var tile_map_layer: TileMapLayer = room_scene.get_node_or_null("TileMapLayer")
	for tile_pos in room.barrier_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, BARRIER_TILE)
	
	for tile_pos in room.exit_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, EXIT_TILE)
		
	return room_scene

func _open_room() -> void:
	var tile_map_layer: TileMapLayer = current_room_scene.get_node_or_null("TileMapLayer")
	current_room_scene.get_node("Exit").get_node("CollisionShape2D").disabled = false
	for tile_pos in current_room.exit_tiles:
		tile_map_layer.erase_cell(tile_pos)

func _close_room() -> void:
	var tile_map_layer: TileMapLayer = next_room_scene.get_node_or_null("TileMapLayer")
	for tile_pos in next_room.entrance_tiles:
		tile_map_layer.set_cell(tile_pos, SOURCE_ID, BARRIER_TILE)

func _on_player_exit() -> void:
	_close_room()
	
	current_room_scene.queue_free()
	current_room_scene = next_room_scene
	current_room = next_room
	
	_create_new_room()
	next_level_ready.emit(_get_move_offset())

func _get_move_offset() -> Vector2:
	return current_room_scene.position - (GameConfig.SCREEN_SIZE - (current_room.room_size as Vector2) * GameConfig.TILE_SIZE) / 2

func _on_game_manager_transition_done() -> void:
	is_transitioning = false
