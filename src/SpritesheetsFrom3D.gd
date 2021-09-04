class_name SpriteSheetsFrom3D # add picture
extends Control


export (String, FILE, "*.gltf, *.glb, *.dae, *.obj, *.escn, *.fbx, *.tscn") var model_location
export (String, DIR) var sheet_save_location
export (int, 1, 10) var number_of_sheets
export (PoolStringArray) var sheet_names = PoolStringArray()
export (bool) var fullscreen
export (Vector2) var viewport_size = Vector2(1920, 1080) 
export (bool) var transparent_bg = true 
export (Environment) var environment
export (ShaderMaterial) var canvas_shader
export (ShaderMaterial) var spatial_shader
export (float, 0.0, 1.0) var pan_sensitivity = 0.04 
export (float, 0.0, 1.0) var rotate_sensitivity = 0.04 
export (float, 0.0, 1.0) var zoom_sensitivity = 0.2 
export (float, 0, 1000000) var minimum_camera_distance = 0.1
export (int, 10, 1000) var slider_subdivisions = 100
export (DynamicFont) var font

var currSheet : int = 0
const DEFAULT_SHEET_NAME = "unnamedSheet"
const SHEET_EXTENSION = ".png"

var screenSize : Vector2 
const MIN_VIEWPORT_SIZE = Vector2(192, 108)
var textures : Array = []
var texture_numbers : Array = []

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
var mds # the model scene
var amp : AnimationPlayer

const VPC_CHILD_NUM = 1

signal picture_taken
signal picture_undone
signal sheet_saved


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
	amc = $UI/BottomUI/AnimationController
	
	OS.window_fullscreen = fullscreen
	
	adjust_vpc_size(viewport_size)
	
	var modelScene : PackedScene = load(model_location)
	if modelScene != null:
		mds = modelScene.instance()
		edt.obj = mds
		amp = get_animation_player(mds)
		$UI/BottomUI/AnimationController.animationPlayer = amp
	else:
		edt.obj = null
		amc.animationPlayer = null
	
	edt.get_camera().environment = environment
	vpc.material = canvas_shader
	
	if modelScene != null:
		var allMeshes : Array = HelperFunctions.get_all_descendants_of_type(mds, MeshInstance)
		for i in allMeshes:
			var mesh : MeshInstance = i as MeshInstance
			mesh.set_surface_material(0, spatial_shader)
	
	edt.pan_sens = pan_sensitivity
	edt.rot_sens = rotate_sensitivity
	edt.zoom_sens = zoom_sensitivity
	edt.min_cam_dist = minimum_camera_distance
	
	$UI.set_slider_subdiv(slider_subdivisions)
	
	for _i in range(number_of_sheets):
		textures.append([])
		texture_numbers.append(0)
	
	while sheet_names.size() > number_of_sheets:
		sheet_names.remove(sheet_names.size() - 1)
	
	var count = 1
	for i in range(sheet_names.size() - 1):
		if sheet_names[i] == null or sheet_names[i] == "":
			sheet_names[i] = DEFAULT_SHEET_NAME + str(count)
			count += 1
	while sheet_names.size() < number_of_sheets:
		sheet_names.append(DEFAULT_SHEET_NAME + str(count))
		count += 1


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("viewport_get_image"):
			store_current_texture()
			replace_viewport()
			emit_signal("picture_taken")
		
		elif Input.is_action_just_pressed("viewport_undo"):
			toss_last_texture()
			emit_signal("picture_undone")
		
		elif Input.is_action_just_pressed("textures_save_sheet"):
			save_all_sheets()
			emit_signal("sheet_saved")


func get_texture_numbers_list() -> Array:
	return texture_numbers


func get_animation_player(root : Node) -> AnimationPlayer:
	for child in root.get_children():
		if child is AnimationPlayer:
			return child
	return null


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
	textures[currSheet].append(image)
	texture_numbers[currSheet] += 1
	increment_sheet_num(true)


func toss_last_texture() -> void:
	increment_sheet_num(false)
	var sheet : Array = textures[currSheet]
	sheet.pop_back()
	texture_numbers[currSheet] -= 1


func increment_sheet_num(pos : bool) -> void:
	if pos:
		currSheet += 1
	else:
		currSheet -= 1
	currSheet %= number_of_sheets


func replace_viewport() -> void:
	var transY = edt.get_pivot_y().transform
	var transX = edt.get_pivot_x().transform
	var transZ = edt.get_camera().transform
	var ampTime = amp.current_animation_position
	
	var dupe = vpc.duplicate()
	hbc.remove_child(hbc.get_child(VPC_CHILD_NUM))
	hbc.add_child(dupe)
	hbc.move_child(dupe, VPC_CHILD_NUM)
	
	vpc = hbc.get_child(VPC_CHILD_NUM)
	vpt = vpc.get_child(0)
	edt = vpt.get_child(0)
	mds = edt.get_child(0)
	amp = get_animation_player(mds)

	edt.get_pivot_y().transform = transY
	edt.get_pivot_x().transform = transX
	edt.get_camera().transform = transZ
	$UI.swap_amp(amp, ampTime)


func create_spriteSheet(which : int) -> Image:
	var x = textures[which][0].get_width()
	var y = textures[which][0].get_height() * textures.size() 
	
	var pba : PoolByteArray = PoolByteArray()
	for i in textures[which]:
		var img : Image = i.get_data()
		img.convert(Image.FORMAT_RGBA8)
		pba.append_array(img.get_data())
	
	var rv : Image = Image.new()
	rv.create_from_data(x, y, false, Image.FORMAT_RGBA8, pba)
	
	return rv


func save_spriteSheet(imgSheet : Image, saveLoc : String, saveName : String):
	imgSheet.save_png(saveLoc + "/" + saveName + SHEET_EXTENSION)


func save_all_sheets():
	for i in range(number_of_sheets):
		save_spriteSheet(create_spriteSheet(i), sheet_save_location, sheet_names[i])


func wait(seconds : float) -> void:
	yield(get_tree().create_timer(seconds), "timeout")
