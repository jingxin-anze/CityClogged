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
##车的起点
var start_point: Vector3
##车的终点
var end_point: Vector3
##车辆应该行驶的路
var act_road: PackedVector3Array
var current_point: int = 0

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	astar3d = AStar3D.new()
	#direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))

func _physics_process(delta: float) -> void:
	if is_target:
		if one_await:
			navigation_agent_3d.target_position = target_one
			one_await = false
			return
		if current_point < act_road.size():
			direction_3d = (act_road[current_point] - global_position).normalized()
		#move_toward()
		#direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))
		##print(direction_2d_long)
		#direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
		#var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
				##print(navigation_agent_3d.get_next_path_position())
		##var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
		##self.quaternion = self.quaternion.slerp(target_quaternion, delta*10)
		#steering = clamp(direction_2d_long.angle_to(direction_2d),-PI/8,PI/8)
		##print(linear_velocity)
		#if ray_cast_3d.is_colliding():
			#brake = _minus_engine
			#return
		#if linear_velocity.length() <= speed:
			#engine_force = _add_engine
		#else:
			#engine_force = 0

func _reset() -> void:
	_sort_array()
	for i in map_points.size():
		astar3d.add_point(i,map_points[i],1)
		#print(map_points[i])
	for i in temp_array.size():
		if i == temp_array.size()-1:
			for j in temp_array[i].size() - 1:
				if temp_array[i][j+1].z - temp_array[i][j].z <= 1.5:
					astar3d.connect_points(temp_array2[i][j+1], temp_array2[i][j], true)
		elif i == temp_array.size() - 2:
			for j in temp_array[i].size(): 
				if j < temp_array[i].size() - 1:
					if temp_array[i][j+1].z - temp_array[i][j].z <= 1.5:
						astar3d.connect_points(temp_array2[i][j+1], temp_array2[i][j], true)
				for k in temp_array[i+1].size():
					if temp_array[i+1][k].x - temp_array[i][j].x <= 1.5 and is_zero_approx(temp_array[i+1][k].z - temp_array[i][j].z) :
						astar3d.connect_points(temp_array2[i+1][k], temp_array2[i][j], true)
		else:
			for j in temp_array[i].size(): 
				if j < temp_array[i].size() - 1:
					if temp_array[i][j+1].z - temp_array[i][j].z <= 1.5:
						astar3d.connect_points(temp_array2[i][j+1], temp_array2[i][j], true)
				for k in temp_array[i+1].size():
					if temp_array[i+1][k].x - temp_array[i][j].x <= 1.5 and is_zero_approx(temp_array[i+1][k].z - temp_array[i][j].z) :
						astar3d.connect_points(temp_array2[i+1][k], temp_array2[i][j], true)
	#map_points.sort()
	#astar3d.connect_points(0, 1, false)
	#print(temp_array)
	#print(astar3d.get_id_path(3,16))
	var _s_p = map_points.bsearch_custom(start_point,_custom_sort,true)
	var _e_p = map_points.bsearch_custom(end_point,_custom_sort,true)
	#act_road = astar3d.get_point_path(_s_p,_e_p)
	
	act_road = astar3d.get_point_path(_s_p,_e_p)
	print(act_road)

#数组排序
func _sort_array() -> void:
	map_points.sort_custom(_custom_sort)
	var _x: int = 0
	var _y: int = 0
	temp_array.append([])
	temp_array[_x].append(map_points[0])
	temp_array2.append([])
	temp_array2[_x].append(0)
	for i in map_points.size() - 1:
		if is_zero_approx(map_points[i].x - map_points[i+1].x):
			temp_array[_x].append(map_points[i+1])
			temp_array2[_x].append(i+1)
		else :
			temp_array.append([])
			_x += 1
			temp_array[_x].append(map_points[i+1])
			temp_array2.append([])
			temp_array2[_x].append(i+1)
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
			return false
