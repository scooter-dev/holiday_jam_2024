extends Area3D

class_name LightProbe

enum e_mode {MIX, OVERRIDE}

@export var mode : e_mode = 0
@export var falloff : float = 0.5
@export var lightTexture : Texture
@export var skyReplace : Texture

@export var shape : CollisionShape3D
@export var directionNode : Node3D
@export var environment : Environment

var prevSky : Texture

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.player_model.registerLightProbe(self)
		if skyReplace and environment:
			prevSky = environment.sky.sky_material.panorama
			environment.sky.sky_material.panorama = skyReplace

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.player_model.unregisterLightProbe(self)
		if skyReplace and environment:
			environment.sky.sky_material.panorama = prevSky
