extends OmniLight3D

class_name VertexLight

#func _enter_tree() -> void:
	#if visible:
		#LightingManager.registerLight(self)
#
#func _exit_tree() -> void:
	#LightingManager.unregisterLight(self)
#
#
#func _on_visibility_changed() -> void:
	#if visible:
		#LightingManager.registerLight(self)
	#else:
		#LightingManager.unregisterLight(self)
