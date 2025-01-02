extends Control

func _ready() -> void:
	await get_tree().create_timer(randf_range(1,4)).timeout
	LevelManager.loadAL()
