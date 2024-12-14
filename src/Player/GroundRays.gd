extends Node3D

class_name GroundRays

var groundDistance: float
var groundNormal: float
const ANGLE_LIMIT: float = cos(deg_to_rad(50))

func _physics_process(delta):
	groundDistance = 50
	for ray: RayCast3D in get_children():
		if ray.get_collider():
			var dist = global_position.y - ray.get_collision_point().y
			var normal = ray.get_collision_normal()
			if dist < groundDistance and Vector3.UP.dot(normal) > ANGLE_LIMIT:
				groundDistance = dist
