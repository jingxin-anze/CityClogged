extends Node3D

@onready var target: Marker3D = $Target
@onready var test_car: RigidBody3D = $TestCar

func _ready() -> void:
	test_car.target_one = target.position
