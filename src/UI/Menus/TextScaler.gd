extends Control

func _ready() -> void:
	OptionsManager.optionsUpdated.connect(onOptionsUpdated)
	get_viewport().size_changed.connect(onOptionsUpdated)
	onOptionsUpdated()

func onOptionsUpdated() -> void:
	match OptionsManager.resolution:
		OptionsManager.e_res.PSX:
			add_theme_font_size_override("font_size", 7)
		OptionsManager.e_res.PSX2X:
			add_theme_font_size_override("font_size", 14)
		OptionsManager.e_res.P360:
			add_theme_font_size_override("font_size", 14)
		OptionsManager.e_res.P540:
			add_theme_font_size_override("font_size", 16)
		OptionsManager.e_res.NATIVE:
			add_theme_font_size_override("font_size", 24 * (get_viewport().size.y / 720))
