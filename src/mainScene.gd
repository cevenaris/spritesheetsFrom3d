extends Control


var screenSize : Vector2
var textures : Array = []

var hbc : HBoxContainer
var vpc: ViewportContainer
var vp: Viewport

var texture_width = 800
var texture_height = 400

var saveLoc : String = "res://tests/spriteSheetTest.png"


# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize.x = ProjectSettings.get_setting("display/window/size/width")
	screenSize.y = ProjectSettings.get_setting("display/window/size/height")
	$HBoxContainer.rect_size = screenSize
	
	vp = $HBoxContainer/ViewportContainer/Viewport
	pass # Replace with function body.
	
#	test(vp.get_texture())


func _process(delta):
	pass


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("viewport_get_image"):
#			var image : Texture = vp.get_texture()
#			textures.append(image)
#			print(textures)
			var image : ViewportTexture = vp.get_texture()
			textures.append(image)
			print(textures)
#			swap_viewports()
		
		elif Input.is_action_just_pressed("test_save_sheet"):
			print("s pressed")
			save_spriteSheet(create_spriteSheet())


# 
#func test(text : Texture):
#	var img : Image = text.get_data()
#	var pba : PoolByteArray = img.get_data()
#	print(pba.size())


func create_spriteSheet() -> Image:
	var x = textures[0].get_width()
	var y = textures[0].get_height() * textures.size() 
	
	var pba : PoolByteArray = PoolByteArray()
	for i in textures:
		print(i.get_data())
#		var toFlip = i.get_data()
#		toFlip.flip_y()
#		var flipped = toFlip.get_data()
		pba.append_array(i.get_data().get_data())
	
	var rv : Image = Image.new()
	rv.create_from_data(x, y, false, Image.FORMAT_RGBAH, pba)
	
	return rv


func save_spriteSheet(imgSheet : Image):
	imgSheet.save_png(saveLoc)
