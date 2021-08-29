class_name UIManager
extends CanvasLayer


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_children_visibility()


func toggle_children_visibility():
	$HBoxContainer/Status.visible = !$HBoxContainer/Status.visible
	$HBoxContainer/AnimationController.visible = !$HBoxContainer/AnimationController.visible
