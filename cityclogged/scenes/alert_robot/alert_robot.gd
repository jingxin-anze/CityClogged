extends RigidBody3D

func _ready() -> void:
	if not "," in "ve,":
		print("ppp")
	#print("Vector2(1,1)".split(","))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
