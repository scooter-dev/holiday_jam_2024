extends Node

var fbrl: Vector2
var ludrl: Vector2
signal jump(state: bool)
signal slide(state : bool)
signal interact
signal pause

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		ludrl = -event.relative * OptionsManager.lookSensitivity

func _physics_process(delta):
	fbrl = Input.get_vector("left", "right", "up", "down")
	ludrl += Input.get_vector("look_right","look_left","look_down","look_up", 0.1) * OptionsManager.lookSensitivity * 16.0
	set_deferred("ludrl", Vector2())

	if Input.is_action_just_pressed("jump"):
		jump.emit(true)
	elif Input.is_action_just_released("jump"):
		jump.emit(false)
	
	if Input.is_action_just_pressed("slide"):
		slide.emit(true)
	elif Input.is_action_just_released("slide"):
		slide.emit(false)
	
	if Input.is_action_just_pressed("interact"):
		interact.emit()
	
	if Input.is_action_just_pressed("pause"):
		pause.emit()
