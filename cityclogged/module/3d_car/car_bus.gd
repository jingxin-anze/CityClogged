class_name Car extends VehicleBody3D

@export var speed = 300

@onready var street_now: Street
# 0正常 1 拥堵 2 故障
var status: int = 0
# 添加一个标记来追踪是否已经计入密度
var density_counted: bool = false
var is_ready: bool = false
var is_enter_tree:bool = false
# 添加射线检测器用于检测前方车辆
@onready var front_ray: RayCast3D = $RayCast3D
# 添加停止检测的阈值
const STOP_THRESHOLD: float = 2

func _ready() -> void:	
	engine_force = speed
	
func _physics_process(delta: float) -> void:
		if  !get_colliding_bodies().is_empty():
			status_accident()
			
		check_front_traffic()
	

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
			
func status_accident():
	if status == 2:
		return
	status = 2
	street_now.density_calculation -= 1
	print("车辆故障：",street_now.density_calculation)
	await get_tree().create_timer(2.0).timeout
	queue_free()
