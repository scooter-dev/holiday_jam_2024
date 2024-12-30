@tool

extends Node3D

@export var enabled : bool = false:
	set(en):
		enabled = en
		if is_inside_tree():
			tile.get_surface_override_material(0).albedo_color = Color.GREEN if enabled else Color.DARK_GRAY
@export var impulse : float = 10.0:
	set(imp):
		impulse = imp
		if is_inside_tree():
			setHeightDebug()
@export var directionalImpulse : Vector2
@export_category("Components")
@export var height_debug: MeshInstance3D
@export var tile: MeshInstance3D

func setHeightDebug() -> void:
	height_debug.position.y = pow(impulse,2) / (2 * 9.8)

func _ready() -> void:
	setHeightDebug()
	tile.get_surface_override_material(0).albedo_color = Color.GREEN if enabled else Color.DARK_GRAY


func _on_area_3d_body_entered(body: Node3D) -> void:
	if enabled and body is Player:
		body.movement.launchPlayer(Vector3(0,impulse,0) + directionalImpulse.x * global_basis.x.normalized() + directionalImpulse.y * global_basis.z.normalized(), true)
