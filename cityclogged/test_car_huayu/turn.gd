extends CarState

var _timer: int = 0

func enter() -> void:
	super.enter()
	_timer = 0
	#common_car.engine_force = 0
	#common_car.brake_factor = 5
func physics_process(delta: float) -> void:
	#print(common_car.linear_velocity)
	#print(common_car.linear_velocity.length())
	_timer += 1
	if common_car.left_right_turn == 0:
		common_car.steering = common_car.turn_steering
	elif  common_car.left_right_turn == 1:
		common_car.steering = -1 * common_car.turn_steering
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
	_state_straight()
	#if _timer >= common_car.turn_timer * 60:
		#_state_straight()
	#if common_car.left_right_turn == 0 and not common_car._ray_road(common_car.left_road_ray):
		#_state_straight()
	#elif common_car.left_right_turn == 1 and not common_car._ray_road(common_car.right_road_ray):
		#_state_straight()
##状态切换成直行
func _state_straight() -> void:
	if is_zero_approx(common_car.target_rotation) and common_car.rotation.y > 7*PI/4:
		#print("1")
		if 2*PI - common_car.rotation.y <= PI/90:
			common_car.steering = 0
			if _timer >= common_car.turn_timer * 60:
				state_machine.state_changed("Straight")
	elif abs(common_car.rotation.y - common_car.target_rotation) <= PI/90:
		common_car.steering = 0
		if _timer >= common_car.turn_timer * 60:
			state_machine.state_changed("Straight")
