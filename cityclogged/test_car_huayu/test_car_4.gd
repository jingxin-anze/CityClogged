class_name CommonCar
extends VehicleBody3D

#enum CarStates{
	#STRA,
	#LEFT,
	#RIGHT,
	#BRAKE,
#}

##刹车
@export var brake_factor: float = 10
##直线加速
@export var straight_engine_factor: float = 30
##转弯速度过小加速
@export var turn_engine_factor: float = 20
##直线最大速度
@export var straight_speed: float = 5
##拐弯最大速度
@export var turn_speed: float = 3

##转弯时的目标y 旋转角度
var current_rotation: float = 0
##当前状态
#var current_state: CarStates = CarStates.STRA

@onready var front_road_ray: RayCast3D = $FrontRoadRay
@onready var left_road_ray: RayCast3D = $LeftRoadRay
@onready var right_road_ray: RayCast3D = $RightRoadRay
@onready var car_state_machine: CarStateMachine = $CarStateMachine

func _ready() -> void:
	current_rotation = self.rotation.y

func _physics_process(delta: float) -> void:
	if left_road_ray.is_colliding():
		pass

##直走
func _straight_line() -> void:
	if self.linear_velocity.length() <= straight_speed:
		self.engine_force = straight_engine_factor

##左转90度
func _left_turn() -> void:
	if self.linear_velocity.length() <= turn_speed:
		self.engine_force = turn_engine_factor

##右转90度
func _right_turn() -> void:
	if self.linear_velocity.length() <= turn_speed:
		self.engine_force = turn_engine_factor

##刹车
func _brake() -> void:
	brake = brake_factor

##掉头
