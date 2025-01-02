extends Control

@export var sub_viewport: SubViewport
@export var screen_tex: TextureRect
@export var crt_effect: Panel

func _enter_tree() -> void:
	sub_viewport.add_child(load(LevelManager.levelToLoad).instantiate())
	OptionsManager.optionsUpdated.connect(onOptionsUpdated)

func onOptionsUpdated() -> void:
	screen_tex.material.set_shader_parameter("dither", OptionsManager.dither)
	crt_effect.material.set_shader_parameter("aperture_grille_rate", OptionsManager.crtGrille)
	crt_effect.material.set_shader_parameter("rf_switch_esque_blur", OptionsManager.crtBlur)
	crt_effect.material.set_shader_parameter("s", OptionsManager.saturation)
	crt_effect.material.set_shader_parameter("v", OptionsManager.bright)
