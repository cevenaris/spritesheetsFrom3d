class_name HelperFunctions
extends Node


static func get_display_window_size() -> Vector2:
	var rv : Vector2 = Vector2()
	rv.x = ProjectSettings.get_setting("display/window/size/width")
	rv.y = ProjectSettings.get_setting("display/window/size/height")
	return rv


static func get_all_descendants(top : Node) -> Array:
	if top.get_child_count() <= 0:
		return [top]
	else:
		var rv = [top]
		for i in top.get_children():
			rv += get_all_descendants(i)
		return rv


static func get_all_descendants_of_type(top : Node, type) -> Array:
	var rv : Array = []
	var all = get_all_descendants(top)
	for i in all:
		if i is Array:
			if i[0] is type:
				rv.append(i[0])
		else:
			if i is type:
				rv.append(i)
	return rv
