extends Node3D

@export var level : String
@export var levelVars : Array[String]
@export_category("Components")
@export var rotate: Node3D
@export var corruption : Node3D

func _ready() -> void:
	var uncorrupted = true
	for lv : String in levelVars:
		if !LevelManager.glitches.has(lv):
			uncorrupted = false
			break
	corruption.visible = !uncorrupted

func openLevel() -> void:
	LevelManager.changeLevel(level)

func _process(delta: float) -> void:
	rotate.rotate_y(delta * 2.0)


func _on_interactable_interacted(interactor: Interactor) -> void:
	openLevel()
