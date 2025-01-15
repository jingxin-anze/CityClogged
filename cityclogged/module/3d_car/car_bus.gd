extends VehicleBody3D

@export var speed = 200
@export var max_speed: float = 3.0 
@onready var street_now: Street
# 0正常 1 拥堵 2 故障 3 等待
var status: int = 0
# 添加一个标记来追踪是否已经计入密度
var density_counted: bool = false
var is_ready: bool = false
var is_enter_tree:bool = false
# 添加射线检测器用于检测前方车辆
@onready var front_ray: RayCast3D = $RayCast3D
# 添加停止检测的阈值
const STOP_THRESHOLD: float = 2
@onready var ray_cast_the_select_startpoint: RayCast3D = $RayCastTheSelectStartpoint
@export var steering_sensitivity = 0.09
@export var max_steering_angle = 0.5  # 最大转向角度（弧度），约30度
@export var turn_radius = 20.0          # 转弯半径

# 开始修正
var is_start_correction: bool = false

# 目标街道
var target_street:RayCast3D

# 开始去下一个街道
var is_go_to_next_street: bool = false

func _ready() -> void:	
	engine_force = speed
	lock_rotation =true

		
func _physics_process(delta: float) -> void:
		if  !get_colliding_bodies().is_empty():
			status_accident()
			
		if status != 3:
			#print("检查前方交通状况")
			check_front_traffic()
			
		if is_start_correction:
			# 计算车与目标之间的朝向差异
			var turn_angle = get_direction_angle(self, target_street)
			# 将转向角度限制在合理范围内
			var target_steering = clampf(turn_angle * steering_sensitivity * 2, -max_steering_angle, max_steering_angle)
			steering = target_steering
			
			if get_direction_angle(self, target_street) == 0.0:
				print("修正完毕")
				is_start_correction = false
				
		if is_go_to_next_street:
			
			# 计算车与目标之间的朝向差异
			var turn_angle = get_direction_angle(self, target_street)
			# 将转向角度限制在合理范围内
			var target_steering = clampf(turn_angle * steering_sensitivity * 2, -max_steering_angle, max_steering_angle)
			steering = target_steering
			
			# 获取到目标点的方向向量
			var to_target = target_street.global_position - global_position
			to_target.y = 0  # 忽略高度差
			
			# 获取车辆当前朝向
			var forward = -global_transform.basis.z
			forward.y = 0
			
			# 计算到目标点的距离
			var distance = to_target.length()
			var current_speed = linear_velocity.length()
			 # 使用考虑速度的转向因子
			var steering_factor = calculate_steering_factor(distance, current_speed)
			# 计算期望的转向角度
			var desired_angle = calculate_desired_steering(forward.normalized(), to_target.normalized())
			
			# 在高速时降低转向敏感度
			var speed_based_sensitivity = steering_sensitivity * (1.0 - (current_speed / max_speed) * 0.3)
			steering = desired_angle * steering_factor * steering_sensitivity
			

# 检查前方交通状况
func check_front_traffic() -> void:
	
			
	if front_ray.is_colliding():
		var collider = front_ray.get_collider()
		if collider is Car:
			# 获取碰撞对象的速度
			var front_car_speed = collider.linear_velocity.length()
			if front_car_speed < STOP_THRESHOLD:
				enter_jam_state()
			else:
				# 前车在移动，恢复正常状态
				recover_from_jam()
	else:
		# 前方无车，恢复正常状态
		recover_from_jam()

# 进入拥堵状态
func enter_jam_state():
	if status == 0: # 如果之前是正常状态
		 # 进入拥堵状态前先减少密度
		if street_now:
			street_now.density_calculation = max(0, street_now.density_calculation - 1)
			print("车辆拥堵：",street_now.density_calculation)
		status = 1
		engine_force = 0
		brake = 20

# 从拥堵状态恢复
func recover_from_jam() -> void:
	if status == 1:  # 如果之前是拥堵状态
		status = 0
		
		# 恢复正常状态时增加密度
		if street_now:
			street_now.density_calculation += 1
			print("车辆恢复：",street_now.density_calculation)
		brake = 0
		engine_force = speed
		
# 故障状态		
func status_accident():
	if status == 2:
		return
	status = 2
	street_now.density_calculation -= 1
	print("车辆故障：",street_now.density_calculation)
	await get_tree().create_timer(2.0).timeout
	queue_free()


# 去下一个街道	
func go_to_the_next_street(target:RayCast3D):
		print("去下一个街道")
		target_street = target
		is_go_to_next_street = true

# 到达下一个街道
func reach_next_street():	
		print("到达下一个街道")
		is_go_to_next_street = false
		print("修正完毕")
		# 开始修正轨迹
		is_start_correction = true
		
		
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
	
func calculate_steering_factor(distance: float, speed: float) -> float:
	# 根据速度动态调整转向半径
	var dynamic_turn_radius = turn_radius * (1.0 + speed / 10.0)
	  
	# 提前转向系数
	var early_turn_factor = 1.0 + (speed / max_speed) * 0.5
	 
	# 根据速度调整转向敏感度
	return clampf(distance / (dynamic_turn_radius * early_turn_factor), 0.0, 1.0)
