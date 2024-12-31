extends Area3D

class_name Interactable

signal focused(interactor: Interactor)
signal unfocused(interactor: Interactor)
signal interacted(interactor: Interactor)

func enable() -> void:
	collision_layer = 8
func disable() -> void:
	collision_layer = 0
