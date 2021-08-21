extends Control


var screenSize : Vector2
var textures : Array = []

var hbc : HBoxContainer
var vpc: ViewportContainer
var vpt: Viewport
var edt : MyEditor

var texture_width = 800
var texture_height = 400

var saveLoc : String = "res://tests/spriteSheetTest.png"


# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize.x = ProjectSettings.get_setting("display/window/size/width")
	screenSize.y = ProjectSettings.get_setting("display/window/size/height")
	$HBoxContainer.rect_size = screenSize
	
	hbc = $HBoxContainer
	vpc = $HBoxContainer/ViewportContainer
	vpt = $HBoxContainer/ViewportContainer/Viewport
	edt = $HBoxContainer/ViewportContainer/Viewport/myEditor


func _process(delta):
	pass


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("viewport_get_image"):
			store_current_texture()
			replace_viewport()
		
		elif Input.is_action_just_pressed("test_save_sheet"):
			save_spriteSheet(create_spriteSheet())


func store_current_texture() -> void:
	var image : ViewportTexture = vpt.get_texture()
	textures.append(image)


func replace_viewport() -> void:
	var transY = edt.get_pivot_y().transform
	var transX = edt.get_pivot_x().transform
	var transZ = edt.get_camera().transform
	
	var dupe = vpc.duplicate()
	hbc.remove_child(hbc.get_child(0))
	hbc.add_child(dupe)
	hbc.move_child(dupe, 0)
	
	vpc = hbc.get_child(0)
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


func save_spriteSheet(imgSheet : Image):
	imgSheet.save_png(saveLoc)
