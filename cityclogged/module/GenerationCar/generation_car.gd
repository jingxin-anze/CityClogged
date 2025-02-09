class_name GenerationCar extends Node3D

@export var car_scene:PackedScene

var is_generation = true

func create() -> void:
	if car_scene and is_generation:
		var car = car_scene.instantiate()
		car.global_position = global_position
		get_tree().root.add_child(car)


func _on_area_3d_body_entered(body: Node3D) -> void:
	is_generation = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	is_generation = true
