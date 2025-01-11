class_name SelectStartPoint extends Area3D

@onready var current_state:String
@export var next_left_street:RayCast3D # 下一个左转路口
@export var next_right_street:RayCast3D # 下一个右转路口
@export var next_straight_street:RayCast3D #下一个直走路口

var curret_car: Car
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if curret_car:
		if current_state == "green":
			curret_car.status = 0
			curret_car.brake = 0
			curret_car.engine_force = curret_car.speed 
			curret_car.go_to_the_next_street(next_left_street)
			curret_car = null
		
func _on_body_entered(body: Node3D) -> void:
	if body is Car:
		body.status = 3
		body.brake = 30
		body.engine_force = 0
		curret_car = body
		
