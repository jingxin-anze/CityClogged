class_name Car extends VehicleBody3D

@onready var front_left: VehicleWheel3D = $front_left
@onready var front_right: VehicleWheel3D = $front_right


@export var MAX_STEER_ANGLE := 0.8  # 最大转向角度
@export var steering_speed := 3.0   # 转向速度
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@export var max_velocity:float = 2
var tar_get: Marker3D
var is_ready: bool = false

var street_now:Street # 当前所在的车道


func _process(delta: float) -> void:
	if  !get_colliding_bodies().is_empty():
			status_accident()
	#print(linear_velocity.length())
	
	#if linear_velocity.length() < 0.001:
		#is_ready = true
	#
	#if is_ready:
		#
		## 抱持恒定得速度
		#if linear_velocity.length() > 2:
			#engine_force = 0
		#else:
			#engine_force = 4
		#
		#
		#lock_rotation = false 
	if     tar_get:
		var target_steer = calculate_steering_angle(tar_get.global_position)
		# 平滑转向
		steering = move_toward(steering, target_steer, steering_speed * delta)

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
	
func set_target(target: Marker3D) -> void:
	tar_get = target
	
# 故障状态		
func status_accident():
	await get_tree().create_timer(2.0).timeout
	queue_free()
