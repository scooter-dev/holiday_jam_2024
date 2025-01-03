extends Control

class_name PlayerHud

@export var info_panel: Panel
@export var info_panel_label: Label
@export var hud_anims: AnimationPlayer

func display_info_box(text : String) -> void:
	info_panel.visible = true
	info_panel_label.text = text

func close_info_box() -> void:
	info_panel.visible = false

signal fadeOut
signal fadeIn

func fade() -> void:
	fOutOnly = false
	hud_anims.play("FadeOut", -1, 3)

var fOutOnly : bool = false
func fadeOutOnly() -> void:
	fOutOnly = true
	hud_anims.play("FadeOut", -1, 3)


func _on_hud_anims_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"FadeOut":
			if fOutOnly:
				return
			fadeOut.emit()
			hud_anims.play("FadeIn")
		"FadeIn":
			fadeIn.emit()
