extends Node3D

func _physics_process(delta):
	rotate_object_local(Vector3(0, 1, 0), 0.01)
