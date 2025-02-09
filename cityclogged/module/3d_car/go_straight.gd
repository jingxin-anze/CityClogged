# 状态：前进
class_name GoStraightState
extends State
func enter():
	print("进入直行")
	
func physics_update(delta: float) -> void:

	# 抱持恒定得速度
	if car.linear_velocity.length() > car.max_velocity:
		car.engine_force = 0
	else:
		car.engine_force = car.speed
	
	if car.linear_velocity.length() > 0.3 and car.is_jam:
		Global.jam_car -= 1
		car.is_jam = false
		
	if car.ray_cast_3d.get_collider() is Car:
		machine.transition_to("SlowDown")
	
	if car.traffic_signal:
		machine.transition_to("WaitingSignalLight")
	
# 虚函数：退出状态
func exit() -> void:
	pass
