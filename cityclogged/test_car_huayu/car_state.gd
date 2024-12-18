class_name CarState
extends Node

@export var animation_name:String

var state_machine:CarStateMachine
var common_car:CommonCar
# Called when the node enters the scene tree for the first time.

func enter() -> void:
	common_car.animation_player.play(animation_name)

func physics_process(delta: float) -> void:
	pass

func exit() -> void:
	pass
