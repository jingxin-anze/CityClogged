extends VehicleBody3D

@export var speed = 10
@export var steering_sensitivity = 0.3
@export var max_steering_angle = 0.5  # 最大转向角度（弧度），约30度
@export var turn_radius = 10.0          # 转弯半径
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
var a: bool = true
func _ready() -> void:
	engine_force = speed

func _physics_process(delta: float) -> void:
	if a:
		# 获取到目标点的方向向量
		var to_target = ray_cast_3d.global_position - global_position
		to_target.y = 0  # 忽略高度差
		
		# 获取车辆当前朝向
		var forward = -global_transform.basis.z
		forward.y = 0
		
		# 计算到目标点的距离
		var distance = to_target.length()
		
		# 计算期望的转向角度
		var desired_angle = calculate_desired_steering(forward.normalized(), to_target.normalized())
		
		# 根据距离调整转向角度
		var steering_factor = clampf(distance / turn_radius, 0.0, 1.0)
		steering = desired_angle * steering_factor * steering_sensitivity
	else:
		# 计算车与目标之间的朝向差异
		var turn_angle = get_direction_angle(self, ray_cast_3d)
		# 将转向角度限制在合理范围内
		var target_steering = clampf(turn_angle * steering_sensitivity * 2, -max_steering_angle, max_steering_angle)
		steering = target_steering

# 计算两个节点之间的朝向夹角，并判断转向方向
func get_direction_angle(vehicle: VehicleBody3D, target: RayCast3D) -> float:
	# 获取车的朝向（前向量）
	var vehicle_forward = -vehicle.global_transform.basis.z
	# 获取目标的朝向
	var target_forward = -target.global_transform.basis.z
	
	# 投影到水平面（忽略y轴的影响）
	vehicle_forward.y = 0
	target_forward.y = 0
	
	# 重新归一化向量
	vehicle_forward = vehicle_forward.normalized()
	target_forward = target_forward.normalized()
	
	# 计算夹角
	var angle = vehicle_forward.angle_to(target_forward)
	
	# 使用叉积判断是向左转还是向右转
	var cross_product = vehicle_forward.cross(target_forward)
	
	# 返回带方向的角度
	# 如果cross_product.y小于0，说明目标在右边，需要向右转（正值）
	# 如果cross_product.y大于0，说明目标在左边，需要向左转（负值）
	return angle * sign(cross_product.y)
	
func calculate_desired_steering(forward: Vector3, to_target: Vector3) -> float:
	# 计算夹角
	var angle = forward.angle_to(to_target)
	
	# 使用叉积判断转向方向
	var cross_product = forward.cross(to_target)
	
	# 获取带方向的转向角度
	var signed_angle = angle * sign(-cross_product.y)
	
	# 限制最大转向角度
	return clampf(signed_angle, -max_steering_angle, max_steering_angle)


func _on_area_3d_body_entered(body: Node3D) -> void:
	a = false
