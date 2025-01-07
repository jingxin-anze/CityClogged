shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 4.0) = 1.5;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float blur_amount : hint_range(0.0, 10.0) = 3.0;

// 高斯模糊函数
float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0 * sigma * sigma)) / (sqrt(2.0 * 3.14159) * sigma);
}

void fragment() {
    vec4 orig_color = texture(TEXTURE, UV);
    vec4 glow = vec4(0.0);
    float total_weight = 0.0;
    
    // 双遍高斯模糊
    for(float i = -blur_amount; i <= blur_amount; i++) {
        float weight = gaussian(i, blur_amount * 0.5);
        vec2 offset = vec2(i, 0.0) * TEXTURE_PIXEL_SIZE;
        glow += texture(TEXTURE, UV + offset) * weight;
        total_weight += weight;
    }
    glow /= total_weight;
    
    total_weight = 0.0;
    vec4 final_glow = vec4(0.0);
    for(float i = -blur_amount; i <= blur_amount; i++) {
        float weight = gaussian(i, blur_amount * 0.5);
        vec2 offset = vec2(0.0, i) * TEXTURE_PIXEL_SIZE;
        final_glow += texture(TEXTURE, UV + offset) * weight;
        total_weight += weight;
    }
    final_glow /= total_weight;
    
    // 混合原始颜色和发光效果
    vec4 glow_effect = final_glow * glow_color * glow_intensity;
    COLOR = orig_color + glow_effect;
    COLOR.a = min(COLOR.a, 1.0);
}