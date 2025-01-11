extends Control

class_name OptionsMenu

@export var hs_sensitivity: HSlider
@export var hs_blur: HSlider
@export var hs_grille: HSlider
@export var hs_sat: HSlider
@export var hs_bright: HSlider
@export var cb_crt: CheckBox
@export var close_button: Button
@export var hs_dither: HSlider
@export var ob_res: OptionButton
@export var ob_depth: OptionButton

@export var hs_master: HSlider
@export var hs_sfx: HSlider
@export var hs_music: HSlider
@export var hs_ambiance: HSlider


func open() -> void:
	show()
	hs_sensitivity.grab_focus()

signal closed
func close() -> void:
	hide()
	closed.emit()

func _ready() -> void:
	hs_sensitivity.value = OptionsManager.lookSensitivity
	hs_blur.value = OptionsManager.crtBlur
	hs_grille.value = OptionsManager.crtGrille
	hs_sat.value = OptionsManager.saturation
	hs_bright.value = OptionsManager.bright
	cb_crt.button_pressed = OptionsManager.crtOn
	hs_dither.value = OptionsManager.dither
	ob_res.selected = OptionsManager.resolution
	ob_depth.selected = OptionsManager.colorDepth
	hs_master.value = OptionsManager.masterVolume
	hs_sfx.value = OptionsManager.sfxVolume
	hs_music.value = OptionsManager.musicVolume
	hs_ambiance.value = OptionsManager.ambianceVolume

func _on_hs_sensitivity_value_changed(value: float) -> void:
	OptionsManager.lookSensitivity = value
	OptionsManager.update()


func _on_hs_blur_value_changed(value: float) -> void:
	OptionsManager.crtBlur = value
	OptionsManager.update()

func _on_hs_grille_value_changed(value: float) -> void:
	OptionsManager.crtGrille = value
	OptionsManager.update()

func _on_hs_sat_value_changed(value: float) -> void:
	OptionsManager.saturation = value
	OptionsManager.update()

func _on_hs_bright_value_changed(value: float) -> void:
	OptionsManager.bright = value
	OptionsManager.update()

func _on_cb_crt_toggled(toggled_on: bool) -> void:
	OptionsManager.crtOn = toggled_on
	OptionsManager.update()


func _on_close_pressed() -> void:
	close()


func _on_hs_dither_value_changed(value: float) -> void:
	OptionsManager.dither = value
	OptionsManager.update()

@export var scroll_container: ScrollContainer

func _on_hs_sensitivity_focus_entered() -> void:
	scroll_container.scroll_vertical = 0


func _on_ob_res_item_selected(index: int) -> void:
	OptionsManager.resolution = index
	OptionsManager.update()


func _on_ob_depth_item_selected(index: int) -> void:
	OptionsManager.colorDepth = index
	OptionsManager.update()


func _on_hs_master_value_changed(value: float) -> void:
	OptionsManager.masterVolume = value
	OptionsManager.update()


func _on_hs_sfx_value_changed(value: float) -> void:
	OptionsManager.sfxVolume = value
	OptionsManager.update()


func _on_hs_music_value_changed(value: float) -> void:
	OptionsManager.musicVolume = value
	OptionsManager.update()


func _on_hs_ambiance_value_changed(value: float) -> void:
	OptionsManager.ambianceVolume = value
	OptionsManager.update()
