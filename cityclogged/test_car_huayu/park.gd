extends CarState

func physics_process(delta: float) -> void:
	#因为停车，所以应该。。
	if common_car.park_type == 0:
		pass
	#因为信号灯，所以应该。。
	if common_car.park_type == 1:
		common_car.brake = common_car.common_brake_factor
