shader_type spatial;
render_mode ambient_light_disabled, fog_disabled, cull_disabled;

uniform sampler2D tex : filter_nearest;
uniform vec4 color : source_color = vec4(1);
uniform vec2 textureScaling = vec2(1);
uniform float waves = 1;
uniform float distortion = 0.02;

uniform float distance_fade_min = 50;
uniform float distance_fade_max = 15;

instance uniform float ambientInfluence = 1.0;
instance uniform float nonAmbient = 0.0;

global uniform sampler2D light_texture;
global uniform vec3 light_direction;
global uniform vec4 ambient_tint;

varying vec3 ambientLight;

void vertex() {
	UV *= textureScaling;
	ambientLight = textureLod(light_texture, vec2(dot(NORMAL, light_direction) * 0.5 + 0.5,0.5),0).rgb;
}

void fragment() {
	vec2 qUV = UV;
	qUV += sin(qUV.y * TAU * waves + TIME) * distortion;
	qUV.y += sin(qUV.x * TAU * waves + TIME) * distortion;
	ALBEDO = texture(tex, qUV).rgb * color.rgb;
	ALPHA = color.a;
	ALPHA *= clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0, 1.0);
	EMISSION = ALBEDO * mix(vec3(nonAmbient), ambientLight * ambient_tint.rgb, ambientInfluence);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
