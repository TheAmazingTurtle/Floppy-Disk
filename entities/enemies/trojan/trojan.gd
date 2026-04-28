extends Node2D

const SPEED = 200

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var dash_timer: Timer = $DashTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var floppy_disk: Node = _get_player()
var direction : Vector2
var is_dashing := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(floppy_disk):
		floppy_disk = _get_player()
	
	if not is_instance_valid(floppy_disk):
		return

	if not is_dashing:
		return
	
	position += direction * SPEED * delta

func _on_cooldown_timer_timeout() -> void:
	if not is_instance_valid(floppy_disk):
		floppy_disk = _get_player()
	
	if not is_instance_valid(floppy_disk):
		return
		
	direction = global_position.direction_to(floppy_disk.global_position)
	
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
		
	sprite.play("dashing")
	is_dashing = true
	dash_timer.start()


func _on_dash_timer_timeout() -> void:
	sprite.play("idle")
	is_dashing = false
	cooldown_timer.start()

func _get_player() -> Node:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	
	return players[0]
