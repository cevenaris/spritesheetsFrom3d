extends Spatial


const MOVE_SENS = 0.01
const SCROLL_SENS = 0.2
#const RESET_POS : Transform = 


var cam : Camera
var pivot : Spatial
var totalTime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $placeHolder/Pivot/Camera
	pivot = $placeHolder/Pivot
	pass # Replace with function body.


func _process(delta):
#	test(delta)
	pass


func _input(event):
	if Input.is_action_pressed("editor_pan1") and Input.is_action_pressed("editor_pan2"):
		if event is InputEventMouseMotion:
			cam.translate(Vector3(-event.relative.x, event.relative.y, 0) * MOVE_SENS)
	
	elif Input.is_action_pressed("editor_rotate"):
		if event is InputEventMouseMotion:
			pivot.rotate_y(event.relative.x * MOVE_SENS)
			pivot.rotate_x(-event.relative.y * MOVE_SENS)
	
	elif Input.is_action_pressed("editor_zoomIn") or Input.is_action_pressed("editor_zoomOut"):
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_DOWN:
					cam.translate(Vector3(0, 0, event.factor * SCROLL_SENS))
				if event.button_index == BUTTON_WHEEL_UP:
					cam.translate(Vector3(0, 0, -event.factor * SCROLL_SENS))


func zoom(amount : int):
	pass


func input_stuff():
	if Input.is_action_pressed("editor_rotate"):
		print("hi")


func test(delta):
	totalTime += delta
	var a = 4 * sin(0.25 * totalTime * PI)
	cam.translation = Vector3(0, 0, a)
