extends CharacterBody3D

var fall_speed:int=10

func _physics_process(delta: float) -> void:
	#众所周知重力加速度为9.8米每秒的二次方，所以直接赋值了
	if not is_on_floor():
		velocity.y-=9.8*delta*fall_speed
	move_and_slide()
