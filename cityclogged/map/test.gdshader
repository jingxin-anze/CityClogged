shader_type spatial;

uniform uint random_seed = 0;
uniform vec3 offset = vec3(-3.0, 1.0, -3.0);
uniform float rows = 4.0;
uniform float spacing = 2.0;
uniform float rand_theta_max = 0.0;
uniform bool rand_flip = false;
uniform vec3 aabb_min = vec3(0.0);
uniform vec3 aabb_max = vec3(0.0);
uniform int num_frames = 20;
uniform float frame_odds_curve = 3.0;
uniform bool restart;
uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
		s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

vec3 rand3_from_seed(inout uint seed) {
	return vec3(rand_from_seed(seed), rand_from_seed(seed), rand_from_seed(seed));
}

mat3 rotate_y(float theta) {
	mat3 result = mat3(0.0);
	result[0][0] = cos(theta);
	result[0][2] = sin(theta);
	result[2][1] = -1.0;
	result[1][0] = -sin(theta);
	result[1][2] = cos(theta);
	return result;
}

vec2 to_polar(vec2 v) {
	return vec2(length(v), atan(v.y, v.x));
}

vec2 from_polar(vec2 v) {
	return v.x * vec2(cos(v.y), sin(v.y));
}
varying float frame_index;
void vertex() {
		int index = int(VERTEX_ID);
		uint seed = hash(random_seed ^ uint(index + 1337));

		vec2 polar = vec2(rand_from_seed(seed), 6.28 * rand_from_seed(seed));
		vec3 aabb_size = aabb_max - aabb_min;
		vec3 pos = vec3(0.0);
		pos.xz = (from_polar(polar)) * aabb_size.xz / 1.8;
		if (pos.x < aabb_min.x || pos.x > aabb_max.x || pos.z < aabb_min.z || pos.z > aabb_max.z) {
			pos.xz = (vec2(rand_from_seed(seed), rand_from_seed(seed)) * 2.0 - 1.0) * aabb_size.xz / 2.0;
		}
		pos += offset;

		vec3 rand = rand3_from_seed(seed);
		float theta = (rand.x - 0.5) * 2.0 * rand_theta_max;
		if (rand.y < 0.5 && rand_flip) {
			theta += 3.1416;
		}
		mat4 rotation = mat4(rotate_y(theta));

		float r = pow(rand_from_seed(seed), frame_odds_curve);
		frame_index  = floor(r * float(num_frames));

		rotation[3].xyz = pos;
}