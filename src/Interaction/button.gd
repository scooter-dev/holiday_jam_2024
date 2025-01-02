extends StaticBody3D

@export var interactable: Interactable

var isPressed: bool = false

signal activateStepsMotion

func _ready():
	interactable.raiseStairs.connect(activation)

func activation():
	isPressed = true
	activateStepsMotion.emit()
