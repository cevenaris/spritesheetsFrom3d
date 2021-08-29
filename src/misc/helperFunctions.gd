class_name HelperFunctions
extends Resource


static func get_display_window_size() -> Vector2:
	var rv : Vector2 = Vector2()
	rv.x = ProjectSettings.get_setting("display/window/size/width")
	rv.y = ProjectSettings.get_setting("display/window/size/height")
	return rv
