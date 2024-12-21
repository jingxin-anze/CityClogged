class_name CommonCar
extends VehicleBody3D

##急刹车
@export var urgent_brake_factor: float = 15
##正常刹车
@export var common_brake_factor: float = 10
##转弯减速刹车
@export var turn_brake_factor: float = 2
##直线加速
@export var straight_engine_factor: float = 100
##转弯速度过小时加速
@export var turn_engine_factor: float = 20
##直线最大速度
@export var straight_speed: float = 4
##转弯最大速度
@export var turn_speed: float = 3
##转弯角度变化的快慢
@export var turn_steering: float = PI/8
##距离多少米时开始减速
@export var turn_reduce_lenth: float = 1.1
##距离信号灯多少米开始刹车
@export var light_lenth: float = 2
##距离前车多少米开始刹车
@export var car_lengh: float = 1
##一辆车道的宽度多少米（格子）
@export var road_width: float = 1
##转弯时的目标y 旋转角度
var target_rotation: float = 0
var target_point: Vector3 = Vector3.ZERO
##当前左转还是右转
var left_right_turn: int = -1

@onready var front_light_ray: RayCast3D = $FrontLightRay
@onready var front_car_ray: RayCast3D = $FrontCarRay
@onready var front_road_ray: RayCast3D = $FrontRoadRay
@onready var left_road_ray: RayCast3D = $LeftRoadRay
@onready var right_road_ray: RayCast3D = $RightRoadRay
@onready var car_state_machine: CarStateMachine = $CarStateMachine

func _ready() -> void:
	#print(_fixes_point(Vector2(5.9,5),Vector2(1,0)))
	front_light_ray.target_position.z = light_lenth
	front_car_ray.target_position.z = car_lengh
	left_road_ray.position.z = turn_reduce_lenth
	right_road_ray.position.z = turn_reduce_lenth
	target_rotation = _fixes_degree(self.rotation.y)
	target_point = _direction_vector(target_rotation) * 10000 + self.global_position
	#print(target_point)

func _physics_process(delta: float) -> void:
	self.rotation.y = _positive_degree(self.rotation.y)
	#print(position)
	#print(target_rotation)
	#print(linear_velocity.length())
	#if self.rotation.y == 2*PI:
		#self.rotation.y = 0

##直走
#func _straight_line() -> void:
	#if self.linear_velocity.length() <= straight_speed:
		#self.engine_force = straight_engine_factor
#
###左转90度
#func _left_turn() -> void:
	#if self.linear_velocity.length() <= turn_speed:
		#self.engine_force = turn_engine_factor

###右转90度
#func _right_turn() -> void:
	#if self.linear_velocity.length() <= turn_speed:
		#self.engine_force = turn_engine_factor

###刹车
#func _brake() -> void:
	#brake = brake_factor

##角度只有0，90，180，270
func _fixes_degree(_t: float) -> float:
	_t = _positive_degree(_t)
	if _t <= PI/4 or _t > 7*PI/4:
		return 0
	elif _t <= PI*3/4:
		return PI/2
	elif  _t <= PI*5/4:
		return PI
	else:
		return 3*PI/2

##角度限制为[0,2PI)
func _positive_degree(_t: float) -> float:
	while  _t < 0:
		_t = _t + 2*PI
	while _t >= 2*PI:
		_t = _t - 2*PI
	return _t

func _fixes_point(_t: Vector3, _turn: float, _turn2: float) -> Vector3:
	var _t2:Vector3i = _t
	var _turnv: Vector3 = _direction_vector(_turn)
	#_turn = _fixes_degree(_turn)
	var _turnv2: Vector3 = _direction_vector(_turn2)
	_t = Vector3(_t2) + _turnv * road_width / 2 + _turnv2 * 10000
	return _t

func _direction_vector(_t: float) -> Vector3:
	_t = _fixes_degree(_t)
	if is_zero_approx(_t - 0):
		return Vector3(0,0,1)
	elif is_zero_approx(_t - PI/2):
		return Vector3(1,0,0) 
	elif is_zero_approx(_t - PI):
		return Vector3(0,0,-1)
	else :
		return Vector3(-1,0,0)

##从标准方向到当前方向
func _angle_degree(_t: Vector3, _t2: Vector3) -> float:
	_t = _t.normalized()
	_t2 = _t2.normalized()
	var _tt: Vector2 = Vector2(_t.x, _t.z)
	var _tt2: Vector2 = Vector2(_t2.x, _t2.z)
	return _tt.angle_to(_tt2)

##离目标点的垂直距离,前者是目标点
func _interpolation(_t: Vector3, _t2: Vector3) -> float:
	if _t.x >= 9000:
		return _t2.z - _t.z
	elif _t.x <= -9000:
		return _t.z - _t2.z
	elif _t.z >= 9000:
		return _t.x - _t2.x
	else:
		return _t2.x - _t.x
