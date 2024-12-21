shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded;
uniform sampler2D depth_tex : hint_depth_texture;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment(){
	float depth = texture(depth_tex, SCREEN_UV).r;
	ALBEDO = vec3(depth);
}