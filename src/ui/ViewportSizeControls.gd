class_name ViewportSizeControls
extends Control


var oldText

var width : TextEdit
var height : TextEdit

var locked = false

export var starting_width = 1319
export var starting_height = 1080
export var minimum_width = 100
export var maximum_width = 1700
export var minimum_height = 100
export var maximum_height = 1080

signal sizeValuesChanged(w, h)


func _ready():
	width = $HBoxContainer/widthContainer/width
	height = $HBoxContainer/heightContainer/height
	
	$HBoxContainer.rect_size = self.rect_size
	
	width.text = str(starting_width)
	height.text = str(starting_height)


func _on_width_gui_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			if isValueValid(width.text):
				var temp = int(width.text)
				temp = temp.clamp(temp, minimum_width, maximum_width)
				emit_signal("sizeValuesChanged", temp, int(height.text))


func _on_height_gui_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			if isValueValid(height.text):
				var temp = int(height.text)
				temp = temp.clamp(temp, minimum_height, maximum_height)
				emit_signal("sizeValuesChanged", int(width.text), temp)


func isValueValid(val : String) -> bool:
	var temp = int(val)
	if temp <= 0:
		return false
	return true


func _on_ViewportSizeControls_resized():
	$HBoxContainer.rect_size = self.rect_size
