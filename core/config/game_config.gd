extends Node

class_name GameConfig

const TILE_SIZE = 32

static func get_screen_size(context: Node) -> Vector2:
	if context != null and context.is_inside_tree():
		return context.get_viewport().get_visible_rect().size
	
	return Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
