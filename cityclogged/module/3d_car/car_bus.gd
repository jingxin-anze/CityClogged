class_name Car extends VehicleBody3D

@export var speed = 200
@export var max_velocity: float = 1.0 
@onready var street_now: Street # 当前的街道
# 0正常 1 拥堵 2 故障 3 等待 4转弯
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
@export var MAX_STEER_ANGLE := 0.8  # 最大转向角度
@export var steering_speed := 3.0   # 转向速度
# 开始修正
var is_start_correction: bool = false
@onready var marker_3d: Marker3D = $Marker3D

# 目标点
var target_point:Marker3D

var traffic_signal:TrafficSignal # 当到达信号灯位置，保存一个信号灯的对象

# 下一个街道
var next_street: Street

func _ready() -> void:	
	engine_force = speed
	lock_rotation =true

		
func _physics_process(delta: float) -> void:
		if linear_velocity.length() < 0.001:
			lock_rotation = false
		if  !get_colliding_bodies().is_empty():
			status_accident()
			
		if status != 3:
			#print("检查前方交通状况")
			check_front_traffic()
		if status == 4:
			check_front_traffic()
		if traffic_signal:
			
			match traffic_signal.current_state:
				"red": # 红灯
					engine_force = 0
					brake = 20
					status = 3 
				"yellow": # 黄灯
					engine_force = 0
					brake = 20
					status = 3
				"green":
					engine_force = speed
					brake = 20
					status = 0
					traffic_signal = null
					
		if  target_point:
			var target_steer = calculate_steering_angle(target_point.global_position)
			# 平滑转向
			steering = move_toward(steering, target_steer, steering_speed * delta)
					
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
	# 抱持恒定得速度
	if linear_velocity.length() > max_velocity:
		engine_force = 0
	else:
		engine_force = speed	# 待机状态物理逻辑
	#if  target_point:
		#var target_steer = calculate_steering_angle(target_point.global_position)
		## 平滑转向
		#steering = move_toward(steering, target_steer, steering_speed)
		
# 故障状态		
func status_accident():
	if status == 2:
		return
	status = 2
	street_now.density_calculation -= 1
	print("车辆故障：",street_now.density_calculation)
	await get_tree().create_timer(2.0).timeout
	queue_free()


func calculate_steering_angle(target_position: Vector3) -> float:
	# 获取当前位置
	var current_pos = global_position
	
	# 计算目标方向向量
	var to_target = target_position - current_pos
	to_target.y = 0
	
	# 获取车辆当前的前进方向
	var forward = global_transform.basis.z
	forward.y = 0
	
	# 计算目标方向与当前方向的夹角
	var angle = forward.signed_angle_to(to_target, Vector3.UP)
	
	# 限制转向角度
	return clampf(angle, -MAX_STEER_ANGLE, MAX_STEER_ANGLE)		


func _on_body_entered(body: Node) -> void:
	if body.get_parent() is ShiZiLuKou:
		print(123)

func go_to_next_point():
	target_point = next_street.get_road_point("right_end")
