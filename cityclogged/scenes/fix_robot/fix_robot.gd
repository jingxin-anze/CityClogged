extends CharacterBody3D 

@export var move_speed: float = 200
@export var disabled_vehicle:Node3D
@export var turns_number:int=2
var turns:int=0
@onready var animation_player: AnimationPlayer = $Sprite3D/AnimationPlayer

# 定义圆周运动的半径
var radius: = 2.0
# 定义角速度（弧度/秒）
var angular_velocity:= 3.0
# 定义初始角度
var angle: = 0.0
# 定义圆心位置
var reach_car_position:bool = false
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if is_instance_valid(disabled_vehicle) and !reach_car_position:
			move(delta)
			if global_position - disabled_vehicle.global_position < Vector3(2,2,2):
				reach_car_position = true
		
		if reach_car_position:
				circle_around(delta)
	move_and_slide()

func circle_around(dt:float):
	# 更新角度
	if turns_number<=turns:
		if is_instance_valid(disabled_vehicle):
			disabled_vehicle.queue_free()
			animation_player.play("face")
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

func move(delta):
	velocity = (disabled_vehicle.global_position - global_position).normalized() * move_speed * delta
	
	
