extends Node3D

@onready var target: Marker3D = $Target
@onready var test_car: RigidBody3D = %TestCar
@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D
@onready var grid_map: GridMap = $NavigationRegion3D/Map/GridMap


func _ready() -> void:
	test_car.target_one = target.position
	path_3d.curve.get_point_in()
