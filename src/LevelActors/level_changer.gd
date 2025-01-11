extends Area3D

@export var level : String

func changeLevel() -> void:
	LevelManager.changeLevel(level)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.suspend(true)
		changeLevel.call_deferred()
