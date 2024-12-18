extends Node3D

var ss : Array[Array] = []

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	self.rotation.y += PI/2
	print(self.rotation.y)
