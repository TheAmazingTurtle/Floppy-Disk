extends Area2D

signal player_exit

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		collision_shape_2d.disabled = true
		player_exit.emit()
