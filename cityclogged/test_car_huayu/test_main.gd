extends Node3D

var s: Array = []

@onready var target: Marker3D = $Target
@onready var test_car: RigidBody3D = %TestCar
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D


func _ready() -> void:
	test_car.target_one = target.position
