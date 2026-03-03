extends Node2D

@onready var bg_1: TextureRect = $BG1
@onready var bg_2: TextureRect = $BG2

func _ready() -> void:
	bg_2.position.y = bg_1.position.y - bg_2.size.y
	
func _process(delta: float) -> void:
	if bg_1.position.y > GameConfig.SCREEN_SIZE.y:
		bg_1.position.y = bg_2.position.y - bg_1.size.y
		
	if bg_2.position.y > GameConfig.SCREEN_SIZE.y:
		bg_2.position.y = bg_1.position.y - bg_2.size.y
