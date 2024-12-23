extends OmniLight3D

class_name VertexLight

func _enter_tree() -> void:
	LightingManager.registerLight(self)

func _exit_tree() -> void:
	LightingManager.unregisterLight(self)
