extends Node3D

class_name GroundRays

var groundDistance: float = 50
var groundNormal: Vector3 = Vector3.UP
const ANGLE_LIMIT: float = cos(deg_to_rad(42))
var gDistR: float = 50
var gNormR: Vector3 = Vector3.UP
var ground: Node3D

func _physics_process(delta):
	ground = null
	groundDistance = 50
	gDistR = 50
	groundNormal = Vector3.UP
	gNormR = Vector3.UP
	for ray: RayCast3D in get_children():
		if ray.get_collider():
			var dist = global_position.y - ray.get_collision_point().y
			var normal = ray.get_collision_normal()
			if dist < groundDistance and Vector3.UP.dot(normal) > ANGLE_LIMIT:
				groundDistance = dist
				groundNormal = normal
				ground = ray.get_collider()
			if dist < gDistR:#get the ground distance and normal even if no walkable ground is found
				gDistR = dist
				gNormR = normal
