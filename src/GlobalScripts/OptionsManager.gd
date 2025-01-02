extends Node

var lookSensitivity : float = 0.0025

var crtOn : bool = true
var crtBlur : float = 0.7
var crtGrille : float = 0.25
var dither : float = 0.5

var bright : float = 2.0
var saturation : float = 1.0

func update() -> void:
	optionsUpdated.emit()

signal optionsUpdated
