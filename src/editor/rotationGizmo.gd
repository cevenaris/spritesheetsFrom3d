class_name RotationGizmo
extends Spatial


const RESET_ROTATION = Vector3.ZERO


func _ready():
	pass


func rotate_gizmo(relativeNorm : Vector2, rot_sens) -> void:
	self.rotate_y(-relativeNorm.x * rot_sens)
	$PivotX.rotate_x(-relativeNorm.y * rot_sens)


func reset_gizmo() -> void:
	self.rotation = RESET_ROTATION
	$PivotX.rotation = RESET_ROTATION
