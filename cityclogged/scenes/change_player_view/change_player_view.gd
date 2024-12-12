extends Area3D

@export_enum("x+","x-","z+","z-") var carmera_relative_pos:String

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		match carmera_relative_pos:
			"x+":
				body.rotation=(Vector3(0,PI/2,0))
			"x-":
				body.rotation=(Vector3(0,PI/2,0))
			"z+":
				body.rotation=(Vector3(0,0,0))
			"z-":
				body.rotation=(Vector3(0,PI,0))
