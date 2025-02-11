extends Node3D

@onready var marker_3d: Marker3D = $Marker3D
@onready var generation_car: GenerationCar = $GenerationCar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Car:
		body.target_point = marker_3d


func _on_timer_timeout() -> void:
	generation_car.create() # Replace with function body.
