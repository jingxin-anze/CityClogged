extends Node3D

var state_machine:StateMachine
var player:Player

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if not player.movement_direction:
		state_machine.change_state("Idle")

func _physics_tick(delta:float):
	player.velocity = player.movement_direction_3d *player.movement_speed
	pass
