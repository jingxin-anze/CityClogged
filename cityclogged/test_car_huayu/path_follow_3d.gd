extends PathFollow3D

func _process(delta: float) -> void:
	progress_ratio += 0.05 * delta
