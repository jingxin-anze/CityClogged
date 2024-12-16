class_name CommonCar
extends CharacterBody3D
##车辆一般的运动速度
@export var speed: float = 15#目前不能超过15
##与目的地的最小距离
@export var stop_min: float = 1
##值越大加速减速越快
@export var speed_changed: float = 8
##给车辆一个目标点
@export var is_target: bool = false
##车辆的目的地，现在为一个点，以后可以为两个点（比如一个地方有两个停车场）或一片区域（一个数组）
var target_one: Vector3 = Vector3.ZERO
var direction_3d: Vector3 = Vector3.ZERO
var current_path_3d: PackedVector3Array = []
var one_await: bool = true ##有目标后的第一帧不运行

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_target:
		if one_await:
			navigation_agent_3d.target_position = target_one
			one_await = false
			return
			#if navigation_agent_3d.get_current_navigation_path().size() == 0:
				#current_path_3d = navigation_agent_3d.get_current_navigation_path()
		if navigation_agent_3d.distance_to_target() < stop_min:
			self.velocity = Vector3.ZERO
				#angular_velocity = Vector3(0,0,0)
			queue_free()
			return
		
		direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
		#print(direction_3d)
		var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
			#print(navigation_agent_3d.get_next_path_position())
		var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
		self.quaternion = self.quaternion.slerp(target_quaternion, delta*10)
		if ray_cast_3d.is_colliding():
			self.velocity = _speed_change(self.velocity, Vector3.ZERO, delta)
			move_and_slide()
			return
		if not is_zero_approx(velocity.length() - speed):
			self.velocity = _speed_change(self.velocity,direction_3d*speed,delta)
		else:
			self.velocity = direction_3d*speed
		move_and_slide()

##转向的计算
func _rotating_change() -> void:
	pass

##速度加速减速的计算,从当前速度朝着目标速度改变，但一帧一般是变不完的
func _speed_change(_now_speed: Vector3, _target_speed: Vector3, _delta: float) -> Vector3:
	var _t: Vector3 = _now_speed.slerp(_target_speed, _delta*speed_changed)
	return _t
