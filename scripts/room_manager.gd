extends Node

class Room:
	const ROOM = preload("uid://c3xuv3iytwkw")
	
	var origin: Vector2i
	var obstacle_tiles: Array
	var entrance_tiles: Array
	var exit_tiles: Array
	var scene: Node
	
	func _init(origin: Vector2i, room_size: Vector2i) -> void:
		pass

const ROOM = preload("uid://c3xuv3iytwkw")
const TILE_SIZE = 32
const SCREEN_SIZE: Vector2i = Vector2(1280, 720) / TILE_SIZE

var current_room: Room
var next_room: Room

func _ready() -> void:
	pass

func _construct_new_room() -> Node2D:
	var new_room = ROOM.instantiate()
	
	
	return new_room
