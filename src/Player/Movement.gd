extends Node

class_name PlayerMovement
@onready var debug_label: Label = $"../DebugLabel"

enum {M_FALLING, M_GROUNDED, M_SWIMMING, M_CROUCHING, M_SLIDING}
var movementMode: int = M_FALLING
var velocity := Vector3()
var acceleration: float = 70
var damping: float = 16.0
var waterDamping: float = 4.0
var jump_acceleration: float = 5
var h_speed: float = 0

var jump_state: bool = false
var jump_counter: float = 0
var coyote_time : float = 0.0


func registerWaterVolume(vol: WaterVolume) -> void:
	waterVolumes.append(vol)

func removeWaterVolume(vol: WaterVolume) -> void:
	waterVolumes.erase(vol)

var waterVolumes: Array[WaterVolume] = []
const swimLevel: float = 0.5
var waterLevel: float = 0.0
var submerged: bool = false

func getWaterLevel() -> void:
	waterLevel = 0.0
	for volume: WaterVolume in waterVolumes:
		var lvl: float = volume.global_position.y - player.global_position.y
		if lvl > waterLevel:
			waterLevel = lvl

@export var groundRays: GroundRays
@export var camY: Node3D
@export var playerInput: PlayerInput
@export var player: CharacterBody3D
#@export var slideRay : RayCast3D
@export var airControl: float = 0.14

signal jumped

func set_jump(state: bool):
	jump_state = state

var slideState: bool = false
func set_slide(state: bool):
	slideState = state

func _ready():
	playerInput.jump.connect(set_jump)
	playerInput.slide.connect(set_slide)

var nwProtect: int = 0
func _physics_process(delta):
	velocity = player.get_real_velocity()
	h_speed = Vector2(velocity.x, velocity.z).length()
	getWaterLevel()
	m_mode()
	debug_label.text = "Mode: %d\n" % movementMode
	debug_label.text += "Water Level: %0.2f\n" % waterLevel
	var direction: Vector3 = camY.global_basis.x * playerInput.fbrl.x + camY.global_basis.z * playerInput.fbrl.y
	direction = direction.limit_length()
	match movementMode:
		M_FALLING:
			# velocity -= velocity * damping * delta
			var sliding = groundRays.gDistR < -0.15 #if the ground is more than 15cm inside the raycasts, player can slide
			var slideNormal: Vector3 = groundRays.gNormR
			var gdt: float = slideNormal.dot(Vector3.UP) #cos of angle between ground and up vector
			sliding = sliding and gdt < 0.7 and h_speed > 3.7#if player can silde, the ground is at ~45 degrees and horizontal speed is greater than 3.7 m/s, player is sliding
			if !(sliding):#if player isn't sliding, move in
				velocity.y = clamp(velocity.y - 9.8 * delta, -80, 80)#clamp the vertical velocity so player won't clip into the ground when falling too fast
				#look_arrow.visible = false
				if h_speed < 2:#if horizontal speed is less than 2 m/s, player can freely use air control
					velocity += direction * delta * acceleration * airControl
				else:#if horizontal speed is greater than 2 m/s, player can only change direction or counteract velocity, not add speed
					var dt: float = velocity.dot(direction)
					if dt < 0.0:
						velocity += direction * delta * acceleration * airControl
					else:
						velocity += (direction * delta * acceleration * airControl).project(camY.global_basis.y.normalized().cross(Vector3(velocity.x, 0, velocity.z).normalized()))
				if jump_state and coyote_time > 0.001:
					jumped.emit()
					velocity.y = jump_acceleration
					coyote_time = 0.0
			else:
				set_m_mode(M_SLIDING)
		M_GROUNDED:
			velocity -= velocity * damping * delta
			velocity += direction * delta * acceleration
			velocity.y = clamp(-groundRays.groundDistance * delta * 2500, -6, 6)
			if jump_state:
				jumped.emit()
				set_m_mode(M_FALLING)
				velocity.y = jump_acceleration
		M_SWIMMING:
			velocity -= velocity * waterDamping * delta
			velocity += direction * delta * acceleration * 0.25
			
			if submerged:
				var udAxis: float = float(jump_state) - float(slideState)
				velocity.y = clamp(velocity.y + acceleration * delta * udAxis * 0.25, -6, 6)
				if waterLevel < swimLevel + 0.25:
					submerged = false
			else:
				velocity.y = clamp(velocity.y + clamp((waterLevel - swimLevel) / 8.0, -2, 2) * delta * 200.0, -6, 6)
				if jump_state and waterLevel > swimLevel - 0.08 and waterLevel < swimLevel + 0.08:
					set_m_mode(M_FALLING)
					velocity.y = jump_acceleration
				elif slideState:
					submerged = true
					velocity.y -= 1.0
		M_CROUCHING:
			pass
		M_SLIDING:
			var sliding = groundRays.gDistR < -0.15
			var slideNormal: Vector3 = groundRays.gNormR
			var gdt: float = slideNormal.dot(Vector3.UP)
			sliding = sliding # and gdt > 0.0
			if sliding:
				var prevSPD: float = velocity.length()
				
				velocity += acceleration * delta * direction * airControl * 2.0
				
				velocity = velocity.limit_length(prevSPD)
				if jump_state:
					if h_speed < 7.0:
						jumped.emit()
						set_m_mode(M_FALLING)
					velocity += jump_acceleration * slideNormal * Vector3(1, 0.25, 1) * 1.5 + Vector3(0, 2, 0)
				velocity.y = clamp(velocity.y - (4.0 if velocity.y > 0.0 else 10.0) * delta, -80, 80)
			else:
				debug_label.text += "No slide\n"
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
	
	coyote_time = max(0.0, coyote_time - delta)
	player.velocity = velocity
	player.move_and_slide()

func m_mode():
	match movementMode:
		M_FALLING:
			if waterLevel > swimLevel:
				set_m_mode(M_SWIMMING)
			elif groundRays.groundDistance < 0 and velocity.y < 2.0:
				if slideState and (h_speed > 3.0 or groundRays.gNormR.dot(Vector3.UP) < 0.8):
					set_m_mode(M_SLIDING)
				else:
					set_m_mode(M_GROUNDED)
		M_GROUNDED:
			if waterLevel > 1.0:
				set_m_mode(M_SWIMMING)
			elif groundRays.groundDistance > 0.3:
				set_m_mode(M_FALLING)
		M_SWIMMING:
			if waterLevel < swimLevel - 0.05:
				set_m_mode(M_FALLING)
		M_CROUCHING:
			pass
		M_SLIDING:
			if waterLevel > swimLevel:
				set_m_mode(M_SWIMMING)
			elif (h_speed < 3.0 and groundRays.gNormR.dot(Vector3.UP) > groundRays.ANGLE_LIMIT):
				set_m_mode(M_FALLING)

@onready var world: Node3D = player.get_parent();

func set_m_mode(n_mode: int):
	match n_mode:
		M_GROUNDED:
			match movementMode:
				M_FALLING:
					if (groundRays.ground and groundRays.ground != player.get_parent()):
						player.reparent(groundRays.ground, true)
		M_FALLING:
			match movementMode:
				M_GROUNDED:
					coyote_time = 0.15
					player.reparent(world, true)
		M_SWIMMING:
			submerged = waterLevel > swimLevel + 0.5
			if submerged:
				if velocity.y < 0.5:
					velocity.y += 2.0
	movementMode = n_mode
