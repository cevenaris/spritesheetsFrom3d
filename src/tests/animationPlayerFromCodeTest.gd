extends Spatial


onready var ap : AnimationPlayer = $AnimationPlayer


func _ready():
	yield(get_tree().create_timer(2), "timeout")
	ap.play("greet")
	yield(ap, "animation_finished")
	ap.play("walk")
