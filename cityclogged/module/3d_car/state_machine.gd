class_name CarStateMachine
extends Node

# 当前状态
var current_state: State
# 所有状态字典
var states: Dictionary = {}
# 是否处于过渡状态
var is_transitioning: bool = false
@onready var car: Car = $".."

func _ready() -> void:
	# 获取所有State节点
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.machine = self
			child.car = car
			
	# 初始化第一个状态
	if not states.is_empty():
		current_state = states.values()[0]
		current_state.enter()

# 状态转换
func transition_to(state_name: String) -> void:
	if is_transitioning:
		return
		
	state_name = state_name.to_lower()
	if not states.has(state_name):
		push_warning("State " + state_name + " not found!")
		return
	
	if current_state:
		is_transitioning = true
		current_state.exit()
		
	current_state = states[state_name]
	current_state.enter()
	is_transitioning = false

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
