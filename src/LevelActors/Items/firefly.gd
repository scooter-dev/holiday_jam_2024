extends Node3D

@export var firefly_mesh: MeshInstance3D
@export var fireflyTime : float = 60.0
@export var interactable: Interactable


var eaten : bool = false
var timer : float = 0.0
var respawnTimer : float = 0.0
func _process(delta: float) -> void:
	timer = timer + delta if timer < PI * 12 else 0.0
	firefly_mesh.position.x = sin(timer * 0.5) * 0.25
	firefly_mesh.position.y = cos(timer * 2.0) * 0.25
	firefly_mesh.position.z = sin(timer * 4.0) * 0.25
	
	if eaten:
		respawnTimer = max(0.0, respawnTimer - delta)
		if respawnTimer < 0.001:
			eaten = false
			interactable.enable()
			firefly_mesh.visible = true
	

func _on_interactable_interacted(interactor: Interactor) -> void:
	print("interacted")
	if eaten:
		print("returned")
		return
	var player : Player = interactor.controller if interactor.controller is Player else null
	if player != null:
		player.firefly.activate(fireflyTime)
		eaten = true
		interactable.disable()
		respawnTimer = fireflyTime * 0.5
		firefly_mesh.visible = false
