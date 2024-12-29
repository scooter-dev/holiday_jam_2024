extends Area3D

class_name InfoBoxArea

@export_multiline var text : String

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.hud.display_info_box(text)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.hud.close_info_box()
