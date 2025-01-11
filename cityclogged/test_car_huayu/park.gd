extends CarState

##是否停止
var _park_time: bool = false

func enter() -> void:
	super.enter()
	if common_car.park_type == 0:
		await get_tree().create_timer(1.5).timeout
		_park_time = true

func physics_process(delta: float) -> void:
	#因为停车，所以应该。。
	if common_car.park_type == 0 and _park_time:
		common_car.brake = common_car.common_brake_factor
	#因为信号灯，所以应该。。
	if common_car.park_type == 1:
		common_car.brake = common_car.common_brake_factor
	#推出状态的时候将type改一下
