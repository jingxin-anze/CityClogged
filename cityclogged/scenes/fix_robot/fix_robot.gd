extends CharacterBody3D

var target:Car

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	
	move_and_slide()
