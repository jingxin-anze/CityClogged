@tool
extends Node3D

@export var flush: bool = false
@export var create_car: bool = false
@export var car_scene: PackedScene
@export_group("Lane Settings")
@export var lane_length: float = 20.0
@export var lane_width: float = 4.0
@export var lane_separation: float = 1.0
@export var spawn_interval: Vector2 = Vector2(2.0, 5.0)

# 添加调试显示控制
@export_group("Debug Settings")
@export var show_debug_visuals: bool = true
@export var debug_color_lane_1: Color = Color(1, 0, 0, 0.3)  # 红色半透明
@export var debug_color_lane_2: Color = Color(0, 0, 1, 0.3)  # 蓝色半透明

var debug_meshes: Array = []
var time_to_next_spawn: float

class Lane:
	var position: float
	var direction: float
	var traffic_density: float

	func _init(pos: float, dir: float, density: float = 1.0):
		position = pos
		direction = dir
		traffic_density = density

var lanes: Array[Lane] = []

func _ready() -> void:
	setup_lanes()
	time_to_next_spawn = randf_range(spawn_interval.x, spawn_interval.y)
	if show_debug_visuals:
		_create_debug_visualization()

func setup_lanes() -> void:
	var left_lane = Lane.new(-lane_width - lane_separation/2, 0, 1.0)
	var right_lane = Lane.new(lane_width + lane_separation/2, PI, 1.0)
	lanes = [left_lane, right_lane]

# 创建调试可视化
func _create_debug_visualization() -> void:
	# 清除旧的调试网格
	for mesh in debug_meshes:
		if is_instance_valid(mesh):
			mesh.queue_free()
	debug_meshes.clear()
	
	# 为每个车道创建可视化
	for i in range(lanes.size()):
		var lane = lanes[i]
		
		# 车道地面
		var lane_mesh = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		mesh.size = Vector3(lane_width, 0.2, lane_length)  # 扁平的盒子表示车道
		lane_mesh.mesh = mesh
		
		# 设置材质
		var material = StandardMaterial3D.new()
		material.albedo_color = debug_color_lane_1 if i == 0 else debug_color_lane_2
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		lane_mesh.material_override = material
		
		lane_mesh.position = Vector3(lane.position, 0, -0.5)
		add_child(lane_mesh)
		debug_meshes.append(lane_mesh)


# 切换调试显示
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

# 生成车辆的代码保持不变...
func spawn_car() -> void:
	if car_scene:
		var lane = choose_lane()
		var car = car_scene.instantiate()
		add_child(car)
		
		var spawn_z = randf_range(-lane_length/2, lane_length/2)
		car.global_position = global_position + global_transform.basis * Vector3(lane.position, 0.1, spawn_z)
		# 将车辆的朝向旋转结合道路的全局旋转和车道方向
		var road_rotation = global_rotation.y
		var car_direction = lane.direction
		car.global_rotation.y = road_rotation + car_direction

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
