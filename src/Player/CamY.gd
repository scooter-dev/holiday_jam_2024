extends Node3D

@export var camX: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
const ANGLE_LIMIT = PI / 2

func _physics_process(delta):
	rotate_y(PlayerInput.ludrl.x)
	camX.rotation.x = clamp(camX.rotation.x + PlayerInput.ludrl.y, -ANGLE_LIMIT, ANGLE_LIMIT)
