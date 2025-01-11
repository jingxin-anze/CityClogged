@tool
class_name Street extends Node3D

@export var flush: bool = false
@export var create_car: bool = false
@export var car_scene: PackedScene
@export_group("Lane Settings")
@export var lane_length: float = 20.0
@export var lane_width: float = 4.0
@export var lane_separation: float = 1.0
@export var spawn_interval: Vector2 = Vector2(2.0, 5.0) # 随机生成汽车的时间（2 - 5）

# 添加调试显示控制
@export_group("Debug Settings")
@export var show_debug_visuals: bool = true
@export var debug_color_lane_1: Color = Color(1, 0, 0, 0.3)  # 红色半透明
@export var debug_color_lane_2: Color = Color(0, 0, 1, 0.3)  # 蓝色半透明


# 用来统计当前街道的密度
@onready var density_calculation: float = 0

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
		

# 生成车辆的代码
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
		
		

# 随机选择一条车道
#假设有两条车道：
#
#左车道密度为 0.7
#右车道密度为 0.3
#
#那么：
#
#total_density = 0.7 + 0.3 = 1.0
#生成随机值，比如 0.45
#检查第一个车道：0.45 ≤ 0.7，所以选择左车道
#如果随机值是 0.8：0.8 > 0.7，继续检查右车道
#0.8 ≤ (0.7 + 0.3)，所以选择右车道
func choose_lane() -> Lane:
	
	# 计算所有车道的总密度
	var total_density = 0.0
	for lane in lanes:
		total_density += lane.traffic_density
	
	# 生成一个 0 到总密度之间的随机值
	# 这个随机值用来按照密度比例选择车道
	var random_value = randf() * total_density
	var current_sum = 0.0
	
	# 用于累加每条车道的密度，形成一个范围区间
	for lane in lanes:
		current_sum += lane.traffic_density
		
		 # 如果随机值小于等于当前累加和，说明随机值落在这条车道的区间内
		if random_value <= current_sum:
			return lane
	
	return lanes[0]


func _on_density_calculation_body_entered(body: Node3D) -> void:
	if body is Car:
		body.street_now = self
		if body.status == 0:
			density_calculation += 1
			print("车俩进入：", density_calculation)
		print("当前街道密度：", density_calculation)

func _on_density_calculation_body_exited(body: Node3D) -> void:
	if body is Car:  # 只检查正常的车辆
		if body.status == 0:
			density_calculation =  max(0, density_calculation - 1)
			print("车俩离开：", density_calculation)
		print("当前街道密度：", density_calculation)
