extends Node3D

@export var drop_shadow_mesh: MeshInstance3D
@onready var dss : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
var ray : PhysicsRayQueryParameters3D

func _ready() -> void:
	ray = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 1

func _physics_process(delta: float) -> void:
	ray.from = global_position
	ray.to = global_position - Vector3(0,20.0,0)
	var res = dss.intersect_ray(ray)
	if res.has("collider"):
		drop_shadow_mesh.visible = true
		drop_shadow_mesh.global_position.y = res.position.y - 0.95
	else:
		drop_shadow_mesh.visible = false
