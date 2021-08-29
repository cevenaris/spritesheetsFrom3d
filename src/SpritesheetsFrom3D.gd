class_name SpriteSheetsFrom3D # add picture
extends Control


export (Vector2) var viewport_size = Vector2(1920, 1080) # setget viewport_size_set
export (bool) var transparent_bg = true # setget transparent_bg_set
export (World) var viewport_world
export (ShaderMaterial) var postprocessing
export (String, FILE, "*.gltf, *.glb, *.dae, *.obj, *.escn, *.fbx") var model_location # setget set_model_location
export (String, DIR) var sheet_save_location
export (float, 0.0, 1.0) var pan_sensitivity = 0.04 # setget set_pan_sens
export (float, 0.0, 1.0) var rotate_sensitivity = 0.04 # setget set_rot_sens
export (float, 0.0, 1.0) var zoom_sensitivity = 0.2 # setget set_zoom_sens

var screenSize : Vector2 # = HelperFunctions.get_display_window_size()
const MIN_VIEWPORT_SIZE = Vector2(192, 108)
var textures : Array = []
#var canChangeViewportSize = true

var top : Panel
var bot : Panel
var left : Panel
var right : Panel
var vbc : VBoxContainer
var hbc : HBoxContainer
var vpc: ViewportContainer
var vpt: Viewport
var edt : MyEditor
var amc : AnimationController
#var is_edt_ready = false
const VPC_CHILD_NUM = 1


func _ready():
	screenSize = HelperFunctions.get_display_window_size()
	$ViewportHeight.rect_size = screenSize
	
	top = $ViewportHeight/TopPanel
	bot = $ViewportHeight/BottomPanel
	left = $ViewportHeight/ViewportWidth/LeftPanel
	right = $ViewportHeight/ViewportWidth/RightPanel
	vbc = $ViewportHeight
	hbc = $ViewportHeight/ViewportWidth
	vpc = $ViewportHeight/ViewportWidth/ViewportContainer
	vpt = vpc.get_child(0)
	edt = vpt.get_child(0)
	amc = $UI/HBoxContainer/AnimationController
	
	adjust_vpc_size(viewport_size)
	
	var modelScene : PackedScene = load(model_location)
	edt.obj = modelScene
	
	vpt.transparent_bg = transparent_bg
	vpt.world = viewport_world
	
#	vpc.material = postprocessing
	
	amc.animationPlayer = edt.get_animation_player()
	
	

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("viewport_get_image"):
			store_current_texture()
			replace_viewport()
		
		elif Input.is_action_just_pressed("test_save_sheet"):
			save_spriteSheet(create_spriteSheet(), sheet_save_location)


#func set_model_location(new_loc : String):
#	if is_edt_ready:
#		print(new_loc)
#		var new_model : PackedScene = load(new_loc)
#		edt.obj = new_model
#
#
#func set_pan_sens(newSens : float):
#	if is_edt_ready:
#		edt.pan_sens = newSens
#
#
#func set_rot_sens(newSens : float):
#	if is_edt_ready:
#		edt.rot_sens = newSens
#
#
#func set_zoom_sens(newSens : float):
#	if is_edt_ready:
#		edt.zoom_sens = newSens
#
#
#func transparent_bg_set(yes):
#	pass
#
#
#func bg_color_set(new_color):
#	pass


func clamp_new_size(new_size : Vector2) -> Vector2:
	var rv : Vector2 = Vector2.ZERO
	rv.x = clamp(new_size.x, MIN_VIEWPORT_SIZE.x, screenSize.x) as int
	rv.y = clamp(new_size.y, MIN_VIEWPORT_SIZE.y, screenSize.y) as int
	return rv


func adjust_vpc_size(new_size_unclamped: Vector2):
	var new_size : Vector2 = clamp_new_size(new_size_unclamped)
	
	var x : int = new_size.x
	var y : int = new_size.y
	
	var x_proportion : float = x / screenSize.x
	var y_proportion : float = y / screenSize.y
	
	hbc.size_flags_stretch_ratio = y_proportion
	vpc.size_flags_stretch_ratio = x_proportion
	
	var left_right : float = (1 - x_proportion) / 2
	var top_bot : float = (1 - y_proportion) / 2
	
	left.size_flags_stretch_ratio = left_right
	right.size_flags_stretch_ratio = left_right
	top.size_flags_stretch_ratio = top_bot
	bot.size_flags_stretch_ratio = top_bot


func store_current_texture() -> void:
	var image : ViewportTexture = vpt.get_texture()
	textures.append(image)


func replace_viewport() -> void:
	var transY = edt.get_pivot_y().transform
	var transX = edt.get_pivot_x().transform
	var transZ = edt.get_camera().transform
	
	var dupe = vpc.duplicate()
	hbc.remove_child(hbc.get_child(VPC_CHILD_NUM))
	hbc.add_child(dupe)
	hbc.move_child(dupe, VPC_CHILD_NUM)
	
	vpc = hbc.get_child(VPC_CHILD_NUM)
	vpt = vpc.get_child(0)
	edt = vpt.get_child(0)
	
	edt.get_pivot_y().transform = transY
	edt.get_pivot_x().transform = transX
	edt.get_camera().transform = transZ
	


func create_spriteSheet() -> Image:
	var x = textures[0].get_width()
	var y = textures[0].get_height() * textures.size() 
	
	var pba : PoolByteArray = PoolByteArray()
	for i in textures:
		var img : Image= i.get_data()
		img.convert(Image.FORMAT_RGBA8)
		pba.append_array(img.get_data())
	
	var rv : Image = Image.new()
	rv.create_from_data(x, y, false, Image.FORMAT_RGBA8, pba)
	
	return rv


func save_spriteSheet(imgSheet : Image, saveLoc : String):
	imgSheet.save_png(saveLoc)


func wait(seconds : float) -> void:
	yield(get_tree().create_timer(seconds), "timeout")

#func _on_myEditor_ready():
#	is_edt_ready = true
#	yield(get_tree().create_timer(2.0), "timeout")
#
#	set_pan_sens(pan_sensitivity)
#	set_rot_sens(rotate_sensitivity)
#	set_zoom_sens(zoom_sensitivity)
#	set_model_location(model_location as String)
