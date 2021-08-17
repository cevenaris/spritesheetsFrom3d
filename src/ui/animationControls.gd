extends HBoxContainer


signal start
signal reverse
signal play
signal end


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_start_pressed():
	emit_signal("start")


func _on_reverse_pressed():
	emit_signal("reverse")


func _on_play_pressed():
	emit_signal("play")


func _on_end_pressed():
	emit_signal("end")
