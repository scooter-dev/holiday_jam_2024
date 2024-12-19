extends Node

class_name PlayerInput

var fbrl: Vector2
var ludrl: Vector2
signal jump(state: bool)
signal slide(state : bool)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		ludrl = -event.relative * 0.0025

func _physics_process(delta):
	fbrl = Input.get_vector("left", "right", "up", "down")
	set_deferred("ludrl", Vector2())

	if Input.is_action_just_pressed("jump"):
		jump.emit(true)
	elif Input.is_action_just_released("jump"):
		jump.emit(false)
	
	if Input.is_action_just_pressed("slide"):
		slide.emit(true)
	elif Input.is_action_just_released("slide"):
		slide.emit(false)
