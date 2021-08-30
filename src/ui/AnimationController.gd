class_name AnimationController
extends Control


var animationPlayer : AnimationPlayer setget set_animationPlayer
var options : OptionButton
var slider : HSlider


func _ready():
	options = $HBoxContainer/AnimationPicker
	slider = $animationSlider
	animationPlayer = null


func _process(delta):
	if animationPlayer != null:
		if animationPlayer.is_playing():
			slider.value = animationPlayer.current_animation_position


func set_animationPlayer(new_player : AnimationPlayer) -> void:
	options.clear()
	
	# using boolean short circuiting here to avoid a null error
	if new_player == null or new_player.get_animation_list().size() <= 0:
		options.text = "No animations found."
		$HBoxContainer/Start.disabled = true
		$HBoxContainer/End.disabled = true
		$HBoxContainer/Rewind.disabled = true
		$HBoxContainer/Play.disabled = true
		$HBoxContainer/Pause.disabled = true
		$animationSlider.visible = false
	else:
		options.text = "Select an animation: "
		var animationList = new_player.get_animation_list()
		for i in range(animationList.size()):
			options.add_item(animationList[i], i)
		options.selected = 0
		
		animationPlayer = new_player
		change_animation(0)
		animationPlayer.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(anim_name):
	_on_Pause_pressed()


func setup_slider():
	slider.min_value = 0
	slider.max_value = animationPlayer.current_animation_length
	slider.tick_count = 100


# only call with animation picker values
func change_animation(id : int) -> void:
	var name : String = options.get_item_text(id)
#	print(name)
	animationPlayer.current_animation = name
	animationPlayer.seek(0, true)
	setup_slider()
#	print(animationPlayer.current_animation)


func _on_Start_pressed():
	if options.items.size() > 0:
		animationPlayer.seek(0, true)
		_on_Pause_pressed()


func _on_End_pressed():
	if options.items.size() > 0:
		animationPlayer.seek(animationPlayer.current_animation_length, true)
		_on_Pause_pressed()


func _on_Rewind_toggled(button_pressed):
	if button_pressed:
		animationPlayer.play_backwards(animationPlayer.current_animation)
		$HBoxContainer/Play.disabled = true
	else:
		_on_Pause_pressed()


func _on_AnimationPicker_item_selected(id):
#	print(id) works correctly
	change_animation(id)
	setup_slider()


func _on_Pause_pressed():
	if options.items.size() > 0:
		animationPlayer.stop(false)
	$HBoxContainer/Play.pressed = false
	$HBoxContainer/Play.disabled = false
	$HBoxContainer/Rewind.pressed = false
	$HBoxContainer/Rewind.disabled = false


func _on_animationSlider_value_changed(value):
	if !animationPlayer.is_playing():
		animationPlayer.seek(value, true)


func _on_Play_toggled(button_pressed):
	if button_pressed:
		animationPlayer.play(animationPlayer.current_animation)
		$HBoxContainer/Rewind.disabled = true
	else:
		_on_Pause_pressed()
