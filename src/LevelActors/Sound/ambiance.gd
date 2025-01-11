extends AudioStreamPlayer

class_name AmbiancePlayer

enum eAmb {BIRDS, CAVE, ETHERAL}

@export var ambiance : eAmb = eAmb.BIRDS

func _ready() -> void:
	switchAmbiance(ambiance)

var fadingOut : bool = false

func switchAmbiance(amb : eAmb) -> void:
	ambiance = amb
	fadingOut = true
	set_process(true)

func _process(delta: float) -> void:
	if fadingOut:
		volume_db = lerpf(volume_db, -48, delta * 3.0)
		if volume_db < -47:
			fadingOut = false
			match ambiance:
				eAmb.BIRDS:
					stream = preload("res://Assets/Sound/birdsAmbiance.ogg")
				eAmb.CAVE:
					stream = preload("res://Assets/Sound/caveAmbiance.ogg")
				eAmb.ETHERAL:
					pass
			play()
	else:
		volume_db = lerpf(volume_db, 0, delta * 3.0)
