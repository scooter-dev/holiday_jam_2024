extends Node3D

@export var level : String
@export_category("Components")
@export var rotate: Node3D

func openLevel() -> void:
	LevelManager.levelToLoad = level
	get_tree().change_scene_to_file("res://src/UI/Renderer/game_renderer.tscn")

func _process(delta: float) -> void:
	rotate.rotate_y(delta * 2.0)
