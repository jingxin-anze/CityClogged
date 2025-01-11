extends Node3D

@export var car_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if car_scene:
		var car = car_scene.instantiate()
		
		get_parent().add_child(car)
		car.global_position = global_position
		car.global_rotation = global_rotation
	
