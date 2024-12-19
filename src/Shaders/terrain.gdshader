shader_type spatial;
render_mode unshaded;

uniform sampler2D terrainMap;
uniform sampler2D tex1 : filter_nearest;
uniform vec4 col1 : source_color = vec4(1);
uniform sampler2D tex2 : filter_nearest;
uniform vec4 col2 : source_color = vec4(1);
uniform float AOPower = 3.0;

uniform vec2 textureScaling = vec2(16.0);

varying vec2 tUV;

void vertex() {
	tUV = UV * textureScaling;
}

void fragment() {
	vec4 tMap = texture(terrainMap, UV);
	vec3 t1 = texture(tex1, tUV).rgb * col1.rgb;
	vec3 t2 = texture(tex2, tUV).rgb * col2.rgb;
	ALBEDO = mix(t1,t2,tMap.r);
	ALBEDO *= pow(COLOR.r,AOPower);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
