@tool

extends Node3D

class_name WoodPlatform

const WOOD_BOARDS = preload("res://Assets/Textures/woodBoards.png")
const WOOD_BOARDS_CRACKED = preload("res://Assets/Textures/woodBoardsCracked.png")

@export var breaks : bool = false:
	set(brk):
		breaks = brk
		if is_inside_tree():
			platformMesh.material_override.set_shader_parameter("albedo_texture", WOOD_BOARDS_CRACKED if breaks else WOOD_BOARDS)
@export var breakTime : float = 5.0
@export var respawnTime = 10.0

var breakTimer : float = 0.0
var respawnTimer : float = 0.0

@export_category("Components")
@export var platform_body: CharacterBody3D
@export var particles: CPUParticles3D
@export var platformMesh: MeshInstance3D
@export var animation_player: AnimationPlayer

var breaking : bool = false

func _ready() -> void:
	platformMesh.material_override.set_shader_parameter("albedo_texture", WOOD_BOARDS_CRACKED if breaks else WOOD_BOARDS)
	set_physics_process(false)

func _on_platform_body_child_entered_tree(node: Node) -> void:
	if breaks and node is Player:
		set_physics_process(true)
		breaking = true
		breakTimer = breakTime
		respawnTimer = respawnTime

func _physics_process(delta: float) -> void:
	if breaking:
		breakTimer = maxf(0, breakTimer - delta)
		if breakTimer <= 1.0 and breakTimer > 0.01:
			platformMesh.position.y = sin(breakTimer * 58.0) * 0.025 + 0.025
			platformMesh.position.x = sin(breakTimer * 64.0) * 0.025 + 0.025
			platformMesh.position.z = sin(breakTimer * 48.0) * 0.025 + 0.025
		if breakTimer < 0.001:
			breaking = false
			platform_body.collision_layer = 0
			particles.emitting = true
			platformMesh.position = Vector3()
			await get_tree().physics_frame
			platform_body.set_deferred("visible", false)
	else:
		respawnTimer = maxf(0, respawnTimer - delta)
		if respawnTimer < 0.001:
			platform_body.collision_layer = 1
			platform_body.visible = true
			set_physics_process(false)
			animation_player.play("Grow",-1,2.0)
