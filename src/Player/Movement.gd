extends Node

class_name PlayerMovement

enum {M_FALLING, M_GROUNDED, M_SWIMMING, M_CROUCHING}
var movementMode: int = M_FALLING
var velocity := Vector3()
var acceleration: float = 70
var damping: float = 16.0
var jump_acceleration: float = 5
var h_speed: float = 0

var jump_state: bool = false
var jump_counter: float = 0

@export var groundRays: GroundRays
@export var camY: Node3D
@export var playerInput: PlayerInput
@export var player: CharacterBody3D
@export var airControl: float = 0.1

func set_jump(state: bool):
	jump_state = state

func _ready():
	playerInput.jump.connect(set_jump)

func _physics_process(delta):
	velocity = player.get_real_velocity()
	h_speed = Vector2(velocity.x, velocity.z).length()
	m_mode()

	var direction: Vector3 = camY.global_basis.x * playerInput.fbrl.x + camY.global_basis.z * playerInput.fbrl.y
	direction = direction.limit_length()
	match movementMode:
		M_FALLING:
			velocity.y = clamp(velocity.y - 9.8 * delta, -80, 80)
			# velocity -= velocity * damping * delta

			if h_speed < 4:
				velocity += direction * delta * acceleration * airControl
			else:
				var dt: float = -velocity.dot(direction)
				if dt < 0.1:
					velocity += direction * delta * acceleration * airControl
				else:
					velocity += (direction * delta * acceleration * airControl).project(camY.global_basis.y.normalized().cross(Vector3(velocity.x, 0, velocity.z).normalized()))
		M_GROUNDED:
			velocity -= velocity * damping * delta
			velocity += direction * delta * acceleration

			velocity.y = clamp(-groundRays.groundDistance * delta * 1200, -6, 6)
			if jump_state:
				set_m_mode(M_FALLING)
				velocity.y = jump_acceleration
		M_SWIMMING:
			pass
		M_CROUCHING:
			pass

	
	player.velocity = velocity
	player.move_and_slide()
			
func m_mode():
	match movementMode:
		M_FALLING:
			if groundRays.groundDistance < 0 and velocity.y < 0.5:
				set_m_mode(M_GROUNDED)
		M_GROUNDED:
			if groundRays.groundDistance > 0.3:
				set_m_mode(M_FALLING)
		M_SWIMMING:
			pass
		M_CROUCHING:
			pass
func set_m_mode(n_mode: int):
	movementMode = n_mode
