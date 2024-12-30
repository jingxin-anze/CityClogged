extends Node

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player

@export var alert_robot:CharacterBody3D
@export var speed:int=100

var is_right:bool
var dir:Vector3


func _enter():
	an.play("front_run")
	pass

func _exit():
	pass

func _tick(delta:float):
	if alert_robot.can_track:
		state_machine.change_state("Track")
	pass

func _physics_tick(delta:float):
	if is_right:
		dir=(alert_robot.p2-alert_robot.global_position).normalized()
		if (alert_robot.p2-alert_robot.global_position).length()<0.1:
			is_right=!is_right
	else:
		dir=(alert_robot.p1-alert_robot.global_position).normalized()
		if (alert_robot.p1-alert_robot.global_position).length()<0.1:
			is_right=!is_right
	alert_robot.velocity=dir*delta*speed
	pass
