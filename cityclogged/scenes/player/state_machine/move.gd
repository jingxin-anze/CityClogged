extends StateBase

var movement_dir:Vector2
signal to_idle(dir:Vector2,id:String)

func _enter():
	super._enter()
	pass

func _exit():
	super._exit()
	pass

func _tick(delta:float):
	super._tick(delta)
	if not owner.movement_direction:
		state_machine.change_state("Idle")
		an_t.get("parameters/playback").travel("Idle")
		to_idle.emit(movement_dir,self.name)
	else:
		movement_dir=owner.movement_direction

func _physics_tick(delta:float):
	super._physics_tick(delta)
	an_t.set("parameters/Move/blend_position",owner.movement_direction)
	
	owner.velocity.x= owner.movement_direction_3d.x*owner.movement_speed*delta
	owner.velocity.z= owner.movement_direction_3d.z*owner.movement_speed*delta
	pass
