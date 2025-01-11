shader_type spatial;

// Base color for the text
uniform vec4 albedo_color : source_color;

// Emission color for the glow effect
uniform vec4 emission_color : source_color;

// Strength of the emission
uniform float emission_strength : hint_range(0.0, 10.0);

void fragment() {
    ALBEDO = albedo_color.rgb;      // 设置字体的基础颜色
    EMISSION = emission_color.rgb * emission_strength; // 控制发光效果
}