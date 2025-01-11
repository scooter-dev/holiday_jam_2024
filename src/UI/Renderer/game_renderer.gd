extends Control

@export var sub_viewport: SubViewport
@export var screen_tex: TextureRect
@export var crt_effect: Panel
@export var loadLevel : bool = true

func _enter_tree() -> void:
	if loadLevel:
		sub_viewport.add_child(load(LevelManager.levelToLoad).instantiate())
	screen_tex.texture = sub_viewport.get_texture()
	OptionsManager.optionsUpdated.connect(onOptionsUpdated)
	get_tree().root.size_changed.connect(onViewportSizeChanged)

func _ready() -> void:
	onOptionsUpdated()


func onViewportSizeChanged() -> void:
	if OptionsManager.resolution == OptionsManager.e_res.NATIVE:
		sub_viewport.size = get_tree().root.size

func onOptionsUpdated() -> void:
	screen_tex.material.set_shader_parameter("dither", OptionsManager.dither)
	crt_effect.material.set_shader_parameter("aperture_grille_rate", OptionsManager.crtGrille)
	crt_effect.material.set_shader_parameter("rf_switch_esque_blur", OptionsManager.crtBlur)
	crt_effect.material.set_shader_parameter("s", OptionsManager.saturation)
	crt_effect.material.set_shader_parameter("v", OptionsManager.bright)
	crt_effect.visible = OptionsManager.crtOn
	
	match  OptionsManager.colorDepth:
		OptionsManager.e_col.B15:
			screen_tex.material.set_shader_parameter("colors", 15)
		OptionsManager.e_col.B16:
			screen_tex.material.set_shader_parameter("colors", 16)
		OptionsManager.e_col.TRUE_COLOR:
			screen_tex.material.set_shader_parameter("colors", 32)
	
	match OptionsManager.resolution:
		OptionsManager.e_res.PSX:
			sub_viewport.size = Vector2i(256,224)
		OptionsManager.e_res.PSX2X:
			sub_viewport.size = Vector2i(256,224) * 2
		OptionsManager.e_res.P360:
			sub_viewport.size = Vector2i(640,360)
		OptionsManager.e_res.P540:
			sub_viewport.size = Vector2i(960,540)
		OptionsManager.e_res.NATIVE:
			sub_viewport.size = get_tree().root.size
