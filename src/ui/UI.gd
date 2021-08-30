class_name UIManager
extends CanvasLayer


const STATUS_START = "Status: "


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_children_visibility()


func toggle_children_visibility():
	$HBoxContainer/Status.visible = !$HBoxContainer/Status.visible
	$HBoxContainer/AnimationController.visible = !$HBoxContainer/AnimationController.visible


func change_status_text(text : String, seconds : float):
	$HBoxContainer/Status.text = STATUS_START + text
	yield(get_tree().create_timer(seconds), "timeout")
	$HBoxContainer/Status.text = STATUS_START


func _on_SpritesheetsFrom3D_picture_taken():
	change_status_text("Picture taken.", 2)


func _on_SpritesheetsFrom3D_sheet_saved():
	change_status_text("Image saved.", 2)
