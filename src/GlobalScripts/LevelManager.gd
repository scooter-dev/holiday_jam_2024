extends Node

var glitches : Dictionary = {}

var initialCutscene : bool = false

var levelToLoad : String = "res://Scenes/TutorialLevel/tutorial_level.tscn"

func changeLevel(level : String) -> void:
	levelToLoad = level
	get_tree().change_scene_to_file("res://src/UI/Renderer/game_renderer.tscn")

#func _ready() -> void:
	#if OS.is_debug_build():
		#addAllArtifacts()

func addAllArtifacts() -> void:
	glitches["croc1-1"] = 1
	glitches["croc2-1"] = 1
	glitches["croc2-2"] = 1
	glitches["vector1-1"] = 1
	glitches["vector2-1"] = 1
	glitches["FINAL"] = 1
