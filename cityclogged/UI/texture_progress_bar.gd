extends TextureProgressBar

@export var glow_color: Color = Color(1.0, 0.5, 0.0, 1.0)
@export var glow_intensity: float = 1.0
@export var glow_scale: float = 1.5
@export var smooth_speed: float = 5.0

var target_value: float = 0.0
var material_shader: ShaderMaterial

func _ready():
	material_shader = ShaderMaterial.new()
	material_shader.shader = preload("res://UI/load.gdshader")
	material = material_shader
	# 设置初始参数
	update_shader_parameters()

func update_shader_parameters():
	material_shader.set_shader_parameter("glow_color", glow_color)
	material_shader.set_shader_parameter("glow_intensity", glow_intensity)
	material_shader.set_shader_parameter("glow_scale", glow_scale)
	material_shader.set_shader_parameter("progress", value / max_value)
	

func set_progress(new_value: float):
	target_value = new_value
	
func _process(delta):
	# 平滑过渡到目标值
	value = lerp(value, target_value, delta * smooth_speed)
	update_shader_parameters()
	
	var pulse = (sin(Time.get_ticks_msec() * 0.005) + 1.0) * 0.5
	material.set_shader_parameter("glow_intensity", 1.0 + pulse)
