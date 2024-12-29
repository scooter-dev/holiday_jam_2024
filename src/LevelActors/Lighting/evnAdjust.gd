extends WorldEnvironment

@export var player : Player
@export var farPlane : float = 50.0
@export var envLighting : Texture

func _ready() -> void:
	player.camera.far = farPlane
	RenderingServer.global_shader_parameter_set("view_distance", farPlane)
