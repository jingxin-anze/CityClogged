extends Node3D

@export var ufo:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("car_is_brealdown",create_ufo)


func create_ufo(car:Car):
	var ufo = ufo.instantiate()
	ufo.car = car
	ufo.global_position = car.global_position
	ufo.global_position.y = 50
	get_tree().root.add_child(ufo)
