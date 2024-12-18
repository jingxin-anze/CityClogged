class_name CarStateMachine
extends Node

@export var current_state:CarState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child:CarState in get_children():
		child.state_machine = self
		child.common_car = get_parent()
	await get_parent().ready
	current_state.enter()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)

func state_changed(target_state_name: String) -> void:
	#if current_state.animation_name == "died":
		#return
	var target_state = get_node_or_null(target_state_name)
	if target_state == null:
		print("target_state wrong")
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()
