extends Node2D

const SPEED = 75

@onready var floppy_disk: Node = _get_player()

func _process(delta: float) -> void:
	if not is_instance_valid(floppy_disk):
		floppy_disk = _get_player()
	
	if not is_instance_valid(floppy_disk):
		return
	
	var direction = global_position.direction_to(floppy_disk.global_position)
	position += direction * SPEED * delta

func _get_player() -> Node:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	
	return players[0]
