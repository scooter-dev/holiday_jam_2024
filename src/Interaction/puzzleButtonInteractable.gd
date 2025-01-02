extends Interactable

var is_pressed: bool = false

signal raiseStairs

func pressed():
	is_pressed = true

func _on_interacted(_interactor: Interactor):
	if not is_pressed:
		print("pressed")
		raiseStairs.emit()
		pressed()
