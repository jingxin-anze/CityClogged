@tool
class_name Street extends Node3D

@export var flush: bool = false
@export var create_car: bool = false
@export var car_scene: PackedScene
@export_group("Lane Settings")
@export var lane_length: float = 20.0
@export var lane_width: float = 4.0
@export var lane_separation: float = 1.0
@export var spawn_interval: Vector2 = Vector2(2.0, 5.0)

@export_group("Debug Settings")
@export var show_debug_visuals: bool = true
@export var debug_color_lane_1: Color = Color(1, 0, 0, 0.3)
@export var debug_color_lane_2: Color = Color(0, 0, 1, 0.3)
@export var point_size: float = 0.5  # 点的大小

@onready var density_calculation: float = 0 # 车道密度

var debug_meshes: Array = []
var point_meshes: Array[MeshInstance3D] = []  # 存储点的可视化网格
var time_to_next_spawn: float

# 
var road_points: Dictionary = {
	"left_start": null,   # 红车道起点
	"left_end": null,     # 红车道终点
	"right_start": null,  # 蓝车道起点
	"right_end": null     # 蓝车道终点
}

class Lane:
	var position: float
	var direction: float
	var traffic_density: float
	var start_marker: Marker3D
	var end_marker: Marker3D

	func _init(pos: float, dir: float, density: float = 1.0):
		position = pos
		direction = dir
		traffic_density = density

var lanes: Array[Lane] = []

# 获取道路点的方法
func get_road_point(point_name: String) -> Marker3D:
	return road_points.get(point_name)

func _ready() -> void:
	setup_lanes()
	time_to_next_spawn = randf_range(spawn_interval.x, spawn_interval.y)
	if show_debug_visuals:
		_create_debug_visualization()

func setup_lanes() -> void:
	# 清除之前的标记点和可视化
	for marker in road_points.values():
		if is_instance_valid(marker):
			marker.queue_free()
	
	for mesh in point_meshes:
		if is_instance_valid(mesh):
			mesh.queue_free()
	point_meshes.clear()
	
	# 创建左车道和右车道
	var left_lane = Lane.new(-lane_width - lane_separation/2, 0, 1.0)
	var right_lane = Lane.new(lane_width + lane_separation/2, PI, 1.0)
	lanes = [left_lane, right_lane]
	
	# 为每条车道添加起点和终点标记
	# 左车道
	road_points["left_start"] = _create_marker("LeftStart", left_lane, true)
	road_points["left_end"] = _create_marker("LeftEnd", left_lane, false)
	
	# 右车道
	road_points["right_start"] = _create_marker("RightStart", right_lane, true)
	road_points["right_end"] = _create_marker("RightEnd", right_lane, false)
	
	# 更新车道的标记引用
	left_lane.start_marker = road_points["left_start"]
	left_lane.end_marker = road_points["left_end"]
	right_lane.start_marker = road_points["right_start"]
	right_lane.end_marker = road_points["right_end"]
	
	# 创建点的可视化
	_create_point_visualization()

# 创建标记点的辅助函数
func _create_marker(name: String, lane: Lane, is_start: bool) -> Marker3D:
	var marker = Marker3D.new()
	marker.name = name
	add_child(marker)
	
	var base_position = Vector3(lane.position, 0, -lane_length/2 if is_start else lane_length/2)
	var offset_direction = 5  # 偏移距离
	
	# 对于左车道（方向为0）
	if abs(lane.direction) < 0.1:  # 近似等于0
		if is_start:
			base_position.z -= offset_direction + 1 # 起点向后偏移
		else:
			base_position.z += offset_direction + 2  # 终点向前偏移
	# 对于右车道（方向为PI）
	else:
		if is_start:
			base_position.z -= offset_direction + 2.5  # 起点向前偏移
		else:
			base_position.z += offset_direction    # 终点向后偏移
	
	marker.position = base_position
	marker.rotation.y = lane.direction
	
	return marker

# 创建点的可视化
func _create_point_visualization() -> void:
	for marker in road_points.values():
		var mesh_instance = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = point_size
		sphere.height = point_size * 2
		mesh_instance.mesh = sphere
		
		var material = StandardMaterial3D.new()
		material.albedo_color = Color(1, 1, 0)  # 黄色
		material.emission_enabled = true
		material.emission = Color(1, 1, 0)
		mesh_instance.material_override = material
		
		add_child(mesh_instance)
		mesh_instance.global_position = marker.global_position
		point_meshes.append(mesh_instance)

