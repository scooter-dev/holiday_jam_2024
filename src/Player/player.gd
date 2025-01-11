extends CharacterBody3D

class_name Player

@export var movement: PlayerMovement
@export var firefly: PlayerFirefly
@export var player_model: PlayerModel
@export var camera: Camera3D
@export var cam_y: PlayerCamera
@export var hud: PlayerHud
@export var interactor: Area3D

signal playerDied

func _ready() -> void:
	lastCheckpoint = Node3D.new()
	get_parent().add_child.call_deferred(lastCheckpoint)
	lastCheckpoint.set_deferred("global_position", global_position)

func suspend(camLock : bool = false) -> void: #Suspends the player for cutscenes and such
	#movement.set_m_mode(PlayerMovement.M_FALLING)
	movement.set_m_mode(PlayerMovement.M_SUSPENDED, 3)
	cam_y.camLocked = camLock
	interactor.enabled = false

func unsuspend() -> void:#Returns control to the player
	movement.set_m_mode(PlayerMovement.M_FALLING)
	cam_y.camLocked = false
	interactor.enabled = true

var lastCheckpoint : Node3D
var lastCheckpointSeq : int = -1

var dieLock : bool = false
func die() -> void:
	if dieLock:
		return
	playerDied.emit()
	dieLock = true
	suspend(true)
	hud.fadeOut.connect(onFadeOut)
	hud.fadeIn.connect(onFadeIn)
	hud.fade()

func onFadeOut() -> void:
	global_position = lastCheckpoint.global_position

func onFadeIn() -> void:
	dieLock = false
	unsuspend()
	hud.fadeOut.disconnect(onFadeOut)
	hud.fadeIn.disconnect(onFadeIn)

func setCheckpoint(chk : Checkpoint) -> void:
	if chk.checkpointSeqNumber >= lastCheckpointSeq:
		lastCheckpoint = chk
		lastCheckpointSeq = chk.checkpointSeqNumber

func _on_pause_menu_reset() -> void:
	die()
