extends StateBase

@onready var player:Player=get_tree().get_first_node_in_group("player")

func _enter():
	owner.rotation.z=PI/2
	pass

func _exit():
	pass

func _tick(delta:float):

	pass

func _physics_tick(delta:float):

	pass
