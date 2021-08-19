extends Control

var vp : Viewport
var editorScene = preload("res://editor/myEditor.tscn")
var editor : MyEditor
var textures : Array = []
var saveLoc = "res://tests/VTUT.png"


func _ready():
	vp = $HBoxContainer/ViewportContainer/Viewport
	editor = editorScene.instance()
	vp.add_child(editor)
	print_tree_pretty()
	vp.render_target_update_mode = Viewport.UPDATE_ALWAYS
	print(vp.get_camera().current)
	
	print(vp.get_texture().get_data().get_data().size())
	
	


func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		var pivotY = $HBoxContainer/ViewportContainer/Viewport.get_child(0).get_child(1)
		var transY = pivotY.transform
		var transX = pivotY.get_child(0).transform
		var dupe = $HBoxContainer/ViewportContainer.duplicate()
		print(dupe.get_child(0).name)
		print(dupe.name)
		$HBoxContainer.remove_child($HBoxContainer.get_child(0))
		$HBoxContainer.add_child(dupe)
		$HBoxContainer.move_child(dupe, 0)
		var pivotY2 = dupe.get_child(0).get_child(0).get_child(1)
		pivotY2.transform = transY
		pivotY2.get_child(0).transform = transX
		print_tree_pretty()
		
		textures.append(dupe.get_child(0).get_texture())
	
	if Input.is_action_just_pressed("ui_cancel"):
		saveSheet()


func saveSheet():
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
	
	rv.save_png(saveLoc)
		
		# It seems that
		# viewports will only display correctly if and only if
		# they are in a viewport container
		# which must then be put into another container(like the HBoxContainer)
		# Then the preview shows up in the editor and they work properly in the
		# app window too
		# wack
