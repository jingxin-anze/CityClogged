shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx, shadows_disabled, skip_vertex_transform;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform bool flags_albedo_tex_force_srgb = false;
uniform float specular;
uniform float metallic;
uniform float alpha_scissor_threshold;
uniform float roughness : hint_range(0, 1);
uniform float point_size : hint_range(0, 128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform vec3 wind_strength = vec3(0.25, 0.0, 0.125);
uniform float wind_phase = 0.0;

uniform vec3 avoid_pos1 = vec3(0.0, -1000.0, 0.0);
uniform vec3 avoid_pos2 = vec3(0.0, -1000.0, 0.0);
uniform float avoid_distance = 1.5;
uniform float avoid_amount = 0.667;

vec3 avoid(vec4 world_center, vec4 world_vertex, vec3 avoid_pos, float height_weight) {
    vec3 disp = world_vertex.xyz - avoid_pos;
    if (length(disp) < avoid_distance) {
        vec3 dir = normalize(world_center.xyz - avoid_pos);
        return (avoid_distance - length(disp)) / avoid_distance * dir * avoid_amount * height_weight / sqrt(length(world_vertex.xyz - world_center.xyz));
    }
    return vec3(0.0);
}

void vertex() {
    UV = UV * uv1_scale.xy + uv1_offset.xy;

    mat3 normal_matrix = transpose(inverse(mat3(MODEL_MATRIX)));
	NORMAL = normalize(normal_matrix * NORMAL);




    // 使用自定义矩阵进行转换
    mat4 custom_modelview_matrix = mat4(1.0);
    custom_modelview_matrix = INV_VIEW_MATRIX * mat4(
        VIEW_MATRIX[0],
        VIEW_MATRIX[1],
        VIEW_MATRIX[2],
        vec4(MODEL_MATRIX[3].xyz, 1.0)
    );

    custom_modelview_matrix = custom_modelview_matrix * mat4(
        vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
        vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
        vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );

    mat4 custom_world_matrix = VIEW_MATRIX * custom_modelview_matrix;

    float height_weight = abs(VERTEX.y);
    vec4 v = vec4(VERTEX, 0.0);
    vec4 rsv = custom_world_matrix * v;
    vec4 center = custom_world_matrix * vec4(vec3(0.0), 1.0);
    vec4 wv = custom_world_matrix * vec4(VERTEX, 1.0);
    wv /= wv.w;

    float pos_phase = dot(wv.xyz, wind_strength) * 0.25;
    rsv.xyz += wind_strength * (0.5 + 0.5 * sin(wind_phase + pos_phase)) * height_weight;
    v = inverse(custom_world_matrix) * rsv;

    wv = custom_world_matrix * vec4(v.xyz, 1.0);
    wv /= wv.w;
    rsv.xyz += avoid(center, wv, avoid_pos1, height_weight);
    rsv.xyz += avoid(center, wv, avoid_pos2, height_weight);

    v = inverse(custom_world_matrix) * rsv;
    VERTEX = v.xyz;
    VERTEX = (custom_modelview_matrix * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec2 base_uv = UV;
    vec4 albedo_tex = texture(texture_albedo, base_uv);

    if (flags_albedo_tex_force_srgb) {
        albedo_tex.rgb = mix(
            pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)),
            albedo_tex.rgb * (1.0 / 12.92),
            lessThan(albedo_tex.rgb, vec3(0.04045))
        );
    }

    ALBEDO = albedo.rgb * albedo_tex.rgb;
    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = specular;
    ALPHA = albedo.a * albedo_tex.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}
