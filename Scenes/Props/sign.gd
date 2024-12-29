extends Node3D

@export_multiline var text : String
@export var infoBoxArea : InfoBoxArea

func _ready() -> void:
	infoBoxArea.text = text
