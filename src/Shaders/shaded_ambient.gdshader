shader_type spatial;
render_mode world_vertex_coords, ambient_light_disabled;

uniform sampler2D albedo_texture : hint_default_white, filter_nearest;
uniform vec4 albedo_color : source_color = vec4(1);
uniform vec2 UVScaling = vec2(1);

uniform float distance_fade_min : hint_range(0.0, 4096.0, 0.01);
uniform float distance_fade_max : hint_range(0.0, 4096.0, 0.01);

global uniform float view_distance;
uniform float viewDistanceOverride = 0.0;

global uniform sampler2D light_texture : repeat_disable;
global uniform vec3 light_direction;
global uniform vec4 ambient_tint;

uniform float AOMix = 0.0;
uniform float ambientMix = 1.0;

varying vec3 ambientLight;

void vertex() {
	UV *= UVScaling;
	ambientLight = textureLod(light_texture, vec2(dot(NORMAL, light_direction) * 0.5 + 0.5,0.5),0).rgb;
	ambientLight = mix(vec3(0),ambientLight,ambientMix);
}

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb * albedo_color.rgb;
	EMISSION = ALBEDO * ambientLight * ambient_tint.rgb * mix(1.0, COLOR.r, AOMix);
	//EMISSION = COLOR.rgb;
	{
		// Distance Fade: Pixel Dither
		float fade_distance = length(VERTEX);

		// Use interleaved gradient noise, which is fast but still looks good.
		const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
		float fade = clamp(smoothstep(mix(view_distance, distance_fade_min, viewDistanceOverride), mix(view_distance - 15.0,distance_fade_max,viewDistanceOverride), fade_distance), 0.0, 1.0);
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
