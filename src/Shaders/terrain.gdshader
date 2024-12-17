shader_type spatial;
render_mode unshaded;

uniform sampler2D terrainMap;
uniform sampler2D tex1 : filter_nearest;
uniform sampler2D tex2 : filter_nearest;

uniform vec2 textureScaling = vec2(16.0);

varying vec2 tUV;

void vertex() {
	tUV = UV * textureScaling;
}

void fragment() {
	vec4 tMap = texture(terrainMap, UV);
	vec3 t1 = texture(tex1, tUV).rgb;
	vec3 t2 = texture(tex2, tUV).rgb;
	ALBEDO = mix(t1,t2,tMap.r);
	ALBEDO *= pow(COLOR.r,5.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
