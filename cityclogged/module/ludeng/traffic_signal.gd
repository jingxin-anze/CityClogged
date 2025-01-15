class_name TrafficSignal extends Node3D


@export var red_duration: float = 5.0 
@export var yellow_duration: float = 2.0 
@export var green_duration: float = 5.0
@export var select_point:SelectStartPoint

@onready var sprite_green: Sprite3D = $SpriteGreen
@onready var sprite_yellow: Sprite3D = $SpriteYellow
@onready var sprite_red: Sprite3D = $SpriteRed


@export_enum("red","green") var initial_state: String = "green"

var timer: float = 0.0
var current_state
func _ready() -> void:
	init() # Replace with function body.


# 初始化
func init():
	current_state = initial_state
	update_lights()
	
	
# 更新灯光显示
func update_lights():
	sprite_red.visible = current_state == "red"
	sprite_yellow.visible = current_state == "yellow"
	sprite_green.visible = current_state == "green"	
	#select_point.current_state = current_state

func _process(delta: float) -> void:
	timer += delta

	match current_state:
		"red": # 红灯
			if timer >= red_duration:
				current_state = "green" # 切换到绿灯
				timer = 0.0
		"green": # 绿灯
			if timer >= green_duration:
				current_state = "yellow" # 切换到黄灯
				timer = 0.0
		"yellow": # 黄灯
			if timer >= yellow_duration:
				current_state = "red" # 切换到红灯
				timer = 0.0
	update_lights()


func _on_area_3d_area_entered(area: Area3D) -> void:
	
	if area.get_parent() is Street:
		print(area.get_rid())
