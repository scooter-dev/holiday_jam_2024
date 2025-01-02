extends Node3D

class_name Laser

var pointA : Vector3
var pointB : Vector3
var lifeTime : float
var laserColor : Color = Color.RED
@export var mesh_instance_3d: MeshInstance3D

func _enter_tree() -> void:
	mesh_instance_3d.material_override.albedo_color = laserColor
	var dist : float = (pointB - pointA).length()
	global_position = pointA
	look_at(pointB)
	scale.z = dist / 2.0
	await get_tree().create_timer(lifeTime).timeout
	queue_free()
