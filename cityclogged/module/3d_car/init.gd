# 状态：初始化
class_name InitState
extends State


func physics_update(delta: float) -> void:
	print(car.linear_velocity.length())
	if car.linear_velocity.length() < 0.001:
		machine.transition_to("GoStraight")

func exit():
	car.lock_rotation = false
