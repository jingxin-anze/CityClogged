extends Node3D

var state_machine:StateMachine
var an_t:AnimationTree
var an:AnimationPlayer
var player:Player

var movement_dir:Vector2
signal to_idle(dir:Vector2)

func _enter():
	pass

func _exit():
	pass

func _tick(delta:float):
	if not player.movement_direction:
		state_machine.change_state("Idle")
		an_t["parameters/conditions/MTI"]=true
		an_t["parameters/conditions/ITM"]=false
		to_idle.emit(movement_dir)
		
	else:
		movement_dir=player.movement_direction

func _physics_tick(delta:float):
	an_t.set("parameters/Move/blend_position",player.movement_direction)
	
	if not player.is_on_floor():
		player.velocity.z = player.movement_direction_3d.z *player.movement_speed*delta

	player.velocity.x= player.movement_direction_3d.x*player.movement_speed*delta
	player.velocity.z= player.movement_direction_3d.z*player.movement_speed*delta
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		player.velocity.y+=player.jump_speed*get_process_delta_time()
