shader_type spatial;
render_mode unshaded;

uniform sampler2D tex : filter_nearest;
uniform vec4 color : source_color = vec4(1);
uniform vec2 textureScaling = vec2(1);
uniform float waves = 1;
uniform float distortion = 0.02;

uniform float distance_fade_min = 50;
uniform float distance_fade_max = 15;

void vertex() {
	UV *= textureScaling;
}

void fragment() {
	vec2 qUV = UV;
	qUV += sin(qUV.y * TAU * waves + TIME) * distortion;
	qUV.y += sin(qUV.x * TAU * waves + TIME) * distortion;
	ALBEDO = texture(tex, qUV).rgb * color.rgb;
	ALPHA = color.a;
	ALPHA *= clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
