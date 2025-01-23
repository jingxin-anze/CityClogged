# 状态： 等待红绿灯
class_name WaitingSignalLight
extends State


# 虚函数：物理更新
func physics_update(_delta: float) -> void:
	if car.brake < 5:
		car.brake += _delta * 2
	if is_instance_valid(car.traffic_signal):
		if car.traffic_signal.current_state ==  "green":
			machine.transition_to("GoStraight")

# 虚函数：进入状态
func enter() -> void:
	print("等待红绿灯")
	car.brake = 0
	car.engine_force = 0

# 虚函数：退出状态
func exit() -> void:
	car.brake = 0
	car.traffic_signal = null
	print("退出红绿灯")
