extends AudioStreamPlayer

var bossIntro : bool = false

func _ready() -> void:
	set_process(false)
	playAmbiance()

func playAmbiance() -> void:
	if playing:
		stop()
	volume_db = 12.0
	stream = preload("res://Assets/Music/ambianceloop.wav")
	play()

func playBossMusic() -> void:
	volume_db = 0
	stream = preload("res://Assets/Music/Boss_Theme-intro.wav")
	play()
	bossIntro = true

func _on_finished() -> void:
	if bossIntro:
		bossIntro = false
		stream = preload("res://Assets/Music/Boss_Theme-loop.wav")
		play()

func fadeBossOut() -> void:
	set_process(true)

func _process(delta: float) -> void:
	volume_db = lerpf(volume_db, -48, 2.0 * delta)
	if volume_db < -47:
		playAmbiance()
		set_process(false)
