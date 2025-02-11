extends Node3D

var is_active:bool=true
const FIX_ROBOT = preload("res://scenes/fix_robot/fix_robot.tscn")
var car:Car

func _physics_process(delta: float) -> void:
	if car && is_active:
		var t:Tween=get_tree().create_tween()
		t.tween_property(self,"global_position",Vector3(0,5,0)+car.global_position,5)
		t.tween_callback(create_robot.bind(car))
		
		t.tween_property(self,"global_position",Vector3(0,20,0),5)
		t.tween_callback(queue_free)
		is_active=false

func create_robot(car:Car):
	var fix_robot:=FIX_ROBOT.instantiate()
	fix_robot.global_position = global_position
	fix_robot.scale = Vector3(5,5,5)
	get_parent().add_child(fix_robot)
	fix_robot.disabled_vehicle = car
