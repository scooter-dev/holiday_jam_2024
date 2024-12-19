shader_type spatial;
render_mode unshaded;

uniform sampler2D tex : filter_nearest;
uniform vec4 color : source_color = vec4(1);
uniform vec2 textureScaling = vec2(1);
uniform float AOPower = 3.0;

void vertex() {
	UV = UV * textureScaling;
}

void fragment() {
	ALBEDO = texture(tex, UV).rgb * color.rgb;
	ALBEDO *= pow(COLOR.r,AOPower);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
