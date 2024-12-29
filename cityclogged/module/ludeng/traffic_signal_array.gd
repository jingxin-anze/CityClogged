class_name TrafficSignalArray extends Node3D

@export var red_duration: float = 5.0 
@export var yellow_duration: float = 2.0 
@export var green_duration: float = 5.0

var current_state: String = "" # 当前的信号灯状态
var timer: float = 0.0


signal change_signal(current_state:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta

	match current_state:
		"red": # 红灯
			if timer >= red_duration:
				current_state = "green" # 切换到绿灯
				change_signal.emit(current_state)
				timer = 0.0
		"green": # 绿灯
			if timer >= green_duration:
				current_state = "yellow" # 切换到黄灯
				change_signal.emit(current_state)
				timer = 0.0
		"yellow": # 黄灯
			if timer >= yellow_duration:
				current_state = "red" # 切换到红灯
				change_signal.emit(current_state)
				timer = 0.0
