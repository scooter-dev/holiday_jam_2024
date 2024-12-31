extends MeshInstance3D

@export var interactor: Interactor

func _process(delta: float) -> void:
	if interactor.current_closest != null:
		visible = true
		global_position = interactor.current_closest.global_position
	else:
		visible = false
