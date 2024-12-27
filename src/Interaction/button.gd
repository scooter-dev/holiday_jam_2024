extends Interactable

# onready animation

var is_pressed: bool = false

func pressed():
	is_pressed = true
func add_hightlights():
	pass
func remove_highlights():
	pass

func _on_focused(_interactor: Interactor):
	if not is_pressed:
		add_hightlights()

func _on_interacted(_interactor: Interactor):
	if not is_pressed:
		remove_highlights()
		# queue_free()
		pressed()


func _on_unfocused(_interactor: Interactor):
	remove_highlights()
