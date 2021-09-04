class_name UIManager
extends CanvasLayer


var par : SpriteSheetsFrom3D
var amc : AnimationController
var bui : HBoxContainer
var lbh : VBoxContainer
var cct : VBoxContainer
var sth : VBoxContainer
var sts : Label
var act : Label
var pvx : Spatial
var pvy : Spatial
var cam : Camera

const ACTION_START = "Action: "
const STATUS_SEPARATOR = " - "
const STATUS_START = "Status: sheet name" + STATUS_SEPARATOR + "number of pictures"
const ACTION_TEXT_WAIT_TIME = 1.5
var names : PoolStringArray

var font : DynamicFont


func _ready():
	par = self.get_parent()
	amc = $BottomUI/AnimationController
	bui = $BottomUI
	lbh = $BottomUI/Labels
	cct = $CamControls
	sth = $StatusHolder
	sts = $StatusHolder/Status
	act = $BottomUI/Labels/Actions
	
	font = par.font
	set_fonts()
	
	yield(get_tree().create_timer(2), "timeout")
	names = par.sheet_names
	set_cam_stuff()
	
	change_status_text()
	change_action_text("", 0.1)


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_children_visibility()


func set_fonts():
	amc.set_fonts(font)
	
	if font != null:
		for i in cct.get_children():
			var temp : Button = i as Button
			i.set("custom_fonts/font", font)
		
		sts.set("custom_fonts/font", font)
		act.set("custom_fonts/font", font)
		
		if font.size > par.screenSize.x / 96:
			cct.rect_position.x -= font.size * 3 # empirically verified


func set_cam_stuff():
	pvx = par.edt.get_pivot_x()
	pvy = par.edt.get_pivot_y()
	cam = par.edt.get_camera()


func toggle_children_visibility():
	sth.visible = !sth.visible
	bui.visible = !bui.visible
	cct.visible = !cct.visible


func change_status_text():
	sts.text = STATUS_START
	var nums = par.get_texture_numbers_list()
	for i in range(nums.size()):
		sts.text += "\n\t" + names[i] + STATUS_SEPARATOR + str(nums[i])


func change_action_text(text : String, seconds : float):
	act.text = ACTION_START + text
	yield(get_tree().create_timer(seconds), "timeout")
	act.text = ACTION_START


func set_slider_subdiv(num : int):
	amc.slider_subdiv = num


func swap_amp(new_amp : AnimationPlayer, time : float):
	amc.animationPlayer = new_amp
	amc.animation_time = time


func _on_SpritesheetsFrom3D_picture_taken():
	change_action_text("Picture taken.", ACTION_TEXT_WAIT_TIME)
	change_status_text()
	set_cam_stuff()


func _on_SpritesheetsFrom3D_sheet_saved():
	change_action_text("Image saved.", ACTION_TEXT_WAIT_TIME)
	change_status_text()


func _on_plusX_pressed():
	pvx.rotation.x = 0
	pvy.rotation.y = 3 * PI / 2


func _on_plusY_pressed():
	pvx.rotation.x = 3 * PI / 2
	pvy.rotation.y = 0


func _on_plusZ_pressed():
	pvx.rotation.x = 0
	pvy.rotation.y = 0


func _on_minusX_pressed():
	pvx.rotation.x = 0
	pvy.rotation.y = PI / 2


func _on_minusY_pressed():
	pvx.rotation.x = PI / 2
	pvy.rotation.y = 0


func _on_minusZ_pressed():
	pvx.rotation.x = 0
	pvy.rotation.y = PI


func _on_OptionButton_item_selected(id):
	match id:
		0: 
			cam.projection = Camera.PROJECTION_PERSPECTIVE
		1: 
			cam.projection = Camera.PROJECTION_ORTHOGONAL
		2: 
			cam.projection = Camera.PROJECTION_FRUSTUM
		_:
			cam.projection = Camera.PROJECTION_PERSPECTIVE
			print("Error switching camera projection modes, changing to perspective for now")


func _on_SpritesheetsFrom3D_picture_undone():
	change_action_text("Undid picture take.", ACTION_TEXT_WAIT_TIME)
	change_status_text()
