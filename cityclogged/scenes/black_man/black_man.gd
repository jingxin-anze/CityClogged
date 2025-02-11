extends CharacterBody3D

var to_dropped:bool
var fall_speed:int=100
var p1:Vector3
var p2:Vector3
var can_track:bool
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	
	pass

func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity+=get_gravity()*fall_speed
	if to_dropped:
		state_machine.change_state("Dropped")
	move_and_slide()
