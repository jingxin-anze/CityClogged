extends RigidBody3D

# 基础参数
@export var engine_force := 15.0  # 引擎力
@export var turn_speed := 2.0     # 转向速度
@export var target_speed := 10.0  # 目标速度
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"

# 转向控制
var target_rotation: float
var is_turning := false
var turn_direction := 0.0

func _ready():
	# 设置物理参数
	gravity_scale = 1  # 保持重力
	linear_damp = 1.0  # 添加一些阻尼防止滑行
	angular_damp = 3.0 # 角速度阻尼
	
	# 如果要转向X轴方向
	turn_to_direction(Vector3.RIGHT)
	# 或者使用目标点的方向
	turn_to_direction(ray_cast_3d.global_transform.basis.x)

func _physics_process(delta: float) -> void:
	if is_turning:
		handle_turning(delta)
	else:
		# 正常前进
		apply_forward_force()

# 处理转向
func handle_turning(delta: float) -> void:
	var current_angle = global_rotation.y
	var angle_diff = wrapf(target_rotation - current_angle, -PI, PI)
	
	if abs(angle_diff) > 0.05:  # 如果还没到达目标角度
		# 添加转向力
		var turn_force = turn_direction * turn_speed
		apply_torque(Vector3.UP * turn_force)
		
		# 在转向时适当减速
		var forward_force = engine_force * 0.5
		apply_central_force(global_transform.basis.z * forward_force)
	else:
		# 到达目标角度，停止转向
		is_turning = false
		# 继续前进
		apply_forward_force()

# 开始转向
func start_turn(direction: Vector3) -> void:
	var target_dir = direction.normalized()
	var current_dir = -global_transform.basis.z
	
	# 计算目标旋转角度
	target_rotation = atan2(target_dir.x, -target_dir.z)
	
	# 确定转向方向（左转为负，右转为正）
	var angle_diff = wrapf(target_rotation - global_rotation.y, -PI, PI)
	turn_direction = sign(angle_diff)
	
	is_turning = true

# 应用前进力
func apply_forward_force() -> void:
	var current_speed = linear_velocity.length()
	if current_speed < target_speed:
		apply_central_force(global_transform.basis.z * engine_force)

# 外部调用的转向函数
func turn_to_direction(world_direction: Vector3) -> void:
	start_turn(world_direction)

# 辅助函数：获取当前速度
func get_current_speed() -> float:
	return linear_velocity.length()
