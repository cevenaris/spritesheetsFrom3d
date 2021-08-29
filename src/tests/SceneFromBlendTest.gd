extends Control

var vpt : Viewport
const fileName = "res://tests/human_low_animated.glb"


func _ready():
	vpt = $CenterContainer/ViewportContainer/Viewport
	
	var test : PackedScene = create_scene()
	var scene = test.instance()
	
	vpt.add_child(scene)
	
	var anPlayer = has_child_with_name(scene, "AnimationPlayer")
	if anPlayer != -1:
		scene.get_child(anPlayer).play("greet")
	


func create_scene() -> PackedScene:
	return preload(fileName)


func has_child_with_name(parent : Node, child_name : String) -> int:
	for i in range(parent.get_children().size()):
		if parent.get_child(i).name == child_name:
			return i
	
	return -1
