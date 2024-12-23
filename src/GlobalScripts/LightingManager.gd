extends Node

var lightImage : Image
var lightImageTexture : ImageTexture

var registeredLights : Array[VertexLight]

func registerLight(light : VertexLight) -> void:
	registeredLights.append(light)

func unregisterLight(light : VertexLight) -> void:
	var lightPos : int = registeredLights.find(light)
	if lightPos > -1:
		registeredLights.erase(light)
		var posPixelX = (lightPos * 2) % imageResolution
		var posPixelY = (lightPos * 2) / imageResolution
		var colPixelX = (lightPos * 2 + 1) % imageResolution
		var colPixelY = (lightPos * 2 + 1) / imageResolution
		lightImage.set_pixel(posPixelX, posPixelY, Color(0,0,0,0))
		lightImage.set_pixel(colPixelX, colPixelY, Color(0,0,0,0))

func _ready() -> void:
	lightImage = Image.create(imageResolution,imageResolution,false, Image.FORMAT_RGBAF)
	lightImage.resize(imageResolution, imageResolution, Image.INTERPOLATE_NEAREST)
	lightImageTexture = ImageTexture.new()

const imageResolution : int = 8

func _process(delta: float) -> void:
	for i : int in range(registeredLights.size()):
		if i >= (imageResolution * imageResolution) / 2:
			break
		var light : VertexLight = registeredLights[i]
		var posPixelX = (i * 2) % imageResolution
		var posPixelY = (i * 2) / imageResolution
		var colPixelX = (i * 2 + 1) % imageResolution
		var colPixelY = (i * 2 + 1) / imageResolution
		lightImage.set_pixel(colPixelX, colPixelY, Color(light.light_color, light.light_energy))
		lightImage.set_pixel(posPixelX, posPixelY, Color(light.global_position.x, light.global_position.y, light.global_position.z, light.omni_range))
	lightImageTexture.create_from_image(lightImage)
	RenderingServer.global_shader_parameter_set("light_texture", lightImageTexture)
