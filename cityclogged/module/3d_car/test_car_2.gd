class_name Car extends VehicleBody3D


@export var speed = 200
@export var max_velocity: float = 1.0 
@export var MAX_STEER_ANGLE = 0.8  # 最大转向角度
@export var steering_speed = 3.0   # 转向速度
@export var max_brake = 1 # 最大刹车力度


@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var machine: CarStateMachine = $Machine
# 添加射线检测器用于检测前方车辆
@onready var front_ray: RayCast3D = $RayCast3D

# 目标点
var target_point:Marker3D
var traffic_signal:TrafficSignal # 当到达信号灯位置，保存一个信号灯的对象
var current_lane_type:String
# 下一个街道
var next_street: Street
var street_now:Street # 当前所在的车道,当车辆生成的时候，所在的车道会给这个值赋值
# 添加一个标记来追踪是否已经计入密度
var density_counted: bool = false
var is_enter_tree:bool = false


func _process(delta: float) -> void:
	if  !get_colliding_bodies().is_empty():
			status_accident()
	
		
	if  target_point:
		var target_steer = calculate_steering_angle(target_point.global_position)
		# 平滑转向
		steering = move_toward(steering, target_steer, steering_speed * delta)

func calculate_steering_angle(target_position: Vector3) -> float:
	# 获取当前位置
	var current_pos = global_position
	street_now.rotation
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
	

	
# 故障状态		
func status_accident():
	await get_tree().create_timer(2.0).timeout
	
	queue_free()
	
func go_to_next_point():
	print("下一个街道",next_street)
	if next_street:		
		if current_lane_type == "red":		
			target_point = next_street.get_road_point("right_end")
		if current_lane_type == "blue":		
			target_point = next_street.get_road_point("left_start")
	else:
		queue_free()
