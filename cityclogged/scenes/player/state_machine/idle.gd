extends Node3D

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player

var move_state:bool
var state:int

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if player.movement_direction:
		if not move_state:
			state_machine.change_state("Move")
			an_t.get("parameters/playback").travel("Move")
		else:
			state_machine.change_state("Move1")
			an_t.get("parameters/playback").travel("Move1")
	if Input.is_action_just_pressed("pick_drop"):
		move_state=!move_state 
	pass

func _physics_tick(delta:float):
	player.velocity.x = move_toward(player.velocity.x, 0,player.movement_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.movement_speed)
	pass

func _on_move_to_idle(dir: Vector2,id:int) -> void:
	an_t.set("parameters/Idle/blend_position",dir)
	state=id


func _on_hand_up_to_idle(dir:Vector2,id:int) -> void:
	an_t.set("parameters/Idle1/blend_position",dir)
	state=id
