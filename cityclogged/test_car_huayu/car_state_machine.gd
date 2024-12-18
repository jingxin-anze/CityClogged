class_name CarStateMachine
extends Node

@export var current_state:CarState
var _car: CommonCar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child:CarState in get_children():
		child.state_machine = self
		child.common_car = get_parent()
	await get_parent().ready
	_car = get_parent()
	current_state.enter()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_car.rotation.y = _car._positive_degree(_car.rotation.y)
	current_state.physics_process(delta)

func state_changed(target_state_name: String) -> void:
	_car.rotation.y = _car._positive_degree(_car.rotation.y)
	#print(target_state_name)
	#if current_state.animation_name == "died":
		#return
	var target_state = get_node_or_null(target_state_name)
	if target_state == null:
		print("target_state wrong")
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()
