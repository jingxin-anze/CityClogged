shader_type spatial;
render_mode cull_back, depth_draw_always;


uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;
uniform float pixel_size = 0.0;
uniform vec4 color_really_deep : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 color_deep : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 color_mid : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 color_foam : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float beers_law = 1.3;
uniform float depth_offset = 0.0;
uniform float refraction = 0.075; // Refraction of the water
uniform float vertex_movement = 1.0;

uniform float wave_speed = 0.5; // Speed scale for the waves
uniform vec4 wave_a = vec4(1.0, 1.0, 0.35, 3.0); // xy = Direction, z = Steepness, w = Length
uniform vec4 wave_b = vec4(1.0, 0.6, 0.30, 1.55);// xy = Direction, z = Steepness, w = Length
uniform vec4 wave_c = vec4(1.0, 1.3, 0.25, 0.9); // xy = Direction, z = Steepness, w = Length

// Surface settings:
uniform vec2 sampler_scale = vec2(0.25, 0.25); // Scale for the sampler
uniform vec2 sampler_direction = vec2(0.05, -0.04); // Direction and speed for the sampler
uniform vec2 uv_sampler_scale = vec2(0.25, 0.25); // UV sampler scale
uniform float uv_sampler_strength = 0.04; // UV shifting strength
uniform float uv_noise = 0.05;
uniform sampler2D uv_sampler : hint_anisotropy ; // UV motion sampler for shifting the normalmap
uniform sampler2D normalmap_a_sampler : hint_normal; // Normalmap sampler A
uniform sampler2D normalmap_b_sampler : hint_normal; // Normalmap sampler B
uniform sampler2DArray caustic_sampler : hint_default_black;
uniform sampler2D noise_sampler : hint_default_black;

uniform float foam_amount = 0.01;
uniform float deep_amount = 0.25;
uniform float specular_amount = 0.0;
uniform float specular_brightness = 0.0;
uniform vec3 light_vec = vec3(0.0, 1.0, -1.0);

uniform vec2 surface_size = vec2(2.0, 24.0);
uniform float surface_speed = 10.0;
uniform vec2 surface_direction = vec2(0.5, -10.0);
uniform vec2 surface_direction2 = vec2(-0.5, 1.0);
uniform float surface_exp = 9.0;
uniform float surface_multiplier = 5.0;

uniform bool show_waterfall = true;
uniform vec2 waterfall_size = vec2(4.0, 40.0);
uniform float waterfall_framerate = 10.0;
uniform float waterfall_speed = 64.0;
uniform float waterfall_start_depth = 0.9;
uniform float waterfall_exp = 9.0;
uniform float waterfall_multiplier = 5.0;

varying float vertex_height;
varying vec3 vertex_normal;
varying vec3 vertex_tangent;
varying vec3 vertex_binormal;
varying float waterfall_height;

// Wave function:
vec4 wave(vec4 parameter, vec2 position, float time, inout vec3 tangent, inout vec3 binormal)
{
	float wave_steepness = parameter.z;
	float wave_length = parameter.w;

	float k = 2.0 * 3.14159265359 / wave_length;
	float c  = sqrt(9.8 / k);
	vec2 d = normalize(parameter.xy);
	float f = k * (dot(d, position) - c * time);
	float a = wave_steepness / k;
	
	tangent += normalize(vec3(1.0-d.x * d.x * (wave_steepness * sin(f)), d.x * (wave_steepness * cos(f)), -d.x * d.y * (wave_steepness * sin(f))));
	binormal += normalize(vec3(-d.x * d.y * (wave_steepness * sin(f)), d.y * (wave_steepness * cos(f)), 1.0-d.y * d.y * (wave_steepness * sin(f))));

	return vec4(d.x * (a * cos(f)), a * sin(f) * 0.25, d.y * (a * cos(f)), 0.0);
}

