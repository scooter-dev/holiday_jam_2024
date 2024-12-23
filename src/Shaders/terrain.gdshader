shader_type spatial;
render_mode ambient_light_disabled;

uniform sampler2D terrainMap : filter_nearest, hint_default_black, repeat_disable;
uniform sampler2D tex1 : filter_nearest;
uniform vec4 col1 : source_color = vec4(1);
uniform sampler2D tex2 : filter_nearest;
uniform vec4 col2 : source_color = vec4(1);
uniform float AOPower = 3.0;
uniform float terrainBlendPower = 1.0;
uniform float terrainBlendMul = 1.0;

uniform vec2 textureScaling = vec2(16.0);

uniform float distance_fade_min : hint_range(0.0, 4096.0, 0.01);
uniform float distance_fade_max : hint_range(0.0, 4096.0, 0.01);

//global uniform sampler2D light_texture : filter_nearest, hint_default_black, repeat_disable;

//uniform int i = 0;

varying vec2 tUV;
varying vec3 norm;
varying vec3 vLight;

#define lightRes 8
#define maxLights 32

void vertex() {
	tUV = UV * textureScaling;
	norm = NORMAL;
	vLight = vec3(0);
	vec2 singleStep = vec2(1.0 / float(lightRes), 0);
	/*vec3 col = textureLod(terrainMap, vec2(float(i % lightRes), float(i / lightRes)) / vec2(lightRes),0).rgb;
	vLight = col.rgb;*/
	/*for(int i = 0; i < maxLights; i++)
	{
		vec2 posUV = vec2(float(i % lightRes), float(i / lightRes)) / vec2(lightRes);
		vec4 pos = textureLod(light_texture, posUV,0) - vec4(1000000,1000000,1000000,0);
		vec4 col = textureLod(light_texture, posUV + singleStep,0);
		vLight += max(0,dot(normalize(pos.xyz - VERTEX), NORMAL)) * col.rgb * max(0,(pos.w - distance(pos.xyz, VERTEX)) / pos.w);
	}*/
}

void fragment() {
	vec4 tMap = COLOR;
	vec3 t1 = texture(tex1, tUV).rgb * col1.rgb;
	vec3 t2 = texture(tex2, tUV).rgb * col2.rgb;
	float dt = pow(clamp(dot(norm, vec3(0,1,0)) * terrainBlendMul,0,1),terrainBlendPower);
	vec3 albedo = mix(t1,t2,(1.0 - tMap.g) * dt);
	ALBEDO = albedo;
	//vec3 lighting = pow(tMap.r,AOPower) + vLight;
	EMISSION = ALBEDO * pow(tMap.r,AOPower);

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

/*void light() {
	if (LIGHT_IS_DIRECTIONAL)
	{
		DIFFUSE_LIGHT += vec3(1);//dot(NORMAL,LIGHT) * 0.5 + 0.5 * LIGHT_COLOR;
	}
}*/
