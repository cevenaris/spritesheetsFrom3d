extends Control


export (String, FILE) var modelLoc
var ap : AnimationPlayer


func _ready():
	var model : PackedScene = load(modelLoc)
	var scene = model.instance()
	$HBoxContainer/ViewportContainer/Viewport/Spatial.add_child(scene)
	$HBoxContainer/ViewportContainer/Viewport/Spatial.move_child(scene, 0)
#	get_animation_player(scene)
	ap = get_animation_player2(scene)
	$Button.connect("pressed", self, "button_pressed")
	$Button2.ap = ap


func button_pressed():
	if ap != null:
		ap.play(ap.get_animation_list()[0])


func get_animation_player(scene):
	for node in scene.get_children():
		if node is AnimationPlayer:
			ap = node


func get_animation_player2(scene):
	for node in scene.get_children():
		if node is AnimationPlayer:
			return node
