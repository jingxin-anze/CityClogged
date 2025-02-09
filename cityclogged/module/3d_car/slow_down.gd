# 状态: 减速
class_name SlowDownState
extends State

var ray_car: Car
var is_jam:bool = false
func enter():
	print("进入刹车")
func physics_update(delta: float) -> void:
	
	if !car.ray_cast_3d.get_collider() is Car:
		machine.transition_to("GoStraight")

	if  car.ray_cast_3d.get_collider() is Car:
		ray_car = car.ray_cast_3d.get_collider()
		if ray_car.linear_velocity.length() < car.linear_velocity.length():
			if car.brake < car.max_velocity:
				car.brake += delta * car.max_brake
				
				if car.linear_velocity.length() == 0 and !is_jam:
					#Global.jam_car_array += 1
					is_jam = true
				else:
					#Global.jam_car_array -= 1
					is_jam = false
			car.engine_force = 0
		else:
			car.brake = 0
	
	
func exit():
	ray_car = null
