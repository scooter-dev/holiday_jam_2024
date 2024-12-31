extends Area3D

class_name Checkpoint

@export var checkpointSeqNumber : int = 0


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.setCheckpoint(self)
