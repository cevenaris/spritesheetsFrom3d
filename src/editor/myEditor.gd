extends Spatial
class_name MyEditor


var totalTime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _input(event):
	pass


func get_camera() -> Camera:
	return $PivotY.get_camera()
