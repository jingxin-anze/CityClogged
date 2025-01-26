class_name StateBase extends Node

@export var  an_t:AnimationTree
@export var  an:AnimationPlayer

var state_machine:StateMachine

func _enter():
	an.play("toward_idle")
	pass

func _exit():
	pass

func _tick(delta:float):
	pass

func _physics_tick(delta:float):
	pass
