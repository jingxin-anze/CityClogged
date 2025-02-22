class_name TrafficSignal extends Node3D


@export var red_duration: float = 5.0 
@export var yellow_duration: float = 2.0 
@export var green_duration: float = 5.0
@export var select_point:SelectStartPoint

@onready var sprite_green: Sprite3D = $SpriteGreen
@onready var sprite_yellow: Sprite3D = $SpriteYellow
@onready var sprite_red: Sprite3D = $SpriteRed

@export_enum("red","green") var initial_state: String = "green"

signal street_is_ready(street:Street)

var timer: float = 0.0
var current_state
var self_street:Street

var left_street:Street
var go_street:Street
var right:Street


var next_state: String = "red"

func _ready() -> void:
	init() # Replace with function body.


# 始化函数，确保正确设置初始状态
func init():
	current_state = initial_state
	# 设置初始的next_state
	next_state = "red" if initial_state == "green" else "green"
	update_lights()
	
	
# 更新灯光显示
func update_lights():
	sprite_red.visible = current_state == "red"
	sprite_yellow.visible = current_state == "yellow"
	sprite_green.visible = current_state == "green"	

func _process(delta: float) -> void:
	timer += delta
	
	match current_state:
		"red": # 红灯
			if timer >= red_duration:
				# 红灯结束时，先切换到黄灯，并标记下一个状态为绿灯
				current_state = "yellow"
				next_state = "green"
				timer = 0.0
		"green": # 绿灯
			if timer >= green_duration:
				# 绿灯结束时，先切换到黄灯，并标记下一个状态为红灯
				current_state = "yellow"
				next_state = "red"
				timer = 0.0
		"yellow": # 黄灯
			if timer >= yellow_duration:
				# 黄灯结束时，切换到之前标记的下一个状态
				current_state = next_state
				timer = 0.0
	
	update_lights()
	
	

func _on_area_3d_area_entered(area: Area3D) -> void:
	
	# 这里是防止重复发送信号
	var rid:RID
	if area.get_parent() is Street and area.get_rid() != rid:
		self_street = area.get_parent()
		rid = area.get_rid()
		street_is_ready.emit(area.get_parent())
		
	

func find_min_density_street(streets: Array[Street]) -> Street:
	# 创建一个新的数组，避免修改原始数组
	var available_streets = streets.duplicate()
	
	# 如果输入数组为空，返回 null
	if available_streets.is_empty():
		return null
		
	# 从数组中移除 self_street
	available_streets.erase(self_street)
	
	# 如果移除后数组为空，返回 null
	if available_streets.is_empty():
		return null
	
	# 找出密度最小的街道
	var min_street = available_streets[0]
	var min_density = available_streets[0].density_calculation
	
	for street in available_streets:
		if street.density_calculation < min_density:
			min_density = street.density_calculation
			min_street = street
			
	return min_street
	

# 获取密度最低的街道
func get_density_calculation_street_low() -> Street:
	return find_min_density_street(get_parent().traffic_signal_array)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Car:
		body.traffic_signal = self
		body.next_street = get_density_calculation_street_low()
