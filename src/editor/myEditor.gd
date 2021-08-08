extends Spatial


var cam : Camera
var totalTime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $Camera
	pass # Replace with function body.


func _process(delta):
	test(delta)
	pass


func _input(event):
	pass


func test(delta):
	totalTime += delta
	var a = 4 * sin(0.25 * totalTime * PI)
	cam.translation = Vector3(0, 0, a)
