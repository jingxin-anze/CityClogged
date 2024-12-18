extends CarState

func enter() -> void:
	super.enter()
	common_car.steering = 0

func physics_process(delta: float) -> void:
	#print(common_car.target_rotation)
	#common_car.steering = 0
	#print(common_car.linear_velocity)
	if is_zero_approx(common_car.target_rotation) and common_car.rotation.y > 7*PI/4:
		common_car.steering = (common_car.target_rotation - common_car.rotation.y + 2*PI)
	elif abs(common_car.target_rotation - common_car.rotation.y) >= PI/90:
		common_car.steering = (common_car.target_rotation - common_car.rotation.y)
	#汽车直线行驶时的逻辑
	if common_car.linear_velocity.length() < common_car.straight_speed:
		common_car.engine_force = common_car.straight_engine_factor
		common_car.brake = 0
	elif common_car.linear_velocity.length() < common_car.straight_speed * 1.1:
		common_car.engine_force = 0
		common_car.brake = 0
	else:
		common_car.engine_force = 0
		common_car.brake = common_car.brake_factor

	#状态切换
	if common_car.left_road_ray.is_colliding():
		common_car.target_rotation = common_car._fixes_degree(common_car.target_rotation + PI/2)
		state_machine.state_changed("Turn")
		return
