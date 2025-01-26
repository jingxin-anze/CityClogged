extends Node3D

var is_active:bool=true

const FIX_ROBOT = preload("res://scenes/fix_robot/fix_robot.tscn")

func _physics_process(delta: float) -> void:
	if Global.maintain_breakdown_car_array && is_active:
		var car=Global.maintain_breakdown_car_array.pop_front()
		var t:Tween=get_tree().create_tween()
		self.global_position=Vector3(0,100,0)+car.global_position
		t.tween_property(self,"global_position",Vector3(0,50,0)+car.global_position,1)
		var fix_robot:=FIX_ROBOT.instantiate()
		get_parent().add_child(fix_robot)
		fix_robot.target=car
		t.tween_property(self,"global_position",Vector3(0,1000,0),2)
		t.tween_callback(queue_free)
		is_active=false
