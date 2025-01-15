shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0, 20) = 1.0;

// 使用方向采样优化性能
void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    vec2 pixel_size = TEXTURE_PIXEL_SIZE;

    // 8方向采样
    vec2 directions[8] = {
        vec2(1, 0), vec2(-1, 0),   // 右左
        vec2(0, 1), vec2(0, -1),   // 上下
        vec2(1, 1), vec2(-1, -1),  // 对角线
        vec2(-1, 1), vec2(1, -1)   // 对角线
    };

    float alpha = current_color.a;
    // 检查8个方向
    for(int i = 0; i < 8; i++) {
        vec2 offset = directions[i] * outline_width * pixel_size;
        alpha = max(alpha, texture(TEXTURE, UV + offset).a);
    }

    // 应用描边
    vec4 final_color = mix(outline_color, current_color, current_color.a);
    COLOR = mix(vec4(0.0), final_color, alpha);
}