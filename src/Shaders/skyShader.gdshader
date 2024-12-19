shader_type sky;

uniform sampler2D skyGradient : repeat_disable, filter_nearest;
//uniform vec3 skyDirection = vec3(0,1,0);

void sky() {
	COLOR = texture(skyGradient, vec2(EYEDIR.y * 0.5 + 0.5,0.5)).rgb;
}
