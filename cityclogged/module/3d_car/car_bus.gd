class_name Car2 extends VehicleBody3D

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

var current_lane_type:String
# 下一个街道
var next_street: Street

# 添加最小速度阈值来判断拥堵状态
@export var MIN_SPEED_THRESHOLD: float = 0.1  # 最小速度阈值，低于此速度认为是拥堵
@export var SPEED_MATCH_FACTOR: float = 0.9   # 与前车保持的速度比例（略低于前车速度）

@export var FRONT_CAR_START_THRESHOLD: float = 0.3  # 前车需要达到的启动速度阈值
@export var FOLLOW_DISTANCE: float = 2.0  # 跟车距离

# 添加一个计时器来处理异常拥堵状态
var stuck_timer: float = 0.0
@export var STUCK_TIMEOUT: float = 0.5  # 如果1.5秒内没有检测到前车，就强制恢复


func _ready() -> void:	
	engine_force = speed
	lock_rotation =true

		
func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 0.001:
		lock_rotation = false
		
	if !get_colliding_bodies().is_empty():
		status_accident()
	
	# 处理信号灯状态
	if traffic_signal:
		match traffic_signal.current_state:
			"red", "yellow":
				engine_force = 0
				brake = 20
			"green":
				engine_force = speed
				brake = 0
				traffic_signal = null
	else:
		# 如果处于拥堵状态，检查是否需要强制恢复
		if status == 1:
			if !front_ray.is_colliding():  # 前方没有车
				stuck_timer += delta
				if stuck_timer >= STUCK_TIMEOUT:
					print("强制恢复 - 前方无车")
					recover_from_jam()
					stuck_timer = 0.0
			else:
				# 如果检测到前车，重置计时器
				stuck_timer = 0.0
		
	handle_speed_control()
	
	# 处理转向
	if target_point:
		var target_steer = calculate_steering_angle(target_point.global_position)
		steering = move_toward(steering, target_steer, steering_speed * delta)



func handle_speed_control() -> void:
	var current_speed = linear_velocity.length()
	
	if front_ray.is_colliding():
		var collider = front_ray.get_collider()
		if collider is Car:
			
			var front_car_speed = collider.linear_velocity.length()
			
			# 前车速度过低时进入拥堵状态
			if front_car_speed < MIN_SPEED_THRESHOLD:
				enter_jam_state()
				return
			
			# 调整速度以匹配前车
			if current_speed > front_car_speed:
				var target_speed = front_car_speed * SPEED_MATCH_FACTOR
				adjust_speed(target_speed)
			else:
				maintain_normal_speed(current_speed)
	else:
		# 前方无车，检查是否需要恢复
		if status == 1:
			recover_from_jam()
		maintain_normal_speed(current_speed)

# 跟随行为调整函数
func adjust_following_behavior(front_car_speed: float, distance: float) -> void:
	var current_speed = linear_velocity.length()
	
	# 计算基于距离的目标速度
	var distance_factor = clamp((distance - FOLLOW_DISTANCE) / FOLLOW_DISTANCE, 0, 1)
	var target_speed = front_car_speed * SPEED_MATCH_FACTOR * distance_factor
	
	if distance < FOLLOW_DISTANCE:
		# 距离太近，需要减速
		engine_force = 0
		brake = 20
	elif current_speed > target_speed:
		# 速度过快，需要减速
		var brake_force = remap(current_speed - target_speed, 
							  0, max_velocity, 
							  5, 20)
		engine_force = 0
		brake = brake_force
	else:
		# 可以适当加速跟随
		var acceleration = remap(distance, 
							   FOLLOW_DISTANCE, 
							   FOLLOW_DISTANCE * 2, 
							   0.3, 0.8)
		engine_force = speed * acceleration
		brake = 0
			
func maintain_turning_speed(current_speed: float) -> void:
	var target_turning_speed = max_velocity * 0.7  # 转向时的目标速度
	
	if current_speed > target_turning_speed:
		engine_force = 0
		brake = 5
	elif current_speed < target_turning_speed * 0.8:
		engine_force = speed * 0.6
		brake = 0
	else:
		engine_force = speed * 0.4
		brake = 0

func maintain_normal_speed(current_speed: float) -> void:
	if current_speed > max_velocity:
		#engine_force = 0
		brake = 1  # 轻微刹车以降低速度
	elif current_speed < max_velocity * 0.9:  # 添加一个缓冲区
		engine_force = speed
		brake = 0
	else:
		engine_force = speed * 0.5  # 接近最大速度时减小引擎力
		brake = 0

func adjust_speed(target_speed: float) -> void:
	var current_speed = linear_velocity.length()
	var speed_diff = current_speed - target_speed
	
	if speed_diff > 0:  # 需要减速
		var brake_force = remap(speed_diff, 0, max_velocity, 5, 20)
		engine_force = 0
		brake = brake_force
	else:  # 需要加速
		engine_force = speed
		brake = 0

func enter_jam_state() -> void:
	if status == 0:
		if street_now:
			street_now.density_calculation = max(0, street_now.density_calculation - 1)
			print("车辆拥堵：", street_now.density_calculation)
		status = 1
		engine_force = 0
		brake = 10
		# 重置卡住计时器
		stuck_timer = 0.0

func recover_from_jam() -> void:
	if status == 1:
		status = 0
		if street_now:
			street_now.density_calculation += 1
			print("车辆恢复：", street_now.density_calculation)
		brake = 0
		engine_force = speed
		# 重置卡住计时器
		stuck_timer = 0.0
		
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


func go_to_next_point():
	print("下一个街道",next_street)
	if next_street:		
		if current_lane_type == "red":		
			target_point = next_street.get_road_point("right_end")
		if current_lane_type == "blue":		
			target_point = next_street.get_road_point("left_start")
	else:
		queue_free()
