# 状态：直走
class_name GoStraightState
extends State
func enter():
	print("进入直行")
	
func physics_update(delta: float) -> void:

	# 抱持恒定得速度
	if car.linear_velocity.length() > car.max_velocity:
		car.engine_force = 0
	else:
		car.engine_force = 4	# 待机状态物理逻辑
		
	if car.ray_cast_3d.get_collider():
		machine.transition_to("SlowDown")
	
