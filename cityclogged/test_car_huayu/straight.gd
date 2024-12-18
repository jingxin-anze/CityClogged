extends CarState

func enter() -> void:
	super.enter()

func _physics_process(delta: float) -> void:
	if common_car.left_road_ray.is_colliding():
		state_machine.state_changed("Fall")
		return
