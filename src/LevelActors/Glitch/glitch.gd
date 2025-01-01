extends Node3D

@export var varChange : String
@export_category("Components")
@export var rotator: Node3D
@export var animation_player: AnimationPlayer
@export var interactable: Interactable

func _process(delta: float) -> void:
	rotator.rotate_y(delta * 2.0)

var player : Player

func _on_interactable_interacted(interactor: Interactor) -> void:
	player = interactor.controller if interactor.controller is Player else null
	if player:
		interactable.disable()
		LevelManager.set_deferred(varChange, true)
		animation_player.play("PickUp")
		player.hud.display_info_box("Glitch Collected")

func hideInfoBox() -> void:
	player.hud.close_info_box()
