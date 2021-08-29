tool
extends Control


var total_time = 0.0


func _process(delta):
	total_time += delta
	$ViewportContainer/Viewport/Spatial/Camera.translation.z = 5 * cos(total_time) + 8
