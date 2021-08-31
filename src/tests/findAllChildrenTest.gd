extends Node2D



func _ready():
	print(find_all_children(self))


func find_all_children(top : Node):
	if top.get_child_count() <= 0:
		return [top]
	else:
		var rv = [top]
		for i in top.get_children():
			rv += find_all_children(i)
		return rv