float linearize_depth(mat4 inv_proj_matrix, vec2 uv, float depth) {
	vec3 ndc = vec3(uv, depth) * 2.0 - 1.0;
	vec4 view = inv_proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

vec2 pixellate(vec2 v) {
	if (pixel_size > 0.0) {
		v = floor(v / pixel_size) * pixel_size;
	}
	return v;
}

void vertex()
{
	vec4 world_vertex  = MODEL_MATRIX * vec4(VERTEX, 1.0);
	mat4 inv_w = inverse(MODEL_MATRIX);
	
	waterfall_height = sign(VERTEX.y);
	
	float time = -TIME * wave_speed;
	
	vec4 v = world_vertex;
	vec3 vt = vec3(0.0, 0.0, 0.0);
	vec3 vb = vec3(0.0, 0.0, 0.0);
	v += wave(wave_a, world_vertex.xz, time, vt, vb);
	v += wave(wave_b, world_vertex.xz, time, vt, vb);
	v += wave(wave_c, world_vertex.xz, time, vt, vb);
	vertex_tangent = vt;
	vertex_binormal = vb;
	
	vec4 vertex = inv_w * v;
	vertex_normal = normalize(cross(vertex_binormal, vertex_tangent));
	vertex_height = (PROJECTION_MATRIX * MODELVIEW_MATRIX * vertex).z;
	
	TANGENT = vertex_tangent;
	BINORMAL = vertex_binormal;
	NORMAL = vertex_normal;
	
	VERTEX = mix(VERTEX, vertex.xyz, vertex_movement);
	
	mat4 world_rot = mat4(1.0);
	world_rot[0][0] = inv_w[0][0];
	world_rot[0][2] = inv_w[0][2];
	world_rot[2][0] = inv_w[2][0];
	world_rot[2][2] = inv_w[2][2];
	UV = (world_rot * world_vertex).xz;
}

float get_surface_flow(vec2 uv, float time) {
	vec2 uv1 = pixellate(uv + surface_direction * time);
	vec2 uv2 = pixellate(uv + surface_direction2 * time);
	uv1 /= surface_size;
	uv2 /= surface_size;
	float surface = (texture(noise_sampler, uv1).r + texture(noise_sampler, uv2).r) / 2.0;
	surface = pow(surface, surface_exp);
	surface *= surface_multiplier;
	return surface;
}

float get_waterfall_flow(vec4 world_vertex, float time) {
	vec2 uv = pixellate(vec2(world_vertex.x + world_vertex.z, world_vertex.y + time * waterfall_speed));
	uv /= waterfall_size;
	float surface = texture(caustic_sampler, vec3(uv, mod(time * waterfall_framerate, 16.0))).r;
	float d = 1.0 - (1.0 + waterfall_height) / (1.0 + waterfall_start_depth);
	surface = mix(pow(surface, waterfall_exp), surface, max(0.0, pow(d, 2.0)));
	surface *= waterfall_multiplier;
	return surface;
}

void fragment() {
	vec4 world_vertex = VIEW_MATRIX  * vec4(VERTEX, 1.0);
	
	float time = TIME * wave_speed;
	
	// Calculation of the UV with the UV motion sampler
	vec2 uv_offset = sampler_direction * time;
	vec2 uv_sampler_uv = UV * uv_sampler_scale + uv_offset;
	vec2 uv_sampler_uv_offset = uv_sampler_strength * texture(uv_sampler, uv_sampler_uv).rg * 2.0 - 1.0;
	vec2 uv = UV + uv_sampler_uv_offset;
	
	// Normalmap:
	vec3 normalmap = texture(normalmap_a_sampler, uv_sampler_scale * (uv - uv_offset*2.0)).rgb * 0.75; // 75 % sampler A
	normalmap += texture(normalmap_b_sampler, uv_sampler_scale * (uv + uv_offset)).rgb * 0.25; // 25 % sampler B
	
	// Refraction UV:
	vec3 ref_normalmap = normalmap * 2.0 - 1.0;
	ref_normalmap = normalize(vertex_tangent*ref_normalmap.x + vertex_binormal*ref_normalmap.y + vertex_normal*ref_normalmap.z);
	
	vec2 ref_uv = SCREEN_UV + (ref_normalmap.xy * refraction) / vertex_height;
	
	// UV noise
	ref_uv += (texture(normalmap_a_sampler, world_vertex.xz * uv_sampler_scale + time * sampler_direction).xy * 2.0 - 1.0) * uv_noise;
	
	// Ground depth:
	float actual_depth = linearize_depth(INV_PROJECTION_MATRIX, SCREEN_UV, texture(DEPTH_TEXTURE, SCREEN_UV).r);
	float surface_depth = linearize_depth(INV_PROJECTION_MATRIX, SCREEN_UV, FRAGCOORD.z);
	float depth_sample = linearize_depth(INV_PROJECTION_MATRIX, SCREEN_UV, texture(DEPTH_TEXTURE, ref_uv).r);
	if (depth_sample <= surface_depth - 1.0) {
		depth_sample = actual_depth;
	}
	float depth = depth_sample;
	float depth_blend = exp((depth + VERTEX.z + depth_offset) * -beers_law);
	depth_blend = clamp(depth_blend, 0.0, 1.0);
	
	float base_brightness = clamp(1.0 - pow(1.0 - depth_blend, 2.5), 0.0, 1.0);
	vec4 color = mix(color_deep, color_mid, clamp(base_brightness / deep_amount, 0.0, 1.0));
	color = mix(color, color_really_deep, 1.0 - clamp(3.0 * SCREEN_UV.y, 0.0, 1.0));
	if (base_brightness >= 1.0 - foam_amount) {
		color = mix(color, color_foam, (base_brightness - 1.0 + foam_amount) / foam_amount);
	}
	
	// Surface texture:
	float surface = get_surface_flow(uv, time);
	float waterfallness = (-waterfall_height + 1.0) / 2.0 * float(show_waterfall);
	float waterfall = get_waterfall_flow(world_vertex, time);
	surface = mix(surface, waterfall, waterfallness);
	
	color = mix(color, color_foam, surface);
	
	if (specular_amount > 0.0) {
		float reflect_amount = texture(noise_sampler, (uv + surface_direction * time) / 8.0).r * 2.0 - 1.0;
		reflect_amount += texture(noise_sampler, (uv + surface_direction2 * time) / surface_size).r * 2.0 - 1.0;
		reflect_amount += texture(noise_sampler, (uv + surface_direction * time) / 16.0).g * 2.0 - 1.0;
		reflect_amount += texture(noise_sampler, (uv + surface_direction2 * time * 2.0) / 64.0).g * 2.0 - 1.0;
		reflect_amount += texture(noise_sampler, (uv + surface_direction * time) / 256.0).b * 2.0 - 1.0;
		reflect_amount += texture(noise_sampler, (uv + surface_direction * time)).b * 2.0 - 1.0;

		vec3 n = normalize(NORMAL);
		float d = dot(n, light_vec);
		vec3 reflection = -reflect(light_vec, n);
		float specular = abs(dot(normalize(reflection), normalize(VIEW)));
		reflect_amount *= clamp(specular, 0.0, 1.0);

		if (reflect_amount > 1.0/specular_amount) {
			EMISSION = vec3(specular_brightness);
		} else {
			EMISSION = vec3(0.0);
		}
	} else {
		EMISSION = vec3(0.0);
	}
	
	ALBEDO = color.rgb;
	SPECULAR = surface;
}
