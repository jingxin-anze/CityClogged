shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float glow_scale : hint_range(0.0, 4.0) = 1.5;
uniform float progress : hint_range(0.0, 1.0) = 0.5;
uniform float edge_thickness : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    // 获取原始颜色
    vec4 original_color = texture(TEXTURE, UV);
    
    // 创建发光效果
    float glow = 0.0;
    vec2 center = vec2(progress, 0.5);  // 进度条位置
    float dist = distance(UV, center);
    glow = 1.0 - smoothstep(0.0, glow_scale, dist);
    
    // 合并原始颜色和发光
    vec4 final_color = original_color + (glow_color * glow * glow_intensity);
    COLOR = mix(original_color, final_color, original_color.a);
}