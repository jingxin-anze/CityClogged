shader_type spatial;
render_mode unshaded, cull_front, depth_draw_always;

uniform float outline_width : hint_range(0.0, 1.0) = 0.1;
uniform float outer_width_multiplier : hint_range(0.0, 5.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void vertex() {
    // 在模型空间计算法线扩展，使用multiplier来控制最终宽度
    vec3 normal = normalize(NORMAL);
    vec3 position = VERTEX + normal * (outline_width * outer_width_multiplier);

    // 转换到裁剪空间
    POSITION = PROJECTION_MATRIX * VIEW_MATRIX * MODEL_MATRIX * vec4(position, 1.0);
}

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA = outline_color.a;
}