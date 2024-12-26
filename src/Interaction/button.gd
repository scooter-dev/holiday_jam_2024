extends Interactable

# onready animation

var is_open: bool = false

func open():
	is_open = true
func add_hightlights():
	pass
func remove_highlights():
	pass

func _on_focused(_interactor: Interactor):
	if not is_open:
		add_hightlights()

func _on_interacted(_interactor: Interactor):
	if not is_open:
		remove_highlights()
		queue_free()
		open()


func _on_unfocused(_interactor: Interactor):
	remove_highlights()
