extends VehicleBody3D

@export var is_target: bool = false
##最大速度
@export var speed: float = 2.5
##加速时的加速度
@export var _add_engine: float = 30
##减速时的加速度
@export var _minus_engine: float = 2.5
##车辆的目的地，现在为一个点，以后可以为两个点（比如一个地方有两个停车场）或一片区域（一个数组）
var target_one: Vector3 = Vector3.ZERO
var direction_3d: Vector3 = Vector3.ZERO
var current_path_3d: PackedVector3Array = []
var one_await: bool = true ##有目标后的第一帧不运行
var direction_2d_long: Vector2 
var temp_array: Array[Array] = []
var temp_array2: Array[Array] = []
var astar3d: AStar3D
var map_points: Array[Vector3] = []

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	astar3d = AStar3D.new()
	direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))

func _physics_process(delta: float) -> void:
	if is_target:
		if one_await:
			navigation_agent_3d.target_position = target_one
			one_await = false
			return
		direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))
		#print(direction_2d_long)
		direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
		var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
				#print(navigation_agent_3d.get_next_path_position())
		#var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
		#self.quaternion = self.quaternion.slerp(target_quaternion, delta*10)
		steering = clamp(direction_2d_long.angle_to(direction_2d),-PI/8,PI/8)
		#print(linear_velocity)
		if ray_cast_3d.is_colliding():
			brake = _minus_engine
			return
		if linear_velocity.length() <= speed:
			engine_force = _add_engine
		else:
			engine_force = 0

func _reset() -> void:
	_sort_array()
	for i in map_points.size():
		astar3d.add_point(i,map_points[i],1)
	var _now_id: int = 0
	for i in temp_array.size():
		if i == temp_array.size():
			for j in temp_array[i].size() - 1:
				if temp_array[i][j+1].z - temp_array[i][j].z <= 1.5:
					astar3d.connect_points(temp_array2[i][j+1], temp_array2[i][j], true)
		else:
			for j in temp_array[i].size() - 1:
				if temp_array[i][j+1].z - temp_array[i][j].z <= 1.5:
					astar3d.connect_points(temp_array2[i][j+1], temp_array2[i][j], true)
				if temp_array[i+1][j].x - temp_array[i][j].x <= 1.5:
					astar3d.connect_points(_now_id, _now_id + 1, true)
				#astar3d.connect_points(i,i+1,true)
	#map_points.sort()
	#astar3d.connect_points(0, 1, false)
	#print(astar3d.get_point_path(0,1,true))
#数组排序
func _sort_array() -> void:
	map_points.sort_custom(_custom_sort)
	var _x: int = 0
	var _y: int = 0
	temp_array[_x][_y] = map_points[0]
	temp_array2[_x][_y] = 0
	for i in map_points.size() - 1:
		if is_zero_approx(map_points[i].x - map_points[i+1].x):
			temp_array[_x][++_y] = map_points[i+1]
			temp_array2[_x][++_y] = i+1
		else :
			temp_array[++_x][0] = map_points[i+1]
			temp_array2[++_x][0] = i+1
#自定义排序，从左上到右下
func _custom_sort(a: Vector3,b: Vector3) -> bool:
	if a.x < b.x:
		return true
	elif a.x > b.x:
		return false
	else :
		if a.z < b.z:
			return true
		elif a.z > b.z:
			return false
		else:
			return true
