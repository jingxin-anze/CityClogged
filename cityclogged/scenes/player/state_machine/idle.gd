extends StateBase


var state:String

func _enter():
	super._enter()
	pass

func _exit():
	super._exit()
	pass

func _tick(delta:float):
	super._tick(delta)
	if owner.movement_direction:
		if not owner.move_state:
			state_machine.change_state("Move")
			an_t.get("parameters/playback").travel("Move")
		else:
			state_machine.change_state("HandUp")
			an_t.get("parameters/playback").travel("Move1")

	pass

func _physics_tick(delta:float):
	super._physics_tick(delta)
	owner.velocity.x = move_toward(owner.velocity.x, 0,owner.movement_speed)
	owner.velocity.z = move_toward(owner.velocity.z, 0, owner.movement_speed)
	pass

func _on_move_to_idle(dir: Vector2,id:String) -> void:
	an_t.set("parameters/Idle/blend_position",dir)
	state=id

func _on_hand_up_to_idle(dir:Vector2,id:String) -> void:
	an_t.set("parameters/Idle1/blend_position",dir)
	state=id

func determine_dir(dir:Vector2):
	#print(dir)
	an_t.set("parameters/Idle/blend_position",dir)
