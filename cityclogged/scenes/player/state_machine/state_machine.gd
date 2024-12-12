class_name StateMachine extends Node3D

@export var current_state:Node3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
var player:Player

func _ready() -> void:
	await owner.ready
	player=owner
	for child in get_children():
		if child.is_in_group("state_base"):
			child.state_machine=self
			child.player=player
			child.an_t=animation_tree
			child.an=animation_player
	current_state._enter()

func _process(delta: float) -> void:
	current_state._tick(delta)

func _physics_process(delta: float) -> void:
	current_state._physics_tick(delta)

func change_state(state_name:String):
	var next_state:Node3D=get_node(state_name)
	print(state_name)
	if is_instance_valid(next_state):
		current_state._exit()
		current_state=next_state
		current_state._enter()
	else:
		printerr("节点不存在!请检查节点名称是否正确。")
