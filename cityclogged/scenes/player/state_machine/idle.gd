extends Node3D

var state_machine:StateMachine
var player:Player

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if player.movement_direction:
		state_machine.change_state("Move")
	pass

func _physics_tick(delta:float):
	player.velocity.x = move_toward(player.velocity.x, 0,player.movement_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.movement_speed)
	pass
