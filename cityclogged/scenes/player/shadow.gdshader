shader_type spatial;
render_mode depth_test_disabled;

uniform vec4 color: source_color;
uniform sampler2D depth_texture:source_color,hint_depth_texture;
uniform float bias = 0.1;

void fragment() {
	float depth = texture(depth_texture,SCREEN_UV).r;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	ALPHA = 0.99;
	ALPHA_SCISSOR_THRESHOLD = float(depth + bias > -VERTEX.z);
	ALBEDO = vec3(depth*0.1);
}
