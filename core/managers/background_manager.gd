extends Node2D

@onready var bg_1: TextureRect = $BG1
@onready var bg_2: TextureRect = $BG2

func _ready() -> void:
	bg_2.position.y = bg_1.position.y - bg_2.size.y
	
func _process(delta: float) -> void:
	var screen_size := GameConfig.get_screen_size(self)
	
	if bg_1.position.y > screen_size.y:
		bg_1.position.y = bg_2.position.y - bg_1.size.y
		
	if bg_2.position.y > screen_size.y:
		bg_2.position.y = bg_1.position.y - bg_2.size.y
