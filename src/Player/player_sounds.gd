extends AudioStreamPlayer

@export var movement : PlayerMovement
@export var one_off: AudioStreamPlayer

const footsteps = [preload("res://Assets/Sound/footstep01.ogg"), preload("res://Assets/Sound/footstep02.ogg")]
const slide = preload("res://Assets/Sound/slide.ogg")
const splash = preload("res://Assets/Sound/splash.ogg")
const tongue = preload("res://Assets/Sound/tongue.ogg")
var soundTimer : float = 0.5

func _ready() -> void:
	PlayerInput.interact.connect(attacking)

func _process(delta: float) -> void:
	match movement.movementMode:
		PlayerMovement.M_GROUNDED:
			volume_db = 3.0
			if movement.h_speed > 2.0:
				soundTimer = max(soundTimer - delta, 0)
				if soundTimer < 0.001:
					if playing:
						stop()
					pitch_scale = randf_range(0.9,1.2)
					stream = footsteps.pick_random()
					play()
					soundTimer = randf_range(0.38,0.42)
		PlayerMovement.M_SLIDING:
			volume_db = 6.0
			if stream != slide:
				if playing:
					stop()
				stream = slide
			if movement.slidingOnGround:
				pitch_scale = clamp(movement.h_speed / 30.0,0.25,6.0)
				if !playing:
					play()
			else:
				if playing:
					stop()
		_:
			if playing:
					stop()
			
	pass


func _on_movement_m_mode_changed(old: Variant, new: Variant) -> void:
	if old == PlayerMovement.M_FALLING and new == PlayerMovement.M_GROUNDED:
		if one_off.playing:
			one_off.stop()
		one_off.volume_db = 6.0
		one_off.stream = footsteps.pick_random()
		one_off.play()
	if old == PlayerMovement.M_FALLING and new == PlayerMovement.M_SWIMMING and movement.velocity.y < -4:
		if one_off.playing:
			one_off.stop()
		one_off.stream = splash
		one_off.play()


func attacking() -> void:
	if one_off.playing:
		one_off.stop()
	volume_db = 5.0
	one_off.stream = tongue
	one_off.play()
