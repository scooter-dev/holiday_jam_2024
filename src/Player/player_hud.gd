extends Control

class_name PlayerHud

@export var info_panel: Panel
@export var info_panel_label: Label

func display_info_box(text : String) -> void:
	info_panel.visible = true
	info_panel_label.text = text

func close_info_box() -> void:
	info_panel.visible = false
