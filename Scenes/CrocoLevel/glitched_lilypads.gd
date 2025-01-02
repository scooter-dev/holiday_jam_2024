extends Node3D


@export var button: Node3D

var stairsActivated: bool = false

func _ready():
	button.activateStepsMotion.connect(_on_stairs_button_activate_steps_motion)

func activatedStairs():
	stairsActivated = true

func _physics_process(delta):
	rotate_object_local(Vector3(0, 1, 0), 0.01)

	if stairsActivated:
		position.y = lerpf(position.y, 0, delta*4.0)
		if(position.y > -0.01):
			stairsActivated = false


func _on_stairs_button_activate_steps_motion():
	activatedStairs()
