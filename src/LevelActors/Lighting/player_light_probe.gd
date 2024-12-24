extends Area3D

class_name LightProbe

enum e_mode {MIX, OVERRIDE}

@export var mode : e_mode = 0
@export var lightTexture : Texture

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.player_model.registerLightProbe(self)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.player_model.unregisterLightProbe(self)
