extends Spatial
class_name EditorCamera


const RESET_POS = Vector3.ZERO
const RESET_ROTATION = Vector3.ZERO
const RESET_ZOOM = 5

var cam : Camera


func _ready():
	cam = $PivotX/Camera


func get_camera() -> Camera:
	var rv : Camera = $PivotX/Camera
	return rv


func get_pivot_y() -> Spatial:
	return self


func get_pivot_x() -> Spatial:
	return $PivotX as Spatial


func pan_camera(relativeNorm : Vector2, pan_sens) -> void:
	cam.translate(Vector3(-relativeNorm.x, relativeNorm.y, 0) * pan_sens)


func rotate_camera(relativeNorm : Vector2, rot_sens) -> void:
	self.rotate_y(-relativeNorm.x * rot_sens)
	$PivotX.rotate_x(-relativeNorm.y * rot_sens)


func zoom_camera(factor : float, button_index : int, zoom_sens, min_cam_dist : float) -> void:
	if button_index == BUTTON_WHEEL_DOWN:
		cam.translate(Vector3(0, 0, factor * zoom_sens))
	elif button_index == BUTTON_WHEEL_UP:
		if cam.translation.z > min_cam_dist:
			cam.translate(Vector3(0, 0, -factor * zoom_sens))


func reset_cam() -> void:
	self.translation = RESET_POS
	self.rotation = RESET_ROTATION
	$PivotX.rotation = RESET_ROTATION
	cam.translation.z = RESET_ZOOM
