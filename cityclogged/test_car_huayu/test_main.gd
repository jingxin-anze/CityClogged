extends Node3D

var s: Array = []

@onready var target: Marker3D = $Target
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var test_car_3: VehicleBody3D = %test_car_3



func _ready() -> void:
	test_car_3.is_target = true
	test_car_3.target_one = target.position
