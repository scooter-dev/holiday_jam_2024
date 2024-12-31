extends Control

@export var sub_viewport: SubViewport

func _enter_tree() -> void:
	sub_viewport.add_child(load(LevelManager.levelToLoad).instantiate())
