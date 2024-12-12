extends Node3D

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if player.movement_direction:
		state_machine.change_state("Move")
		an_t["parameters/conditions/ITM"]=true
		an_t["parameters/conditions/MTI"]=false
	pass

func _physics_tick(delta:float):
	player.velocity.x = move_toward(player.velocity.x, 0,player.movement_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.movement_speed)
	pass

func _on_move_to_idle(dir: Vector2) -> void:
	an_t.set("parameters/Idle/blend_position",dir)
