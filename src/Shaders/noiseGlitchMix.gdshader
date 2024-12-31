shader_type spatial;

render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}
float random( vec2 pos )
{
	return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	float white_noise = random(SCREEN_UV * vec2( sin( TIME * 0.543254 ), cos( TIME * 0.254323563 ) ) );
	ALBEDO = vec3(white_noise);
	//ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
