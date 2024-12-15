extends Area3D

@export_enum("x+","x-","z+","z-") var carmera_relative_pos:String
var rotate_time:int=1
#var start_rotate:bool
#var time:float
#var player:Player
func _ready() -> void:
	#SLSystem.save_data("a",123)
	#SLSystem.show_all_content()
	pass
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		#player=body
		var tween:Tween=get_tree().create_tween()
		var init_rotation=body.rotation
		
		match carmera_relative_pos:
			"x+":
				body.rotation=simplify_angle(body.rotation)
				if simplify_angle(init_rotation)==Vector3(0,PI/2,0):
					return
				#start_rotate=true
				#print(init_rotation)
				#print(relative_angle_dirr(simplify_angle(init_rotation),Vector3(0,PI,0)))
				tween.tween_property(body,"rotation",Vector3(0,PI/2,0),rotate_time)
			"x-":
				if init_rotation==Vector3(0,-PI/2,0):
					return
				tween.tween_property(body,"rotation",Vector3(0,-PI/2,0),rotate_time)
			"z+":
				body.rotation=simplify_angle(body.rotation)
				if simplify_angle(init_rotation)==Vector3(0,0,0):
					return
				tween.tween_property(body,"rotation",Vector3(0,0,0),rotate_time)
			"z-":
				if simplify_angle(init_rotation)==Vector3(0,PI,0):
					return
				#print(init_rotation)
				#print(relative_angle_dirr(simplify_angle(init_rotation),Vector3(0,PI,0)))
				tween.tween_property(body,"rotation",Vector3(0,PI,0),rotate_time)

#func _physics_process(delta: float) -> void:
	#if start_rotate:
		#time+=delta
		#match carmera_relative_pos:
			#"x+":
				#player.rotation.y=lerp_angle(player.rotation.y,PI/2,time)
				#if player.drotation.y==PI/2:
					#start_rotate=false
			#"x-":
				#pass
			#"z+":
				#pass
			#"z-":
				#pass
	#pass
##想一想angle需要旋转多少度能到anchor
func relative_angle_dirr(angle:Vector3,anchor:Vector3):
	angle=simplify_angle(angle+Vector3(PI,PI,PI)-anchor)
	anchor=Vector3(PI,PI,PI)
	
	return anchor-angle
	
#func simplify_angle(angle:float):
	#while angle >=PI*2:
		#angle-=PI*2
	#while angle<0:
		#angle+=PI*2
	#return angle

##将角度简化在0到360
func simplify_angle(angle:Vector3):
	while angle.x >=PI*2:
		angle.x-=PI*2
	while angle.x<0:
		angle.x+=PI*2
		
	while angle.y >=PI*2:
		angle.y-=PI*2
	while angle.y<0:
		angle.y+=PI*2
		
	while angle.z >=PI*2:
		angle.z-=PI*2
	while angle.y<0:
		angle.z+=PI*2
		
	return angle
