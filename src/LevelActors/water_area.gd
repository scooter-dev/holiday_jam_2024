extends Area3D

class_name WaterVolume


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.movement


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		pass
