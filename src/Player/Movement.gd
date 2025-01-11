extends Node

class_name PlayerMovement
@onready var debug_label: Label = $"../DebugLabel"

enum {M_FALLING, M_GROUNDED, M_SWIMMING, M_CROUCHING, M_SLIDING, M_SUSPENDED}
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
			if waterLevel > swimLevel and volume.saltWater:
				player.die()

@export var groundRays: GroundRays
@export var camY: Node3D
@export var player: CharacterBody3D
#@export var slideRay : RayCast3D
@export var airControl: float = 0.14

signal jumped
signal mModeChanged(old, new)

const slideHover : float = -0.1

func set_jump(state: bool):
	jump_state = state

var slideState: bool = false
func set_slide(state: bool):
	slideState = state

func _ready():
	PlayerInput.jump.connect(set_jump)
	PlayerInput.slide.connect(set_slide)

var launchVelocity : Vector3 = Vector3()
var launchOverride : bool = false
func launchPlayer(launchVel : Vector3, override : bool = false) -> void:
	launchOverride = override
	if override:
		launchVelocity = launchVel
	else:
		launchVelocity += launchVel

var slideJumpCooldown : int = 0
var nwProtect: int = 0
func resetRotation(delta : float) -> void:
	player.global_basis = player.global_basis.orthonormalized()
	if movementMode == M_GROUNDED:
		player.global_rotation.x = 0
		player.global_rotation.z = 0

var prevVelocity : Vector3 = Vector3()
var slidingOnGround : bool = false
func _physics_process(delta):
	prevVelocity = velocity
	set_deferred("mLock",maxi(mLock - 1,0))
	if movementMode != M_SUSPENDED:
		resetRotation(delta)
	velocity = player.get_real_velocity()
	h_speed = Vector2(velocity.x, velocity.z).length()
	getWaterLevel()
	slideJumpCooldown = maxi(0, slideJumpCooldown - 1)
	m_mode()
	debug_label.text = "Mode: %d\n" % movementMode
	debug_label.text += "Water Level: %0.2f\n" % waterLevel
	var direction: Vector3 = camY.global_basis.x * PlayerInput.fbrl.x + camY.global_basis.z * PlayerInput.fbrl.y
	direction = direction.limit_length()
	match movementMode:
		M_FALLING:
			# velocity -= velocity * damping * delta
			if jump_state and OS.is_debug_build():
				velocity.y += 12 * delta
			var sliding = groundRays.gDistR < slideHover #if the ground is more than 15cm inside the raycasts, player can slide
			var slideNormal: Vector3 = groundRays.gNormR
			var gdt: float = slideNormal.dot(Vector3.UP) #cos of angle between ground and up vector
			sliding = sliding and gdt < 0.7 and h_speed > 5.5#if player can silde, the ground is at ~45 degrees and horizontal speed is greater than 3.7 m/s, player is sliding
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
			var sliding = groundRays.gDistR < slideHover
			var slideNormal: Vector3 = groundRays.gNormR
			var gdt: float = slideNormal.dot(Vector3.UP)
			sliding = sliding # and gdt > 0.0
			slidingOnGround = sliding
			if sliding:
				var prevSPD: float = velocity.length()
				
				velocity += acceleration * delta * direction * airControl * 2.0
				velocity.x -= velocity.x * 0.25 * delta
				velocity.z -= velocity.z * 0.25 * delta
				velocity = velocity.limit_length(prevSPD)
				if jump_state and slideJumpCooldown == 0 and h_speed < 7.0:
					jumped.emit()
					set_m_mode(M_FALLING)
					velocity.y += jump_acceleration
					slideJumpCooldown = 5
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
		M_SUSPENDED:
			velocity = Vector3()
	launch()
	coyote_time = max(0.0, coyote_time - delta)
	player.velocity = velocity
	player.move_and_slide()

func launch() -> void:
	if movementMode != M_SUSPENDED and launchVelocity.length_squared() > 0.01:
		if launchOverride:
			velocity = launchVelocity
			launchOverride = false
		else:
			velocity += launchVelocity
		if movementMode == M_GROUNDED:
			set_m_mode(M_FALLING)
		launchVelocity = Vector3()

func m_mode():
	match movementMode:
		M_FALLING:
			if waterLevel > swimLevel:
				set_m_mode(M_SWIMMING)
			elif groundRays.gDistR < 0.0 and slideState and (h_speed > 3.0) and slideJumpCooldown == 0:
				set_m_mode(M_SLIDING)
			elif groundRays.groundDistance < 0 and velocity.y < 2.0:
				if slideState and (h_speed > 3.0 or groundRays.gNormR.dot(Vector3.UP) < 0.9):
					set_m_mode(M_SLIDING)
				else:
					set_m_mode(M_GROUNDED)
		M_GROUNDED:
			if waterLevel > swimLevel:
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

var mLock : int = 0
func set_m_mode(n_mode: int, lock : int = 0):
	if mLock > 0:
		return
	mModeChanged.emit(movementMode,n_mode)
	mLock += lock
	print(lock)
	match n_mode:
		M_GROUNDED:
			player.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
			match movementMode:
				M_FALLING:
					if prevVelocity.y < -16.0:
						player.die()
					if (groundRays.ground and groundRays.ground != player.get_parent()):
						player.reparent(groundRays.ground, true)
		M_FALLING:
			player.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
			match movementMode:
				M_GROUNDED:
					coyote_time = 0.15
					player.reparent(world, true)
		M_SWIMMING:
			player.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
			submerged = waterLevel > swimLevel + 0.5
			if submerged:
				if velocity.y < 0.5:
					velocity.y += 2.0
		M_SLIDING:
			player.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	movementMode = n_mode
