extends Node

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player

@export var alert_robot:CharacterBody3D
@export var speed:int=100
var dir:Vector3

func _enter():
	an.play("front_run_alert")
	pass

func _exit():
	pass

func _tick(delta:float):
	if not alert_robot.can_track:
		state_machine.change_state("Patrol")
	pass

func _physics_tick(delta:float):
	dir=(player.global_position-alert_robot.global_position).normalized()
	alert_robot.velocity=dir*delta*speed
	pass
