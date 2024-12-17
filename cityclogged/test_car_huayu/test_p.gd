extends Node3D

var ss : Array[Array] = []

func _ready() -> void:
	var s: Array = [1]
	
	ss.append(s)
	print(ss)
	ss[0].append(5)
	print(ss[0])