func _create_debug_visualization() -> void:
	for mesh in debug_meshes:
		if is_instance_valid(mesh):
			mesh.queue_free()
	debug_meshes.clear()
	
	for i in range(lanes.size()):
		var lane = lanes[i]
		
		var lane_mesh = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		mesh.size = Vector3(lane_width, 0.2, lane_length)
		lane_mesh.mesh = mesh
		
		var material = StandardMaterial3D.new()
		material.albedo_color = debug_color_lane_1 if i == 0 else debug_color_lane_2
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		lane_mesh.material_override = material
		
		lane_mesh.position = Vector3(lane.position, 0, -0.5)
		add_child(lane_mesh)
		debug_meshes.append(lane_mesh)


func toggle_debug_visualization() -> void:
	show_debug_visuals = !show_debug_visuals
	for mesh in debug_meshes:
		if is_instance_valid(mesh):
			mesh.visible = show_debug_visuals

func _process(delta: float) -> void:
	if flush:
		setup_lanes()
		time_to_next_spawn = randf_range(spawn_interval.x, spawn_interval.y)
		if show_debug_visuals:
			_create_debug_visualization()
		flush = false
	
	if create_car:
		time_to_next_spawn -= delta
		if time_to_next_spawn <= 0:
			spawn_car()
			time_to_next_spawn = randf_range(spawn_interval.x, spawn_interval.y)

func spawn_car() -> void:
	if car_scene:
		var lane = choose_lane()
		var car = car_scene.instantiate()

		add_child(car)
		var spawn_z = randf_range(-lane_length/2, lane_length/2)
		car.global_position = global_position + global_transform.basis * Vector3(lane.position, 0.1, spawn_z)
		var road_rotation = global_rotation.y
		var car_direction = lane.direction
		car.global_rotation.y = road_rotation + car_direction
		
		## 根据车辆的行驶方向设置目标点
		## 如果车辆朝正方向，使用终点标记；否则使用起点标记
		#var target_marker = lane.end_marker if abs(car_direction) < PI/2 else lane.start_marker
		#car.set("target_point", target_marker)

func choose_lane() -> Lane:
	var total_density = 0.0
	for lane in lanes:
		total_density += lane.traffic_density
	
	var random_value = randf() * total_density
	var current_sum = 0.0
	
	for lane in lanes:
		current_sum += lane.traffic_density
		if random_value <= current_sum:
			return lane
	
	return lanes[0]

func _on_density_calculation_body_entered(body: Node3D) -> void:
	if body is Car:
		density_calculation += 1
		body.street_now = self
		
		# 根据车辆的行驶方向设置目标点
		var car_global_rotation = body.global_rotation.y
		var road_rotation = global_rotation.y
		
		# 定义方向判断的容差值（比如30度 = PI/6）
		var direction_tolerance = PI / 6
		
		# 寻找最近的车道和确定行驶方向
		var nearest_lane
		var min_distance = INF
		for l in lanes:
			var lane_pos = Vector3(l.position, 0, 0)
			var car_local_pos = body.global_position - global_position
			var distance = abs(car_local_pos.x - lane_pos.x)
			
			if distance < min_distance:
				min_distance = distance
				nearest_lane = l
		
		if nearest_lane:
			# 计算期望的理想方向（车道的基准方向）
			var ideal_direction = nearest_lane.direction + road_rotation
			
			# 将车辆的实际方向规范化到 [-PI, PI] 范围内
			var actual_direction = wrapf(car_global_rotation, -PI, PI)
			var ideal_direction_normalized = wrapf(ideal_direction, -PI, PI)
			
			# 计算方向差的绝对值
			var direction_diff = abs(wrapf(actual_direction - ideal_direction_normalized, -PI, PI))
			
			# 根据方向差判断目标点
			var target_marker
			if direction_diff <= direction_tolerance:
				# 车辆方向接近车道的正向方向
				target_marker = nearest_lane.end_marker
			else:
				# 车辆方向接近车道的反向方向
				target_marker = nearest_lane.start_marker
			
			body.set("target_point", target_marker)
		
		print("车辆进入：", density_calculation)
		print("当前街道密度：", density_calculation)

func _on_density_calculation_body_exited(body: Node3D) -> void:
	if body is Car:
		density_calculation = max(0, density_calculation - 1)
		body.traffic_signal = null
		print("车俩离开：", density_calculation)
		print("当前街道密度：", density_calculation)
