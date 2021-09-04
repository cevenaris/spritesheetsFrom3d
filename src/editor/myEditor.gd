extends Spatial
class_name MyEditor


var pan_sens = 0.08
var rot_sens = 0.08
var zoom_sens = 0.2
var min_cam_dist = 0.1

const OBJ_CHILD_LOC = 0
var obj : Node setget set_obj
var cam : EditorCamera


func _ready():
	cam = $PivotY


func _input(event):
	if Input.is_action_pressed("editor_pan1") and Input.is_action_pressed("editor_pan2"):
		if event is InputEventMouseMotion:
			var norm : Vector2 = event.relative.normalized()
			cam.pan_camera(norm, pan_sens)
	
	elif Input.is_action_pressed("editor_rotate"):
		if event is InputEventMouseMotion:
			var norm : Vector2 = event.relative.normalized()
			cam.rotate_camera(norm, rot_sens)
	
	elif Input.is_action_pressed("editor_zoomIn") or Input.is_action_pressed("editor_zoomOut"):
		if event is InputEventMouseButton:
			if event.is_pressed():
				cam.zoom_camera(event.factor, event.button_index, zoom_sens, min_cam_dist)
	
	elif Input.is_action_just_pressed("editor_reset_transform"):
		cam.reset_cam()


func set_obj(new_obj : Node):
	if obj != null:
		obj.queue_free()
		obj = null
	
	if new_obj == null:
		print("ERROR: scene file could not be loaded, using default cube instead")
		createPlaceHolder()
	else:
		add_child(new_obj)
		move_child(new_obj, OBJ_CHILD_LOC)
	obj = new_obj


func createPlaceHolder():
	var placeHolder = Spatial.new()
	var cube = MeshInstance.new()
	cube.mesh = CubeMesh.new()
	placeHolder.add_child(cube)
	add_child(placeHolder)
	move_child(placeHolder, OBJ_CHILD_LOC)


func get_camera() -> Camera:
	return $PivotY.get_camera()


func get_pivot_y() -> Spatial:
	return $PivotY.get_pivot_y()


func get_pivot_x() -> Spatial:
	return $PivotY.get_pivot_x()
