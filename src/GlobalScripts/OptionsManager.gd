extends Node

var lookSensitivity : float = 0.0025

enum e_res {PSX = 0, PSX2X = 1, P360 = 2, P540 = 3, NATIVE = 4}
enum e_col {B15 = 0, B16 = 1, TRUE_COLOR = 2}

var crtOn : bool = true
var crtBlur : float = 0.7
var crtGrille : float = 0.25
var dither : float = 0.5
var resolution : e_res = e_res.PSX
var colorDepth : e_col = e_col.B15

var bright : float = 2.0
var saturation : float = 1.0

var masterVolume : float = 0
var musicVolume : float = 0
var ambianceVolume : float = 0
var sfxVolume : float = 0

func update() -> void:
	optionsUpdated.emit()
	AudioServer.set_bus_volume_db(0, masterVolume)
	AudioServer.set_bus_volume_db(1, sfxVolume)
	AudioServer.set_bus_volume_db(2, musicVolume)
	AudioServer.set_bus_volume_db(3, ambianceVolume)

signal optionsUpdated
