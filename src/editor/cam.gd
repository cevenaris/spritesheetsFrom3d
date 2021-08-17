extends Spatial
class_name EditorCamera


const RESET_POS = Vector3.ZERO
const RESET_ROTATION = Vector3.ZERO
const MAX_ZOOM_IN = 0.1

var MOVE_SENS = 0.03
var ZOOM_SENS = 0.02

var cam : Camera


func _ready():
	cam = $PivotX/Camera


func _input(event):
	if Input.is_action_pressed("editor_pan1") and Input.is_action_pressed("editor_pan2"):
		if event is InputEventMouseMotion:
			cam.translate(Vector3(-event.relative.x, event.relative.y, 0) * MOVE_SENS)
	
	elif Input.is_action_pressed("editor_rotate"):
		if event is InputEventMouseMotion:
			var norm : Vector2 = event.relative.normalized()
			self.rotate_y(norm.x * MOVE_SENS)
			$PivotX.rotate_x(-norm.y * MOVE_SENS)
	
	elif Input.is_action_pressed("editor_zoomIn") or Input.is_action_pressed("editor_zoomOut"):
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_DOWN:
					cam.translate(Vector3(0, 0, event.factor * ZOOM_SENS))
				if event.button_index == BUTTON_WHEEL_UP:
					if cam.translation.z > MAX_ZOOM_IN:
						cam.translate(Vector3(0, 0, -event.factor * ZOOM_SENS))
	
	elif Input.is_action_just_pressed("editor_reset_transform"):
		self.translation = RESET_POS
		self.rotation = RESET_ROTATION


func manage_rotation(x, y):
	pass