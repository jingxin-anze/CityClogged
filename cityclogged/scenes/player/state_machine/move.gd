extends Node3D

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player


var movement_dir:Vector2
signal to_idle(dir:Vector2,id:int)

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if not player.movement_direction:
		state_machine.change_state("Idle")
		an_t.get("parameters/playback").travel("Idle")
		to_idle.emit(movement_dir,1)
	else:
		movement_dir=player.movement_direction

func _physics_tick(delta:float):
	an_t.set("parameters/Move/blend_position",player.movement_direction)
	
	player.velocity.x= player.movement_direction_3d.x*player.movement_speed*delta
	player.velocity.z= player.movement_direction_3d.z*player.movement_speed*delta
	pass
