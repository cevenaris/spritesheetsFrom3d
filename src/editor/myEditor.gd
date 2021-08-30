extends Spatial
class_name MyEditor


#export (NodePath) var parentPath = null
var pan_sens = 0.08
var rot_sens = 0.08
var zoom_sens = 0.2

const OBJ_CHILD_LOC = 0
var obj : Node setget set_obj
#var animationPlayer : AnimationPlayer
var cam : EditorCamera
#var rotGizmo : RotationGizmo

#const GIZMO_CONTROL_SUBDIV = 5


func _ready():
	cam = $PivotY
#	animationPlayer = null
#	rotGizmo = $Control/HBoxContainer/ViewportContainer/Viewport/Spatial/PivotY
	
#	var parent = get_node(parentPath)
#	if parent != null:
#		$Control.rect_size = parent.screenSize / GIZMO_CONTROL_SUBDIV
#		pan_sens = parent.pan_sensitivity
#		rot_sens = parent.rot_sensitivity
#		zoom_sens = parent.zoom_sensitivity
#
#	else:
#		$Control.rect_size = HelperFunctions.get_display_window_size() / GIZMO_CONTROL_SUBDIV
#
#	$Control.rect_position = Vector2((GIZMO_CONTROL_SUBDIV - 1) * $Control.rect_size.x, 0)
#	$Control/HBoxContainer.rect_size = $Control.rect_size


func _input(event):
	if Input.is_action_pressed("editor_pan1") and Input.is_action_pressed("editor_pan2"):
		if event is InputEventMouseMotion:
			var norm : Vector2 = event.relative.normalized()
			cam.pan_camera(norm, 0.08)
	
	elif Input.is_action_pressed("editor_rotate"):
		if event is InputEventMouseMotion:
			var norm : Vector2 = event.relative.normalized()
			cam.rotate_camera(norm, 0.08)
#			rotGizmo.rotate_gizmo(norm, 0.08)
	
	elif Input.is_action_pressed("editor_zoomIn") or Input.is_action_pressed("editor_zoomOut"):
		if event is InputEventMouseButton:
			if event.is_pressed():
				cam.zoom_camera(event.factor, event.button_index, 0.2)
	
	elif Input.is_action_just_pressed("editor_reset_transform"):
		cam.reset_cam()
#		rotGizmo.reset_gizmo()


func set_obj(new_obj : Node):
	if new_obj == null:
		print("ERROR: scene file could not be loaded, using default cube instead")
		createPlaceHolder()
	else:
		add_child(new_obj)
		move_child(new_obj, OBJ_CHILD_LOC)


func createPlaceHolder():
	var placeHolder = Spatial.new()
	var cube = MeshInstance.new()
	cube.mesh = CubeMesh.new()
	placeHolder.add_child(cube)
	add_child(placeHolder)
	move_child(placeHolder, OBJ_CHILD_LOC)


#func set_animation_player(objScene : Node) -> void:
#	var childList = objScene.get_children()
#	for child in childList:
#		if child is AnimationPlayer:
#			animationPlayer = child
#			return
#	animationPlayer = null
#
#
#func get_animation_player() -> AnimationPlayer:
#	return animationPlayer


func get_camera() -> Camera:
	return $PivotY.get_camera()


func get_pivot_y() -> Spatial:
	return $PivotY.get_pivot_y()


func get_pivot_x() -> Spatial:
	return $PivotY.get_pivot_x()
