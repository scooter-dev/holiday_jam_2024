extends CharacterBody3D

class_name Player

@export var movement: PlayerMovement
@export var firefly: PlayerFirefly
@export var player_model: PlayerModel
@export var camera: Camera3D
@export var cam_y: PlayerCamera
@export var hud: PlayerHud


func suspend(camLock : bool = false) -> void:
	#movement.set_m_mode(PlayerMovement.M_FALLING)
	movement.set_m_mode(PlayerMovement.M_SUSPENDED, 3)
	cam_y.camLocked = camLock

func unsuspend() -> void:
	movement.set_m_mode(PlayerMovement.M_FALLING)
	cam_y.camLocked = false
