class_name CommonCar
extends VehicleBody3D

##急刹车
@export var brake_factor: float = 10
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

##转弯时的目标y 旋转角度
var target_rotation: float = 0

@onready var front_road_ray: RayCast3D = $FrontRoadRay
@onready var left_road_ray: RayCast3D = $LeftRoadRay
@onready var right_road_ray: RayCast3D = $RightRoadRay
@onready var car_state_machine: CarStateMachine = $CarStateMachine

func _ready() -> void:
	left_road_ray.position.z = turn_reduce_lenth
	right_road_ray.position.z = turn_reduce_lenth
	target_rotation = _fixes_degree(self.rotation.y)
	#print(target_rotation)

func _physics_process(delta: float) -> void:
	self.rotation.y = _positive_degree(self.rotation.y)
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
