shader_type spatial;
render_mode world_vertex_coords, ambient_light_disabled, cull_disabled;

uniform sampler2D albedo_texture : hint_default_white, filter_nearest;
instance uniform float ambientAffect = 1.0;
instance uniform vec4 albedo_color_r : source_color = vec4(1);
instance uniform vec4 albedo_color_g : source_color = vec4(1);
instance uniform vec4 albedo_color_b : source_color = vec4(1);
uniform vec2 UVScaling = vec2(1);

uniform float distance_fade_min : hint_range(0.0, 4096.0, 0.01);
uniform float distance_fade_max : hint_range(0.0, 4096.0, 0.01);

global uniform sampler2D light_texture : repeat_disable;
global uniform vec3 light_direction;

varying vec3 ambientLight;

void vertex() {
	UV *= UVScaling;
	ambientLight = textureLod(light_texture, vec2(dot(NORMAL, light_direction) * 0.5 + 0.5,0.5),0.5).rgb;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = tex.r * albedo_color_r.rgb + tex.g * albedo_color_g.rgb + tex.b * albedo_color_b.rgb;
	EMISSION = ALBEDO * mix(vec3(1.0),ambientLight,ambientAffect);
	ALPHA_SCISSOR_THRESHOLD = 0.25;
	ALPHA = tex.a;
	{
		// Distance Fade: Pixel Dither
		float fade_distance = length(VERTEX);

		// Use interleaved gradient noise, which is fast but still looks good.
		const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
		float fade = clamp(smoothstep(distance_fade_min, distance_fade_max, fade_distance), 0.0, 1.0);
		// Use a hard cap to prevent a few stray pixels from remaining when past the fade-out distance.
		if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
			discard;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
