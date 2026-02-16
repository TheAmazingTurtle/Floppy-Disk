extends Node

signal transition_done

const MOVEMENT_SPEED = 400

var movable_nodes := []
var move_offset : Vector2
var is_transitioning := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _process(delta: float) -> void:
	if not is_transitioning:
		return
	
	var step = move_offset.normalized() * MOVEMENT_SPEED * delta
	
	if step.length() > move_offset.length():
		step = move_offset
	
	for node in movable_nodes:
		if not node or not is_instance_valid(node):
			continue 
		node.position -= step
	
	move_offset -= step
	
	if move_offset.length() <= 0:
		move_offset = Vector2.ZERO
		is_transitioning = false
		get_tree().paused = false
		transition_done.emit()

func _on_room_manager_next_level_ready(_move_offset: Vector2) -> void:
	movable_nodes = get_tree().get_nodes_in_group("movable")
	move_offset = _move_offset
	is_transitioning = true
	get_tree().paused = true
