extends Node

var glitches : Dictionary = {}

var initialCutscene : bool = false

var levelToLoad : String = "res://Scenes/TutorialLevel/tutorial_level.tscn"

func changeLevel(level : String) -> void:
	levelToLoad = level
	get_tree().change_scene_to_file("res://src/UI/Renderer/game_renderer.tscn")
