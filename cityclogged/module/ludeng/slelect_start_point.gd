class_name SelectStartPoint extends Area3D

@onready var trafficSignal:TrafficSignal
@export var next_left_point:Array[Area3D] # 下一个左转路口点位
@export var next_right_street:Array[Area3D]# 下一个右转路口点位
@export var next_straight_street:Array[Area3D] #下一个直走路口点位

var curret_car: Car
# Called when the node enters the scene tree for the first time.
