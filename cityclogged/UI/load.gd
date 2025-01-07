extends Control

# 进度条节点引用
@onready var progress_bar = $BackBufferCopy/ProgressBar
@onready var glow_layer = $BackBufferCopy

func _ready():
	# 设置 BackBufferCopy
	glow_layer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	glow_layer.rect = Rect2(Vector2.ZERO, Vector2(400, 100))  # 设置足够大的区域
	
	# 创建发光材质
	var material = ShaderMaterial.new()
	material.shader = preload("res://UI/glow_shader.gdshader")
	glow_layer.material = material
	
	# 设置进度条样式
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 0.0)
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_bottom_left = 5
	progress_bar.add_theme_stylebox_override("fill", style)
	# 确保发光效果可见
	material.set_shader_parameter("glow_intensity", 1.5)
	material.set_shader_parameter("blur_amount", 3.0)
	material.set_shader_parameter("glow_color", Color(1.0, 1.0, 0.0, 1.0))
# 更新进度
func set_progress(value: float):
	progress_bar.value = value

# 在脚本中添加呼吸效果
func _process(delta):
	var pulse = (sin(Time.get_ticks_msec() * 0.003) + 1.0) * 0.5
	var intensity = 1.5 + (pulse * 2.0)  # 增加发光强度变化范围
	glow_layer.material.set_shader_parameter("glow_intensity", intensity)
	
# 调整辉光效果
func adjust_glow():
	var material = glow_layer.material
	material.set_shader_parameter("glow_intensity", 1.5)
	material.set_shader_parameter("blur_amount", 2.0)
	material.set_shader_parameter("glow_color", Color(1.0, 1.0, 0.0))
