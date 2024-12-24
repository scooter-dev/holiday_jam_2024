extends OmniLight3D

class_name PlayerFirefly

var timer : float = 0.0

func _ready() -> void:
	set_physics_process(false)
	visible = false

func activate(time : float, additive : bool = false):
	timer = time
	if timer > 0.0:
		visible = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if timer > 0.001:
		timer = max(0, timer - delta)
	else:
		visible = false
		set_physics_process(false)
