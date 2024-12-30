shader_type spatial;
render_mode unshaded;

uniform sampler2D albedo_texture : filter_nearest;
uniform vec4 albedo_color : source_color = vec4(1);

uniform vec2 uvScale = vec2(1);

void vertex() {

}

void fragment() {
	ALBEDO = albedo_color.rgb * texture(albedo_texture, SCREEN_UV * uvScale + NORMAL.xy).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
