extends Area3D

@export var level : String

func changeLevel() -> void:
	LevelManager.levelToLoad = level
	get_tree().change_scene_to_file("res://src/UI/Renderer/game_renderer.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.suspend(true)
		changeLevel.call_deferred()
