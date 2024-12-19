extends Node

class_name PlayerMovement

enum {M_FALLING, M_GROUNDED, M_SWIMMING, M_CROUCHING, M_SLIDING}
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
@export var slideRay : RayCast3D
@export var airControl: float = 0.14

signal jumped

func set_jump(state: bool):
	jump_state = state

var slideState : bool = false
func set_slide(state : bool):
	slideState = state

func _ready():
	playerInput.jump.connect(set_jump)
	playerInput.slide.connect(set_slide)

var nwProtect : int = 0
func _physics_process(delta):
	velocity = player.get_real_velocity()
	h_speed = Vector2(velocity.x, velocity.z).length()
	m_mode()
	
	var direction: Vector3 = camY.global_basis.x * playerInput.fbrl.x + camY.global_basis.z * playerInput.fbrl.y
	direction = direction.limit_length()
	match movementMode:
		M_FALLING:
			# velocity -= velocity * damping * delta
			var sliding = slideRay.get_collider() != null
			var slideNormal : Vector3 = slideRay.get_collision_normal()
			var gdt : float = slideNormal.dot(Vector3.UP)
			sliding = sliding and gdt > 0.0 and gdt < 0.95
			if !(sliding):
				velocity.y = clamp(velocity.y - 9.8 * delta, -80, 80)
				#look_arrow.visible = false
				if h_speed < 2:
					velocity += direction * delta * acceleration * airControl
				else:
					var dt: float = velocity.dot(direction)
					if dt < 0.0:
						velocity += direction * delta * acceleration * airControl
					else:
						velocity += (direction * delta * acceleration * airControl).project(camY.global_basis.y.normalized().cross(Vector3(velocity.x, 0, velocity.z).normalized()))
			else:
				set_m_mode(M_SLIDING)
		M_GROUNDED:
			velocity -= velocity * damping * delta
			velocity += direction * delta * acceleration

			velocity.y = clamp(-groundRays.groundDistance * delta * 1200, -6, 6)
			if jump_state:
				jumped.emit()
				set_m_mode(M_FALLING)
				velocity.y = jump_acceleration
		M_SWIMMING:
			pass
		M_CROUCHING:
			pass
		M_SLIDING:
			var sliding = slideRay.get_collider() != null
			var slideNormal : Vector3 = slideRay.get_collision_normal()
			var gdt : float = slideNormal.dot(Vector3.UP)
			sliding = sliding and gdt > 0.0
			if sliding:
				velocity.y = clamp(velocity.y - (4.0 if velocity.y > 0.0 else 10.0) * delta, -80, 80)
				var prevSPD : float = velocity.length()
				var orthVec : Vector3 = Vector3()
				if slideNormal.dot(Vector3.UP) > 0.99:
					orthVec = Vector3(velocity.x,0,velocity.z).normalized().cross(Vector3.UP)
					#velocity.x -= velocity.x * delta * 0.1
					#velocity.z -= velocity.z * delta * 0.1
				else:
					orthVec = slideNormal.cross(Vector3.UP).normalized()
				var velProj : Vector3 = velocity.project(orthVec)
				var dt : float = velocity.normalized().dot(direction)
				var accel : Vector3 = (direction * delta * acceleration * airControl * 2.0).project(orthVec)
				if dt > -0.7:
					if accel.dot(velProj) < 0.01:
						velocity += accel
					else:
						velocity += accel * clamp(3.0 - velProj.length(),0.01,1)
				else:
					velocity += (direction * delta * acceleration * airControl)
				velocity = velocity.limit_length(prevSPD)
				if jump_state:
					if h_speed < 7.0:
						jumped.emit()
						set_m_mode(M_FALLING)
					velocity += jump_acceleration * slideNormal * Vector3(1,0.25,1) * 1.5 + Vector3(0,2,0)
			else:
				velocity.y = clamp(velocity.y - 9.8 * delta, -80, 80)
				#look_arrow.visible = false
				if h_speed < 2:
					velocity += direction * delta * acceleration * airControl
				else:
					var dt: float = velocity.dot(direction)
					if dt < 0.0:
						velocity += direction * delta * acceleration * airControl
					else:
						velocity += (direction * delta * acceleration * airControl).project(camY.global_basis.y.normalized().cross(Vector3(velocity.x, 0, velocity.z).normalized()))
	
	player.velocity = velocity
	player.move_and_slide()

func m_mode():
	match movementMode:
		M_FALLING:
			if groundRays.groundDistance < 0 and velocity.y < 0.5:
				if slideState and h_speed > 3.0:
					set_m_mode(M_SLIDING)
				else:
					set_m_mode(M_GROUNDED)
		M_GROUNDED:
			if groundRays.groundDistance > 0.3:
				set_m_mode(M_FALLING)
		M_SWIMMING:
			pass
		M_CROUCHING:
			pass
		M_SLIDING:
			if h_speed < 3.0:
				set_m_mode(M_FALLING)

func set_m_mode(n_mode: int):
	movementMode = n_mode
