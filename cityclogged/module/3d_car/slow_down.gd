# 状态: 减速
class_name SlowDownState
extends State

var ray_car: Car
func enter():
	print("进入刹车")
func physics_update(delta: float) -> void:
	
	if !car.ray_cast_3d.get_collider() is Car:
		machine.transition_to("GoStraight")

	if  car.ray_cast_3d.get_collider() is Car:
		ray_car = car.ray_cast_3d.get_collider()
		if ray_car.linear_velocity.length() < car.linear_velocity.length():
			print("刹车")
			if car.brake < car.max_velocity:
				car.brake += delta * 2
			car.engine_force = 0
			print(car.brake)
		else:
			print("松开")
			car.brake = 0
	
	
func exit():
	ray_car = null
