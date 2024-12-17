extends CharacterBody3D


var speed = 10
var jump_speed = 10
var grav_factor = 3
var turn_speed = 5
var target_velocity = Vector3.ZERO

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $CameraBase

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta * grav_factor

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# rotate_x(direction.x * 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

# 	move_and_slide()
# func _process(delta):
# 	var input = Input.get_action_strength("ui_up")
# 	apply_central_force(input * Vector3.FORWARD * 1200.0 * delta)
