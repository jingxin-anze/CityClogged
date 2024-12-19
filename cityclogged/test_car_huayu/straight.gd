extends CarState

func enter() -> void:
	super.enter()
	common_car.steering = 0

func physics_process(delta: float) -> void:
	#print(common_car.target_rotation)
	#common_car.steering = 0
	#print(common_car.linear_velocity)
	#print(common_car.linear_velocity.length())
	#if is_zero_approx(common_car.target_rotation) and common_car.rotation.y > 7*PI/4:
		#common_car.steering = (2*PI - common_car.rotation.y)
	#elif abs(common_car.target_rotation - common_car.rotation.y) >= PI/90:
		#common_car.steering = (common_car.target_rotation - common_car.rotation.y)
	#print(abs(common_car._angle_degree(common_car._direction_vector(common_car.target_rotation),(common_car.target_point - common_car.global_position))))
	##print(common_car.target_point - common_car.global_position)
	#if abs(common_car._angle_degree(common_car._direction_vector(common_car.target_rotation),(common_car.target_point - common_car.global_position))) >= PI/180 :
		#common_car.steering = common_car._angle_degree(common_car._direction_vector(common_car.target_rotation),(common_car.target_point - common_car.global_position))
	#汽车直线行驶时的逻辑
	#if common_car
	#print(common_car._interpolation(common_car.target_point,common_car.global_position))
	common_car.steering = 0
	if abs(common_car._interpolation(common_car.target_point,common_car.global_position) )>= 0.05:
		
		common_car.steering = common_car._interpolation(common_car.target_point,common_car.global_position)/2
	if common_car.linear_velocity.length() < common_car.straight_speed:
		common_car.engine_force = common_car.straight_engine_factor
		common_car.brake = 0
	elif common_car.linear_velocity.length() < common_car.straight_speed * 1.1:
		common_car.engine_force = 0
		common_car.brake = 0
	else:
		common_car.engine_force = 0
		common_car.brake = common_car.common_brake_factor

	#状态切换
	if common_car.left_road_ray.is_colliding():
		common_car.target_point = common_car._fixes_point(common_car.left_road_ray.get_collision_point(),common_car.target_rotation,common_car.target_rotation + PI/2)
		print(common_car.target_point)
		common_car.target_rotation = common_car._fixes_degree(common_car.target_rotation + PI/2)
		common_car.left_right_turn = 0
		state_machine.state_changed("Turn")
		return
	if common_car.right_road_ray.is_colliding():
		common_car.target_point = common_car._fixes_point(common_car.right_road_ray.get_collision_point(),common_car.target_rotation,common_car.target_rotation - PI/2)
		print(common_car.target_point)
		common_car.target_rotation = common_car._fixes_degree(common_car.target_rotation - PI/2)
		common_car.left_right_turn = 1
		state_machine.state_changed("Turn")
		return
