extends StateBase

var is_right:bool
var dir:Vector3
var speed:float=100

func _enter():
	print("p1",owner.p1)
	an.play("toward_walk")


#func _physics_tick(delta:float):
	#if is_right:
		#dir=(owner.p2-owner.global_position).normalized()
		#if (owner.p2-owner.global_position).length()<0.1:
			#is_right=!is_right
	#else:
		#dir=(owner.p1-owner.global_position).normalized()
		#if (owner.p1-owner.global_position).length()<0.1:
			#is_right=!is_right
	#owner.velocity=dir*delta*speed
	#pass
