extends Area3D

@export var fwAmbiance : AmbiancePlayer.eAmb
@export var bwAmbiance : AmbiancePlayer.eAmb
@export var ambiance : AmbiancePlayer


func _on_body_exited(body: Node3D) -> void:
	if sign(body.global_position - global_position).dot(global_basis.x) > 0:
		ambiance.switchAmbiance(fwAmbiance)
	else:
		ambiance.switchAmbiance(bwAmbiance)
