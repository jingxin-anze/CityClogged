extends Camera3D

@export var tilt_randomisation_period:float = 1.0 # 随机偏移的周期（秒），用于生成新的随机倾斜。
@export var mouse_tilt_decay:float = 0.5 # 鼠标倾斜的衰减速度（范围 0.0 ~ 1.0）。
@export var tilt_smoothing:float = 5.0 # 倾斜变化的平滑度，用于控制过渡速度。
@export var max_tilt_degrees:Vector2 = Vector2(1, 5) # 相机最大倾斜角度（X 和 Y 轴）。
@export var tilt_randomisation:float = 0.0 # 倾斜随机化程度（0 为无随机化，1 为完全随机化）。
var last_mouse_pos:Vector2 # 上一帧鼠标位置，用于计算鼠标移动的变化。
var last_joy_pos:Vector2 # 上一帧手柄输入的位置（未来功能）。
var mouse_tilt_pos:Vector2 # 鼠标的倾斜位置，基于鼠标移动计算。
var target_tilt_rotation:Vector3 # 目标相机旋转（倾斜）。
var _tilt_rand_t:float = 0.0 # 用于随机偏移的计时器。
var _tilt_rand:Vector2 # 当前随机偏移值。
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# 初始化 last_mouse_pos 为相对屏幕的鼠标位置，归一化为 0 ~ 1 的范围
	last_mouse_pos = get_viewport().get_mouse_position() / Vector2(get_viewport().size.x, get_viewport().size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 更新随机倾斜计时器
	_tilt_rand_t -= delta
	if _tilt_rand_t < 0.0:
		_tilt_rand_t = tilt_randomisation_period
		_tilt_rand = Vector2(randf_range( - 1, 1), randf_range( - 1, 1)) # 生成新的随机倾斜值
	
	
	# 获取归一化的鼠标位置
	var mouse_pos = get_viewport().get_mouse_position() /  Vector2(get_viewport().size.x, get_viewport().size.y)
	
	# 如果鼠标没有明显移动，则对鼠标倾斜进行衰减
	if mouse_pos.distance_to(last_mouse_pos) < 0.001:
		mouse_tilt_pos *= (1.0 - mouse_tilt_decay * delta)
	else :
		# 根据鼠标移动计算新的倾斜位置
		mouse_tilt_pos = mouse_pos * 2.0 - Vector2(1.0, 1.0)
	
	# 更新鼠标位置
	last_mouse_pos = mouse_pos
	
	# 根据鼠标和随机倾斜计算目标旋转角度
	target_tilt_rotation.x = - max_tilt_degrees.y * lerp(clamp(mouse_tilt_pos.y, - 1.0, 1.0), _tilt_rand.y, tilt_randomisation)
	target_tilt_rotation.y = - max_tilt_degrees.x * lerp(clamp(mouse_tilt_pos.x, - 1.0, 1.0), _tilt_rand.x, tilt_randomisation)
	
	# 平滑过渡到目标旋转
	rotation_degrees += (target_tilt_rotation - rotation_degrees) * clamp(tilt_smoothing * delta, 0.0, 1.0)
