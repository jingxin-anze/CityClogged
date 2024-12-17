extends Node3D

var s: Array = []

@onready var target: Marker3D = $Target
@onready var road_main: GridMap = $RoadMain
@onready var test_car_3: VehicleBody3D = %test_car_3

func _ready() -> void:
	var _t: Array[Vector3i] = road_main.get_used_cells()
	for i in _t:
		test_car_3.map_points.append(road_main.map_to_local(i))
		#print(road_main.map_to_local(i))
	test_car_3.is_target = true
	test_car_3.target_one = target.position
	test_car_3.start_point = test_car_3.position
	test_car_3.end_point = target.position
	test_car_3._reset()
