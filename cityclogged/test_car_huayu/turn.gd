extends CarState

func enter() -> void:
	super.enter()
	#common_car.engine_force = 0
	#common_car.brake_factor = 5
func physics_process(delta: float) -> void:
	
	common_car.steering = common_car.turn_steering
	#print(common_car.target_rotation,common_car.rotation)
	if common_car.linear_velocity.length() < common_car.turn_speed:
		common_car.engine_force = common_car.turn_engine_factor
		common_car.brake = 0
	elif common_car.linear_velocity.length() < common_car.turn_speed*1.1:
		common_car.engine_force = 0
		common_car.brake = 0
	else:
		common_car.engine_force = 0
		common_car.brake = common_car.turn_brake_factor

	if is_zero_approx(common_car.target_rotation) and common_car.rotation.y > 7*PI/4:
		if (common_car.rotation.y - 2*PI) <= PI/90:
			common_car.steering = 0
			state_machine.state_changed("Straight")
	elif abs(common_car.rotation.y - common_car.target_rotation) <= PI/90:
		common_car.steering = 0
		state_machine.state_changed("Straight")
