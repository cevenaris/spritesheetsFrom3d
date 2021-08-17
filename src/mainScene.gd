extends Control


var screenSize : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize.x = ProjectSettings.get_setting("display/window/size/width")
	screenSize.y = ProjectSettings.get_setting("display/window/size/height")
	$HBoxContainer.rect_size = screenSize
	pass # Replace with function body.


func _process(delta):
	pass
	
