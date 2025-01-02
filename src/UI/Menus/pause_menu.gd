extends Control

signal reset

@export var resume_button: Button

func _ready() -> void:
	PlayerInput.pause.connect(pausePressed)

func pausePressed() -> void:
	if get_tree().paused:
		if !margin_container.visible:
			options.close()
		unpause()
	else:
		pause()

func pause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	show()
	resume_button.grab_focus()

func _on_resume_pressed() -> void:
	unpause()

func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	hide()


func _on_return_pressed() -> void:
	unpause()
	LevelManager.changeLevel("res://Scenes/MenuLevels/menu_level.tscn")


func _on_reset_pressed() -> void:
	unpause()
	reset.emit()

@export var options: OptionsMenu
@export var margin_container: MarginContainer

func _on_options_pressed() -> void:
	if !options.visible:
		options.open()
		margin_container.visible = false


func _on_options_closed() -> void:
	margin_container.visible = true
	resume_button.grab_focus()
