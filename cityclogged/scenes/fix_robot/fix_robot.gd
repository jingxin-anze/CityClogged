extends CharacterBody3D 

@export var disabled_vehicle:Node3D
@export var turns_number:int=2
var turns:int=0

# 定义圆周运动的半径
var radius: = 2.0
# 定义角速度（弧度/秒）
var angular_velocity:= 1.0
# 定义初始角度
var angle: = 0.0
# 定义圆心位置

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_instance_valid(disabled_vehicle):
		circle_around(delta)
	move_and_slide()

func circle_around(dt:float):
	# 更新角度
	if turns_number<=turns:
		return
	angle += angular_velocity * dt
	#print(angle)
	if abs(angle-TAU)<0.001:
		turns+=1
	# 确保角度在 0 到 TAU (2*PI) 之间循环
	angle = wrapf(angle, 0, TAU)
	# 计算新位置
	var position_2d:Vector2=Vector2( disabled_vehicle.global_position.x, disabled_vehicle.global_position.z)
	var new_position:Vector2 =position_2d + Vector2(cos(angle), sin(angle)) * radius
	# 更新节点位置
	global_position.x = new_position.x
	global_position.z=new_position.y


	
	
