extends StateBase

@export var alert_robot:CharacterBody3D
@export var speed:int=100

@onready var player=get_tree().get_first_node_in_group("player")

var dir:Vector3

func _ready() -> void:
	
	pass

func _enter():
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
	an_t.get("parameters/playback").travel("Run")
	an_t.set("parameters/Run/blend_position",alert_robot.dir)
	pass
