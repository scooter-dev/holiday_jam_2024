extends Interactor

@export var player: Player

var current_closest: Interactable

var enabled : bool = true
signal interacted(obj : Interactable)
func _ready():
	PlayerInput.interact.connect(onInteract)
	controller = player

func onInteract() -> void:
	if !enabled:
		return
	if current_closest:
			interact(current_closest)
			interacted.emit(current_closest)

func _physics_process(_delta):
	var new_closest: Interactable = get_closest_interactable()

	if new_closest != current_closest:
		if is_instance_valid(current_closest):
			unfocus(current_closest)
		if new_closest:
			focus(new_closest)
		
		current_closest = new_closest


func _on_area_exited(area: Interactable):
	if current_closest == area:
		unfocus(area)
